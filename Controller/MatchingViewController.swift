//
//  MatchingViewController.swift
//  boostudy
//

import UIKit

class MatchingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetWhoisMatchListProtocol {
    
    
    @IBOutlet weak var matchingTableView: UITableView!
    
    var matchingArray = [UserDataModel]()
    var userData = [String:Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchingTableView.delegate = self
        matchingTableView.dataSource = self
        matchingTableView.register(InviteListTableViewCell.nib(), forCellReuseIdentifier: InviteListTableViewCell.idetifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let getDBModel = GetDBModel()
        self.navigationController?.navigationBar(navigationcontroller: self.navigationController!)
        self.tabBarController?.tabBar.isHidden = false
        getDBModel.getWhoisMatchListProtocol = self
        getDBModel.getMatchingPersonData()
        userData = KeyChain.getKeyChain(key: "userData")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InviteListTableViewCell.idetifier, for: indexPath) as! InviteListTableViewCell
        cell.configure(inviteListImageString: matchingArray[indexPath.row].userImageString!, inviteListNameString: matchingArray[indexPath.row].name!, inviteListGenderString: matchingArray[indexPath.row].gender!, inviteListAgeString: matchingArray[indexPath.row].age!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = self.navigationController?.storyboard?.instantiateViewController(identifier: "chatVC") as! ChatViewController
        chatVC.userDataModel = matchingArray[indexPath.row]
        chatVC.userData = userData
        self.navigationController?.pushViewController(chatVC, animated: true)
    }

    func getWhoisMatchListProtocol(userDataModelArray: [UserDataModel]) {
        matchingArray = userDataModelArray
        matchingTableView.reloadData()
    }
    
}
