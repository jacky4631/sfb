package com.wxwx.flutter_alibc
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.Intent
import android.webkit.WebChromeClient
import android.webkit.WebViewClient
import com.alibaba.baichuan.android.trade.AlibcTrade
import com.alibaba.baichuan.android.trade.AlibcTradeSDK
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback
import com.alibaba.baichuan.android.trade.model.AlibcShowParams
import com.alibaba.baichuan.android.trade.page.AlibcBasePage
import com.alibaba.baichuan.android.trade.page.AlibcDetailPage
import com.alibaba.baichuan.android.trade.page.AlibcMyCartsPage
import com.alibaba.baichuan.android.trade.page.AlibcShopPage
import com.alibaba.baichuan.trade.biz.AlibcTradeCallback
import com.alibaba.baichuan.trade.biz.applink.adapter.AlibcFailModeType
import com.alibaba.baichuan.trade.biz.context.AlibcResultType
import com.alibaba.baichuan.trade.biz.context.AlibcTradeResult
import com.alibaba.baichuan.trade.biz.core.taoke.AlibcTaokeParams
import com.alibaba.baichuan.trade.biz.login.AlibcLogin
import com.alibaba.baichuan.trade.biz.login.AlibcLoginCallback
import com.alibaba.fastjson.JSON
import com.wxwx.flutter_alibc.web.WebViewActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class FlutterAlibcHandle(var methodChannel: MethodChannel?){
    var activity:Activity? = null
    fun disposed(){
        this.methodChannel = null
        this.activity = null
    }

    /**
     * 初始化阿里百川
     * @param call
     * @param result
     */
    fun initAlibc(result: MethodChannel.Result){
        AlibcTradeSDK.asyncInit(activity!!.application, object : AlibcTradeInitCallback {
            override fun onSuccess() {
                result.success(PluginResponse.success(null).toMap())
            }

            override fun onFailure(code: Int, msg: String?) {
                result.success(PluginResponse(code.toString(), msg, null).toMap())
            }
        })
    }

    /**
     * 登陆淘宝
     * @param result
     */
    fun loginTaoBao(){
        val alibcLogin = AlibcLogin.getInstance()
        if(alibcLogin.isLogin){
            val session = alibcLogin.session
            System.out.println(JSON.toJSONString(alibcLogin.session))
            val userInfo: MutableMap<String, Any> = HashMap()
            userInfo["nick"] = session.nick
            userInfo["avatarUrl"] = session.avatarUrl
            userInfo["openId"] = session.openId
            userInfo["openSid"] = session.openSid
            userInfo["topAccessToken"] = session.topAccessToken
            userInfo["topAuthCode"] = session.topAuthCode
            methodChannel!!.invokeMethod("AlibcTaobaoLogin", PluginResponse.success(userInfo).toMap())
            return
        }
        alibcLogin.showLogin(object : AlibcLoginCallback {
            override fun onSuccess(loginResult: Int, openId: String?, nickName: String?) {
                val userInfo: MutableMap<String, Any> = HashMap()
                val session = alibcLogin.session
                System.out.println(JSON.toJSONString(alibcLogin.session))
                userInfo["nick"] = session.nick
                userInfo["avatarUrl"] = session.avatarUrl
                userInfo["openId"] = session.openId
                userInfo["openSid"] = session.openSid
                userInfo["topAccessToken"] = session.topAccessToken
                userInfo["topAuthCode"] = session.topAuthCode
                methodChannel!!.invokeMethod("AlibcTaobaoLogin", PluginResponse.success(userInfo).toMap())

            }

            override fun onFailure(code: Int, msg: String?) {
                // code：错误码  msg： 错误信息
                methodChannel!!.invokeMethod("AlibcTaobaoLogin", PluginResponse(code.toString(), msg, null).toMap())
            }
        })
    }

    /**
     * 登出
     * @param result
     */
    fun logoutTaoBao(result: MethodChannel.Result){
        val alibcLogin = AlibcLogin.getInstance()
        alibcLogin.logout(object : AlibcLoginCallback {
            override fun onSuccess(p0: Int, p1: String?, p2: String?) {
                result.success(PluginResponse.success(null).toMap())
            }

            override fun onFailure(code: Int, msg: String?) {
                result.success(PluginResponse(code.toString(), msg, null).toMap())
            }
        })
    }

    /**
     * 淘宝授权登陆  获取access_token
     *  官方说明文档 {https://open.taobao.com/doc.htm?docId=118&docType=1}
     * @param call
     * @param result
     */
    fun taoKeLogin(call: MethodCall){
        val map = call.arguments as HashMap<String, Any>
        val url = call.argument<String>("url")
        WebViewActivity.callBack = object : WebViewActivity.Callback {
            override fun success(accessToken: String?) {
                val resMap: HashMap<String, Any?> = HashMap<String, Any?>()
                resMap["accessToken"] = accessToken
                methodChannel!!.invokeMethod("AlibcTaokeLogin", PluginResponse.success(resMap).toMap())
            }

            override fun failed(errorMsg: String?) {
                val code = -1
                methodChannel!!.invokeMethod("AlibcTaokeLogin", PluginResponse(code.toString(), errorMsg, null).toMap())
            }
        }
        val intent = Intent(activity!!, WebViewActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.putExtra("url", url)
        intent.putExtra("arguments", map)
        activity!!.startActivity(intent)
    }

    /**
     * 淘宝授权登陆  获取code 授权码
     *  官方说明文档 {https://open.taobao.com/doc.htm?docId=118&docType=1}
     * @param call
     * @param result
     */
    fun taoKeLoginForCode(call: MethodCall){
        val map = call.arguments as HashMap<*, *>
        val url = call.argument<String>("url")
        WebViewActivity.callBack = object : WebViewActivity.Callback {
            override fun success(accessToken: String?) {
                val resMap: HashMap<String, Any?> = HashMap<String, Any?>()
                resMap["code"] = accessToken
                methodChannel!!.invokeMethod("AlibcTaokeLoginForCode", PluginResponse.success(resMap).toMap())
            }

            override fun failed(errorMsg: String?) {
                var code = -1
                methodChannel!!.invokeMethod("AlibcTaokeLoginForCode", PluginResponse(code.toString(), errorMsg, null).toMap())
            }
        }
        val intent = Intent(activity!!, WebViewActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.putExtra("url", url)
        intent.putExtra("arguments", map)
        activity!!.startActivity(intent)
    }

    /**
     * 通过URL方式打开淘宝
     * @param call
     * @param result
     */
    fun openByUrl(call: MethodCall, result: MethodChannel.Result){
        val showParams = AlibcShowParams()
        var taokeParams: AlibcTaokeParams? = AlibcTaokeParams("", "", "")

        showParams.backUrl = call.argument(PluginConstants.key_BackUrl)

        if (call.argument<Any?>(PluginConstants.key_OpenType) != null) {
            println("openType" + call.argument<Any>(PluginConstants.key_OpenType))
            showParams.openType = PluginUtil.getOpenType("" + call.argument<Any>(PluginConstants.key_OpenType))
        }
        if (call.argument<Any?>(PluginConstants.key_ClientType) != null) {
            println("clientType " + call.argument<Any>(PluginConstants.key_ClientType))
            showParams.clientType = PluginUtil.getClientType("" + call.argument<Any>(PluginConstants.key_ClientType))
        }
        if (call.argument<Any?>("taokeParams") != null) {
            taokeParams = PluginUtil.getTaokeParams(call.argument<Map<String?, Any?>>("taokeParams")!!)
        }
        if ("false" == call.argument<Any>("isNeedCustomNativeFailMode")) {
            showParams.nativeOpenFailedMode = AlibcFailModeType.AlibcNativeFailModeNONE
        } else if (call.argument<Any?>(PluginConstants.key_NativeFailMode) != null) {
            showParams.nativeOpenFailedMode = PluginUtil.getFailModeType("" + call.argument<Any>(PluginConstants.key_NativeFailMode))
        }

        val trackParams: Map<String, String> = HashMap()
        val url = call.argument<String>("url")
        // 以显示传入url的方式打开页面（第二个参数是套件名称）
        // 以显示传入url的方式打开页面（第二个参数是套件名称）
        AlibcTrade.openByUrl(activity, "", url, null,
                WebViewClient(), WebChromeClient(), showParams,
                taokeParams, trackParams, object : AlibcTradeCallback {
            override fun onTradeSuccess(tradeResult: AlibcTradeResult) {
                val results: MutableMap<String, Any> = HashMap()
                if (AlibcResultType.TYPECART == tradeResult.resultType) {
                    results["type"] = 1
                } else if (AlibcResultType.TYPEPAY == tradeResult.resultType) {
                    results["type"] = 0
                    results["payFailedOrders"] = tradeResult.payResult.payFailedOrders
                    results["paySuccessOrders"] = tradeResult.payResult.paySuccessOrders
                }
                methodChannel!!.invokeMethod("AlibcOpenURL", PluginResponse.success(results).toMap())
            }

            override fun onFailure(code: Int, msg: String) {
                methodChannel!!.invokeMethod("AlibcOpenURL", PluginResponse(code.toString(), msg, null).toMap())
            }
        })
    }

    /**
     * 打开商店
     * @param call
     * @param result
     */
    fun openShop(call: MethodCall, result: MethodChannel.Result) {
        val page: AlibcBasePage = AlibcShopPage(call.argument("shopId"))
        openByBizCode(page, "shop", "AlibcOpenShop",call, result)
    }

    /**
     * 打开购物车
     * @param result
     */
    fun openCart(call: MethodCall, result: MethodChannel.Result) {
        val page: AlibcBasePage = AlibcMyCartsPage()
        openByBizCode(page, "cart", "AlibcOpenCar", call, result)
    }

    /**
     * 打开商品详情
     * @param call   call.argument["itemID"]  详情id
     * @param result
     */
    fun openItemDetail(call: MethodCall, result: MethodChannel.Result) {
        val page: AlibcBasePage = AlibcDetailPage(call.argument("itemID"))
        openByBizCode(page, "detail", "AlibcOpenDetail",call, result)
    }

    private fun openByBizCode(page: AlibcBasePage, type: String, methodName: String, call: MethodCall, result: MethodChannel.Result) {
        val showParams = AlibcShowParams()
        var taokeParams: AlibcTaokeParams? = AlibcTaokeParams("", "", "")
        showParams.backUrl = call.argument(PluginConstants.key_BackUrl)
        if (call.argument<Any?>(PluginConstants.key_OpenType) != null) {
            showParams.openType = PluginUtil.getOpenType("" + call.argument<Any>(PluginConstants.key_OpenType))
        }
        if (call.argument<Any?>(PluginConstants.key_ClientType) != null) {
            showParams.clientType = PluginUtil.getClientType("" + call.argument<Any>(PluginConstants.key_ClientType))
        }
        if (call.argument<Any?>("taokeParams") != null) {
            taokeParams = PluginUtil.getTaokeParams(call.argument<Map<String?, Any?>>("taokeParams")!!)
        }
        if ("false" == call.argument<Any>("isNeedCustomNativeFailMode")) {
            showParams.nativeOpenFailedMode = AlibcFailModeType.AlibcNativeFailModeNONE
        } else if (call.argument<Any?>(PluginConstants.key_NativeFailMode) != null) {
            showParams.nativeOpenFailedMode = PluginUtil.getFailModeType("" + call.argument<Any>(PluginConstants.key_NativeFailMode))
        }
        val trackParams: Map<String, String> = HashMap()
        AlibcTrade.openByBizCode(activity, page, null, WebViewClient(),
                WebChromeClient(), type, showParams, taokeParams,
                trackParams, object : AlibcTradeCallback {
            override fun onTradeSuccess(tradeResult: AlibcTradeResult) {
                val results: MutableMap<String, Any> = HashMap()
                if (AlibcResultType.TYPECART == tradeResult.resultType) {
                    results["type"] = 1
                } else if (AlibcResultType.TYPEPAY == tradeResult.resultType) {
                    results["type"] = 0
                    results["payFailedOrders"] = tradeResult.payResult.payFailedOrders
                    results["paySuccessOrders"] = tradeResult.payResult.paySuccessOrders
                }
                methodChannel!!.invokeMethod(methodName, PluginResponse.success(results).toMap())
            }

            override fun onFailure(code: Int, msg: String) {
                // 失败回调信息
                methodChannel!!.invokeMethod(methodName, PluginResponse(code.toString(), msg, null).toMap())
            }
        })
    }

    /**
     * 设置淘客打点策略 是否异步
     * @param call
     */
    fun syncForTaoke(call: MethodCall) {
        AlibcTradeSDK.setSyncForTaoke(call.argument<Boolean>("isSync")!!)
    }

    fun useAlipayNative(call: MethodCall) {
//        AlibcTradeSDK.setShouldUseAlipay(call.argument<Boolean>("isNeed")!!)
    }
}