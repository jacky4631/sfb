package com.shanyan;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.chuanglan.shanyan_sdk.listener.ActionListener;
import com.chuanglan.shanyan_sdk.listener.AuthenticationExecuteListener;
import com.chuanglan.shanyan_sdk.listener.GetPhoneInfoListener;
import com.chuanglan.shanyan_sdk.listener.InitListener;
import com.chuanglan.shanyan_sdk.listener.OneKeyLoginListener;
import com.chuanglan.shanyan_sdk.listener.OpenLoginAuthListener;
import com.chuanglan.shanyan_sdk.listener.PricacyOnClickListener;
import com.chuanglan.shanyan_sdk.listener.ShanYanCustomInterface;
import com.chuanglan.shanyan_sdk.tool.ConfigPrivacyBean;
import com.chuanglan.shanyan_sdk.tool.ShanYanUIConfig;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * MyFlutterPlugin
 */
public class ShanyanPlugin implements FlutterPlugin, MethodCallHandler {

    // 定义日志 TAG
    private static final String TAG = "|ProcessShanYanLogger_|";
    final String shanyan_code = "code";//返回码
    final String shanyan_message = "message";//描述
    String shanyan_innerCode = "innerCode"; //内层返回码
    String shanyan_innerDesc = "innerDesc"; //内层事件描述
    String shanyan_token = "token"; //token
    final String shanyan_type = "type";
    final String shanyan_result = "result";
    final String shanyan_operator = "operator";
    final String shanyan_widgetId = "widgetId";
    private MethodChannel channel;
    /**
     * Plugin registration.
     */
    private Context context;
    private boolean isFinish;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "shanyan");
        context = flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("setDebugMode")) {
            //闪验SDK 设置debug模式
            setDebug(call);
        }
        if (call.method.equals("setInitDebug")) {
            //闪验SDK 设置debug模式
            setInitDebug(call);
        }
        if (call.method.equals("getOperatorType")) {
            //闪验SDK 获取运营商类型
            getOperatorType(call, result);
        }
        if (call.method.equals("getOperatorInfo")) {
            //闪验SDK 获取运营商类型
            getOperatorInfo(call, result);
        }
        if (call.method.equals("init")) {
            //闪验SDK 初始化
            init(call, result);
        }
        if (call.method.equals("getPhoneInfo")) {
            //闪验SDK 预取号
            getPhoneInfo(result);
        }
        if (call.method.equals("setAuthThemeConfig")) {
            setAuthThemeConfig(call, result);
        }
        if (call.method.equals("openLoginAuth")) {
            //闪验SDK 拉起授权页
            openLoginAuth(call, result);
        }
        if (call.method.equals("finishAuthActivity")) {
            OneKeyLoginManager.getInstance().finishAuthActivity();
        }
        if (call.method.equals("getPreIntStatus")) {
            result.success(OneKeyLoginManager.getInstance().getPreIntStatus());
        }
        if (call.method.equals("startAuthentication")) {
            startAuthentication(call, result);
        }
        if (call.method.equals("setLoadingVisibility")) {
            setLoadingVisibility(call);
        }
        if (call.method.equals("setCheckBoxValue")) {
            setCheckBoxValue(call);
        }
        if (call.method.equals("setActionListener")) {
            setActionListener(call, result);
        }
        if (call.method.equals("setPrivacyOnClickListener")) {
            setPrivacyOnClickListener(call, result);
        }
        if (call.method.equals("getOaidEnable")) {
            getOaidEnable(call);
        }
        if (call.method.equals("getSinbEnable")) {
            getSinbEnable(call);
        }
        if (call.method.equals("getSiEnable")) {
            getSiEnable(call);
        }
        if (call.method.equals("getIEnable")) {
            getIEnable(call);
        }
        if (call.method.equals("getMaEnable")) {
            getMaEnable(call);
        }
        if (call.method.equals("getImEnable")) {
            getImEnable(call);
        }
        if (call.method.equals("clearScripCache")) {
            OneKeyLoginManager.getInstance().clearScripCache(context);
        }
        if (call.method.equals("setTimeOutForPreLogin")) {
            int timeOut = call.argument("timeOut");
            OneKeyLoginManager.getInstance().setTimeOutForPreLogin(timeOut);
        }
        if (call.method.equals("performLoginClick")) {
            OneKeyLoginManager.getInstance().performLoginClick();
        }
        if (call.method.equals("getPrivacyCheckBox")) {
            getPrivacyCheckBox(call, result);
        }
        if (call.method.equals("setActivityLifecycleCallbacksEnable")) {
            boolean enable = call.argument("activityLifecycleCallbacksEnable");
            OneKeyLoginManager.getInstance().setActivityLifecycleCallbacksEnable(enable);
        }
        if (call.method.equals("checkProcessesEnable")) {
            boolean enable = call.argument("checkProcessesEnable");
            OneKeyLoginManager.getInstance().checkProcessesEnable(enable);
        }
        if (call.method.equals("removeAllListener")) {
            OneKeyLoginManager.getInstance().removeAllListener();
        }
    }

    private void setPrivacyOnClickListener(MethodCall call, Result result) {
        OneKeyLoginManager.getInstance().setPrivacyOnClickListener(new PricacyOnClickListener() {
            @Override
            public void onClick(String s, String s1) {
                Map<String, Object> map = new HashMap<>();
                map.put("url", s);
                map.put("name", s1);
                Log.e(TAG, "map=" + map);
                channel.invokeMethod("onReceivePrivacyEvent", map);
            }
        });
    }

    private void getPrivacyCheckBox(MethodCall call, Result result) {
        CheckBox privacyCheckBox = OneKeyLoginManager.getInstance().getPrivacyCheckBox();
        result.success(privacyCheckBox);
    }

    private void getImEnable(MethodCall call) {
        boolean imEnable = call.argument("imEnable");
        OneKeyLoginManager.getInstance().getImEnable(imEnable);
    }

    private void getMaEnable(MethodCall call) {
        boolean maEnable = call.argument("maEnable");
        OneKeyLoginManager.getInstance().getMaEnable(maEnable);
    }

    private void getIEnable(MethodCall call) {
        boolean iEnable = call.argument("iEnable");
        OneKeyLoginManager.getInstance().getIEnable(iEnable);
    }

    private void getSiEnable(MethodCall call) {
        boolean sibEnable = call.argument("sibEnable");
        OneKeyLoginManager.getInstance().getSiEnable(sibEnable);
    }

    private void getSinbEnable(MethodCall call) {
        boolean sinbEnable = call.argument("sinbEnable");
        OneKeyLoginManager.getInstance().getSinbEnable(sinbEnable);
    }

    private void getOaidEnable(MethodCall call) {
        boolean oaidEnable = call.argument("oaidEnable");
        OneKeyLoginManager.getInstance().getOaidEnable(oaidEnable);
    }

    private void getOperatorType(MethodCall call, Result result) {
        String operatorType = OneKeyLoginManager.getInstance().getOperatorType(context);
        result.success(operatorType);
    }

    private void getOperatorInfo(MethodCall call, Result result) {
        String operatorInfo = OneKeyLoginManager.getInstance().getOperatorInfo(context);
        result.success(operatorInfo);
    }

    private void setActionListener(MethodCall call, Result result) {
        OneKeyLoginManager.getInstance().setActionListener(new ActionListener() {
            @Override
            public void ActionListner(int i, int i1, String s) {
                Map<String, Object> map = new HashMap<>();
                map.put(shanyan_type, i);
                map.put(shanyan_code, i1);
                map.put(shanyan_message, s);
                Log.e(TAG, "map=" + map.toString());
                channel.invokeMethod("onReceiveAuthEvent", map);
            }
        });
    }

    private void setCheckBoxValue(MethodCall call) {
        boolean isChecked = call.argument("isChecked");
        OneKeyLoginManager.getInstance().setCheckBoxValue(isChecked);
    }

    private void setLoadingVisibility(MethodCall call) {
        boolean visibility = call.argument("visibility");
        OneKeyLoginManager.getInstance().setLoadingVisibility(visibility);
    }

    private void startAuthentication(MethodCall call, final Result result) {
        OneKeyLoginManager.getInstance().startAuthentication(new AuthenticationExecuteListener() {
            @Override
            public void authenticationRespond(int code, String msg) {
                Map<String, Object> map = new HashMap<>();
                if (2000 == code) {
                    map.put(shanyan_code, 1000);
                } else {
                    map.put(shanyan_code, code);
                }
                map.put(shanyan_message, msg);
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    if (2000 == code) {
                        map.put(shanyan_token, jsonObject.optString("token"));
                    } else {
                        map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                        map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                result.success(map);
            }
        });
    }

    private void openLoginAuth(MethodCall call, final Result result) {
        //闪验SDK 拉起授权页
        OneKeyLoginManager.getInstance().openLoginAuth(isFinish, new OpenLoginAuthListener() {
            @Override
            public void getOpenLoginAuthStatus(int code, String msg) {
                //授权页是否拉起成功回调
                Map<String, Object> map = new HashMap<>();
                map.put(shanyan_code, code);
                map.put(shanyan_message, msg);
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                    map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                result.success(map);
            }
        }, new OneKeyLoginListener() {
            @Override
            public void getOneKeyLoginStatus(int code, String msg) {
                //点击授权页“一键登录”按钮或者返回键（包括物理返回键）回调
                Map<String, Object> map = new HashMap<>();
                map.put(shanyan_code, code);
                map.put(shanyan_message, msg);
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    if (1000 == code) {
                        map.put(shanyan_token, jsonObject.optString("token"));
                    } else {
                        map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                        map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                channel.invokeMethod("onReceiveAuthPageEvent", map);
            }
        });
    }

    private void getPhoneInfo(final Result result) {
        OneKeyLoginManager.getInstance().getPhoneInfo(new GetPhoneInfoListener() {
            @Override
            public void getPhoneInfoStatus(int code, String msg) {
                Map<String, Object> map = new HashMap<>();
                if (1022 == code) {
                    map.put(shanyan_code, 1000);
                } else {
                    map.put(shanyan_code, code);
                }
                map.put(shanyan_message, msg);
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                    map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                result.success(map);
            }
        });
    }

    private void init(MethodCall call, final Result result) {
        String appId = call.argument("appId");
        OneKeyLoginManager.getInstance().init(context, appId, new InitListener() {
            @Override
            public void getInitStatus(int code, String msg) {
                Map<String, Object> map = new HashMap<>();
                if (1022 == code) {
                    map.put(shanyan_code, 1000);
                } else {
                    map.put(shanyan_code, code);
                }
                map.put(shanyan_message, msg);
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                    map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                result.success(map);
            }
        });
    }

    private void setDebug(MethodCall call) {
        boolean debug = call.argument("debug");
        OneKeyLoginManager.getInstance().setDebug(debug);
    }

    private void setInitDebug(MethodCall call) {
        boolean debug = call.argument("initDebug");
        OneKeyLoginManager.getInstance().setInitDebug(debug);
    }

    private void setAuthThemeConfig(MethodCall call, Result result) {
        //竖屏设置
        Map portraitConfig = call.argument("androidPortrait");
        List<Map> portraitWidgets = (List<Map>) valueForKey(portraitConfig, "widgets");
        List<Map> portraitWidgetLayout = (List<Map>) valueForKey(portraitConfig, "widgetLayouts");
        List<Map> morePrivacy = (List<Map>) valueForKey(portraitConfig, "morePrivacy");
        ShanYanUIConfig.Builder builder = new ShanYanUIConfig.Builder();
        if (null != morePrivacy) {
            setMorePrivacy(morePrivacy, builder);
        }
        if (null != portraitConfig) {
            setAuthLayoutView(portraitConfig, builder);
        }
        if (null != portraitWidgets) {
            for (Map widgetMap : portraitWidgets) {
                /// 新增自定义的控件
                String type = (String) widgetMap.get("type");
                if ("TextView".equals(type)) {
                    addCustomTextWidgets(widgetMap, builder);
                } else if ("Button".equals(type)) {
                    addCustomBtnWidgets(widgetMap, builder);
                } else {
                    Log.e(TAG, "don't support widget");
                }
            }
        }
        if (null != portraitWidgetLayout) {
            for (Map widgetMap : portraitWidgetLayout) {
                /// 新增自定义的控件
                String type = (String) widgetMap.get("type");
                if (type.equals("RelativeLayout")) {
                    addCustomRelativeLayoutWidgets(widgetMap, builder);
                } else {
                    Log.e(TAG, "don't support widgetlayout");
                }
            }
        }

        //横屏设置
        Map landscapeConfig = call.argument("androidLandscape");
        List<Map> landscapeWidgets = (List<Map>) valueForKey(landscapeConfig, "widgets");
        List<Map> landscapeWidgetLayout = (List<Map>) valueForKey(landscapeConfig, "widgetLayouts");
        ShanYanUIConfig.Builder landscapeBuilder = new ShanYanUIConfig.Builder();
        if (null != landscapeConfig) {
            setAuthLayoutView(landscapeConfig, landscapeBuilder);
        }
        if (null != landscapeWidgets) {
            for (Map widgetMap : landscapeWidgets) {
                /// 新增自定义的控件
                String type = (String) widgetMap.get("type");
                if ("TextView".equals(type)) {
                    addCustomTextWidgets(widgetMap, landscapeBuilder);
                } else if ("Button".equals(type)) {
                    addCustomBtnWidgets(widgetMap, landscapeBuilder);
                } else {
                    Log.e(TAG, "don't support widget");
                }
            }
        }
        if (null != landscapeWidgetLayout) {
            for (Map widgetMap : landscapeWidgetLayout) {
                /// 新增自定义的控件
                String type = (String) widgetMap.get("type");
                if (type.equals("RelativeLayout")) {
                    addCustomRelativeLayoutWidgets(widgetMap, landscapeBuilder);
                } else {
                    Log.e(TAG, "don't support widgetlayout");
                }
            }
        }
        ShanYanUIConfig portraitUIConfig = builder.build();
        ShanYanUIConfig landscapeUIConfig;
        if (null != landscapeBuilder) {
            landscapeUIConfig = landscapeBuilder.build();
        } else {
            landscapeUIConfig = null;
        }
        OneKeyLoginManager.getInstance().setAuthThemeConfig(portraitUIConfig, landscapeUIConfig);
    }

    private void setMorePrivacy(List<Map> morePrivacy, ShanYanUIConfig.Builder builder) {
        List<ConfigPrivacyBean> list = new ArrayList();
        for (Map privacy : morePrivacy) {
            String name = (String) privacy.get("name");
            String url = (String) privacy.get("url");
            String color = (String) privacy.get("color");
            String midStr = (String) privacy.get("midStr");
            String title = (String) privacy.get("title");
            ConfigPrivacyBean bean = new ConfigPrivacyBean(name, url);
            if (!TextUtils.isEmpty(color)) {
                bean.setColor(Color.parseColor(color));
            }
            if (!TextUtils.isEmpty(midStr)) {
                bean.setMidStr(midStr);
            }
            if (!TextUtils.isEmpty(title)) {
                bean.setTitle(title);
            }
            list.add(bean);
        }
        builder.setMorePrivacy(list);
    }

    /**
     * 添加自定义xml布局文件
     */
    private void addCustomRelativeLayoutWidgets(Map para, ShanYanUIConfig.Builder builder) {
        Log.d(TAG, "addCustomRelativeLayoutWidgets: para = " + para);
        String widgetLayoutName = (String) para.get("widgetLayoutName");
        Object widgetId = para.get("widgetLayoutId");
        int left = (Integer) para.get("left");
        int top = (Integer) para.get("top");
        int right = (Integer) para.get("right");
        int bottom = (Integer) para.get("bottom");
        int width = (Integer) para.get("width");
        int height = (Integer) para.get("height");
        LayoutInflater inflater1 = LayoutInflater.from(context);
        if (0 != getLayoutForId(widgetLayoutName)) {
            RelativeLayout relativeLayout = (RelativeLayout) inflater1.inflate(getLayoutForId(widgetLayoutName), null);
            RelativeLayout.LayoutParams mLayoutParams1 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
            mLayoutParams1.addRule(RelativeLayout.CENTER_HORIZONTAL);
            if (left > 0) {
                mLayoutParams1.leftMargin = dp2Pix(context, (float) left);
                mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
            }
            if (top > 0) {
                mLayoutParams1.topMargin = dp2Pix(context, (float) top);
            }
            if (right > 0) {
                mLayoutParams1.rightMargin = dp2Pix(context, (float) right);
                mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
            }
            if (bottom > 0) {
                mLayoutParams1.bottomMargin = dp2Pix(context, (float) bottom);
                mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
            }
            if (width > 0) {
                mLayoutParams1.width = dp2Pix(context, (float) width);
            }
            if (height > 0) {
                mLayoutParams1.height = dp2Pix(context, (float) height);
            }
            if (null != relativeLayout) {
                relativeLayout.setLayoutParams(mLayoutParams1);
                //授权页 隐私协议栏
                if (null != widgetId) {
                    final ArrayList<String> widgetIdList = (ArrayList) widgetId;
                    if (null != widgetIdList && widgetIdList.size() > 0) {
                        for (int i = 0; i < widgetIdList.size(); i++) {
                            if (0 != (getId(widgetIdList.get(i)))) {
                                final int finalI = i;
                                relativeLayout.findViewById(getId(widgetIdList.get(i))).setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        final Map<String, Object> jsonMap = new HashMap<>();
                                        jsonMap.put(shanyan_widgetId, widgetIdList.get(finalI));
                                        channel.invokeMethod("onReceiveClickWidgetEvent", jsonMap);
                                    }
                                });
                            }

                        }
                    }
                }
                builder.addCustomView(relativeLayout, false, false, null);
            }
        } else {
            Log.d(TAG, "layout【" + widgetLayoutName + "】 not found!");
        }
    }

    /**
     * 添加自定义 Button
     */
    private void addCustomBtnWidgets(Map para, ShanYanUIConfig.Builder builder) {
        Log.d(TAG, "addCustomBtnView " + para);
        String widgetId = (String) para.get("widgetId");
        int left = (Integer) para.get("left");
        int top = (Integer) para.get("top");
        int right = (Integer) para.get("right");
        int bottom = (Integer) para.get("bottom");
        int width = (Integer) para.get("width");
        int height = (Integer) para.get("height");
        String textContent = (String) para.get("textContent");
        Object font = para.get("textFont");
        Object textColor = para.get("textColor");
        Object backgroundColor = para.get("backgroundColor");
        Object backgroundImgPath = para.get("backgroundImgPath");
        Object alignmet = para.get("textAlignment");
        boolean isFinish = (Boolean) para.get("isFinish");
        Button customView = new Button(context);
        customView.setText(textContent);
        if (textColor != null) {
            customView.setTextColor(Color.parseColor((String) textColor));
        }
        if (font != null) {
            double titleFont = (double) font;
            if (titleFont > 0) {
                customView.setTextSize((float) titleFont);
            }
        }
        if (backgroundColor != null) {
            customView.setBackgroundColor(Color.parseColor((String) backgroundColor));
        }
        if (null != getDrawableByReflect(backgroundImgPath)) {
            customView.setBackground(getDrawableByReflect(backgroundImgPath));
        }
        if (alignmet != null) {
            String textAlignment = (String) alignmet;
            int gravity = getAlignmentFromString(textAlignment);
            customView.setGravity(gravity);
        }
        RelativeLayout.LayoutParams mLayoutParams1 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        mLayoutParams1.addRule(RelativeLayout.CENTER_HORIZONTAL);
        if (left > 0) {
            mLayoutParams1.leftMargin = dp2Pix(context, (float) left);
            mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        }
        if (top > 0) {
            mLayoutParams1.topMargin = dp2Pix(context, (float) top);
        }
        if (right > 0) {
            mLayoutParams1.rightMargin = dp2Pix(context, (float) right);
            mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        }
        if (bottom > 0) {
            mLayoutParams1.bottomMargin = dp2Pix(context, (float) bottom);
            mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        }
        if (width > 0) {
            mLayoutParams1.width = dp2Pix(context, (float) width);
        }
        if (height > 0) {
            mLayoutParams1.height = dp2Pix(context, (float) height);
        }
        customView.setLayoutParams(mLayoutParams1);
        final HashMap jsonMap = new HashMap();
        jsonMap.put(shanyan_widgetId, widgetId);
        builder.addCustomView(customView, isFinish, false, new ShanYanCustomInterface() {
            @Override
            public void onClick(Context context, View view) {
                channel.invokeMethod("onReceiveClickWidgetEvent", jsonMap);
            }
        });
    }

    /**
     * 添加自定义 TextView
     */
    private void addCustomTextWidgets(Map para, ShanYanUIConfig.Builder builder) {
        Log.d(TAG, "addCustomTextView " + para);
        String widgetId = (String) para.get("widgetId");
        int left = (Integer) para.get("left");
        int top = (Integer) para.get("top");
        int right = (Integer) para.get("right");
        int bottom = (Integer) para.get("bottom");
        int width = (Integer) para.get("width");
        int height = (Integer) para.get("height");
        String textContent = (String) para.get("textContent");
        Object font = para.get("textFont");
        Object textColor = para.get("textColor");
        Object backgroundColor = para.get("backgroundColor");
        Object backgroundImgPath = para.get("backgroundImgPath");
        Object alignmet = para.get("textAlignment");
        boolean isFinish = (Boolean) para.get("isFinish");
        TextView customView = new TextView(context);
        customView.setText(textContent);
        if (textColor != null) {
            customView.setTextColor(Color.parseColor((String) textColor));
        }
        if (font != null) {
            double titleFont = (double) font;
            if (titleFont > 0) {
                customView.setTextSize((float) titleFont);
            }
        }
        if (backgroundColor != null) {
            customView.setBackgroundColor(Color.parseColor((String) backgroundColor));
        }
        if (null != getDrawableByReflect(backgroundImgPath)) {
            customView.setBackground(getDrawableByReflect(backgroundImgPath));
        }
        if (alignmet != null) {
            String textAlignment = (String) alignmet;
            int gravity = getAlignmentFromString(textAlignment);
            customView.setGravity(gravity);
        }
        RelativeLayout.LayoutParams mLayoutParams1 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        mLayoutParams1.addRule(RelativeLayout.CENTER_HORIZONTAL);
        if (left > 0) {
            mLayoutParams1.leftMargin = dp2Pix(context, (float) left);
            mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        }
        if (top > 0) {
            mLayoutParams1.topMargin = dp2Pix(context, (float) top);
        }
        if (right > 0) {
            mLayoutParams1.rightMargin = dp2Pix(context, (float) right);
            mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        }
        if (bottom > 0) {
            mLayoutParams1.bottomMargin = dp2Pix(context, (float) bottom);
            mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        }
        if (width > 0) {
            mLayoutParams1.width = dp2Pix(context, (float) width);
        }
        if (height > 0) {
            mLayoutParams1.height = dp2Pix(context, (float) height);
        }
        customView.setLayoutParams(mLayoutParams1);
        final HashMap jsonMap = new HashMap();
        jsonMap.put(shanyan_widgetId, widgetId);
        builder.addCustomView(customView, isFinish, false, new ShanYanCustomInterface() {
            @Override
            public void onClick(Context context, View view) {
                channel.invokeMethod("onReceiveClickWidgetEvent", jsonMap);
            }
        });
    }

    private void setAuthLayoutView(Map shanYanUIConfig, ShanYanUIConfig.Builder builder) {
        Log.d(TAG, "shanYanUIConfig " + shanYanUIConfig);
        Object isFinish = valueForKey(shanYanUIConfig, "isFinish");
        Object setAuthBGImgPath = valueForKey(shanYanUIConfig, "setAuthBGImgPath");
        Object setAuthBgGifPath = valueForKey(shanYanUIConfig, "setAuthBgGifPath");
        Object setAuthBgVideoPath = valueForKey(shanYanUIConfig, "setAuthBgVideoPath");

        Object setStatusBarColor = valueForKey(shanYanUIConfig, "setStatusBarColor");
        Object setLogBtnBackgroundColor = valueForKey(shanYanUIConfig, "setLogBtnBackgroundColor");
        Object setLightColor = valueForKey(shanYanUIConfig, "setLightColor");
        Object setStatusBarHidden = valueForKey(shanYanUIConfig, "setStatusBarHidden");
        Object setVirtualKeyTransparent = valueForKey(shanYanUIConfig, "setVirtualKeyTransparent");
        Object setAuthFlagSecureEnable = valueForKey(shanYanUIConfig, "setAuthFlagSecureEnable");
        Object setPrivacyFlagSecureEnable = valueForKey(shanYanUIConfig, "setPrivacyFlagSecureEnable");

        Object setFullScreen = valueForKey(shanYanUIConfig, "setFullScreen");
        Object setNavColor = valueForKey(shanYanUIConfig, "setNavColor");
        Object setNavText = valueForKey(shanYanUIConfig, "setNavText");
        Object setNavTextColor = valueForKey(shanYanUIConfig, "setNavTextColor");
        Object setNavTextSize = valueForKey(shanYanUIConfig, "setNavTextSize");
        Object setNavReturnImgPath = valueForKey(shanYanUIConfig, "setNavReturnImgPath");
        Object setNavReturnImgHidden = valueForKey(shanYanUIConfig, "setNavReturnImgHidden");
        Object setNavReturnBtnWidth = valueForKey(shanYanUIConfig, "setNavReturnBtnWidth");
        Object setNavReturnBtnHeight = valueForKey(shanYanUIConfig, "setNavReturnBtnHeight");
        Object setNavReturnBtnOffsetRightX = valueForKey(shanYanUIConfig, "setNavReturnBtnOffsetRightX");
        Object setNavReturnBtnOffsetX = valueForKey(shanYanUIConfig, "setNavReturnBtnOffsetX");
        Object setNavReturnBtnOffsetY = valueForKey(shanYanUIConfig, "setNavReturnBtnOffsetY");
        Object setAuthNavHidden = valueForKey(shanYanUIConfig, "setAuthNavHidden");
        Object setAuthNavTransparent = valueForKey(shanYanUIConfig, "setAuthNavTransparent");
        Object setNavTextBold = valueForKey(shanYanUIConfig, "setNavTextBold");
        Object setBackPressedAvailable = valueForKey(shanYanUIConfig, "setBackPressedAvailable");
        Object setFitsSystemWindows = valueForKey(shanYanUIConfig, "setFitsSystemWindows");


        Object setLogoImgPath = valueForKey(shanYanUIConfig, "setLogoImgPath");
        Object setLogoWidth = valueForKey(shanYanUIConfig, "setLogoWidth");
        Object setLogoHeight = valueForKey(shanYanUIConfig, "setLogoHeight");
        Object setLogoOffsetY = valueForKey(shanYanUIConfig, "setLogoOffsetY");
        Object setLogoOffsetBottomY = valueForKey(shanYanUIConfig, "setLogoOffsetBottomY");
        Object setLogoHidden = valueForKey(shanYanUIConfig, "setLogoHidden");
        Object setLogoOffsetX = valueForKey(shanYanUIConfig, "setLogoOffsetX");

        Object setNumberColor = valueForKey(shanYanUIConfig, "setNumberColor");
        Object setNumFieldOffsetY = valueForKey(shanYanUIConfig, "setNumFieldOffsetY");
        Object setNumFieldOffsetBottomY = valueForKey(shanYanUIConfig, "setNumFieldOffsetBottomY");
        Object setNumFieldWidth = valueForKey(shanYanUIConfig, "setNumFieldWidth");
        Object setNumFieldHeight = valueForKey(shanYanUIConfig, "setNumFieldHeight");
        Object setNumberSize = valueForKey(shanYanUIConfig, "setNumberSize");
        Object setNumFieldOffsetX = valueForKey(shanYanUIConfig, "setNumFieldOffsetX");
        Object setNumberBold = valueForKey(shanYanUIConfig, "setNumberBold");
        Object setTextSizeIsdp = valueForKey(shanYanUIConfig, "setTextSizeIsdp");


        Object setLogBtnText = valueForKey(shanYanUIConfig, "setLogBtnText");
        Object setLogBtnTextColor = valueForKey(shanYanUIConfig, "setLogBtnTextColor");
        Object setLogBtnImgPath = valueForKey(shanYanUIConfig, "setLogBtnImgPath");
        Object setLogBtnOffsetY = valueForKey(shanYanUIConfig, "setLogBtnOffsetY");
        Object setLogBtnOffsetBottomY = valueForKey(shanYanUIConfig, "setLogBtnOffsetBottomY");
        Object setLogBtnTextSize = valueForKey(shanYanUIConfig, "setLogBtnTextSize");
        Object setLogBtnHeight = valueForKey(shanYanUIConfig, "setLogBtnHeight");
        Object setLogBtnWidth = valueForKey(shanYanUIConfig, "setLogBtnWidth");
        Object setLogBtnOffsetX = valueForKey(shanYanUIConfig, "setLogBtnOffsetX");
        Object setLogBtnTextBold = valueForKey(shanYanUIConfig, "setLogBtnTextBold");

        Object setAppPrivacyOne = valueForKey(shanYanUIConfig, "setAppPrivacyOne");
        Object setAppPrivacyTwo = valueForKey(shanYanUIConfig, "setAppPrivacyTwo");
        Object setAppPrivacyThree = valueForKey(shanYanUIConfig, "setAppPrivacyThree");
        Object setPrivacySmhHidden = valueForKey(shanYanUIConfig, "setPrivacySmhHidden");
        Object setPrivacyTextSize = valueForKey(shanYanUIConfig, "setPrivacyTextSize");
        Object setPrivacyWidth = valueForKey(shanYanUIConfig, "setPrivacyWidth");
        Object setAppPrivacyColor = valueForKey(shanYanUIConfig, "setAppPrivacyColor");
        Object setPrivacyOffsetBottomY = valueForKey(shanYanUIConfig, "setPrivacyOffsetBottomY");
        Object setPrivacyOffsetY = valueForKey(shanYanUIConfig, "setPrivacyOffsetY");
        Object setPrivacyOffsetX = valueForKey(shanYanUIConfig, "setPrivacyOffsetX");
        Object setCheckBoxOffsetXY = valueForKey(shanYanUIConfig, "setCheckBoxOffsetXY");

        Object setPrivacyOffsetGravityLeft = valueForKey(shanYanUIConfig, "setPrivacyOffsetGravityLeft");
        Object setPrivacyState = valueForKey(shanYanUIConfig, "setPrivacyState");
        Object setPrivacyActivityEnabled = valueForKey(shanYanUIConfig, "setPrivacyActivityEnabled");
        Object setPrivacyGravityHorizontalCenter = valueForKey(shanYanUIConfig, "setPrivacyGravityHorizontalCenter");
        Object setUncheckedImgPath = valueForKey(shanYanUIConfig, "setUncheckedImgPath");
        Object setCheckedImgPath = valueForKey(shanYanUIConfig, "setCheckedImgPath");
        Object setCheckBoxHidden = valueForKey(shanYanUIConfig, "setCheckBoxHidden");
        Object setCheckBoxWH = valueForKey(shanYanUIConfig, "setCheckBoxWH");
        Object setCheckBoxMargin = valueForKey(shanYanUIConfig, "setCheckBoxMargin");
        Object setPrivacyText = valueForKey(shanYanUIConfig, "setPrivacyText");
        Object setPrivacyTextBold = valueForKey(shanYanUIConfig, "setPrivacyTextBold");
        Object setCheckBoxTipDisable = valueForKey(shanYanUIConfig, "setCheckBoxTipDisable");
        Object setPrivacyCustomToastText = valueForKey(shanYanUIConfig, "setPrivacyCustomToastText");
        Object setPrivacyNameUnderline = valueForKey(shanYanUIConfig, "setPrivacyNameUnderline");
        Object setOperatorPrivacyAtLast = valueForKey(shanYanUIConfig, "setOperatorPrivacyAtLast");
        Object setSloganTextColor = valueForKey(shanYanUIConfig, "setSloganTextColor");
        Object setSloganTextSize = valueForKey(shanYanUIConfig, "setSloganTextSize");
        Object setSloganOffsetY = valueForKey(shanYanUIConfig, "setSloganOffsetY");
        Object setSloganHidden = valueForKey(shanYanUIConfig, "setSloganHidden");
        Object setSloganOffsetBottomY = valueForKey(shanYanUIConfig, "setSloganOffsetBottomY");
        Object setSloganOffsetX = valueForKey(shanYanUIConfig, "setSloganOffsetX");
        Object setSloganTextBold = valueForKey(shanYanUIConfig, "setSloganTextBold");

        Object setShanYanSloganTextColor = valueForKey(shanYanUIConfig, "setShanYanSloganTextColor");
        Object setShanYanSloganTextSize = valueForKey(shanYanUIConfig, "setShanYanSloganTextSize");
        Object setShanYanSloganOffsetY = valueForKey(shanYanUIConfig, "setShanYanSloganOffsetY");
        Object setShanYanSloganHidden = valueForKey(shanYanUIConfig, "setShanYanSloganHidden");
        Object setShanYanSloganOffsetBottomY = valueForKey(shanYanUIConfig, "setShanYanSloganOffsetBottomY");
        Object setShanYanSloganOffsetX = valueForKey(shanYanUIConfig, "setShanYanSloganOffsetX");
        Object setShanYanSloganTextBold = valueForKey(shanYanUIConfig, "setShanYanSloganTextBold");

        Object setPrivacyNavColor = valueForKey(shanYanUIConfig, "setPrivacyNavColor");
        Object setPrivacyNavTextBold = valueForKey(shanYanUIConfig, "setPrivacyNavTextBold");
        Object setPrivacyNavTextColor = valueForKey(shanYanUIConfig, "setPrivacyNavTextColor");
        Object setPrivacyNavTextSize = valueForKey(shanYanUIConfig, "setPrivacyNavTextSize");
        Object setPrivacyNavReturnImgPath = valueForKey(shanYanUIConfig, "setPrivacyNavReturnImgPath");
        Object setPrivacyNavReturnImgHidden = valueForKey(shanYanUIConfig, "setPrivacyNavReturnImgHidden");
        Object setPrivacyNavReturnBtnWidth = valueForKey(shanYanUIConfig, "setPrivacyNavReturnBtnWidth");
        Object setPrivacyNavReturnBtnHeight = valueForKey(shanYanUIConfig, "setPrivacyNavReturnBtnHeight");
        Object setPrivacyNavReturnBtnOffsetRightX = valueForKey(shanYanUIConfig, "setPrivacyNavReturnBtnOffsetRightX");
        Object setPrivacyNavReturnBtnOffsetX = valueForKey(shanYanUIConfig, "setPrivacyNavReturnBtnOffsetX");
        Object setPrivacyNavReturnBtnOffsetY = valueForKey(shanYanUIConfig, "setPrivacyNavReturnBtnOffsetY");

        Object addCustomPrivacyAlertView = valueForKey(shanYanUIConfig, "addCustomPrivacyAlertView");

        Object setLoadingView = valueForKey(shanYanUIConfig, "setLoadingView");
        Object setDialogTheme = valueForKey(shanYanUIConfig, "setDialogTheme");
        Object setActivityTranslateAnim = valueForKey(shanYanUIConfig, "setActivityTranslateAnim");
        if (0 != getLayoutForId((String) setLoadingView)) {
            RelativeLayout.LayoutParams mLayoutParams3 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
            RelativeLayout view_dialog = (RelativeLayout) LayoutInflater.from(context).inflate(getLayoutForId((String) setLoadingView), null);
            view_dialog.setLayoutParams(mLayoutParams3);
            builder.setLoadingView(view_dialog);
        }
        if (0 != getLayoutForId((String) addCustomPrivacyAlertView)) {
            RelativeLayout.LayoutParams mLayoutParamsAlert = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
            RelativeLayout privacyAlertView = (RelativeLayout) LayoutInflater.from(context).inflate(getLayoutForId((String) addCustomPrivacyAlertView), null);
            privacyAlertView.setLayoutParams(mLayoutParamsAlert);
            builder.addCustomPrivacyAlertView(privacyAlertView);
        }
        //授权页背景
        if (null != isFinish) {
            this.isFinish = (Boolean) isFinish;
        }
        if (null != getDrawableByReflect(setAuthBGImgPath)) {
            builder.setAuthBGImgPath(getDrawableByReflect(setAuthBGImgPath));
        }
        if (null != setAuthBgGifPath) {
            builder.setAuthBgGifPath((String) setAuthBgGifPath);
        }
        if (null != setAuthBgVideoPath) {
            int bgVideoId = getRawForId((String) setAuthBgVideoPath);
            if (bgVideoId != 0) {
                String bgVideoPath = "android.resource://" + context.getPackageName() + "/" + bgVideoId;
                builder.setAuthBgVideoPath(bgVideoPath);
            }
        }
        //状态栏
        if (null != setStatusBarColor) {
            builder.setStatusBarColor(Color.parseColor((String) setStatusBarColor));
        }
        if (null != setLogBtnBackgroundColor) {
            builder.setLogBtnBackgroundColor(Color.parseColor((String) setLogBtnBackgroundColor));
        }
        if (null != setLightColor) {
            builder.setLightColor((Boolean) setLightColor);
        }
        if (null != setStatusBarHidden) {
            builder.setStatusBarHidden((Boolean) setStatusBarHidden);
        }
        if (null != setVirtualKeyTransparent) {
            builder.setVirtualKeyTransparent((Boolean) setVirtualKeyTransparent);
        }
        if (null != setAuthFlagSecureEnable) {
            builder.setAuthFlagSecureEnable((Boolean) setAuthFlagSecureEnable);
        }
        if (null != setPrivacyFlagSecureEnable) {
            builder.setPrivacyFlagSecureEnable((Boolean) setPrivacyFlagSecureEnable);
        }

        //导航栏
        if (null != setFullScreen) {
            builder.setFullScreen((Boolean) setFullScreen);
        }
        if (null != setNavColor) {
            builder.setNavColor(Color.parseColor((String) setNavColor));
        }
        if (null != setNavText) {
            builder.setNavText((String) setNavText);
        }
        if (null != setNavTextColor) {
            builder.setNavTextColor(Color.parseColor((String) setNavTextColor));
        }
        if (null != setNavTextSize) {
            builder.setNavTextSize((Integer) setNavTextSize);
        }
        if (null != setNavReturnImgPath) {
            builder.setNavReturnImgPath(getDrawableByReflect(setNavReturnImgPath));
        }
        if (null != setNavReturnImgHidden) {
            builder.setNavReturnImgHidden((Boolean) setNavReturnImgHidden);
        }
        if (null != setBackPressedAvailable) {
            builder.setBackPressedAvailable((Boolean) setBackPressedAvailable);
        }
        if (null != setFitsSystemWindows) {
            builder.setFitsSystemWindows((Boolean) setFitsSystemWindows);
        }
        if (null != setNavReturnBtnWidth) {
            builder.setNavReturnBtnWidth((Integer) setNavReturnBtnWidth);
        }
        if (null != setNavReturnBtnHeight) {
            builder.setNavReturnBtnHeight((Integer) setNavReturnBtnHeight);
        }
        if (null != setNavReturnBtnOffsetRightX) {
            builder.setNavReturnBtnOffsetRightX((Integer) setNavReturnBtnOffsetRightX);
        }
        if (null != setNavReturnBtnOffsetX) {
            builder.setNavReturnBtnOffsetX((Integer) setNavReturnBtnOffsetX);
        }
        if (null != setNavReturnBtnOffsetY) {
            builder.setNavReturnBtnOffsetY((Integer) setNavReturnBtnOffsetY);
        }
        if (null != setAuthNavHidden) {
            builder.setAuthNavHidden((Boolean) setAuthNavHidden);
        }
        if (null != setAuthNavTransparent) {
            builder.setAuthNavTransparent((Boolean) setAuthNavTransparent);
        }
        if (null != setNavTextBold) {
            builder.setNavTextBold((Boolean) setNavTextBold);
        }
        // 授权页logo
        if (null != setLogoImgPath) {
            builder.setLogoImgPath(getDrawableByReflect(setLogoImgPath));
        }
        if (null != setLogoWidth) {
            builder.setLogoWidth((Integer) setLogoWidth);
        }
        if (null != setLogoHeight) {
            builder.setLogoHeight((Integer) setLogoHeight);
        }
        if (null != setLogoOffsetY) {
            builder.setLogoOffsetY((Integer) setLogoOffsetY);
        }
        if (null != setLogoOffsetBottomY) {
            builder.setLogoOffsetBottomY((Integer) setLogoOffsetBottomY);
        }
        if (null != setLogoHidden) {
            builder.setLogoHidden((Boolean) setLogoHidden);
        }
        if (null != setLogoOffsetX) {
            builder.setLogoOffsetX((Integer) setLogoOffsetX);
        }
        // 授权页 号码栏
        if (null != setNumberColor) {
            builder.setNumberColor(Color.parseColor((String) setNumberColor));
        }
        if (null != setNumFieldOffsetY) {
            builder.setNumFieldOffsetY((Integer) setNumFieldOffsetY);
        }
        if (null != setNumFieldOffsetBottomY) {
            builder.setNumFieldOffsetBottomY((Integer) setNumFieldOffsetBottomY);
        }
        if (null != setNumFieldWidth) {
            builder.setNumFieldWidth((Integer) setNumFieldWidth);
        }
        if (null != setNumFieldHeight) {
            builder.setNumFieldHeight((Integer) setNumFieldHeight);
        }
        if (null != setNumberSize) {
            builder.setNumberSize((Integer) setNumberSize);
        }
        if (null != setNumFieldOffsetX) {
            builder.setNumFieldOffsetX((Integer) setNumFieldOffsetX);
        }
        if (null != setNumberBold) {
            builder.setNumberBold((Boolean) setNumberBold);
        }
        if (null != setTextSizeIsdp) {
            builder.setTextSizeIsdp((Boolean) setTextSizeIsdp);
        }

        //授权页 登录按钮

        if (null != setLogBtnText) {
            builder.setLogBtnText((String) setLogBtnText);
        }
        if (null != setLogBtnTextColor) {
            builder.setLogBtnTextColor(Color.parseColor((String) setLogBtnTextColor));
        }
        if (null != setLogBtnImgPath) {
            builder.setLogBtnImgPath(getDrawableByReflect(setLogBtnImgPath));
        }
        if (null != setLogBtnOffsetY) {
            builder.setLogBtnOffsetY((Integer) setLogBtnOffsetY);
        }
        if (null != setLogBtnOffsetBottomY) {
            builder.setLogBtnOffsetBottomY((Integer) setLogBtnOffsetBottomY);
        }
        if (null != setLogBtnTextSize) {
            builder.setLogBtnTextSize((Integer) setLogBtnTextSize);
        }
        if (null != setLogBtnHeight) {
            builder.setLogBtnHeight((Integer) setLogBtnHeight);
        }
        if (null != setLogBtnWidth) {
            builder.setLogBtnWidth((Integer) setLogBtnWidth);
        }
        if (null != setLogBtnOffsetX) {
            builder.setLogBtnOffsetX((Integer) setLogBtnOffsetX);
        }
        if (null != setLogBtnTextBold) {
            builder.setLogBtnTextBold((Boolean) setLogBtnTextBold);
        }
        //授权页 隐私协议栏
        if (null != setAppPrivacyOne) {
            ArrayList<String> setAppPrivacyOneList = (ArrayList) setAppPrivacyOne;
            setAppPrivacyOneList.addAll(Arrays.asList("", ""));
            builder.setAppPrivacyOne(setAppPrivacyOneList.get(0), setAppPrivacyOneList.get(1));
        }
        if (null != setAppPrivacyTwo) {
            ArrayList<String> setAppPrivacyTwoList = (ArrayList) setAppPrivacyTwo;
            setAppPrivacyTwoList.addAll(Arrays.asList("", ""));
            builder.setAppPrivacyTwo(setAppPrivacyTwoList.get(0), setAppPrivacyTwoList.get(1));
        }
        if (null != setAppPrivacyThree) {
            ArrayList<String> setAppPrivacyThreeList = (ArrayList) setAppPrivacyThree;
            setAppPrivacyThreeList.addAll(Arrays.asList("", ""));
            builder.setAppPrivacyThree(setAppPrivacyThreeList.get(0), setAppPrivacyThreeList.get(1));
        }
        if (null != setPrivacySmhHidden) {
            builder.setPrivacySmhHidden((Boolean) setPrivacySmhHidden);
        }
        if (null != setPrivacyTextSize) {
            builder.setPrivacyTextSize((Integer) setPrivacyTextSize);
        }
        if (null != setPrivacyWidth) {
            builder.setPrivacyWidth((Integer) setPrivacyWidth);
        }
        if (null != setAppPrivacyColor) {
            ArrayList<String> setAppPrivacyColorList = (ArrayList) setAppPrivacyColor;
            setAppPrivacyColorList.addAll(Arrays.asList("", ""));
            builder.setAppPrivacyColor(Color.parseColor(setAppPrivacyColorList.get(0)), Color.parseColor(setAppPrivacyColorList.get(1)));
        }
        if (null != setPrivacyOffsetBottomY) {
            builder.setPrivacyOffsetBottomY((Integer) setPrivacyOffsetBottomY);
        }
        if (null != setPrivacyOffsetY) {
            builder.setPrivacyOffsetY((Integer) setPrivacyOffsetY);
        }
        if (null != setPrivacyOffsetX) {
            builder.setPrivacyOffsetX((Integer) setPrivacyOffsetX);
        }
        if (null != setPrivacyOffsetGravityLeft) {
            builder.setPrivacyOffsetGravityLeft((Boolean) setPrivacyOffsetGravityLeft);
        }
        if (null != setPrivacyState) {
            builder.setPrivacyState((Boolean) setPrivacyState);
        }
        if (null != setPrivacyActivityEnabled) {
            builder.setPrivacyActivityEnabled((Boolean) setPrivacyActivityEnabled);
        }
        if (null != setPrivacyGravityHorizontalCenter) {
            builder.setPrivacyGravityHorizontalCenter((Boolean) setPrivacyGravityHorizontalCenter);
        }
        if (null != setUncheckedImgPath) {
            builder.setUncheckedImgPath(getDrawableByReflect(setUncheckedImgPath));
        }
        if (null != setCheckedImgPath) {
            builder.setCheckedImgPath(getDrawableByReflect(setCheckedImgPath));
        }
        if (null != setCheckBoxHidden) {
            builder.setCheckBoxHidden((Boolean) setCheckBoxHidden);
        }
        if (null != setCheckBoxOffsetXY) {
            ArrayList<Integer> setcheckBoxOffsetXYList = (ArrayList) setCheckBoxOffsetXY;
            setcheckBoxOffsetXYList.addAll(Arrays.asList(0, 0));
            builder.setcheckBoxOffsetXY(setcheckBoxOffsetXYList.get(0), setcheckBoxOffsetXYList.get(1));
        }

        if (null != setCheckBoxWH) {
            ArrayList<Integer> setCheckBoxWHList = (ArrayList) setCheckBoxWH;
            setCheckBoxWHList.addAll(Arrays.asList(0, 0));
            builder.setCheckBoxWH(setCheckBoxWHList.get(0), setCheckBoxWHList.get(1));
        }
        if (null != setCheckBoxMargin) {
            ArrayList<Integer> setCheckBoxMarginList = (ArrayList) setCheckBoxMargin;
            setCheckBoxMarginList.addAll(Arrays.asList(0, 0, 0, 0));
            builder.setCheckBoxMargin(setCheckBoxMarginList.get(0), setCheckBoxMarginList.get(1), setCheckBoxMarginList.get(2), setCheckBoxMarginList.get(3));
        }
        if (null != setPrivacyText) {
            ArrayList<String> setPrivacyTextList = (ArrayList) setPrivacyText;
            setPrivacyTextList.addAll(Arrays.asList("", "", "", "", ""));
            builder.setPrivacyText(setPrivacyTextList.get(0), setPrivacyTextList.get(1), setPrivacyTextList.get(2), setPrivacyTextList.get(3), setPrivacyTextList.get(4));
        }
        if (null != setPrivacyTextBold) {
            builder.setPrivacyTextBold((Boolean) setPrivacyTextBold);
        }
        if (null != setCheckBoxTipDisable) {
            builder.setCheckBoxTipDisable((Boolean) setCheckBoxTipDisable);
        }
        if (null != setPrivacyCustomToastText) {
            builder.setPrivacyCustomToastText((String) setPrivacyCustomToastText);
        }
        if (null != setPrivacyNameUnderline) {
            builder.setPrivacyNameUnderline((Boolean) setPrivacyNameUnderline);
        }
        if (null != setOperatorPrivacyAtLast) {
            builder.setOperatorPrivacyAtLast((Boolean) setOperatorPrivacyAtLast);
        }
        //授权页 slogan（***提供认证服务）
        if (null != setSloganTextColor) {
            builder.setSloganTextColor(Color.parseColor((String) setSloganTextColor));
        }
        if (null != setSloganTextSize) {
            builder.setSloganTextSize((Integer) setSloganTextSize);
        }
        if (null != setSloganOffsetY) {
            builder.setSloganOffsetY((Integer) setSloganOffsetY);
        }
        if (null != setSloganHidden) {
            builder.setSloganHidden((Boolean) setSloganHidden);
        }
        if (null != setSloganOffsetBottomY) {
            builder.setSloganOffsetBottomY((Integer) setSloganOffsetBottomY);
        }
        if (null != setSloganOffsetX) {
            builder.setSloganOffsetX((Integer) setSloganOffsetX);
        }
        if (null != setSloganTextBold) {
            builder.setSloganTextBold((Boolean) setSloganTextBold);
        }
        //授权页 创蓝slogan（创蓝提供技术支持）
        if (null != setShanYanSloganTextColor) {
            builder.setShanYanSloganTextColor(Color.parseColor((String) setShanYanSloganTextColor));
        }
        if (null != setShanYanSloganTextSize) {
            builder.setShanYanSloganTextSize((Integer) setShanYanSloganTextSize);
        }
        if (null != setShanYanSloganOffsetY) {
            builder.setShanYanSloganOffsetY((Integer) setShanYanSloganOffsetY);
        }
        if (null != setShanYanSloganHidden) {
            builder.setShanYanSloganHidden((Boolean) setShanYanSloganHidden);
        }
        if (null != setShanYanSloganOffsetBottomY) {
            builder.setShanYanSloganOffsetBottomY((Integer) setShanYanSloganOffsetBottomY);
        }
        if (null != setShanYanSloganOffsetX) {
            builder.setShanYanSloganOffsetX((Integer) setShanYanSloganOffsetX);
        }
        if (null != setShanYanSloganTextBold) {
            builder.setShanYanSloganTextBold((Boolean) setShanYanSloganTextBold);
        }
        //协议页导航栏
        if (null != setPrivacyNavColor) {
            builder.setPrivacyNavColor(Color.parseColor((String) setPrivacyNavColor));
        }
        if (null != setPrivacyNavTextColor) {
            builder.setPrivacyNavTextColor(Color.parseColor((String) setPrivacyNavTextColor));
        }
        if (null != setPrivacyNavTextSize) {
            builder.setPrivacyNavTextSize((Integer) setPrivacyNavTextSize);
        }
        if (null != setPrivacyNavReturnImgPath) {
            builder.setPrivacyNavReturnImgPath(getDrawableByReflect(setPrivacyNavReturnImgPath));
        }
        if (null != setPrivacyNavReturnImgHidden) {
            builder.setPrivacyNavReturnImgHidden((Boolean) setPrivacyNavReturnImgHidden);
        }
        if (null != setPrivacyNavReturnBtnWidth) {
            builder.setPrivacyNavReturnBtnWidth((Integer) setPrivacyNavReturnBtnWidth);
        }
        if (null != setPrivacyNavReturnBtnHeight) {
            builder.setPrivacyNavReturnBtnHeight((Integer) setPrivacyNavReturnBtnHeight);
        }
        if (null != setPrivacyNavReturnBtnOffsetRightX) {
            builder.setPrivacyNavReturnBtnOffsetRightX((Integer) setPrivacyNavReturnBtnOffsetRightX);
        }
        if (null != setPrivacyNavReturnBtnOffsetX) {
            builder.setPrivacyNavReturnBtnOffsetX((Integer) setPrivacyNavReturnBtnOffsetX);
        }
        if (null != setPrivacyNavReturnBtnOffsetY) {
            builder.setPrivacyNavReturnBtnOffsetY((Integer) setPrivacyNavReturnBtnOffsetY);
        }
        if (null != setPrivacyNavTextBold) {
            builder.setPrivacyNavTextBold((Boolean) setPrivacyNavTextBold);
        }

        if (null != setDialogTheme) {
            ArrayList<String> setDialogThemeList = (ArrayList) setDialogTheme;
            setDialogThemeList.addAll(Arrays.asList("0", "0", "0", "0", "false"));
            builder.setDialogTheme(true, Integer.parseInt(setDialogThemeList.get(0)),
                    Integer.parseInt(setDialogThemeList.get(1)), Integer.parseInt(setDialogThemeList.get(2)),
                    Integer.parseInt(setDialogThemeList.get(3)), Boolean.parseBoolean(setDialogThemeList.get(4)));
        }
        if (null != setActivityTranslateAnim) {
            ArrayList<String> setActivityTranslateAnimList = (ArrayList) setActivityTranslateAnim;
            setActivityTranslateAnimList.addAll(Arrays.asList("0", "0"));
            builder.setActivityTranslateAnim(setActivityTranslateAnimList.get(0), setActivityTranslateAnimList.get(1));
        }

    }

    private Object valueForKey(Map para, String key) {
        if (para != null && para.containsKey(key)) {
            return para.get(key);
        } else {
            return null;
        }
    }

    private int getRawForId(String rawName) {
        if (null == rawName) {
            return 0;
        } else {
            Resources mResources = context.getResources();
            if (mResources != null) {
                return mResources.getIdentifier(rawName, "raw", context.getPackageName());
            } else {
                return 0;
            }
        }
    }

    public int getLayoutForId(String layoutname) {
        if (null == layoutname) {
            return 0;
        } else {
            Resources mResources = context.getResources();
            if (mResources != null) {
                return mResources.getIdentifier(layoutname, "layout", context.getPackageName());
            } else {
                return 0;
            }
        }
    }

    /*
     * 取id资源
     */
    public int getId(String idname) {
        if (null == idname) {
            return 0;
        } else {
            Resources mResources = context.getResources();
            if (mResources != null) {
                return mResources.getIdentifier(idname, "id", context.getPackageName());
            } else {
                return 0;
            }
        }
    }

    private Drawable getDrawableByReflect(Object imageName) {
        Class drawable = R.drawable.class;
        Field field = null;
        int r_id = 0;
        if (null == imageName) {
            return null;
        }
        try {
            field = drawable.getField((String) imageName);
            r_id = field.getInt(field.getName());
        } catch (Exception e) {
            r_id = 0;
        }
        if (r_id == 0) {
            r_id = context.getResources().getIdentifier((String) imageName, "drawable", context.getPackageName());
        }
        if (r_id == 0) {
            r_id = context.getResources().getIdentifier((String) imageName, "mipmap", context.getPackageName());
        }
        return context.getResources().getDrawable(r_id);
    }

    /**
     * 获取对齐方式
     */
    private int getAlignmentFromString(String alignmet) {
        int a = 0;
        if (alignmet != null) {
            switch (alignmet) {
                case "left":
                    a = Gravity.LEFT;
                    break;
                case "top":
                    a = Gravity.TOP;
                    break;
                case "right":
                    a = Gravity.RIGHT;
                    break;
                case "bottom":
                    a = Gravity.BOTTOM;
                    break;
                case "center":
                    a = Gravity.CENTER;
                    break;
                default:
                    a = Gravity.NO_GRAVITY;
                    break;
            }
        }
        return a;
    }

    private int dp2Pix(Context context, float dp) {
        try {
            float density = context.getResources().getDisplayMetrics().density;
            return (int) (dp * density + 0.5F);
        } catch (Exception e) {
            return (int) dp;
        }
    }
}
