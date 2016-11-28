//
//  CASLoginVC.swift
//  
//
//  Created by Yosvani Lopez on 11/14/16.
//
//

import UIKit

class CASLoginVC: UIViewController, UIWebViewDelegate{
    @IBOutlet weak var loginWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginWebView.delegate = self
        let url = URL(string: "https://fed.princeton.edu/cas/login?service=")
        let urlRequest = URLRequest(url: url!)
        loginWebView.loadRequest(urlRequest)
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
    print(webView.request?.url)
    
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("end")
        print(webView.request?.url)
        let request = webView.request!
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {

                let cookieStorage = HTTPCookieStorage.shared
                let cookies = cookieStorage.cookies
                print("Cookies.count: \(cookies?.count)")
                for cookie in cookies! {
                    var cookieProperties = [HTTPCookiePropertyKey: AnyObject]()
                    cookieProperties[HTTPCookiePropertyKey.name] = cookie.name as AnyObject?
                    cookieProperties[HTTPCookiePropertyKey.value] = cookie.value as AnyObject?
                    cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain as AnyObject?
                    cookieProperties[HTTPCookiePropertyKey.path] = cookie.path as AnyObject?
                    cookieProperties[HTTPCookiePropertyKey.version] = NSNumber(value: cookie.version)
                    cookieProperties[HTTPCookiePropertyKey.expires] = NSDate().addingTimeInterval(31536000)
                    
                    let newCookie = HTTPCookie(properties: cookieProperties)
                    HTTPCookieStorage.shared.setCookie(newCookie!)
                    print("name: \(cookie.name) value: \(cookie.value)")
                    
                    if cookie.name == "CASTGC" {
                        
                    }
                }
            }
        }
        task.resume()

}
}
