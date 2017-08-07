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
import SendBirdSDK

class CASLoginVC: UIViewController, UIWebViewDelegate{
    @IBOutlet weak var loginWebView: UIWebView!
    private let CAS_BASE_URL = "https://fed.princeton.edu/cas"
    private let INTERMEDIATE_WEBPAGE = "http://sample-env.zekwisn7pk.us-west-2.elasticbeanstalk.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWebView.delegate = self
        retreiveUserInfo(netid: "ylopez");
        //Princeton Login
        //let url = URL(string: "\(CAS_BASE_URL)/login?service=\(INTERMEDIATE_WEBPAGE)")
        //let urlRequest = URLRequest(url: url!)
        //loginWebView.loadRequest(urlRequest)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        let urlString = webView.request?.url?.absoluteString
        if (urlString?.contains("ST"))! {
           if let ticket = urlString?.components(separatedBy: "=")[1] {
                self.validate(ST: ticket)
            }
        }
    }

    func validate(ST: String) {
        let url_string = "\(CAS_BASE_URL)/validate?service=\(INTERMEDIATE_WEBPAGE)&ticket=\(ST)"
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
                self.retreiveUserInfo(netid: netid)
            }
        }
        task.resume()
    }
    
    func retreiveUserInfo(netid: String) {
        let email = "\(netid)@princeton.edu"
        // work out persistence login logic
        attemptLogIn(email: email) { (success, data) in
            if success {
                self.performSegue(withIdentifier: SEGUE_LOGIN, sender: nil)
            }
            // only available with princeton login
//            else {
//                let urlString = "https://tigerbook.herokuapp.com/student/\(netid)"
//                func getUserInfo(data: String) -> [String:String] {
//                    // alot of explicit handling of thing that should be handled more safely make sure to find safe way to handle all these things
//                    var name = data.components(separatedBy: "h1")[1]
//                    name = name.between(">", " '")!
//                    let firstname = name.components(separatedBy: " ")[0]
//                    let lastname = name.components(separatedBy: " ")[1]
//                    var dorm = data.components(separatedBy: "Dorm")[1]
//                    dorm = dorm.between(">", "<br")!
//                    return ["Email": email, "First Name": firstname, "Last Name":lastname, "Dorm": dorm, "Current LID Count": "0", "Current OID Count": "0"]
//                }
//                if let url = URL(string: urlString) {
//                    let request = NSMutableURLRequest(url: url as URL)
//                    request.httpMethod = "GET"
//                    let session = URLSession.shared
//                    let task = session.dataTask(with: request as URLRequest) {
//                        (data, response, error) in
//                        guard let _:Data = data, let _:URLResponse = response, error == nil else {
//                            print("error")
//                            return
//                        }
//                        let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                        self.attemptSignUp(userInfo: getUserInfo(data: dataString as! String))
//                    }
//                    task.resume()
//                }
//            }
        }
    }
    
    func attemptLogIn(email: String, logIn: @escaping (_ success:Bool, _ data:[String:String]) -> ()) {
        FIRAuth.auth()?.signIn(withEmail: email, password: USER_PASSWORD, completion: { (user, error) in
            if error == nil {
                //get the users data and login stuff from firebase and setup'
                if UserDefaults.standard.value(forKey: KEY_UID) == nil {
                    UserDefaults.standard.setValue(user!.uid , forKey: KEY_UID)
                }
                logIn(true, [:])
            }
            logIn(false, [:])
        })
    }
    
    func attemptSignUp(userInfo: [String:String]) {
        if let email = userInfo["Email"] {
            FIRAuth.auth()?.createUser(withEmail: email, password: USER_PASSWORD, completion: { (user, error) in
                if error != nil {
                    showErrorAlert(title: "Could Not Create Account", msg: "Problem creating account", currentView: self)
                    print(error.debugDescription)
                } else {
                    let userUID = user!.uid
                    UserDefaults.standard.setValue(userUID, forKey: KEY_UID)
                    DataService.instance.createUser(uid: userUID, user: userInfo)
                    FIRAuth.auth()?.signIn(withEmail: email, password: USER_PASSWORD, completion: nil)
                    self.performSegue(withIdentifier: SEGUE_LOGIN, sender: nil)
                }
            })
        }
    }
}
