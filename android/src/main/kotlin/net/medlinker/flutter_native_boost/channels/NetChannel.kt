package net.medlinker.flutter_native_boost.channels

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

internal class NetChannel(messenger: BinaryMessenger, private val handler: NetHandler) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "flutter_native_boost/net")

    init {
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String>("url") ?: return
        val params = call.argument<HashMap<String, Any>>("parameters")
        val headers = call.argument<HashMap<String, String>>("headers")
        handler.request(call.method, url, params, headers) {
            result.success(it)
        }
    }
}


interface NetHandler {

    /**
     * @param method GET POST PUT DELETE ...
     * @param url
     * @param params request params
     * @param headers request headers
     * @param onComplete callback the request response
     */
    fun request(method: String, url: String, params: HashMap<String, Any>?, headers: HashMap<String, String>?, onComplete: (result: Any?) -> Unit)

}