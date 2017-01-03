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
import Alamofire

class CASLoginVC: UIViewController, UIWebViewDelegate{
    @IBOutlet weak var loginWebView: UIWebView!
    private let CAS_BASE_URL = "https://fed.princeton.edu/cas"
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWebView.delegate = self
        FIRDatabase.database().persistenceEnabled = true
        let url = URL(string: "\(CAS_BASE_URL)/login?service=http://sample-env.zekwisn7pk.us-west-2.elasticbeanstalk.com")
        let urlRequest = URLRequest(url: url!)
        loginWebView.loadRequest(urlRequest)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        let urlString = webView.request?.url?.absoluteString
        print(urlString)
        if (urlString?.contains("ST"))! {
        
           if let ticket = urlString?.components(separatedBy: "=")[1] {
                self.validate(ST: ticket)
            }
        }
    }

    func validate(ST: String) {
        let url_string = "\(CAS_BASE_URL)/validate?service=http://sample-env.zekwisn7pk.us-west-2.elasticbeanstalk.com&ticket=\(ST)"
        let url:NSURL = NSURL(string: url_string)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if let netid = dataString?.components(separatedBy: "\n")[1]{
                print(netid)
                self.retreiveUserInfo(netid: netid)
            }
        }
        task.resume()
    }

    func retreiveUserInfo(netid: String) {
        // work out persistence login logic
        let email = "\(netid)@princeton.edu"
        if UserDefaults.standard.value(forKey: email) != nil {
            performSegue(withIdentifier: SEGUE_LOGIN, sender: nil)
        }
        else {
            let urlString = "https://tigerbook.herokuapp.com/student/\(netid)"
            func getUserInfo(data: String) -> [String:String] {
                // alot of explicit handling of thing that should be handled more safely make sure to find safe way to handle all these things
                var name = data.components(separatedBy: "h1")[1]
                name = name.between(">", " '")!
                let firstname = name.components(separatedBy: " ")[0]
                let lastname = name.components(separatedBy: " ")[1]
                var dorm = data.components(separatedBy: "Dorm")[1]
                dorm = dorm.between(">", "<br")!
                return ["Email": email, "First Name": firstname, "Last Name":lastname, "Dorm": dorm]
            }
            if let url = URL(string: urlString) {
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "GET"
                let session = URLSession.shared
                let task = session.dataTask(with: request as URLRequest) {
                    (data, response, error) in
                    guard let _:Data = data, let _:URLResponse = response, error == nil else {
                        print("error")
                        return
                    }
                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    self.attemptSignUp(userInfo: getUserInfo(data: dataString as! String))
                }
                task.resume()
            }
        }
    }
    
    func attemptSignUp(userInfo: [String:String]) {
        if let email = userInfo["Email"] {
            FIRAuth.auth()?.createUser(withEmail: email, password: USER_PASSWORD, completion: { (user, error) in
                if error != nil {
                    print(email)
                    // expand this to account for all possible error codes
                    showErrorAlert(title: "Could Not Create Account", msg: "Problem creating account", currentView: self)
                    print(error.debugDescription)
                    print(error)
                } else {
                    let userUID = user!.uid
                    UserDefaults.standard.setValue(userUID, forKey: email)
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
}
