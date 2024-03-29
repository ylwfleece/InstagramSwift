//
//  UploadViewController.swift
//  InstagramSwift
//
//  Created by Max Lettenberger on 6/9/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

import Parse
import Foundation
import UIKit

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        func displayAlert(title: String, message: String) {

            var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in

                //self.dismissViewControllerAnimated(true, completion: nil)

            })))

            self.presentViewController(alert, animated: true, completion: nil)

        }


        var activityIndicator = UIActivityIndicatorView()


        @IBOutlet weak var imageToPost: UIImageView!

        @IBAction func pickImage(sender: AnyObject) {

            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = false

            self.presentViewController(image, animated: true, completion: nil)
        }

        func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

            self.dismissViewControllerAnimated(true, completion:nil)

            imageToPost.image = image

        }

    //tried to use camera, doesn't work yet

    @IBAction func takePhoto(sender: AnyObject) {

        let imageTaker = UIImagePickerController()

        imageTaker.delegate = self
        imageTaker.sourceType = UIImagePickerControllerSourceType.Camera
        imageTaker.showsCameraControls = true
        //    imagePicker.mediaTypes = [kUTTypeImage as NSString]
        imageTaker.allowsEditing = false

        self.presentViewController(imageTaker, animated: true,
            completion: nil)
    }

    func imagePickerControllerCamera(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        self.dismissViewControllerAnimated(true, completion:nil)

        imageToPost.image = image
        
    }

    

        @IBOutlet weak var comment: UITextField!

        @IBAction func postImage(sender: AnyObject) {

            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()

            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            var post = PFObject(className: "Post")

            post["message"] = comment.text

            post["userId"] = PFUser.currentUser()!.objectId!

            let imageData = UIImagePNGRepresentation(imageToPost.image)

            let imageFile = PFFile(name: "image.png", data: imageData)

//            var currentUser = PFUser.currentUser()
//
//            currentUser["imageFile"] = imageFile

            post["imageFile"] = imageFile

//            currentUser.save()

            post.saveInBackgroundWithBlock{(success, error) -> Void in

                self.activityIndicator.stopAnimating()

                UIApplication.sharedApplication().endIgnoringInteractionEvents()

                if error == nil {

                    self.displayAlert("Image Posted!", message: "Your image has been posted successfully")

                    self.imageToPost.image = UIImage(named: "315px-Blank_woman_placeholder.svg.png")

                    self.comment.text = ""

                } else {

                    self.displayAlert("Could not post image", message: "Please try again later")
                }
            }
        }
}

//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            // Do any additional setup after loading the view.
//        }
//
//        override func didReceiveMemoryWarning() {
//            super.didReceiveMemoryWarning()
//            // Dispose of any resources that can be recreated.
//        }
//        
//        
//        /*
//        // MARK: - Navigation
//        
//        // In a storyboard-based application, you will often want to do a little preparation before navigation
//        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        }
//        */
//        
//    }
//
//
//
//
//
