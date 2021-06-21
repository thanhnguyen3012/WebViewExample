//
//  ViewController.swift
//  WebViewExample
//
//  Created by Thành Nguyên on 21/06/2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let webpURL = URL(string: "https://encodan.info/content/R2_OP_(animated).webp") // 22 MB
    let apngURL = URL(string: "https://encodan.info/content/R2_OP_(animated).png") // 30.7 MB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        myWebView.navigationDelegate = self
        segmentedControl.selectedSegmentIndex = 0
        loadWebView(url: webpURL)
    }
    
    func loadWebView(url: URL?) {
        guard let url = url else {
            print("ERROR: URL is nil.")
            return
        }
        
        let request = URLRequest(url: url)
        myWebView.load(request)
    }
    
    func loadWebView(localFileName: String) {
        do {
            guard let filePath = Bundle.main.path(forResource: localFileName, ofType: "html") else {
                print ("File reading error")
                return
            }

            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            myWebView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print("File HTML error")
        }
    }
    
    @IBAction func changeStateSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: // aPNG
            print("Load APNG")
            loadWebView(url: apngURL)
        case 2: // Local WebP
            print("Load Local HTML")
            loadWebView(localFileName: "index")
        default: // 0: WebP
            print("Load wepb")
            loadWebView(url: webpURL)
        }
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Loading web view fail", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        loadingIndicator.stopAnimating()
        present(alert, animated: true, completion: nil)
    }
    
}

