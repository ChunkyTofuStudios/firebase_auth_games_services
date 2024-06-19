package com.chunkytofustudios.firebase_auth_games_services

import android.app.Activity
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import com.google.android.gms.games.AuthenticationResult
import com.google.android.gms.games.PlayGames
import com.google.android.gms.games.PlayGamesSdk
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
    private var channel: MethodChannel =
        MethodChannel(binaryMessenger, "firebase_auth_games_services")

    init {
        channel.setMethodCallHandler(this)
        PlayGamesSdk.initialize(activity)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            PluginConstants.METHOD_GET_PLATFORM_VERSION -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            PluginConstants.METHOD_GET_AUTH_CODE -> getAuthCode(call, result)

            PluginConstants.METHOD_SIGN_IN -> signIn(call, result)

            else -> result.notImplemented()
        }
    }

    private fun getAuthCode(call: MethodCall, result: MethodChannel.Result) {
        val gamesSignInClient = PlayGames.getGamesSignInClient(activity)

        gamesSignInClient.isAuthenticated()
            .addOnCompleteListener AuthCheck@{ isAuthenticatedTask: Task<AuthenticationResult> ->
                val isAuthenticated =
                    (isAuthenticatedTask.isSuccessful &&
                            isAuthenticatedTask.result.isAuthenticated)
                Log.i(
                    PluginConstants.PLUGIN_NAME,
                    "[${call.method}] Is authenticated=$isAuthenticated"
                )

                if (!isAuthenticated) {
                    result.success(null)
                    return@AuthCheck
                }

                val app: ApplicationInfo = activity.packageManager
                    .getApplicationInfo(activity.packageName, PackageManager.GET_META_DATA)
                val oAuthClientId = app.metaData.getString(
                    PluginConstants.OAUTH_2_CLIENT_ID_KEY
                )
                if (oAuthClientId == null) {
                    result.error(
                        "invalid-config",
                        "Using firebase_auth_games_services plugin requires a metadata tag with the name \"${PluginConstants.OAUTH_2_CLIENT_ID_KEY}\" in the application tag of your manifest.",
                        null
                    )
                    return@AuthCheck
                }

                gamesSignInClient.requestServerSideAccess(
                    oAuthClientId,
                    false
                ).addOnCompleteListener GetAuthCode@{ authCodeTask: Task<String> ->
                    if (!authCodeTask.isSuccessful) {
                        Log.i(
                            PluginConstants.PLUGIN_NAME,
                            "[${call.method}] GetAuthCode failed."
                        )
                        result.success(null)
                        return@GetAuthCode
                    }

                    val authCode = authCodeTask.result
                    if (authCode.isBlank()) {
                        Log.i(
                            PluginConstants.PLUGIN_NAME,
                            "[${call.method}] Received empty auth code."
                        )
                        result.success(null)
                        return@GetAuthCode
                    }

                    Log.i(
                        PluginConstants.PLUGIN_NAME,
                        "[${call.method}] Auth code=$authCode"
                    )
                    result.success(authCode)
                }
            }
    }

    private fun signIn(call: MethodCall, result: MethodChannel.Result) {
        val gamesSignInClient = PlayGames.getGamesSignInClient(activity)

        // Check if the user is already signed in.
        gamesSignInClient.isAuthenticated()
            .addOnCompleteListener AuthCheck@{ isAuthenticatedTask: Task<AuthenticationResult> ->
                val isAuthenticated =
                    (isAuthenticatedTask.isSuccessful &&
                            isAuthenticatedTask.result.isAuthenticated)

                if (isAuthenticated) {
                    getAuthCode(call, result)
                    return@AuthCheck
                }

                gamesSignInClient.signIn()
                    .addOnCompleteListener SignIn@{ signInTask: Task<AuthenticationResult> ->
                        val isSignedIn =
                            (signInTask.isSuccessful &&
                                    signInTask.result.isAuthenticated)
                        Log.i(
                            PluginConstants.PLUGIN_NAME,
                            "[${call.method}] Is signed in=$isSignedIn"
                        )

                        if (!isSignedIn) {
                            result.success(null)
                            return@SignIn
                        }

                        getAuthCode(call, result)
                    }
            }
    }

    fun stopListening() {
        channel.setMethodCallHandler(null)
    }
}
