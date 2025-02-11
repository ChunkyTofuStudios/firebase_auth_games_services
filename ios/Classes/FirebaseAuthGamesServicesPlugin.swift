import Flutter
import GameKit
import UIKit

public class FirebaseAuthGamesServicesPlugin: NSObject, FlutterPlugin {
    static let pluginName = "FirebaseAuthGamesServicesPlugin"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "firebase_auth_games_services", binaryMessenger: registrar.messenger())
        let instance = FirebaseAuthGamesServicesPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "isSignedIn":
            isSignedIn(result: result)
        case "signIn":
            signIn(silent: false, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func isSignedIn(result: @escaping FlutterResult) {
        let playerSignedIn = GKLocalPlayer.local.isAuthenticated
        NSLog("%@: isSignedIn: result is %@", FirebaseAuthGamesServicesPlugin.pluginName, playerSignedIn ? "true" : "false")
        if playerSignedIn {
            result(true)
            return
        }
        signIn(silent: true, result: result)
    }
    
    private func signIn(silent: Bool, result: @escaping FlutterResult) {
        NSLog("%@: signIn: requesting login", FirebaseAuthGamesServicesPlugin.pluginName)
        var waitingForGameKit = true
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            waitingForGameKit = false
            if let viewController = viewController {
                if silent {
                    NSLog("%@: signIn: requires UI, aborting", FirebaseAuthGamesServicesPlugin.pluginName)
                    result(false)
                    return
                }
                NSLog("%@: signIn: showing signIn window.", FirebaseAuthGamesServicesPlugin.pluginName)
                self.topViewController(with: nil)?.present(viewController, animated: true, completion: nil)
                // GameKit will call the authenticateHandler again once the user takes action.
                return
            }
            if error != nil {
                NSLog("%@: signIn: failed: %@", FirebaseAuthGamesServicesPlugin.pluginName, error?.localizedDescription ?? "")
                result(silent ? false : nil)
                return
            }
            if !GKLocalPlayer.local.isAuthenticated {
                NSLog("%@: signIn: signIn succeded but player is not authenticated; this should not happen per API docs", FirebaseAuthGamesServicesPlugin.pluginName)
                result(silent ? false : nil)
                return
            }
            NSLog("%@: signIn: success", FirebaseAuthGamesServicesPlugin.pluginName)
            result(silent ? true : "")
        }
        NSLog("%@: signIn: starting cleanup job", FirebaseAuthGamesServicesPlugin.pluginName)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            if waitingForGameKit {
                // GameKit might ignore requests if a user has declined sign in before.
                // https://stackoverflow.com/questions/4576032/ios-development-strange-problem-with-authenticating-game-center-user
                NSLog("%@: signIn: no response from GameKit; assuming signIn failed", FirebaseAuthGamesServicesPlugin.pluginName)
                result(silent ? false : nil)
            }
        }
    }
    
    private func topViewController(with window: UIWindow?) -> UIViewController? {
        var windowToUse = window
        if windowToUse == nil {
            for window in UIApplication.shared.windows {
                if window.isKeyWindow {
                    windowToUse = window
                    break
                }
            }
        }
        
        var topController = windowToUse?.rootViewController
        while (topController?.presentedViewController) != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}
