//
//  CreateUserViewController.swift
//  boostudy
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PKHUD
import AWSRekognition


class CreateUserViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var studyContentsTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var finishTimeTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var studyContentsLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    
    var dataSringArray = [String]()
    var dataIntArray = [Int]()
    var genderPicker = UIPickerView()
    var agePicker = UIPickerView()
    var startTimePicker = UIPickerView()
    var finishTimePicker = UIPickerView()
    
    var db = Firestore.firestore()
    
    var userData = KeyChain.getKeyChain(key: "userData")
    
    var rekognitionObject: AWSRekognition?
    var rekognitionFilter = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLayout()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        agePicker.delegate = self
        agePicker.dataSource = self
        startTimePicker.delegate = self
        startTimePicker.dataSource = self
        finishTimePicker.delegate = self
        finishTimePicker.dataSource = self
        
        genderTextField.inputView = genderPicker
        ageTextField.inputView = agePicker
        startTimeTextField.inputView = startTimePicker
        finishTimeTextField.inputView = finishTimePicker
        
        genderPicker.tag = 1
        agePicker.tag = 2
        startTimePicker.tag = 3
        finishTimePicker.tag = 4
        
        userImageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if userData["name"] != nil{
            performSegue(withIdentifier: "input", sender: nil)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            dataSringArray = Picker.gender()
            return dataSringArray.count
        case 2:
            dataIntArray = Picker.age()
            return dataIntArray.count
        case 3:
            dataIntArray = Picker.time()
            return dataIntArray.count
        case 4:
            dataIntArray = Picker.time()
            return dataIntArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            genderTextField.text = dataSringArray[row]
            genderTextField.resignFirstResponder()
            break
        case 2:
            ageTextField.text = String(dataIntArray[row]) + "歳"
            ageTextField.resignFirstResponder()
            break
        case 3:
            startTimeTextField.text = String(dataIntArray[row]) + "時"
            startTimeTextField.resignFirstResponder()
            break
        case 4:
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
            return dataSringArray[row]
        case 2:
            return String(dataIntArray[row]) + "歳"
        case 3:
            return String(dataIntArray[row]) + "時"
        case 4:
            return String(dataIntArray[row]) + "時"
        default:
            return ""
        }
    }
    
    
    @IBAction func save(_ sender: Any) {
        HUD.show(.progress)
        if rekognitionFilter == true{
            HUD.hide(animated: true)
            Layout.rekognitionNotification()
            
        }else{
            
            if userNameTextField.text?.isEmpty == false &&
                startTimeTextField.text?.isEmpty == false &&
                finishTimeTextField.text?.isEmpty == false &&
                studyContentsTextField.text?.isEmpty == false
            {
                if ageTextField.text?.isEmpty == true{
                    ageTextField.text = ""
                }else if genderTextField.text?.isEmpty == true{
                    genderTextField.text = ""
                }
                if let ageRange = self.ageTextField.text?.range(of: "歳"),
                   let startTimeRange = self.startTimeTextField.text?.range(of: "時"),
                   let finishTimeRange = self.finishTimeTextField.text?.range(of: "時"){
                    self.ageTextField.text?.replaceSubrange(ageRange, with: "")
                    self.startTimeTextField.text?.replaceSubrange(startTimeRange, with: "")
                    self.finishTimeTextField.text?.replaceSubrange(finishTimeRange, with: "")
                }
                
                let userData = UserDataModel(name: self.userNameTextField.text, age: self.ageTextField.text, gender: self.genderTextField.text, studyContents: self.studyContentsTextField.text, startTime:self.startTimeTextField.text,finishTime: self.finishTimeTextField.text, userImageString: "", uid: Auth.auth().currentUser?.uid)
                
                let sendDBModel = SendDBModel()
                sendDBModel.sendProfile(userData: userData, userImageData: (self.userImageView.image?.jpegData(compressionQuality: 0.4))!)
                HUD.hide(animated: true)
                self.performSegue(withIdentifier: "input", sender: nil)
            }else{
                HUD.hide(animated: true)
                Layout.textAlertNotification()
            }
        }
    }
    
    @IBAction func tapImage(_ sender: Any) {
        openCamera()
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
            return
        }
    }
    
    //選択された画像がここのメソッドに渡る。
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage{
            userImageView.image = pickedImage
            let image: UIImage = userImageView.image!

    //選択された画像が不適切なものでないかどうかを確認
            let rekognitionImage = AWSRekognitionImage()
            rekognitionImage?.bytes = image.jpegData(compressionQuality: 0.4)
            
            let modelLabelRequest = AWSRekognitionDetectModerationLabelsRequest()
            modelLabelRequest?.image = rekognitionImage
            guard let request = modelLabelRequest else { return }
            rekognitionObject = AWSRekognition.default()
            rekognitionObject?.detectModerationLabels(request) { result, error in
                if error != nil {
                    debugPrint("----failure----", error!)
                }
                let resultString = "\(String(describing: result))"
                if resultString.contains("name") == true{
                    self.rekognitionFilter = true
                }else{
                    self.rekognitionFilter = false
                }
            }
        }
        HUD.show(.progress)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            HUD.hide(animated: true)
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    //撮影がキャンセルされたときに呼ばれる。
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func autoLayout(){
        titleLabel.createTitleLabel(label: titleLabel, view: self.view)
        userImageView.createImageView(imageView: userImageView, topItem: titleLabel as Any, view: self.view)
        userNameLabel.labelAutoLayout(label: userNameLabel, topItem: userImageView as Any, view: self.view)
        userNameTextField.textFieldAutoLayout(textField: userNameTextField, topItem: userNameLabel, view: self.view,hex: "4F54CF")
        genderLabel.labelAutoLayout(label: genderLabel, topItem: userNameTextField as Any, view: self.view)
        genderTextField.textFieldAutoLayout(textField: genderTextField, topItem: genderLabel, view: self.view,hex: "4F54CF")
        ageLabel.labelAutoLayout(label: ageLabel, topItem: genderTextField as Any, view: self.view)
        ageTextField.textFieldAutoLayout(textField: ageTextField, topItem: ageLabel, view: self.view,hex: "4F54CF")
        studyContentsLabel.labelAutoLayout(label: studyContentsLabel, topItem: ageTextField as Any, view: self.view)
        studyContentsTextField.textFieldAutoLayout(textField: studyContentsTextField, topItem: studyContentsLabel, view: self.view,hex: "4F54CF")
        studyTimeLabel.labelAutoLayout(label: studyTimeLabel, topItem: studyContentsTextField as Any, view: self.view)
        startTimeTextField.startTimeTextField(textField: startTimeTextField, topItem: studyTimeLabel, view: self.view,hex: "4F54CF")
        fromLabel.fromLabel(label: fromLabel, topItem: studyTimeLabel as Any, leftItem: startTimeTextField as Any, view: self.view)
        finishTimeTextField.finishTextField(textField: finishTimeTextField, topItem: studyTimeLabel as Any, leftLabel: fromLabel, view: self.view,hex: "4F54CF")
        saveButton.buttonLayout(button: saveButton, topItem: startTimeTextField as Any, view: self.view, hex: "4F54CF")
    }
        
}
