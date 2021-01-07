package net.medlinker.flutter_native_boost_example.widget

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.widget.RelativeLayout
import android.widget.TextView
import net.medlinker.flutter_native_boost_example.R
import net.medlinker.flutter_native_boost_example.utils.setCorner

class NotificationDialog(context: Context, private val msg: String) : BaseDialog(context), Runnable {

    private val view by lazy { findViewById<RelativeLayout>(R.id.contentView) }
    private val titleTxt by lazy { findViewById<TextView>(R.id.titleTxt) }
    private val msgTxt by lazy { findViewById<TextView>(R.id.msgTxt) }
    private val handler by lazy { Handler() }
    private var time = 3


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setCancelable(false)
        setContentView(R.layout.dialog_notification)
        view?.setCorner(8f)
        msgTxt?.text = msg
        handler.post(this)
    }

    @SuppressLint("SetTextI18n")
    override fun run() {
        titleTxt?.text = "Notification (${time})"
        time--
        if (time >= 0) {
            handler.postDelayed(this, 1000)
        } else {
            handler.removeCallbacks(this)
            dismiss()
        }
    }
}