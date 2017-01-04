//
//  SellerAdditionalDetailsVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/10/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class SellerAdditionalDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var listing: Listing!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    @IBAction func reviewListingBtn(_ sender: AnyObject) {
        performSegue(withIdentifier: "seePreview", sender: nil)
    }

    @IBAction func addPictureButton(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func backBtnPressed(_ sender: AnyObject) {
           self.navigationController?.dismiss(animated: true, completion: nil)
        }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicker.dismiss(animated: true, completion: nil)
            listingImage.image = pickedImage
            listingImage.alpha = 1.0
            addImageBtn.alpha = 0.0
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seePreview" {
            if let destination = segue.destination as? PreviewListingVC{
                destination.listing = listing
            }
        }
    }
}
