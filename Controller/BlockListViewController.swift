//
//  BlockListViewController.swift
//  boostudy
//

import UIKit

class BlockListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetBlockListProtocol {

    
    @IBOutlet weak var blockListTableView: UITableView!
    
    var blockListArray = [UserDataModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockListTableView.delegate = self
        blockListTableView.dataSource = self
        blockListTableView.register(InviteListTableViewCell.nib(), forCellReuseIdentifier: InviteListTableViewCell.idetifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar(navigationcontroller: self.navigationController!)
        let getDBModel = GetDBModel()
        getDBModel.getBlockListProtocol = self
        getDBModel.getBlockList()
        blockListTableView.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InviteListTableViewCell.idetifier, for: indexPath) as! InviteListTableViewCell
        
        cell.configure(inviteListImageString: blockListArray[indexPath.row].userImageString!, inviteListNameString: blockListArray[indexPath.row].name!, inviteListGenderString: blockListArray[indexPath.row].gender!, inviteListAgeString: blockListArray[indexPath.row].age!)
        
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
        let alertController: UIAlertController =
            UIAlertController(title: "ブロックを解除しますか？", message: "",
                              preferredStyle: .alert)
        
        let release = UIAlertAction(title: "解除", style: .default){
            action in
            let sendDBModel = SendDBModel()
            sendDBModel.sendToBlockList(blockMark: false, blockID: self.blockListArray[indexPath.row].uid!, name: self.blockListArray[indexPath.row].name!, age: self.blockListArray[indexPath.row].age!, gender: self.blockListArray[indexPath.row].gender!, studyContents: self.blockListArray[indexPath.row].studyContents!, startTime: self.blockListArray[indexPath.row].startTime!, finishTime: self.blockListArray[indexPath.row].finishTime!, userImageString: self.blockListArray[indexPath.row].userImageString!, uid: self.blockListArray[indexPath.row].uid!)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel){
                    (action) -> Void in
                }
        
        alertController.addAction(release)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func getBlockListProtocol(userDataModelArray: [UserDataModel]) {
        blockListArray = []
        blockListArray = userDataModelArray
        blockListTableView.reloadData()
    }


}
