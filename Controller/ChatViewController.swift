//
//  ChatViewController.swift
//  boostudy
//

import UIKit
import MessageKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import InputBarAccessoryView
import SDWebImage
import Hex

class ChatViewController: MessagesViewController,MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate,InputBarAccessoryViewDelegate,MessageCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GetAttachProtocol {

    var userDataModel:UserDataModel?
    var userData = [String:Any]()
    
    var currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "")
    var otherUser = Sender(senderId: "", displayName: "")
    //チャットの画像をタップした時の拡大画像を表示するためのimageView.viewを用意
    let imageView = UIImageView()
    let blackView = UIView()
    
    var messages = [Message]()
    
    let db = Firestore.firestore()
    
    //フォーマッター（送信時間）を準備
    lazy var formatter:DateFormatter = {
        let formatter = DateFormatter()
        //MMdHmはMMが月,dが日,Hが時間,mが分
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
        
    }()
    
    var attachImage:UIImage?
    var attachImageString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //自分
        currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: userData["name"] as! String)
        
        //相手
        otherUser = Sender(senderId: userDataModel!.uid!, displayName: userDataModel!.name!)
        
        //チャットをしている画面を指す。
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.backgroundColor = UIColor(hex: "EFF2F9")

        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.delegate = self
        let newMessageInputBar = InputBarAccessoryView()
        newMessageInputBar.delegate = self
        //送信するテキストを入力するtextView
        messageInputBar = newMessageInputBar
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.layer.borderWidth = 0.0
        messageInputBar.inputTextView.layer.backgroundColor = UIColor.white.cgColor
        messageInputBar.inputTextView.layer.cornerRadius = 20
        messageInputBar.inputTextView.textColor = .black
        
        //テキストか画像を送信するときに押すボタン
        messageInputBar.sendButton.title = "送信"
        
        let items = [makeButton(image: UIImage(named: "album")!).onTextViewDidChange({ button,  textView in
            //画像だけを送信するため、textViewに入力されていたら送信ボタンを押させないようにする。
            button.isEnabled = textView.text.isEmpty
        })]
        messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: true)
        messageInputBar.setStackViewItems(items, forStack: .left, animated: true)
        reloadInputViews()
  
    }
   
    //写真を送信するときに押すアルバムのボタン
    func makeButton(image:UIImage)->InputBarButtonItem{
        //configureで体裁を整える
        return InputBarButtonItem().configure {
            //どこに置くか
            $0.spacing = .fixed(10)
            $0.image = image.withRenderingMode(.alwaysTemplate)
            $0.setSize(CGSize(width: 25, height: 25), animated: true)
            $0.tintColor = UIColor(hex: "797979")
            //onSelectedでアルバムボタンが押された時の挙動を記述
        }.onSelected {
            $0.tintColor = .systemBlue
            //カメラを起動(アルバム),クロージャの中であるためselfが必要
            self.openCamera()
            //画像の選択が終わった時の処理
        }.onDeselected {
            $0.tintColor = UIColor.lightGray
        }
    }
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }else{
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage{
            attachImage = pickedImage
            let sendDBModel = SendDBModel()
            sendDBModel.getAttachProtocol = self
            sendDBModel.sendImageData(image: attachImage!, senderID: Auth.auth().currentUser!.uid, recipientID: (userDataModel?.uid)!)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //撮影がキャンセルされたときに呼ばれる。
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func getAttachProtocol(attachImageString: String) {
        self.attachImageString = attachImageString
    }
    
    //メッセージの下の文字列
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .caption2),.foregroundColor: UIColor.darkGray])
    }
    
    //デリゲートメソッド
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if case MessageKind.photo(let media) = message.kind{
            imageView.sd_setImage(with: URL(string: messages[indexPath.section].messageImageString), completed: nil)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar(navigationcontroller: self.navigationController!)
        self.tabBarController?.tabBar.isHidden = true
        loadMessage()
    }
    
    //DBのchatコレクション内にある情報を取得
    func loadMessage(){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(userDataModel!.uid!).collection("chat").order(by: "date").addSnapshotListener { snapShot, error in
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.messages = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()

                    if let text = data["text"] as? String,let senderID = data["senderID"] as? String,let imageURLString = data["imageURLString"] as? String,let date = data["date"] as? TimeInterval{
                        
                        if senderID == Auth.auth().currentUser!.uid{
                            self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: self.userData["name"] as! String)

                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text), userImagePath: imageURLString, date: date, messageImageString: "")
                            self.messages.append(message)
                        }else{
                            self.otherUser = Sender(senderId: senderID, displayName: self.userData["name"] as! String)
                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text), userImagePath: imageURLString, date: date, messageImageString: "")
                            self.messages.append(message)
                        }
                    }
                    
                    //添付画像があれば受信する
                    if let senderID = data["senderID"] as? String,let userImageString = data["imageURLString"] as? String,let date = data["date"] as? TimeInterval,let attachImageString = data["attachImageString"] as? String{
                        
                        if senderID == Auth.auth().currentUser?.uid{
                            
                            self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: self.userData["name"] as! String)
                            
                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .photo(ImageMediaItem(imageURL: URL(string: attachImageString)!)), userImagePath: userImageString, date: date, messageImageString: attachImageString)
                            self.messages.append(message)
                        }else{
                            self.otherUser = Sender(senderId: senderID, displayName: "")
                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .photo(ImageMediaItem(imageURL: URL(string: attachImageString)!)), userImagePath: userImageString, date: date, messageImageString: attachImageString)
                            self.messages.append(message)
                        }
                    }
                }
                self.messagesCollectionView.reloadData()
                //自動で最新のメッセージまでスクロールしてくれる。
                self.messagesCollectionView.scrollToLastItem()
            }
        }
    }

    func getImageByURL(url:String)->UIImage{
        //ストリング型をURL型に
        let url = URL(string: url)
        do {
            //data型にしたurlをdata変数に代入
            let data = try Data(contentsOf: url!)
            //data型のものが入っているdataをUIImage型にキャスト（画像を取得）
            return UIImage(data: data)!
        } catch let error {
            print(error)
        }
        return UIImage()
    }
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    //messageの内容
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    //メッセージの数
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
        
    }
    
    //送信ボタンが押されたときに呼ばれるメソッド
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        inputBar.sendButton.startAnimating()
        let sendDBModel = SendDBModel()
        inputBar.inputTextView.text = ""
        sendDBModel.sendMessage(senderID: Auth.auth().currentUser!.uid, recipientID: (userDataModel?.uid)!, text: text, displayName: userData["name"] as! String, imageURLString: userData["userImageString"] as! String)

        inputBar.sendButton.stopAnimating()
        loadMessage()
    }
    
    //送信者と受信者の顔
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.sd_setImage(with: URL(string: messages[indexPath.section].userImagePath), completed: nil)
    }
    
    //メッセージの上に表示されるラベル
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    //本人か他人か色を変える
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? Layout.ChatColor(mySelf: true) : Layout.ChatColor(mySelf: false)
    }
    
    //メッセージが本人かそうでないかで表示される方向を決める。
    //吹き出し
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner:MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(corner, .curved)
        
    }
    
    //ユーザーのアイコンをタップした後に閉じる処理。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.imageView.alpha == 1.0{
            //0.2秒かけて
            UIView.animate(withDuration: 0.2) {
                
                self.blackView.alpha = 0.0
                self.imageView.alpha = 0.0
                
            } completion: { finish in
                //閉じる
                self.blackView.removeFromSuperview()
                self.imageView.removeFromSuperview()
            }
        }
    }
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        guard let indecPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        //アイコンをズーム
        zoomSystem(imageString: messages[indecPath.section].userImagePath, avatorOrNot: true)
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        
        guard let indecPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        //添付画像があるなら
        if messages[indecPath.section].messageImageString.isEmpty != true{
            zoomSystem(imageString: messages[indecPath.section].messageImageString, avatorOrNot: false)
        }else{
            return
        }
    }
    
    func zoomSystem(imageString:String,avatorOrNot:Bool){
        //画像を拡大
        blackView.frame = view.bounds
        blackView.backgroundColor = .darkGray
        blackView.alpha = 0.0
        imageView.frame = CGRect(x: 0, y: view.frame.size.width/2, width: view.frame.size.width, height: view.frame.size.width)
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0.0
        if avatorOrNot == true{
            imageView.layer.cornerRadius = imageView.frame.width/2
        }else{
            imageView.layer.cornerRadius = 20
        }
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        UIView.animate(withDuration: 0.2) {
            self.blackView.alpha = 0.9
            self.imageView.alpha = 1.0
        } completion: { finish in }

        imageView.sd_setImage(with: URL(string: imageString), completed: nil)
        view.addSubview(blackView)
        view.addSubview(imageView)
    }

}
