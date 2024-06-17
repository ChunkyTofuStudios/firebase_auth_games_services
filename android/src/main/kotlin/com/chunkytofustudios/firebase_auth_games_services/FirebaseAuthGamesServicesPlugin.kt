package com.chunkytofustudios.firebase_auth_games_services

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


/** FirebaseAuthGamesServicesPlugin */
class FirebaseAuthGamesServicesPlugin: FlutterPlugin, ActivityAware {
  private var flutterPluginBinding: FlutterPluginBinding? = null
  private var methodCallHandler: MethodCallHandlerImpl? = null


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    this.flutterPluginBinding = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    val pluginBinding = flutterPluginBinding ?: return
    methodCallHandler = MethodCallHandlerImpl(binding.activity, pluginBinding.binaryMessenger)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding);
  }

  override fun onDetachedFromActivity() {
    methodCallHandler?.stopListening()
    methodCallHandler = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }
}
