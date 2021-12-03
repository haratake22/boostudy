//
//  ProfileViewController.swift
//  boostudy
//

import UIKit
import Firebase
import SDWebImage
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var studyContentsLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleGenderLabel: UILabel!
    @IBOutlet weak var titleAgeLabel: UILabel!
    @IBOutlet weak var titleContentsLabel: UILabel!
    @IBOutlet weak var titleTimeLabel: UILabel!
    
    
    var userDataModel:UserDataModel?
    var uid = String()
    var userData = [String:Any]()
    var inviteMark = Bool()
    var db = Firestore.firestore()
    var invitedListArray = KeyChain.getKeyChainArray(key: "invitedList")
    var menuButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton = UIBarButtonItem(title: "•••", style: .done, target: self, action: #selector(menu(_:)))
        self.navigationItem.rightBarButtonItem = menuButton
        autoLayout()
        inviteState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar(navigationcontroller: self.navigationController!)
        configure()
        backImageView.sd_setImage(with: URL(string: (userDataModel?.userImageString)!), completed: nil)
    }
    
    
    @objc func menu(_ sender: UIBarButtonItem) {
        let alertController: UIAlertController =
            UIAlertController(title: "このユーザーをブロックまたは通報しますか？",
                              message: "",
                              preferredStyle: .alert)

        let block = UIAlertAction(title: "ブロック", style: .destructive){
            action in
            let sendDBModel = SendDBModel()
            sendDBModel.sendToBlockList(blockMark: true, blockID: (self.userDataModel?.uid)!, name: (self.userDataModel?.name)!,age: (self.userDataModel?.age)!,gender: (self.userDataModel?.gender)!,studyContents: (self.userDataModel?.studyContents)!,startTime: (self.userDataModel?.startTime)!,finishTime: (self.userDataModel?.finishTime)!,userImageString: (self.userDataModel?.userImageString)!, uid: (self.userDataModel?.uid)!)
        }

        let notice = UIAlertAction(title: "通報", style: .destructive){
            action in
            let url = NSURL(string: "https://forms.gle/fzvMLe1Hr8k69KDr8")
            if UIApplication.shared.canOpenURL(url! as URL){
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel){
                    (action) -> Void in
                }
        alertController.addAction(block)
        alertController.addAction(notice)
        alertController.addAction(cancel)

        present(alertController, animated: true, completion: nil)
      }
    
    
    func configure(){
        userNameLabel.text = userDataModel?.name
        genderLabel.text = userDataModel?.gender
        ageLabel.text = (userDataModel?.age)! + "歳"
        studyContentsLabel.text = userDataModel?.studyContents
        startTimeLabel.text = (userDataModel?.startTime)! + "時"
        finishTimeLabel.text = (userDataModel?.finishTime)! + "時"
        userImageView.sd_setImage(with: URL(string: (userDataModel?.userImageString)!), completed: nil)
    }
    
    func autoLayout(){
        backImageView.backImageView(imageView: backImageView, view: self.view)
        blurView.blurView(blurView: blurView, view: self.view)
        userImageView.profileImageView(imageView: userImageView, bottomItem: backImageView as Any, view: self.view)
        titleNameLabel.topLabel(label: titleNameLabel, topItem: backImageView as Any, view: self.view)
        userNameLabel.profileLabel(label: userNameLabel, topItem: titleNameLabel as Any, view: self.view)
        titleGenderLabel.labelAutoLayout(label: titleGenderLabel, topItem: userNameLabel as Any, view: self.view)
        genderLabel.profileLabel(label: genderLabel, topItem: titleGenderLabel as Any, view: self.view)
        titleAgeLabel.labelAutoLayout(label: titleAgeLabel, topItem: genderLabel as Any, view: self.view)
        ageLabel.profileLabel(label: ageLabel, topItem: titleAgeLabel as Any, view: self.view)
        titleContentsLabel.labelAutoLayout(label: titleContentsLabel, topItem: ageLabel as Any, view: self.view)
        studyContentsLabel.profileLabel(label: studyContentsLabel, topItem: titleContentsLabel as Any, view: self.view)
        titleTimeLabel.labelAutoLayout(label: titleTimeLabel, topItem: studyContentsLabel as Any, view: self.view)
        startTimeLabel.startTimeLabel(label: startTimeLabel, topItem: titleTimeLabel, view: self.view)
        fromLabel.fromLabel(label: fromLabel, topItem: titleTimeLabel as Any, leftItem: startTimeLabel as Any, view: self.view)
        finishTimeLabel.finishTimeLabel(label: finishTimeLabel, topItem: titleTimeLabel as Any, leftItem: fromLabel, view: self.view)
        inviteButton.inviteButtonLayout(button: inviteButton, topItem: startTimeLabel as Any, view: self.view, hex: "4F54CF")
    }
    
    //ボタンを押したときにinviteBool()からDBのinviteの値を取得し処理を分岐させる。
    @IBAction func inviteButton(_ sender: Any) {
        if userDataModel?.uid != Auth.auth().currentUser?.uid{
            
            let sendDBModel = SendDBModel()
            
            inviteBool()
            
            if inviteMark != true{
                sendDBModel.sendToInvite(inviteMark: true, opponentID: (userDataModel?.uid)!, button: inviteButton,view:self.view)
                inviteButton.setTitle("誘いを取り消す", for: .normal)
            }else{
                sendDBModel.sendToInvite(inviteMark: false, opponentID: (userDataModel?.uid)!, button: inviteButton,view: self.view)
                inviteButton.setTitle("勉強に誘う", for: .normal)
            }
        }
    }
    
    //プロフィールを開いた時のユーザーのinviteMarkの値を取得しボタンを切り替える
    func inviteState(){
        let invitedListArray = KeyChain.getKeyChainArray(key: "invitedList")
        if invitedListArray.contains((userDataModel?.uid)!) != true{
            inviteButton.setTitle("勉強に誘う", for: .normal)
            inviteMark = false
        }else{
            inviteButton.setTitle("誘いを取り消す", for: .normal)
            inviteMark = true
        }
    }

    //プロフィールに表示されているユーザーのinvite(誘われた)の値を取得し、inviteMarkに代入
    //値がなければfalseを入れる
    func inviteBool(){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("invited").document((self.userDataModel?.uid)!).getDocument{ (document, error) in
            if error != nil{
                return
            }
            if let document = document, document.exists{
                let dataDescription = document.data()
                if let invite = dataDescription!["invite"] as? Bool{
                    self.inviteMark = invite
                    return
                }
            }
            self.inviteMark = false
        }
    }
}
