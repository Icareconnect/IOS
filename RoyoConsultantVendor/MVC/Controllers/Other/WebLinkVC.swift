//
//  WebLinkVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 08/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import WebKit

class WebLinkVC: UIViewController {
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    
    public var linkTitle: (url: String?, title: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = /linkTitle?.title
        wkWebView.load(URLRequest.init(url: URL(string: /linkTitle?.url)!))
        wkWebView.navigationDelegate = self

    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
    
}

extension WebLinkVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
            guard let url = navigationAction.request.url else {
                return
            }
            
            let string = url.absoluteString
            if (string.contains("mailto:")) || string.contains("tel") || string.contains("www") || string.contains("http") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                
                return
            }
        }
        decisionHandler(.allow)
    }
}
