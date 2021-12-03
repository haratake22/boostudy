//
//  UserViewController.swift
//  boostudy
//

import UIKit
import Firebase
import SDWebImage
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GetProfileDataProtocol {
    
    
    let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 8.0, right: 16.0)
    let itemsPerRow:CGFloat = 2
    
    var userDataModelArray = [UserDataModel]()
    var db = Firestore.firestore()
    
    let sendDBModel = SendDBModel()
    
    var userCollectionViewCell = UserCollectionViewCell()
    
    var timer = Timer()
    
    var blockListArray = [String]()
    var beenBlockListArray = [String]()
    var hideBlockListArray = [String]()
    
    let collectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
    
    let searchButton = UIButton()
    var searchORNot = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.register(UserCollectionViewCell.nib(), forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hex: "EFF2F9")
        self.collectionView.addSubview(searchButton)
        searchButton.searchButton(button: searchButton, item: self.view,view: self.view)
        searchButton.addTarget(self, action: #selector(search(_:)), for: .touchUpInside)
    }
    
    @objc func search(_ sender: Any){
        performSegue(withIdentifier: "searchVC", sender: nil)
    }
    
    func animateView(_ viewAnimate: UIView) {
        collectionView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                viewAnimate.alpha = 0
            } completion: { (_) in
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                    viewAnimate.alpha = 1
                }
            }
        }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        collectionView.timer(viewAnimate: collectionView)
        let getDBModel = GetDBModel()
        getDBModel.getBeenBlockList()

        if Auth.auth().currentUser?.uid != nil && searchORNot == false{

            let userData = KeyChain.getKeyChain(key: "userData")
            
            let getDBModel = GetDBModel()
            getDBModel.getUsersProfile(uid: Auth.auth().currentUser!.uid)
            getDBModel.getProfileDataProtocol = self
            getDBModel.getInviteList()
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).setData(["name":userData["name"] as Any,"age":userData["age"] as Any,"gender":userData["gender"] as Any,"studyContents":userData["studyContents"] as Any,"startTime":userData["startTime"] as Any,"finishTime":userData["finishTime"] as Any,"userImageString":userData["userImageString"] as Any,"uid":userData["uid"] as Any])
            
            getDBModel.getMatchingPersonData()
        }else{
            collectionView.reloadData()
        }
    }
    
    //自分がブロックしているまたはブロックされているユーザーを表示しないように配列から削除する。
    func getProfileData(userDataModelArray: [UserDataModel]) {
        var deleteArray = [Int]()
        var count = 0
        
        blockListArray = []
        beenBlockListArray = []
        hideBlockListArray = []

        blockListArray = KeyChain.getKeyChainArray(key: "blockList")
        beenBlockListArray = KeyChain.getKeyChainArray(key: "beenBlockList")

        self.userDataModelArray = userDataModelArray
        hideBlockListArray = blockListArray + beenBlockListArray

        for i in 0..<self.userDataModelArray.count{
            if hideBlockListArray.contains(self.userDataModelArray[i].uid!) == true{
                
                deleteArray.append(i)
            }
        }

        for i in 0..<deleteArray.count {
            self.userDataModelArray.remove(at: deleteArray[i] - count)
            count = +1
        }
        
        collectionView.reloadData()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userDataModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width)/2.5, height: (view.frame.size.width)/2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
        
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 0.1
        cell.layer.borderColor = UIColor(hex: "EFF2F9").cgColor
        cell.layer.shadowColor = UIColor(hex: "EFF2F9").cgColor
        cell.layer.shadowOffset = CGSize(width: 4, height: 4)
        cell.layer.shadowRadius = 20
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        
        cell.configure(userImageViewString: userDataModelArray[indexPath.row].userImageString!, userNameLabelString: userDataModelArray[indexPath.row].name!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
        profileVC.userDataModel = userDataModelArray[indexPath.row]
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchVC"{
            
            let searchVC = segue.destination as? SearchViewController
            
            searchVC?.resultHandler = { userDataModelArray,searchDone in
                self.searchORNot = searchDone
                self.userDataModelArray = userDataModelArray
                self.collectionView.reloadData()
            }
        }
    }
    
}
