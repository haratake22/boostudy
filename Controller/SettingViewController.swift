//
//  SettingViewController.swift
//  boostudy
//

import UIKit
import Firebase
import KeychainSwift
import FirebaseAuth

class SettingViewController: UIViewController {

  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var blockListButton: UIButton!
    
    var userDataArray:UserDataModel?
    var userData = KeyChain.getKeyChain(key: "userData")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar(navigationcontroller: self.navigationController!)
    }
    
    func autoLayout(){
        imageView.settingImageView(imageView: imageView, view: self.view)
        settingButton.settingButton(button: settingButton, view: self.view,topItem: imageView as Any)
        contactButton.settingButton(button: contactButton, view: self.view, topItem: settingButton as Any)
        blockListButton.settingButton(button: blockListButton, view: self.view, topItem: contactButton as Any)
        logOutButton.settingButton(button: logOutButton, view: self.view, topItem: blockListButton as Any)
    }
    
    
    @IBAction func settingButton(_ sender: Any) {
        self.performSegue(withIdentifier: "editVC", sender: nil)
        
    }
    
    
    @IBAction func contact(_ sender: Any) {
        let url = NSURL(string: "https://forms.gle/fzvMLe1Hr8k69KDr8")
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func blockListButton(_ sender: Any) {
        self.performSegue(withIdentifier: "blockList", sender: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            performSegue(withIdentifier: "logOut", sender: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    
}
