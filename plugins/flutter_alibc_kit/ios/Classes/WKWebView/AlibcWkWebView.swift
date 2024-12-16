//
//  AlibcWkWebView.swift
//  flutter_alibc
//
//  Created by 吴兴 on 2021/5/15.
//

import Foundation
import WebKit

protocol AlibcWkWebViewDelegate : NSObject {
    func noticeToken(result:String)
    func noticeCode(result:String)
}

class AlibcWkWebView: UIViewController{
//    同步调用的目的，是token还是code
    var fuctionType:String!
    var openUrl:String?
    var webview : WKWebView!
    var delegate: AlibcWkWebViewDelegate?
    init() {
        super.init(nibName: nil, bundle: nil)
        WVURLProtocolService.setSupportWKURLProtocol(true)
        self.webview = WKWebView.init(frame: view.frame)
        self.webview.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        self.webview.scrollView.isScrollEnabled = true;
        self.webview.navigationDelegate = self
        //        webview.addObserver(self, forKeyPath: "URL", optionsNSKeyValueObservingOptions.new, context: nil)
        //        self.webview.backgroundColor = UIColor.red
        self.view.addSubview(webview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建wkwebview
        
        self.title = "淘你喜欢"
        let doneBtn = UIButton(type: UIButton.ButtonType.system)
        doneBtn.setTitle("关闭", for: UIControl.State.normal)
        doneBtn.addTarget(self, action: #selector(doneBtnAction), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: doneBtn)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView:doneBtn);
        
        //        UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset(horizontal: 0,vertical: -60), for: .default)
        //添加wkwebview
        
    }
    public func getWebView() -> WKWebView{
        return webview
    }
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        print("url------------")
    //        print("url------------")
    //        print("处理")
    //    }
    
    @objc private func doneBtnAction (){
        // 关闭
        //            拿到token了，该关闭当前页面了
        self.navigationController?.dismiss(animated: true, completion: {
            //                回调回去
            if self.fuctionType == "token" {
                self.delegate?.noticeToken(result: "")
            }else {
                self.delegate?.noticeCode(result: "")
            }
        })
    }
}

extension AlibcWkWebView : WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("页面开始加载")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("重定向")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webview.url?.absoluteString as Any)
        //        判断是否存在accesstoken或者code
        let urlStr = webview.url?.absoluteString
        var range: NSRange
        var rangeCode : NSRange
        range = (urlStr! as NSString).range(of: "access_token")
        rangeCode = (urlStr! as NSString).range(of: "code=")
        if range.location != NSNotFound {
            let accessString = (urlStr! as NSString).substring(from: range.location)
            //        截止到&
            let range2 = (accessString as NSString).range(of: "&")
            
            let access_token_string = (accessString as NSString).substring(with: NSRange(location: 0, length: range2.location))
            print(access_token_string)
            //            拿到token了，该关闭当前页面了
            self.navigationController?.dismiss(animated: true, completion: {
                //                回调回去
                self.delegate?.noticeToken(result: access_token_string)
            })
        }else if rangeCode.location != NSNotFound {
            var dic = [String:String]()
            let arr = urlStr!.components(separatedBy:"&")
            for item in arr {
                    let arr2 = item.components(separatedBy:"=")
                    let key = arr2[0]
                    let val = arr2[1]
                    dic[key] = val
            }
            let codeString = "code=" + dic["code"]!
            
            //            拿到token了，该关闭当前页面了
            self.navigationController?.dismiss(animated: true, completion: {
                //                回调回去
                self.delegate?.noticeCode(result: codeString)
            })
        }
    }
    
    
    //  MARK:自签名证书信任
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,card)
        }
    }
    
}

extension AlibcWkWebView : WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
