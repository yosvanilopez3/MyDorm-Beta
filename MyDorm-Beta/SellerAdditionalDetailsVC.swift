//
//  SellerAdditionalDetailsVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/10/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class SellerAdditionalDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var listing: Listing!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var descriptionTxtBox: UITextView!
    override func viewDidLoad() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        super.viewDidLoad()
        descriptionTxtBox.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // implement own back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        listing.description = textView.text
    }
    
    @IBAction func reviewListingBtn(_ sender: AnyObject) {
        performSegue(withIdentifier: "seePreview", sender: nil)
    }

    @IBAction func addPictureButton(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicker.dismiss(animated: true, completion: nil)
            listingImage.image = pickedImage
            listingImage.alpha = 1.0
            addImageBtn.alpha = 0.0
            listing.image = pickedImage
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seePreview" {
            if let destination = segue.destination as? PreviewListingVC{
                destination.listing = listing
                print(listing.rent)
            }
        }
    }
}
