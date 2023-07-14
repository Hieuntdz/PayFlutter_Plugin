package com.vinidpay.vinidpay_flutter_plugin

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import com.vinid.paysdk.VinIDPayParams
import com.vinid.paysdk.VinIDPaySdk
import com.vinid.paysdk.VinIDPaySdk.Companion.isVinIdAppInstalled
import com.vinid.paysdk.VinIDPaySdk.Companion.openVinIDInstallPage
import com.vinid.paysdk.utils.EnvironmentMode
import com.vinid.paysdk.utils.VinIDPayConstants
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry

/** VinidpayFlutterPlugin */
class VinidpayFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {

    private lateinit var channel: MethodChannel
    private var pendingResult: MethodChannel.Result? = null

    //    private var mDelegate: VinidpaySdkDelegate? = null
    private var mActivity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {


        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vinpay_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        pendingResult = result
        when (call.method) {
            "proceedPayment" -> proceedPayment(call)
            "isVinIdAppInstalled" -> isVinIdAppInstalled(call)
            "openVinIDInstallPage" -> openVinIDInstallPage(call)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    var binding: ActivityPluginBinding? = null
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this)
        mActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        binding?.removeActivityResultListener(this)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == VinIDPayConstants.REQUEST_CODE_VINIDPAY_PAY) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    when (data!!.getStringExtra(VinIDPayConstants.EXTRA_RETURN_TRANSACTION_STATUS)) {
                        VinIDPayConstants.TRANSACTION_SUCCESS -> pendingResult?.success("payment successful!")
                        VinIDPayConstants.TRANSACTION_ABORT -> pendingResult?.success("user aborted payment")
                        VinIDPayConstants.TRANSACTION_FAIL -> pendingResult?.success("payment failed")
                        else -> pendingResult?.success("unknow status")
                    }
                    return true
                }

                Activity.RESULT_CANCELED -> pendingResult?.success("user aborted payment")
            }
        }

        return false
    }

    private fun proceedPayment(call: MethodCall) {
        val id = call.argument<String>("id")
        val sign = call.argument<String>("sign")
        val sandboxMode = call.argument<Boolean>("sandboxMode")!!
        val params: VinIDPayParams = VinIDPayParams.Builder()
            .setOrderId(id)
            .setSignature(sign)
            .build()
        if (sandboxMode) {
            mActivity?.let {
                VinIDPaySdk.Builder()
                    .setVinIDPayParams(params)
                    .setEnvironmentMode(EnvironmentMode.DEV)
                    .build()
                    .startPaymentForResult(
                        activity = it,
                        VinIDPayConstants.REQUEST_CODE_VINIDPAY_PAY
                    )
            }
        } else {
            mActivity?.let {
                VinIDPaySdk.Builder()
                    .setVinIDPayParams(params)
                    .build()
                    .startPaymentForResult(it, VinIDPayConstants.REQUEST_CODE_VINIDPAY_PAY)
            }
        }
    }

    private fun isVinIdAppInstalled(call: MethodCall) {
        if (mActivity == null) {
            return
        }
        val sandboxMode = call.argument<Boolean>("sandboxMode")!!
        val status: Boolean = if (sandboxMode) {
            isVinIdAppInstalled(mActivity!!, EnvironmentMode.DEV)
        } else {
            isVinIdAppInstalled(mActivity!!, EnvironmentMode.PRODUCTION)
        }
        pendingResult?.success(status)
    }

    private fun openVinIDInstallPage(call: MethodCall) {
        val sandboxMode = call.argument<Boolean>("sandboxMode")!!
        if (sandboxMode) {
            mActivity?.let { openVinIDInstallPage(it, EnvironmentMode.DEV) }
        } else {
            mActivity?.let { openVinIDInstallPage(it, EnvironmentMode.PRODUCTION) }
        }
    }
}
