package com.wxwx.flutter_alibc.web

import android.app.Activity
import android.graphics.Bitmap
import android.os.Bundle
import android.util.Log
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import com.alibaba.baichuan.android.trade.AlibcTrade
import com.alibaba.baichuan.android.trade.model.AlibcShowParams
import com.alibaba.baichuan.trade.biz.AlibcTradeCallback
import com.alibaba.baichuan.trade.biz.applink.adapter.AlibcFailModeType
import com.alibaba.baichuan.trade.biz.context.AlibcTradeResult
import com.alibaba.baichuan.trade.biz.core.taoke.AlibcTaokeParams
import com.wxwx.flutter_alibc.PluginUtil
import com.wxwx.flutter_alibc.R
import java.net.URLDecoder
import java.util.*
import com.wxwx.flutter_alibc.PluginConstants.Companion as Constants

class WebViewActivity : Activity() {
    companion object{
        var callBack: Callback? = null
    }

    interface Callback {
        fun success(accessToken: String?)
        fun failed(errorMsg: String?)
    }

    override fun onDestroy() {
        callBack?.failed("取消授权")
        callBack = null
        super.onDestroy()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.webview_activity)
        if (intent != null){
            val url = intent.getStringExtra("url") as String
            val arguments = intent.getSerializableExtra("arguments") as HashMap<String, Any>
            val webView = findViewById<WebView>(R.id.webview)
            //启用支持JavaScript
            //启用支持JavaScript
            webView.settings.javaScriptEnabled = true
            //启用支持DOM Storage
            //启用支持DOM Storage
            webView.settings.domStorageEnabled = true
            openByUrl(url, webView, arguments)
        }
    }

    private fun openByUrl(url: String, webView: WebView, argument: HashMap<String, Any>) {
        val showParams = AlibcShowParams()
        var taokeParams: AlibcTaokeParams? = AlibcTaokeParams("", "", "")
        showParams.backUrl = argument[Constants.key_BackUrl].toString()
        if (argument[Constants.key_OpenType] != null) {
            showParams.openType = PluginUtil.getOpenType(argument[Constants.key_OpenType].toString())
        }
        if (argument[Constants.key_ClientType] != null) {
            showParams.clientType = PluginUtil.getClientType(argument[Constants.key_ClientType].toString())
        }
        if (argument["taokeParams"] != null) {
            taokeParams = PluginUtil.getTaokeParams(argument["taokeParams"] as HashMap<String?, Any?>)
        }
        if ("false" == argument["isNeedCustomNativeFailMode"]) {
            showParams.nativeOpenFailedMode = AlibcFailModeType.AlibcNativeFailModeNONE
        } else if (argument[Constants.key_NativeFailMode] != null) {
            showParams.nativeOpenFailedMode = PluginUtil.getFailModeType(argument[Constants.key_NativeFailMode].toString())
        }
        val trackParams: Map<String, String> = HashMap()
        val client: WebViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                return false
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                Log.e("", "onPageStarted url : $url")
                super.onPageStarted(view, url, favicon)

                if (url?.contains("access_token=") == true && (url.contains("oauth.taobao.com") || url.contains("oauth.m.taobao.com"))) {
                    val accessToken: String = getURLParam("access_token", url)
                    Log.e("", "onPageStarted accessToken $accessToken")
                    callBack?.success(accessToken)
                    callBack = null
                    finish()
                }
                if (url?.contains("code=") == true) {
                    val code: String = getURLParam("code", url)
                    Log.e("", "onPageStarted code $code")
                    callBack?.success(code)
                    callBack = null
                    finish()
                }
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                Log.e("", "onPageFinished url : $url")
                super.onPageFinished(view, url)
            }

            override fun onLoadResource(view: WebView?, url: String?) {
                super.onLoadResource(view, url)
            }
        }
        AlibcTrade.openByUrl(this@WebViewActivity, "", url, webView,
                client, WebChromeClient(),
                showParams, taokeParams, trackParams, object : AlibcTradeCallback {
            override fun onTradeSuccess(tradeResult: AlibcTradeResult) {} //不会回调
            override fun onFailure(code: Int, msg: String) {} //不会回调
        })
    }

    private fun getURLParam(paramKey: String, url: String): String {
        try {
            var startIndex = url.indexOf(paramKey)
            var subStr = url.substring(startIndex)
            val tempUrl = URLDecoder.decode(subStr, "UTF-8")
            var endIndex = tempUrl.indexOf("&")
            if (endIndex < 0) {
                endIndex = tempUrl.length
            }
            subStr = tempUrl.substring(0, endIndex)
            startIndex = subStr.indexOf("=")
            subStr = subStr.substring(startIndex + 1)
            return subStr
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return ""
    }
}