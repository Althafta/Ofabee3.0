//
//  OFA3WebViewMyCourseViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 05/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import WebKit
//import HttpSwift

class OFA3WebViewMyCourseViewController: UIViewController,UIWebViewDelegate {
    
//    @IBOutlet  var webKitMyCourseContentDelivery: WKWebView!
    @IBOutlet weak var webView: UIWebView!
    var contentDeliveryAppendURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        self.webView.delegate = self
        self.loadHTMLFile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadHTMLFile(){
        
        let url = Bundle.main.url(forResource: "build/index", withExtension: "html")!
        let request = URLRequest(url: URL(string: url.absoluteString + contentDeliveryAppendURL)!)
        webView.loadRequest(request)

//        self.webKitMyCourseContentDelivery.load(URLRequest(url: URL(string: self.courseContentURL)!))
    }
    
//    func webViewDidStartLoad(_ webView: UIWebView) {
//        OFAUtils.showLoadingViewWithTitle("Loading contents")
//    }
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        OFAUtils.removeLoadingView(nil)
//    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if request.url?.scheme == "inapp"{
            if request.url?.host == "exit"{
                self.navigationController?.popViewController(animated: true)
            }
            return false
        }
        return true
    }
}

