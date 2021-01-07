package net.medlinker.flutter_native_boost_example.widget

import android.content.Context
import android.os.Bundle
import android.view.Gravity
import android.view.WindowManager
import androidx.appcompat.app.AlertDialog
import net.medlinker.flutter_native_boost_example.R

abstract class BaseDialog(context: Context) : AlertDialog(context, R.style.DialogTheme) {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setWindow()
    }

    private fun setWindow() {
        val params = window?.attributes
        params?.width = WindowManager.LayoutParams.MATCH_PARENT
        params?.height = WindowManager.LayoutParams.WRAP_CONTENT
        params?.gravity = gravity()
        params?.dimAmount = alpha()
        window?.attributes = params
        if (anim() != -1) {
            window?.setWindowAnimations(anim())
        }
    }

    /**
     * 位置
     */
    open fun gravity(): Int {
        return Gravity.CENTER
    }

    /**
     * 动画
     */
    open fun anim(): Int {
        return -1
    }

    /**
     * 背景透明度
     */
    open fun alpha(): Float {
        return 0.5f
    }

}