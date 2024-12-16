package com.wxwx.flutter_alibc

import com.alibaba.baichuan.android.trade.model.OpenType
import com.alibaba.baichuan.trade.biz.applink.adapter.AlibcFailModeType
import com.alibaba.baichuan.trade.biz.core.taoke.AlibcTaokeParams
import com.wxwx.flutter_alibc.PluginConstants.*
import com.wxwx.flutter_alibc.PluginConstants.Companion as Constants

class PluginUtil {
    companion object{
        fun getOpenType(open: String?): OpenType? {
            return if (Constants.Auto_OpenType == open) {
                OpenType.Auto
            } else {
                OpenType.Native
            }
        }

        fun getClientType(client: String): String? {
            return if (client == Constants.Tmall_ClientType) {
                "tmall"
            } else {
                "taobao"
            }
        }

        fun getFailModeType(mode: String?): AlibcFailModeType? {
            return if (Constants.JumpH5_FailMode == mode) {
                AlibcFailModeType.AlibcNativeFailModeJumpH5
            } else if (Constants.JumpDownloadPage_FailMode == mode) {
                AlibcFailModeType.AlibcNativeFailModeJumpDOWNLOAD
            } else {
                AlibcFailModeType.AlibcNativeFailModeNONE
            }
        }

        fun getTaokeParams(taokePar: Map<String?, Any?>): AlibcTaokeParams? {
            val pid = taokePar["pid"] as String?
            val taokeParams = AlibcTaokeParams("", "", "")
            if (pid != null) {
                taokeParams.setPid(pid)
            }
            val extParams = taokePar["extParams"]
            //TODO 其他参数待添加
            return taokeParams
        }
    }

}