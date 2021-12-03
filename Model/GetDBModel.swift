//
//  GetDBModel.swift
//  boostudy
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol GetProfileDataProtocol {
    func getProfileData(userDataModelArray:[UserDataModel])
}

protocol GetInviteStateProtocol {
    func gentInviteState(inviteMark:Bool)
}

protocol GetInviteDataProtocol {
    func getInviteDataProtocol(userDataModelArray:[UserDataModel])
}

protocol GetWhoisMatchListProtocol {
    func getWhoisMatchListProtocol(userDataModelArray:[UserDataModel])
}

protocol GetBlockListProtocol {
    func getBlockListProtocol(userDataModelArray:[UserDataModel])
}

protocol GetSearchResultProtocol {
    func getSearchResultProtocol(userDataModelArray:[UserDataModel],searchDone:Bool)
}


class GetDBModel {
    
    var db = Firestore.firestore()
    
    var conditions = [(UserDataModel) -> Bool]()
    var profileModelArray = [UserDataModel]()
    var studyModelArray = [UserDataModel]()
    var searchModelArray = [UserDataModel]()
    //protocolをインスタンス化
    var getProfileDataProtocol:GetProfileDataProtocol?
    var getInvteStatetProtocol:GetInviteStateProtocol?
    var getInviteDataProtocol:GetInviteDataProtocol?
    var getWhoisMatchListProtocol:GetWhoisMatchListProtocol?
    var getBlockListProtocol:GetBlockListProtocol?
    var getSearchResultProtocol:GetSearchResultProtocol?
    
    var matchingIDArray = [String]()
    
    //自分以外のDBにあるユーザーのプロフィールを全て取得
    func getUsersProfile(uid:String){
        db.collection("Users").whereField("uid", isNotEqualTo: uid).addSnapshotListener { snapShot, error in
            if error != nil{
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                
                for doc in snapShotDoc{
                    let data = doc.data()

                    if let name = data["name"] as? String,let age = data["age"] as? String,let gender = data["gender"] as? String,let studyContents = data["studyContents"] as? String,let startTime = data["startTime"] as? String,let finishTime = data["finishTime"] as? String,let userImageString = data["userImageString"] as? String,let uid = data["uid"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, age: age, gender: gender, studyContents: studyContents, startTime: startTime, finishTime: finishTime,  userImageString: userImageString, uid: uid)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                }
                self.getProfileDataProtocol?.getProfileData(userDataModelArray: self.profileModelArray)
            }
        }
    }
    
    //
    func getInviteState(opponentID:String,button:UIButton,inviteMark:Bool){
        let invitedListArray = KeyChain.getKeyChainArray(key: "invitedList")
        if invitedListArray.contains(opponentID) != true{
            button.setTitle("勉強に誘う", for: .normal)
        }else{
            button.setTitle("誘いを取り消す", for: .normal)
        }
    }

