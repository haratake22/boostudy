//
//  InviteProfileViewController.swift
//  boostudy
//

import UIKit
import Firebase
import SDWebImage

class InviteProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var studyContentsLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var getInviteButton: UIButton!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleGenderLabel: UILabel!
    @IBOutlet weak var titleAgeLabel: UILabel!
    @IBOutlet weak var titleContentsLabel: UILabel!
    @IBOutlet weak var titleTimeLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var userDataModel:UserDataModel?
    var userData = KeyChain.getKeyChain(key: "userData")
    var menuButton = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton = UIBarButtonItem(title: "•••", style: .done, target: self, action: #selector(menu(_:)))
        self.navigationItem.rightBarButtonItem = menuButton
        autoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar(navigationcontroller: self.navigationController!)
        let getDBModel = GetDBModel()
        getDBModel.getMatchingPersonData()
        configure()
    }
    
    
    @objc func menu(_ sender: UIBarButtonItem) {
        let alertController: UIAlertController =
            UIAlertController(title: "このユーザーをブロックまたは通報しますか？",
                              message: "",
                              preferredStyle: .alert)

        //ブロックを押したときにDBの自分のblockListに相手のbeenBlockListに追加
        let block = UIAlertAction(title: "ブロック", style: .destructive){
            action in
            let sendDBModel = SendDBModel()
            sendDBModel.sendToBlockList(blockMark: true, blockID: (self.userDataModel?.uid)!, name: (self.userDataModel?.name)!,age: (self.userDataModel?.age)!,gender: (self.userDataModel?.gender)!,studyContents: (self.userDataModel?.studyContents)!,startTime: (self.userDataModel?.startTime)!,finishTime: (self.userDataModel?.finishTime)!,userImageString: (self.userDataModel?.userImageString)!, uid: (self.userDataModel?.uid)!)
        }

        //通報を押すと問い合わせの画面に遷移
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
        getInviteButton.buttonLayout(button: getInviteButton, topItem: startTimeLabel as Any, view: self.view,hex: "4F54CF")
    }

    //相手からの誘いに乗る時はマッチングが成立するため自分のmatchingに相手の情報、相手のmatchingに自分の情報を追加
    @IBAction func getInviteButton(_ sender: Any) {
        
        let sendDBModel = SendDBModel()

        sendDBModel.sendToReceiveInvite(inviteMark: true, opponentID: (userDataModel?.uid)!, matchName: (userDataModel?.name)!, matchID: (userDataModel?.uid)!)

        sendDBModel.sendToMatchingList(opponentID: (userDataModel?.uid)!, name: (userDataModel?.name)!, age: (userDataModel?.age)!, gender: (userDataModel?.gender)!, studyContents: (userDataModel?.studyContents)!, startTime: (userDataModel?.startTime)!, finishTime: (userDataModel?.finishTime)!, userImageString: (userDataModel?.userImageString)!, uid: (userDataModel?.uid)!, userData: userData)
    }
    
}
