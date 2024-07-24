import Flutter
import UIKit
import GameKit

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
            signIn(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func isSignedIn(result: @escaping FlutterResult) {
        let playerSignedIn = GKLocalPlayer.local.isAuthenticated
        NSLog("%@: isSignedIn: result is %@", FirebaseAuthGamesServicesPlugin.pluginName, playerSignedIn ? "true" : "false")
        result(playerSignedIn);
    }
    
    func signIn(result: @escaping FlutterResult) {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                NSLog("%@: signIn: showing signIn window.", FirebaseAuthGamesServicesPlugin.pluginName)
                self.topViewController(with: nil)?.present(viewController, animated: true, completion: nil)
                // GameKit will call the authenticateHandler again once the user takes action.
                return
            }
            if error != nil {
                NSLog("%@: signIn: failed: %@", FirebaseAuthGamesServicesPlugin.pluginName, error?.localizedDescription ?? "")
                result(nil)
                return
            }
            if !GKLocalPlayer.local.isAuthenticated {
                NSLog("%@: signIn: signIn succeded but player is not authenticated; this should not happen per API docs", FirebaseAuthGamesServicesPlugin.pluginName)
                result(nil)
            }
            NSLog("%@: signIn: success", FirebaseAuthGamesServicesPlugin.pluginName)
            result("")
        }
    }
    
    func topViewController(with window: UIWindow?) -> UIViewController? {
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
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController
    }
}
