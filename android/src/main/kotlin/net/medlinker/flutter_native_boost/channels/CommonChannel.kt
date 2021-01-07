package net.medlinker.flutter_native_boost.channels

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

internal class CommonChannel(messenger: BinaryMessenger, handler: MethodChannel.MethodCallHandler) {

    private val channel by lazy { MethodChannel(messenger, "flutter_native_boost/common") }

    init {
        channel.setMethodCallHandler(handler)
    }

}