package com.chunkytofustudios.firebase_auth_games_services

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

const val METHOD_GET_PLATFORM_VERSION: String = "getPlatformVersion"
const val METHOD_SIGN_IN_SILENTLY: String = "signInSilently"
const val METHOD_SIGN_IN: String = "signIn"

/** FirebaseAuthGamesServicesPlugin */
class FirebaseAuthGamesServicesPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "firebase_auth_games_services")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      METHOD_GET_PLATFORM_VERSION -> {
        result.success("Android v ${android.os.Build.VERSION.RELEASE}")
      }
      METHOD_SIGN_IN_SILENTLY -> {

      }
      METHOD_SIGN_IN -> {

      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    PlayGamesSdk.initialize(this);
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding);
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }
}
