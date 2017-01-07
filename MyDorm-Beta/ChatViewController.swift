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
    var initialTxtMessages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
                            for message in messages! {
                                let msg = message.description
                                self.displayMessage(message: msg, sender: my, displayName: my)
                            }
                        }
                    })
                }
            }
        })
        self.senderId = myID
    }
    override func viewDidDisappear(_ animated: Bool) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        for msg in initialTxtMessages {
            displayMessage(message: msg, sender: myID, displayName: myID)
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
        channel.sendUserMessage(message, data: "", completionHandler: { (userMessage, error) in
            if error != nil {
                NSLog("Error: %@", error!)
                return
            }
            self.displayMessage(message: message, sender: self.myID, displayName: self.myID)
        })
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        displayMessage(message: message.description, sender: self.otherID, displayName: self.otherID)
    }
    
    func displayMessage(message: String, sender: String, displayName: String) {
        if let msg = JSQMessage(senderId: sender, displayName: displayName, text: message) {
            messages.append(msg)
            finishSendingMessage()
        }
    }
}
