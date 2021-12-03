//
//  InviteListViewController.swift
//  boostudy
//

import UIKit
import Firebase

class InviteListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetInviteDataProtocol,GetWhoisMatchListProtocol {

    
    @IBOutlet weak var inviteListTableView: UITableView!
    
    var InviteListArray = [UserDataModel]()
    var blockListArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteListTableView.delegate = self
        inviteListTableView.dataSource = self
        inviteListTableView.register(InviteListTableViewCell.nib(), forCellReuseIdentifier: InviteListTableViewCell.idetifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar(navigationcontroller: self.navigationController!)
        let getDBModel = GetDBModel()
        getDBModel.getInviteDataProtocol = self
        getDBModel.getWhoisMatchListProtocol = self
        getDBModel.getMatchingPersonData()
        getDBModel.getInviteList()
        inviteListTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InviteListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InviteListTableViewCell.idetifier, for: indexPath) as! InviteListTableViewCell
        
        cell.configure(inviteListImageString: InviteListArray[indexPath.row].userImageString!, inviteListNameString: InviteListArray[indexPath.row].name!, inviteListGenderString: InviteListArray[indexPath.row].gender!, inviteListAgeString: InviteListArray[indexPath.row].age!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.size.height
        if height <= 700 {
            return height/6
        }else{
            return height/8
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inviteVC = self.navigationController?.storyboard?.instantiateViewController(identifier: "inviteProfileVC") as! InviteProfileViewController
        inviteVC.navigationController?.pushViewController(inviteVC, animated: true)
        inviteVC.userDataModel = InviteListArray[indexPath.row]
        self.navigationController?.pushViewController(inviteVC, animated: true)
    }

    //自分がブロックしたひとを表示しないように配列内から削除する。
    func getInviteDataProtocol(userDataModelArray: [UserDataModel]) {
        
        var deleteArray = [Int]()
        var count = 0
        
        self.InviteListArray = []
        self.InviteListArray = userDataModelArray
        
        blockListArray = []
        blockListArray = KeyChain.getKeyChainArray(key: "blockList")

        
        for i in 0..<self.InviteListArray.count{
            if blockListArray.contains(self.InviteListArray[i].uid!) == true{
                
                deleteArray.append(i)
            }
        }

        for i in 0..<deleteArray.count {
            self.InviteListArray.remove(at: deleteArray[i] - count)
            count = +1
        }
        inviteListTableView.reloadData()
    }
    
    func getWhoisMatchListProtocol(userDataModelArray: [UserDataModel]) {
        var count = 0
        var matchArray = [Int]()

        for i in 0..<userDataModelArray.count{
            if self.InviteListArray.firstIndex(where: {$0.uid == userDataModelArray[i].uid}) != nil{
                matchArray.append(i)
            }
        }
        for i in 0..<matchArray.count{
            self.InviteListArray.remove(at: matchArray[i] - count)
            count = +1
        }
        self.inviteListTableView.reloadData()
    }
    
}
