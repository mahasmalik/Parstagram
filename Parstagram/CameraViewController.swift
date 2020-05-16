//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Maha Malik on 5/11/20.
//  Copyright © 2020 Maha Malik. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let query = PFQuery(className: "Posts")
//        query.includeKey("author")
//        query.limit = 20
//
//        query.findObjectsInBackground { (posts, error) in
//            if posts != nil {
//                 self.posts = posts!
//             } else{
//                 print("error!")
//             }
//         }
    }
    
//    @IBAction func onSubmitButton(_ sender: Any) {
//        let post = PFObject(className: "Posts")
//
//        post["caption"] = commentField.text!
//        post["author"] = PFUser.current()!
//
//        let imageData = imageView.image!.pngData()
//        let file = PFFileObject(name: "image.png", data: imageData!)
//
//        post["image"] = file
//
//        post.saveInBackground { (success, error) in
//            if success{
//                self.dismiss(animated: true, completion: nil)
//                print("saved!")
//            } else{
//                print("error!")
//            }
//        }
//
//
//    }
    
    /* ----- TODO: Override prepare (for segue) function to show Present LocationsViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationViewController = segue.destination as! LocationsViewController
        locationViewController.delegate = self
    }
    
    @IBAction func onArrowButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
//        post.add(locationField.text, forKey: "location")
       //post["location"] = locationField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        post["image"] = file
         
//         for post1 in posts {
//            let user = post1["author"] as! PFUser
//            if user.username == PFUser.current()?.username && post1["profile_image"] != nil {
//                post["profile_image"] = post1["profile_image"]
//                break;
//            }
//        }
        
        post.saveInBackground { (success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else{
                print("error!")
            }
        }
    }
    
    @IBAction func onXButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }

    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber, title: String) {
        
        //locationField.text = title
        
        //dismiss teh LocationVC after adding the pin
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func touchDown(_ sender: Any) {
        performSegue(withIdentifier: "locationSegue", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
