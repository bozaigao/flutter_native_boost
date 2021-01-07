package net.medlinker.flutter_native_boost

import android.content.Intent

interface ResultProvider {
    fun addResultListener(resultListener: ((requestCode: Int, resultCode: Int, data: Intent?) -> Unit))
}