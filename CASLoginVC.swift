//
//  CASLoginVC.swift
//  
//
//  Created by Yosvani Lopez on 11/14/16.
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class CASLoginVC: UIViewController, UIWebViewDelegate{
    @IBOutlet weak var loginWebView: UIWebView!
    private let CAS_BASE_URL = "https://fed.princeton.edu/cas"
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase.database().persistenceEnabled = true
        loginWebView.delegate = self
        let url = URL(string: "\(CAS_BASE_URL)/login?service=")
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
                        self.performSegue(withIdentifier: "LoggedIn", sender: nil)
//                        self.getServiceTicket(TGT: cookie.value, complete: {
//                            print("dont bitch")
//                        })
                    }
                }
            }
        }
        task.resume()
    }

    func getServiceTicket(TGT: String, complete: complete) {
        let url_string = "\(CAS_BASE_URL)/v1/tickets/\(TGT)"
        let url:NSURL = NSURL(string: url_string)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let paramString = "service=something"
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString)
            
        }
        
        task.resume()
        
    }
    func attemptSignUp(email: String ) {
        FIRAuth.auth()?.createUser(withEmail: email, password: USER_PASSWORD, completion: { (user, error) in
            if error != nil {
                print(email)
                // expand this to account for all possible error codes
                showErrorAlert(title: "Could Not Create Account", msg: "Problem creating account", currentView: self)
                print(error.debugDescription)
                print(error)
            } else {
                let userUID = user!.uid
                UserDefaults.standard.setValue(userUID, forKey: KEY_UID)
                // possibly provide a check to see if the account type has a value
                let userInfo = ["Email Address": email]
                DataService.instance.createUser(uid: userUID, user: userInfo)
                // no need to error check as account exist with this email and password if this point was reached
                FIRAuth.auth()?.signIn(withEmail: email, password: USER_PASSWORD, completion: nil)
                self.performSegue(withIdentifier: SEGUE_LOGIN, sender: nil)
            }
        })
    }
}
