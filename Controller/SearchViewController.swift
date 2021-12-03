//
//  SearchViewController.swift
//  boostudy
//

import UIKit

struct SearchText:Codable {
    let gender:String?
    let ageMin:String?
    let ageMax:String?
    let startTime:String?
    let finishTime:String?
    let studyContents:String?
}

class SearchViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,GetSearchResultProtocol {
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageMinTextField: UITextField!
    @IBOutlet weak var ageFromLabel: UILabel!
    @IBOutlet weak var ageMaxTextField: UITextField!
    @IBOutlet weak var studyContentsLabel: UILabel!
    @IBOutlet weak var studyContentsTextField: UITextField!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var timeFromLabel: UILabel!
    @IBOutlet weak var finishTimeTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var dataStringArray = [String]()
    var dataIntArray = [Int]()
    
    var userDataModelArray = [UserDataModel]()
    var userData = String()
    var ageMinPicker = UIPickerView()
    var ageMaxPicker = UIPickerView()
    var genderPicker = UIPickerView()
    var startTimePicker = UIPickerView()
    var finishTimePicker = UIPickerView()
    //遷移元から処理を受け取るクロージャのプロパティを用意
    var resultHandler: (([UserDataModel],Bool) -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        ageMinPicker.delegate = self
        ageMinPicker.dataSource = self
        ageMaxPicker.delegate = self
        ageMaxPicker.dataSource = self
        startTimePicker.delegate = self
        startTimePicker.dataSource = self
        finishTimePicker.delegate = self
        finishTimePicker.dataSource = self

        genderTextField.inputView = genderPicker
        ageMinTextField.inputView = ageMinPicker
        ageMaxTextField.inputView = ageMaxPicker
        startTimeTextField.inputView = startTimePicker
        finishTimeTextField.inputView = finishTimePicker
        
        genderPicker.tag = 1
        ageMinPicker.tag = 2
        ageMaxPicker.tag = 3
        startTimePicker.tag = 4
        finishTimePicker.tag = 5
        
        autoLayout()
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: "search"),
              let getSearchText = try? jsonDecoder.decode(SearchText.self, from: data) else {
                return
        }
        
        genderTextField.text = getSearchText.gender
        ageMinTextField.text = getSearchText.ageMin
        ageMaxTextField.text = getSearchText.ageMax
        startTimeTextField.text = getSearchText.startTime
        finishTimeTextField.text = getSearchText.finishTime
        studyContentsTextField.text = getSearchText.studyContents
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar(navigationcontroller: self.navigationController!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            dataStringArray = Picker.gender()
            return dataStringArray.count
        case 2:
            dataIntArray = Picker.age()
            return dataIntArray.count
        case 3:
            dataIntArray = Picker.age()
            return dataIntArray.count
        case 4:
            dataIntArray = Picker.time()
            return dataIntArray.count
        case 5:
            dataIntArray = Picker.time()
            return dataIntArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            genderTextField.text = dataStringArray[row]
            genderTextField.resignFirstResponder()
            break
        case 2:
            ageMinTextField.text = String(dataIntArray[row]) + "歳"
            ageMinTextField.resignFirstResponder()
            break
        case 3:
            ageMaxTextField.text = String(dataIntArray[row]) + "歳"
            ageMaxTextField.resignFirstResponder()
            break
        case 4:
            startTimeTextField.text = String(dataIntArray[row]) + "時"
            startTimeTextField.resignFirstResponder()
            break
        case 5:
            finishTimeTextField.text = String(dataIntArray[row]) + "時"
            finishTimeTextField.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return dataStringArray[row]
        case 2:
            return String(dataIntArray[row]) + "歳"
        case 3:
            return String(dataIntArray[row]) + "歳"
        case 4:
            return String(dataIntArray[row]) + "時"
        case 5:
            return String(dataIntArray[row]) + "時"
        default:
            return ""
        }
    }
    
    func autoLayout(){
        imageView.searchImageView(imageView: imageView, view: self.view)
        genderLabel.searchGenderLabel(label: genderLabel,item: self.view, view: self.view)
        genderTextField.textFieldAutoLayout(textField: genderTextField, topItem: genderLabel, view: self.view,hex: "FFCC33")
        ageLabel.labelAutoLayout(label: ageLabel, topItem: genderTextField as Any, view: self.view)
        ageMinTextField.startTimeTextField(textField: ageMinTextField, topItem: ageLabel, view: self.view,hex: "FFCC33")
        ageFromLabel.fromLabel(label: ageFromLabel, topItem: ageLabel as Any, leftItem: ageMinTextField as Any, view: self.view)
        ageMaxTextField.finishTextField(textField: ageMaxTextField, topItem: ageLabel as Any, leftLabel: ageFromLabel, view: self.view,hex: "FFCC33")
        studyContentsLabel.labelAutoLayout(label: studyContentsLabel, topItem: ageMinTextField as Any, view: self.view)
        studyContentsTextField.textFieldAutoLayout(textField: studyContentsTextField, topItem: studyContentsLabel, view: self.view,hex: "FFCC33")
        studyTimeLabel.labelAutoLayout(label: studyTimeLabel, topItem: studyContentsTextField as Any, view: self.view)
        startTimeTextField.startTimeTextField(textField: startTimeTextField, topItem: studyTimeLabel, view: self.view,hex: "FFCC33")
        timeFromLabel.fromLabel(label: timeFromLabel, topItem: studyTimeLabel as Any, leftItem: startTimeTextField as Any, view: self.view)
        finishTimeTextField.finishTextField(textField: finishTimeTextField, topItem: studyTimeLabel as Any, leftLabel: timeFromLabel, view: self.view,hex: "FFCC33")
        searchButton.buttonLayout(button: searchButton, topItem: startTimeTextField as Any, view: self.view, hex: "FFCC33")
    }
    
    
    @IBAction func search(_ sender: Any) {
        let getDBModel = GetDBModel()
        getDBModel.getSearchResultProtocol = self
        getDBModel.loadSearch(gender: genderTextField.text!, ageMin: ageMinTextField.text!, ageMax: ageMaxTextField.text!, searchContents: studyContentsTextField.text!, startTime: startTimeTextField.text!, finishTime: finishTimeTextField.text!)
        let searchText = SearchText(gender: genderTextField.text, ageMin: ageMinTextField.text, ageMax: ageMaxTextField.text, startTime: startTimeTextField.text, finishTime: finishTimeTextField.text, studyContents: studyContentsTextField.text)
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(searchText) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "search")
        self.navigationController?.popViewController(animated: true)
    }
    
    func getSearchResultProtocol(userDataModelArray: [UserDataModel], searchDone: Bool) {
        self.userDataModelArray = []
        self.userDataModelArray = userDataModelArray
        
        if let handler = self.resultHandler{
            handler(self.userDataModelArray,searchDone)
        }
        self.dismiss(animated: true, completion: nil)
    }

}
