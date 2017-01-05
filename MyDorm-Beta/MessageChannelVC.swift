//
//  MessageChannelVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 1/4/17.
//  Copyright © 2017 Yosvani Lopez. All rights reserved.
//

import UIKit
import SendBirdSDK
class MessageChannelVC: UIViewController, SBDChannelDelegate {
    // listingid+userid
    var myID: String!
    var otherID: String!
    var channel: SBDGroupChannel!
    var UNIQUE_HANDLER_ID: String!
    @IBOutlet weak var messageStream: UITextView!
    @IBOutlet weak var messageInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        UNIQUE_HANDLER_ID = "\(myID)\(otherID)"
        if let my = myID, let other = otherID {
            SBDGroupChannel.createChannel(withUserIds: [my, other], isDistinct: false) { (channel, error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                self.channel = channel
                SBDMain.add(self, identifier: self.UNIQUE_HANDLER_ID)
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: UILabel) {
        if let msg = sender.text {
            sendMessage(message: msg)
        }
    }
    
    func closeChannel() {
        channel.leave { (error) in
            if error != nil {
                NSLog("Error: %@", error!)
                return
            }
            _ = self.navigationController?.popViewController(animated: true)
            SBDMain.removeChannelDelegate(forIdentifier: self.UNIQUE_HANDLER_ID)
        }
    }
    
    func sendMessage(message: String) {
        channel.sendUserMessage(message, data: nil, completionHandler: { (userMessage, error) in
            if error != nil {
            NSLog("Error: %@", error!)
            return
            }
            self.displayMessage(message: message, sender: self.myID)
        })
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        displayMessage(message: message.description, sender: self.otherID)
    }
    
    func displayMessage(message: String, sender: String) {
        var message = message
        if let conversation = messageStream.text {
            message = "\(conversation) \n\(message)"
        }
        messageStream.text = message
    }
}
