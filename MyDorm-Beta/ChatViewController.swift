//
//  ChatViewController.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 1/5/17.
//  Copyright © 2017 Yosvani Lopez. All rights reserved.


import UIKit
import JSQMessagesViewController
import SendBirdSDK
class ChatViewController: JSQMessagesViewController, SBDChannelDelegate {
    // listingid+userid
    var myID: String!
    var otherID: String!
    var channel: SBDGroupChannel!
    var UNIQUE_HANDLER_ID: String!
    var messageStream = UITextView()
    var messageInput = UITextField()
    var messages = [JSQMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Reachability.isConnectedToNetwork() {
            // makes this show connection error view controller
            print("no internet connection")
        }
        else {
            SBDMain.connect(withUserId: myID, completionHandler: { (user, error) in
                if let my = self.myID, let other = self.otherID {
                    SBDGroupChannel.createChannel(withUserIds: [my, other], isDistinct: true) { (channel, error) in
                        if error != nil {
                            NSLog("Error: %@", error!)
                            return
                        }
                        self.channel = channel
                        SBDMain.add(self, identifier: self.UNIQUE_HANDLER_ID)
                        channel?.createPreviousMessageListQuery()?.loadPreviousMessages(withLimit: 200, reverse: true, completionHandler: { (messages, error) in
                            if error != nil {
                                NSLog("Error: %@", error!)
                                return
                            } else {
                                if let msgs = messages {
                                    for message in msgs {
                                        self.displayMessage(message: message, sender: my, displayName: my)
                                    }
                                }
                            }
                        })
                    }
                }
            })
            self.senderId = myID
        }
    }

/*************************************************/
/*      JSQMessagesViewController Functions      */
/*************************************************/
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        sendMessage(message: text)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
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
        if Reachability.isConnectedToNetwork() {
            channel.sendUserMessage(message, data: "", completionHandler: { (userMessage, error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                if let msg = userMessage {
                    self.displayMessage(message: msg, sender: self.myID, displayName: self.myID)
                }
            })
        } else {
            showErrorAlert(title: "Network Connection Error", msg: "Must be connected to the internet to send a message", currentView: self)
        }
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        displayMessage(message: message, sender: self.otherID, displayName: self.otherID)
    }
    
    func displayMessage(message: SBDBaseMessage, sender: String, displayName: String) {
        func parseOutMessage(message: SBDBaseMessage) -> String {
           return message.description.components(separatedBy: "Message: ")[1].components(separatedBy: ",")[0] 
        }
        let text = parseOutMessage(message: message)
        if let msg = JSQMessage(senderId: sender, displayName: displayName, text: text) {
            messages.append(msg)
            finishSendingMessage()
        }
    }
}
