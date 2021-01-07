package net.medlinker.flutter_native_boost.channels

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.medlinker.flutter_native_boost.Container

internal object ContainerNotice : MethodChannel.MethodCallHandler {

    private val notifications = hashMapOf<String, NotificationCallback>()
    private val channel = MethodChannel(Container.engine.dartExecutor, "flutter_native_boost/notification")


    init {
        channel.setMethodCallHandler(this)
    }


    /**
     * 发送通知  native -> flutter
     */
    fun post(key: String, arguments: Any?) {
        channel.invokeMethod(key, arguments)
    }

    /**
     * 注册接收通知  flutter -> native
     */
    fun register(key: String, callback: (arguments: Any?) -> Unit) {
        notifications[key] = object : NotificationCallback {
            override fun onReceiveNotification(arguments: Any?) {
                callback.invoke(arguments)
            }
        }
    }

    /**
     * for java
     */
    fun register(key: String, callback: NotificationCallback) {
        notifications[key] = callback
    }

    /**
     * 解除注册
     */
    fun unregister(key: String) {
        notifications.remove(key)
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val key = call.method
        val args = call.arguments
        notifications[key]?.onReceiveNotification(args)

        result.success(notifications.containsKey(key))
    }
}


interface NotificationCallback {

    fun onReceiveNotification(arguments: Any?)
}



/**
 * post notification  form native to flutter
 */
fun Container.postNotification(key: String, arguments: Any?) {
    ContainerNotice.post(key, arguments)
}

/**
 * receive notification from flutter
 */
fun Container.registerNotification(key: String, callback: (arguments: Any?) -> Unit) {
    ContainerNotice.register(key, callback)
}

fun Container.unregisterNotification(key: String) {
    ContainerNotice.unregister(key)
}