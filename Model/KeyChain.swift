//
//  KeyChain.swift
//  boostudy
//

import Foundation
import KeychainSwift

class KeyChain {
    
    static func getLogInKeyChain(key:String) -> String{
        let keyChain = KeychainSwift()
        let keyData = keyChain.getData(key)
        if keyData != nil{
            let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyData!) as! String
            return unarchivedObject
        }else{
            return String()
        }
    }
    
    static func setLogInKeyChain(value:String,key:String){
        let keyChain = KeychainSwift()
        
        let archive = try!NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        keyChain.set(archive, forKey: key)
    }
    
    //userData
    static func setKeyChain(value:[String:Any],key:String){
        let keyChain = KeychainSwift()
        
        let archive = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        keyChain.set(archive, forKey: key)
        
    }
    //userData
    static func getKeyChain(key:String)->[String:Any]{
        
        let keychain = KeychainSwift()
        //[String:Any]辞書型を保存する時はData型にしてから保存する。保存したData型のものを取り出すときはもう一度辞書型に戻してから取り出す。
        let keyData = keychain.getData(key)
        if keyData != nil {
            let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyData!) as! [String:Any]
            return unarchivedObject
            
        }else{
            
            return[:]
        }
        
    }
    //invitedList
    static func getKeyChainArray(key:String) -> [String]{
        let keyChain = KeychainSwift()
        let keyData = keyChain.getData(key)
        if keyData != nil{
            let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyData!) as! [String]
            return unarchivedObject
        }else{
            
            return []
        }
        
    }
    //invitedList
    static func setKeyChainArray(value:[String],key:String){
        
        let keychain = KeychainSwift()
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        keychain.set(archivedData, forKey: key)
    }
}
