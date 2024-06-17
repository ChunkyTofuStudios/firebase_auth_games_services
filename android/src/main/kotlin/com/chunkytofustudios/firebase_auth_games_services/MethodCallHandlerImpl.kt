package com.chunkytofustudios.firebase_auth_games_services

import android.app.Activity
import com.google.android.gms.games.AuthenticationResult
import com.google.android.gms.games.PlayGames
import com.google.android.gms.games.PlayGamesSdk
import com.google.android.gms.games.Player
import com.google.android.gms.tasks.Task
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


class MethodCallHandlerImpl(
    private val activity: Activity,
    binaryMessenger: BinaryMessenger,
) : MethodCallHandler {
    private var channel : MethodChannel = MethodChannel(binaryMessenger, "firebase_auth_games_services")

    init {
        channel.setMethodCallHandler(this)
        PlayGamesSdk.initialize(activity)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            PluginConstants.METHOD_GET_PLATFORM_VERSION -> {
                result.success("Android v ${android.os.Build.VERSION.RELEASE}")
            }
            PluginConstants.METHOD_SIGN_IN_SILENTLY -> {
                val gamesSignInClient = PlayGames.getGamesSignInClient(activity)

                gamesSignInClient.isAuthenticated()
                    .addOnCompleteListener { isAuthenticatedTask: Task<AuthenticationResult> ->
                        val isAuthenticated =
                            (isAuthenticatedTask.isSuccessful &&
                                    isAuthenticatedTask.result.isAuthenticated)
                        Log.i("FireAuthGameServ", "auth result=$isAuthenticated")

                        if (isAuthenticated) {
                            // Continue with Play Games Services
                            PlayGames.getPlayersClient(activity).currentPlayer.addOnCompleteListener { mTask: Task<Player?>? ->
                                val playerId = mTask?.result?.playerId
                                Log.i("FireAuthGameServ", "playerId=$playerId")
                                result.success(playerId)
                            }
                        } else {
                            // Disable your integration with Play Games Services or show a
                            // login button to ask  players to sign-in. Clicking it should
                            // call GamesSignInClient.signIn().
                        }
                    }
            }
            PluginConstants.METHOD_SIGN_IN -> {
                val gamesSignInClient = PlayGames.getGamesSignInClient(activity)
                gamesSignInClient.signIn().addOnCompleteListener {  signInTask: Task<AuthenticationResult> ->
                    val isAuthenticated =
                        (signInTask.isSuccessful &&
                                signInTask.result.isAuthenticated)

                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    fun stopListening() {
        channel.setMethodCallHandler(null)
    }
}
