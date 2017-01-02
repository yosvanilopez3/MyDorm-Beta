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
        loginWebView.delegate = self
        
        let url = URL(string: "\(CAS_BASE_URL)/login?service=http://sample-env.zekwisn7pk.us-west-2.elasticbeanstalk.com")
        let urlRequest = URLRequest(url: url!)
        loginWebView.loadRequest(urlRequest)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("end")
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
            }
        }
        task.resume()
    }
    
    func retreiveUserInfo(netid: String) {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let nonce: CFString = CFUUIDCreateString(nil, uuid)
        let dateFormatter: DateFormatter = DateFormatter()
        let timestamp = Date()
        let secretKey = "567c79577d41f13eee2af317ce73ec47"
        let username = "ylopez"
        
        let formattedDate: String = dateFormatter.string(from: timestamp as Date)
        
        let text = String((nonce as String)+formattedDate+secretKey)
        
        let sha256 = text?.sha256()
        
        let passwordDigest = sha256.toBase64()
        
        let headers = [
            "Authorization": "WWSE profile=\"UsernameToken\"",
            "X-WSSE": "UsernameToken Username=\"admin\", PasswordDigest=\"buctlzbeVflrVCoEfTKB1mkltCI=\", Nonce=\"ZmMzZDg4YzMzYzRmYjMxNQ==\", Created=\"2014-03-22T15:24:49+00:00\""
        ]
        
        let theUrlString = "https://tigerbook.herokuapp.com/api/v1/undergraduates"
        
        manager.request(.GET, theUrlString, parameters: nil, encoding: ParameterEncoding.URL, headers: headers).responseJSON { (result) -> Void in
            print("BEGIN")
            print("\n\n\n\n\n\n\n\nBEGIN\n\(result)\n\n\n\n\n\nEND")
            print("STOP")
        }
        
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
