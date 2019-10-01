//
//  OFA3WebViewReDirectionViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 17/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import WebKit

class OFA3WebViewReDirectionViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webKitRedirection: WKWebView!
    var reDirectURL = ""
    var pageTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webKitRedirection.navigationDelegate = self
        OFAUtils.showLoadingViewWithTitle(nil)
        self.loadWebPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = self.pageTitle
    }
    
    func loadWebPage(){
        self.webKitRedirection.load(URLRequest(url: URL(string: self.reDirectURL)!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        OFAUtils.removeLoadingView(nil)
    }

}
