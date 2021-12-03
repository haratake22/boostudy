//
//  SendDBModel.swift
//  boostudy
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol SendProfileProtocol {
    func sendProfile()
}

protocol GetAttachProtocol {
    func getAttachProtocol(attachImageString:String)
}

class SendDBModel {
    
    let db = Firestore.firestore()
    
    var logInCount = 0
    
    var sendProfileProtcol:SendProfileProtocol?
    
    var getAttachProtocol:GetAttachProtocol?
    
    func sendProfile(userData:UserDataModel,userImageData:Data){
        
        let imageRef = Storage.storage().reference().child("UserImage").child("\( Auth.auth().currentUser!.uid)").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(userImageData, metadata: nil) { metaData,error in
            if error != nil{
                print(error.debugDescription)
                return
            }
            imageRef.downloadURL { url, error in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["name":userData.name as Any,"age":userData.age as Any,"gender":userData.gender as Any,"studyContents":userData.studyContents as Any,"startTime":userData.startTime as Any,"finishTime":userData.finishTime as Any,"userImageString":url?.absoluteString as Any,"uid":userData.uid as Any])
                
                KeyChain.setKeyChain(value: ["name":userData.name as Any,"age":userData.age as Any,"gender":userData.gender as Any,"studyContents":userData.studyContents as Any,"startTime":userData.startTime as Any,"finishTime":userData.finishTime as Any,"userImageString":url?.absoluteString as Any,"uid":userData.uid as Any], key: "userData")
            }
        }
    }

    
    func sendToInvite(inviteMark:Bool,opponentID:String,button:UIButton,view:UIView){

        if inviteMark == false{
            self.db.collection("Users").document(opponentID).collection("invite").document(Auth.auth().currentUser!.uid).setData(["invite":false])

            deleteToInvite(opponentID: opponentID)

            var invitedListArray = KeyChain.getKeyChainArray(key: "invitedList")
            invitedListArray.removeAll(where: {$0 == opponentID})
            KeyChain.setKeyChainArray(value: invitedListArray, key: "invitedList")
            
        }else if inviteMark == true{
            let userData = KeyChain.getKeyChain(key: "userData")
            
            self.db.collection("Users").document(opponentID).collection("invite").document(Auth.auth().currentUser!.uid).setData(["invite": true,"name":userData["name"] as Any,"age":userData["age"] as Any,"gender":userData["gender"] as Any,"studyContents":userData["studyContents"] as Any,"startTime":userData["startTime"] as Any,"finishTime":userData["finishTime"] as Any,"userImageString":userData["userImageString"] as Any,"uid":userData["uid"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("invited").document(opponentID).setData(["invite": true,"name":userData["name"] as Any,"age":userData["age"] as Any,"gender":userData["gender"] as Any,"studyContents":userData["studyContents"] as Any,"startTime":userData["startTime"] as Any,"finishTime":userData["finishTime"] as Any,"userImageString":userData["userImageString"] as Any,"uid":userData["uid"] as Any])
            
            var invitedListArray = KeyChain.getKeyChainArray(key: "invitedList")
            invitedListArray.append(opponentID)
            KeyChain.setKeyChainArray(value: invitedListArray, key: "invitedList")
            Layout.startAnimation(name: "invite", view: view)
        }
        
        
    }
    
    func deleteToInvite(opponentID:String){
        
        self.db.collection("Users").document(opponentID).collection("invite").document(Auth.auth().currentUser!.uid).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("invite").document(opponentID).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("invited").document(opponentID).delete()
    }
    
    //誘われた人一覧からマッチングする時
    func sendToReceiveInvite(inviteMark:Bool,opponentID:String,matchName:String,matchID:String){
        //誘うのをやめたら
        if inviteMark == false{
            self.db.collection("Users").document(opponentID).collection("invite").document(Auth.auth().currentUser!.uid).setData(["invite":false])
            deleteToInvite(opponentID: opponentID)
            var invitedListArray = KeyChain.getKeyChainArray(key: "invitedList")
            invitedListArray.removeAll(where: {$0 == opponentID})
            KeyChain.setKeyChainArray(value: invitedListArray, key: "invitedList")
            
        }else if inviteMark == true{
            
            let userData = KeyChain.getKeyChain(key: "userData")
            self.db.collection("Users").document(opponentID).collection("invite").document(Auth.auth().currentUser!.uid).setData(["invite": true,"name":userData["name"] as Any,"age":userData["age"] as Any,"gender":userData["gender"] as Any,"studyContents":userData["studyContents"] as Any,"startTime":userData["startTime"] as Any,"finishTime":userData["finishTime"] as Any,"userImageString":userData["userImageString"] as Any,"uid":userData["uid"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("invited").document(opponentID).setData(["invite": true,"name":userData["name"] as Any,"age":userData["age"] as Any,"gender":userData["gender"] as Any,"studyContents":userData["studyContents"] as Any,"startTime":userData["startTime"] as Any,"finishTime":userData["finishTime"] as Any,"userImageString":userData["userImageString"] as Any,"uid":userData["uid"] as Any])
            
            var invitedListArray = KeyChain.getKeyChainArray(key: "invitedList")
            invitedListArray.append(opponentID)
            KeyChain.setKeyChainArray(value: invitedListArray, key: "invitedList")
            //マッチングが成立した。
            deleteToInvite(opponentID: Auth.auth().currentUser!.uid)
            deleteToInvite(opponentID: matchID)

            self.db.collection("Users").document(matchID).collection("matching").document(matchID).delete()
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
        }
        
    }
    
    //自分がブロックする時
    func sendToBlockList(blockMark:Bool,blockID:String,name:String,age:String,gender:String,studyContents:String,startTime:String,finishTime:String,userImageString:String,uid:String){
        //ブロック解除
        if blockMark == false{
            self.db.collection("Users").document(blockID).collection("beenBlock").document(Auth.auth().currentUser!.uid).setData(["block":false])

            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block").document(blockID).delete()
            
            self.db.collection("Users").document(blockID).collection("beenBlock").document(Auth.auth().currentUser!.uid).delete()
            
            var blockListArray = KeyChain.getKeyChainArray(key: "blockList")
            blockListArray.removeAll(where: {$0 == blockID})
            KeyChain.setKeyChainArray(value: blockListArray, key: "blockList")
            
        //ブロックした時
        }else if blockMark == true{
            let userData = KeyChain.getKeyChain(key: "userData")
            
            self.db.collection("Users").document(blockID).collection("beenBlock").document(Auth.auth().currentUser!.uid).setData(["block": true,"name":userData["name"] as Any,"age":userData["age"] as Any,"gender":userData["gender"] as Any,"studyContents":userData["studyContents"] as Any,"startTime":userData["startTime"] as Any,"finishTime":userData["finishTime"] as Any,"userImageString":userData["userImageString"] as Any,"uid":userData["uid"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block").document(blockID).setData(["block": true,"name":name,"age":age,"gender":gender,"studyContents":studyContents as Any,"startTime":startTime as Any,"finishTime":finishTime as Any,"userImageString":userImageString,"uid":uid])
            
            var inviteListArray = KeyChain.getKeyChainArray(key: "invitedList")
            inviteListArray.removeAll(where: {$0 == blockID})
            KeyChain.setKeyChainArray(value: inviteListArray, key: "invitedList")
            
            var matchingIDArray = KeyChain.getKeyChainArray(key: "matchingID")
            matchingIDArray.removeAll(where: {$0 == blockID})
            KeyChain.setKeyChainArray(value: matchingIDArray, key: "matchinID")
            
            var blockListArray = KeyChain.getKeyChainArray(key: "blockList")
            blockListArray.append(blockID)
            KeyChain.setKeyChainArray(value: blockListArray, key: "blockList")
        }
        
        
    }
    
    //マッチングした時に相手のuid以下に自分のプロフィールを追加し、自分のuid以下に相手のプロフィールを追加
    func sendToMatchingList(opponentID:String,name:String,age:String,gender:String,studyContents:String,startTime:String,finishTime:String,userImageString:String,uid:String,userData:[String:Any]){
        
        if opponentID == uid{
            
            self.db.collection("Users").document(opponentID).collection("matching").document(Auth.auth().currentUser!.uid).setData(["name":userData["name"] as Any,"age":userData["age"] as Any,"gender":userData["gender"] as Any,"studyContents":userData["studyContents"] as Any,"startTime":userData["startTime"] as Any,"finishTime":userData["finishTime"] as Any,"userImageString":userData["userImageString"] as Any,"uid":userData["uid"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(opponentID).setData(["name":name as Any,"age":age as Any,"gender":gender as Any,"studyContents":studyContents as Any,"startTime":startTime as Any,"finishTime":finishTime as Any,"userImageString":userImageString as Any,"uid":uid as Any])
        }else{
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(opponentID).setData(["name":name as Any,"age":age as Any,"gender":gender as Any,"studyContents":studyContents as Any,"startTime":startTime as Any,"finishTime":finishTime as Any,"userImageString":userImageString as Any,"uid":uid as Any])
        }
        
        self.db.collection("Users").document(opponentID).collection("invite").document(Auth.auth().currentUser!.uid).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("invite").document(opponentID).delete()
    }
    
    
    //チャットで送信した画像をstorageに追加
    func sendImageData(image:UIImage,senderID:String,recipientID:String){
        
        let userData = KeyChain.getKeyChain(key: "userData")
        let imageRef = Storage.storage().reference().child("ChatImages").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")

        imageRef.putData(image.jpegData(compressionQuality: 0.3)!, metadata: nil) { metaData, error in
            if error != nil{
                return
            }
            
            imageRef.downloadURL { url, error in
                if error != nil{
                    return
                }
                
                if url != nil {
                    //自分のデータにチャットのデータを送信
                    self.db.collection("Users").document(senderID).collection("matching").document(recipientID).collection("chat").document().setData(
                        ["senderID":Auth.auth().currentUser!.uid,"displayName":userData["name"] as Any,"imageURLString":userData["userImageString"] as Any,"date":Date().timeIntervalSince1970,"attachImageString":url?.absoluteString as Any]
                    )
                    //相手のデータに送信
                    self.db.collection("Users").document(recipientID).collection("matching").document(senderID).collection("chat").document().setData(
                        ["senderID":Auth.auth().currentUser!.uid,"displayName":userData["name"] as Any,"imageURLString":userData["userImageString"] as Any,"date":Date().timeIntervalSince1970,"attachImageString":url?.absoluteString as Any]
                    )
                    
                    self.getAttachProtocol?.getAttachProtocol(attachImageString: url!.absoluteString)
                }
            }
        }
    }
    
    //チャットで送信したメッセージのデータを送信
    func sendMessage(senderID:String,recipientID:String,text:String,displayName:String,imageURLString:String){
        
        self.db.collection("Users").document(senderID).collection("matching").document(recipientID).collection("chat").document().setData(["text":text as Any,"senderID":senderID as Any,"displayName":displayName as Any,"imageURLString":imageURLString as Any,"date":Date().timeIntervalSince1970])
        
        self.db.collection("Users").document(recipientID).collection("matching").document(
            senderID).collection("chat").document().setData(["text":text as Any,"senderID":Auth.auth().currentUser!.uid as Any,"displayName":displayName as Any,"imageURLString":imageURLString as Any,"date":Date().timeIntervalSince1970])
    }
    
    //プロフィール設定で変更した内容をDBとstorageに送信
    func sendUpdateProfile(userData:UserDataModel,userImageData:Data){
        
        let imageRef = Storage.storage().reference().child("UserImage").child("\( Auth.auth().currentUser!.uid)").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(userImageData, metadata: nil) { metaData,error in
            if error != nil{
                print(error.debugDescription)
                return
            }
            imageRef.downloadURL { url, error in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["name":userData.name as Any,"age":userData.age as Any,"gender":userData.gender as Any,"studyContents":userData.studyContents as Any,"startTime":userData.startTime as Any,"finishTime":userData.finishTime as Any,"userImageString":url?.absoluteString as Any,"uid":userData.uid as Any])
                
                KeyChain.setKeyChain(value: ["name":userData.name as Any,"age":userData.age as Any,"gender":userData.gender as Any,"studyContents":userData.studyContents as Any,"startTime":userData.startTime as Any,"finishTime":userData.finishTime as Any,"userImageString":url?.absoluteString as Any,"uid":userData.uid as Any], key: "userData")
                
            }
            
        }
    }
    
}
