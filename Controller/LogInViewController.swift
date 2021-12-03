//
//  LogInViewController.swift
//  boostudy
//

import UIKit
import AuthenticationServices
import CryptoKit
import Firebase
import PKHUD
import FirebaseAuth

class LogInViewController: UIViewController,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    
    var checked = false
    var currentNonce:String?
    var logInCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authOption:UNAuthorizationOptions = [.alert,.badge,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOption) { (_, _) in
        }
        
        let appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        
        appleButton.frame = CGRect(x: 0, y: 0, width: 284, height: 40)
        appleButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(appleButton)
        imageView.logInImageView(imageView: imageView, view: self.view)
        titleLabel.logInTitleLabel(label: titleLabel, topItem: imageView)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48).isActive = true
        appleButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 112).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: view.frame.size.height/16).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        termsButton.termsButton(button: termsButton, topItem: titleLabel, rightItem: self.view, view: self.view)
        checkButton.checkButton(button: checkButton,Item: termsButton, view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.view.timer(viewAnimate: self.view)
    }

    @objc func tap(){
        if checked == true{
            
            let nonce = randomNonceString()
            currentNonce = nonce
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            
            request.nonce = sha256(nonce)
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }else{
            Layout.termsNotification()
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            break
        default:
            break
        }
        
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        // Firebaseへのログインを
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                HUD.flash(.labeledError(title: "予期せぬエラー", subtitle: "再度お試しください。"), delay: 0)
                return
            }
            if let authResult = authResult {
                HUD.flash(.labeledSuccess(title: "ログイン完了", subtitle: nil), onView: self.view, delay: 0) { _ in
                    let userData = KeyChain.getKeyChain(key: "userData")
                    if userData["name"] != nil{
                        self.performSegue(withIdentifier: "userVC", sender: nil)
                    }else{
                        self.performSegue(withIdentifier: "createVC", sender: nil)
                    }
                }
            }
        }
    }
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    @IBAction func check(_ sender: Any) {
        if checked == false{
            checkButton.setImage(UIImage(named: "check"),for: .normal)
            checked = true
        }else{
            checkButton.setImage(nil, for: .normal)
            checked = false
        }
    }
    
    @IBAction func terms(_ sender: Any) {
        self.performSegue(withIdentifier: "termsVC", sender: nil)
    }
    
}
