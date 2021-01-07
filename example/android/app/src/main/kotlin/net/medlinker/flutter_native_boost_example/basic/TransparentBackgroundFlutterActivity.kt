package net.medlinker.flutter_native_boost_example.basic

import android.content.Context
import android.graphics.Color
import net.medlinker.flutter_native_boost.ContainerActivity

class TransparentBackgroundFlutterActivity: ContainerActivity() {
    companion object {
        fun build(context: Context) = builder<TransparentBackgroundFlutterActivity>("transparent_flutter",
                backgroundColor = Color.TRANSPARENT).build(context)
    }
}