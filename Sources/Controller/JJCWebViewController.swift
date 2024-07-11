//
//  JJCWebViewController.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/8/3.
//

import UIKit
import WebKit

open class JJCWebViewController: JJCViewController {
    /// ObserveKey - estimatedProgress - 进度
    private let WebViewProgressObserveKey: String = "estimatedProgress"
    /// ObserveKey - URL - 链接
    private let WebViewURLObserveKey: String = "URL"
    /// ObserveKey - title - 标题
    private let WebViewTitleObserveKey: String = "title"
    /// ObserveKey - canGoBack - 是否可以返回
    private let WebViewGoBackObserveKey: String = "canGoBack"
    
    /// WKWebView
    open lazy var webView: WKWebView = {
        let webV = WKWebView()
        webV.frame = CGRect(x: 0, y: 0, width: JJC_ScreenW, height: JJC_ScreenH - JJC_StatusNaviH())
        webV.allowsBackForwardNavigationGestures = true
        webV.navigationDelegate = self
        webV.uiDelegate = self
        
        // 添加观察者
        webV.addObserver(self, forKeyPath: WebViewProgressObserveKey, options: .new, context: nil)
        webV.addObserver(self, forKeyPath: WebViewURLObserveKey, options: .new, context: nil)
        webV.addObserver(self, forKeyPath: WebViewTitleObserveKey, options: .new, context: nil)
        webV.addObserver(self, forKeyPath: WebViewGoBackObserveKey, options: .new, context: nil)
        
        return webV
    }()
    /// UIProgressView - 进度条
    open lazy var progressV: UIProgressView = {
        let progressV = UIProgressView()
        progressV.frame = CGRect(x: 0, y: 0, width: JJC_ScreenW, height: 4)
        progressV.trackTintColor = .clear
        progressV.progressTintColor = .orange
        // 由于 UIProgressView 无法设置高度，默认 1x 2.0；2x 4.0；3x 6.0，可以通过缩放达到效果
        progressV.jjc_scaleHeight(0.5)
        return progressV
    }()
    
    open override func setUI() {
        // WKWebView
        view.addSubview(webView)
        // UIProgressView - 进度条
        view.insertSubview(progressV, aboveSubview: webView)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: WebViewProgressObserveKey)
        webView.removeObserver(self, forKeyPath: WebViewURLObserveKey)
        webView.removeObserver(self, forKeyPath: WebViewTitleObserveKey)
        webView.removeObserver(self, forKeyPath: WebViewGoBackObserveKey)
    }
}

// MARK:- Methods
extension JJCWebViewController {
    /// Action - 设置导航栏
    @objc open func setNavigationParameters(bgColor: UIColor, title: String) {
        navigationController?.navigationBar.backgroundColor = bgColor
    }
    
    /// Action - 设置进度条高度，默认 1x 2.0；2x 4.0；3x 6.0
    @objc open func setProgressViewScaleHeight(_ scale: CGFloat) {
        // 由于 UIProgressView 无法设置高度，可以通过缩放达到效果
        progressV.jjc_scaleHeight(scale)
    }
    
    /// Action - 加载 url
    @objc open func loadRequestUrl(_ urlString: String, isLocal: Bool = false) {
        if let url = URL(string: urlString) {
            if isLocal {
                webView.loadFileURL(url, allowingReadAccessTo: url)
            } else {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    /// Action - 观察者
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
        case WebViewProgressObserveKey:
            // 进度条
            progressV.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                    self?.progressV.progress = 0
                }
            }
        case WebViewURLObserveKey:
            // 链接
            break
        case WebViewTitleObserveKey:
            // 标题
            break
        case WebViewGoBackObserveKey:
            // 是否可以返回
            break
        default: super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK:- WKNavigationDelegate、WKUIDelegate
extension JJCWebViewController: WKNavigationDelegate, WKUIDelegate {
    /// Delegate - 加载完成
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Delegate - 加载完成")
    }
    
    /// Delegate - 页面加载失败
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Delegate - 页面加载失败")
        progressV.setProgress(0, animated: false)
    }
    
    /// Delegate - 提交发生错误
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Delegate - 提交发生错误")
        progressV.setProgress(0, animated: false)
    }
}
