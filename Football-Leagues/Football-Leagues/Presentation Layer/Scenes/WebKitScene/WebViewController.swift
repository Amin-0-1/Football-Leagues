//
//  WebViewController.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    var webView:WKWebView!
    
    var url:URL!
    var coordinator:WebViewCoordinator!
    override func loadView() {
        super.loadView()
    
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        view.addSubview(webView)
        
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        if UIApplication.shared.canOpenURL(self.url){
            showProgress()
            let request = URLRequest(url: self.url)
            webView.load(request)
        }else{
            showError(message: "Cannot open this page right now, please try again later!")
        }
    }
}

extension WebViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgress()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgress()
    }
}