    //自分が勉強に誘ったユーザーの情報を取得
    func getInviteList(){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("invite").addSnapshotListener { snapShot, error in

            if error != nil{
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let gender = data["gender"] as? String,let studyContents = data["studyContents"] as? String,let startTime = data["startTime"] as? String,let finishTime = data["finishTime"] as? String,let userImageString = data["userImageString"] as? String,let uid = data["uid"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, age: age, gender: gender, studyContents: studyContents, startTime: startTime, finishTime: finishTime, userImageString: userImageString, uid: uid)
                        self.profileModelArray.append(userDataModel)
                    }
                }
                self.getInviteDataProtocol?.getInviteDataProtocol(userDataModelArray: self.profileModelArray)
            }
        }
    }
    
    //マッチングしているユーザーの情報を取得
    func getMatchingPersonData(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").addSnapshotListener { snapShot, error in
            if error != nil{
                print(error.debugDescription)
                return
                
            }
            if let snapShotDoc = snapShot?.documents{
                self.profileModelArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let gender = data["gender"] as? String,let studyContents = data["studyContents"] as? String,let startTime = data["startTime"] as? String,let finishTime = data["finishTime"] as? String,let userImageString = data["userImageString"] as? String,let uid = data["uid"] as? String{
                        
                        //マッチングしたIDを配列内に入れる。
                        self.matchingIDArray = KeyChain.getKeyChainArray(key: "matchingID")
                        //配列内にないID、つまり初めてマッチングするIDの場合
                        if self.matchingIDArray.contains(where: {$0 == uid}) == false{
                            
                            if uid == Auth.auth().currentUser?.uid{
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                            }else{
                                Layout.matchNotification(name: name, id: uid)
                                
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                                //配列内に追加する
                                self.matchingIDArray.append(uid)
                                //アプリ内に保存
                                KeyChain.setKeyChainArray(value: self.matchingIDArray, key: "matchingID")
                            }
                        }
                        let userDataModel = UserDataModel(name: name, age: age, gender: gender, studyContents: studyContents, startTime: startTime, finishTime: finishTime, userImageString: userImageString, uid: uid)
                        self.profileModelArray.append(userDataModel)
                    }
                }
                self.getWhoisMatchListProtocol?.getWhoisMatchListProtocol(userDataModelArray: self.profileModelArray)
            }
        }
    }
    
    //自分がブロックしたユーザーの情報を取得
    func getBlockList(){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block").addSnapshotListener { snapShot, error in

            if error != nil{
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []

                for doc in snapShotDoc{
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let gender = data["gender"] as? String,let studyContents = data["studyContents"] as? String,let startTime = data["startTime"] as? String,let finishTime = data["finishTime"] as? String,let userImageString = data["userImageString"] as? String,let uid = data["uid"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, age: age, gender: gender, studyContents: studyContents, startTime: startTime, finishTime: finishTime, userImageString: userImageString, uid: uid)
                        self.profileModelArray.append(userDataModel)
                    }
                }
                self.getBlockListProtocol?.getBlockListProtocol(userDataModelArray: self.profileModelArray)
            }
        }
    }
    
    //自分がブロックされているユーザーの情報を取得
    func getBeenBlockList(){
        var beenBlockListArray = KeyChain.getKeyChainArray(key: "beenBlockList")
        beenBlockListArray.removeAll()
        KeyChain.setKeyChainArray(value: beenBlockListArray, key: "beenBlockList")
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("beenBlock").addSnapshotListener { snapShot, error in
            if error != nil{
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []

                for doc in snapShotDoc{
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let gender = data["gender"] as? String,let studyContents = data["studyContents"] as? String,let startTime = data["startTime"] as? String,let finishTime = data["finishTime"] as? String,let userImageString = data["userImageString"] as? String,let uid = data["uid"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, age: age, gender: gender, studyContents: studyContents, startTime: startTime, finishTime: finishTime, userImageString: userImageString, uid: uid)
                        self.profileModelArray.append(userDataModel)
                        beenBlockListArray.append(userDataModel.uid!)
                        KeyChain.setKeyChainArray(value: beenBlockListArray, key: "beenBlockList")
                    }
                }
            }
        }
    }
    
    //検索した情報を取得
    func loadSearch(gender:String,ageMin:String,ageMax:String,searchContents:String,startTime:String,finishTime:String){

        db.collection("Users").addSnapshotListener { snapShot, error in
            if error != nil{
                return
                    print(error.debugDescription)
            }
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let gender = data["gender"] as? String,let studyContents = data["studyContents"] as? String,let startTime = data["startTime"] as? String,let finishTime = data["finishTime"] as? String,let userImageString = data["userImageString"] as? String,let uid = data["uid"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, age: age, gender: gender, studyContents: studyContents, startTime: startTime, finishTime: finishTime, userImageString: userImageString, uid: uid)
                        self.profileModelArray.append(userDataModel)
                    }
                    
                    if searchContents.isEmpty != true {
                        self.studyModelArray = self.profileModelArray.filter({ ($0.studyContents?.lowercased().contains(searchContents.lowercased()))!
                        })
                        if self.studyModelArray != []{
                            self.searchModelArray = self.studyModelArray.filter({$0.age! >= ageMin && $0.age! <= ageMax && $0.startTime! >= startTime && $0.finishTime! <= finishTime && $0.gender == gender})
                            if self.searchModelArray != []{
                                self.profileModelArray = self.searchModelArray
                            }else{
                                self.searchModelArray = self.studyModelArray.filter({$0.age! >= ageMin && $0.age! <= ageMax || $0.startTime! >= startTime && $0.finishTime! <= finishTime || $0.gender == gender})
                                if self.searchModelArray != []{
                                    self.profileModelArray = self.searchModelArray
                                }else{
                                    self.profileModelArray = self.studyModelArray
                                }
                            }
                        }
                    }
                }
            }
            self.getSearchResultProtocol?.getSearchResultProtocol(userDataModelArray: self.profileModelArray, searchDone: true)
        }
    }
}

