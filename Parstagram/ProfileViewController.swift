//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Maha Malik on 5/11/20.
//  Copyright © 2020 Maha Malik. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2

        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width)
        
        usernameLabel.text = PFUser.current()?.username
        
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                var count = 0
                for post in self.posts{
                    let user = post["author"] as! PFUser
                    if user.username == PFUser.current()?.username{
                        count = count + 1
                    }
                }
                self.postNumberLabel.text = String(count)
                self.collectionView.reloadData()
            } else{
                print("error!")
            }
        }
        
        for post in posts {
           let user = post["author"] as! PFUser
           if user.username == PFUser.current()?.username && post["profile_image"] != nil {
               let imageFile = post["profile_image"] as! PFFileObject
               let urlString = imageFile.url!
               let url = URL(string: urlString)!
               
               profileImageView.af_setImage(withURL: url)
               break;
           }
       }
        
        
        
    }

    @IBAction func onEditProfileButton(_ sender: Any) {
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
        
        let size = CGSize(width: 75, height: 75)
        let scaledImage = image.af_imageScaled(to: size)
        
        profileImageView.image = scaledImage
        print(profileImageView.image)
        
        for post in posts{
            let user = post["author"] as! PFUser
            if user.username == PFUser.current()?.username{
                let imageData = profileImageView.image!.pngData()
                let file = PFFileObject(name: "profile_image.png", data: imageData!)
                
//                post.add(file, forKey: "profile_image")
                post["profile_image"] = file
                
                post.saveInBackground { (success, error) in
                    if success{
                        self.dismiss(animated: true, completion: nil)
                        print("saved!")
                    } else{
                        print("error!")
                    }
                }
            }
        }
    
        dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePostCell", for: indexPath) as! ProfilePostCell
        
        let post = posts[indexPath.item]
        let user = post["author"] as! PFUser
        if user.username == PFUser.current()?.username{
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.postImageView.af_setImage(withURL: url)
            
            if post["profile_image"] != nil {
                let imageFile2 = post["profile_image"] as! PFFileObject
                let urlString2 = imageFile2.url!
                let url2 = URL(string: urlString2)!

                profileImageView.af_setImage(withURL: url2)
            }
        
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 130)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        //switch user back to login screen
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewContoller = main.instantiateViewController(withIdentifier: "loginViewController")
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let delegate =  windowScene?.delegate as! SceneDelegate
        
        delegate.window?.rootViewController = loginViewContoller
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
