//
//  Layout.swift
//  boostudy
//

import Foundation
import UIKit
import Hex
import Lottie
import ImpressiveNotifications

extension UIView {
    func blurView (blurView:UIView,view:UIView) {
        let height = view.frame.size.height
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if height <= 700 {
            blurView.widthAnchor.constraint(equalToConstant: 800).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 800).isActive = true
            blurView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/4.8).isActive = true
        }else{
            blurView.widthAnchor.constraint(equalToConstant: 700).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 700).isActive = true
            blurView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/3.8).isActive = true
        }
        blurView.layer.cornerRadius = blurView.frame.size.width/2
        blurView.clipsToBounds = true
    }
    
    func timer(viewAnimate:UIView){
        viewAnimate.alpha = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
                viewAnimate.alpha = 0
            } completion: { (_) in
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn) {
                    viewAnimate.alpha = 1
                }
            }
        })
    }
}



extension UITextField {
    func setUnderLine(view:UIView,hex:String) {
        borderStyle = .none
        let underline = UIView()
        underline.frame = CGRect(x: 0, y: frame.height - 10, width: view.frame.size.width - 66, height: 1.0)
        underline.backgroundColor = UIColor(hex: hex)
        underline.layer.shadowColor = UIColor(hex: hex).cgColor
        underline.layer.shadowOffset = CGSize(width: 1, height: 1)
        underline.layer.shadowOpacity = 0.4
        underline.layer.shadowRadius = 2.0
        addSubview(underline)
        bringSubviewToFront(underline)
    }
    
    func setShortUnderLine(view:UIView,hex:String) {
        borderStyle = .none
        let underline = UIView()
        underline.frame = CGRect(x: 0, y: frame.height - 10, width: view.frame.size.width/6, height: 1.0)
        underline.backgroundColor = UIColor(hex: hex)
        underline.layer.shadowColor = UIColor(hex: hex).cgColor
        underline.layer.shadowOffset = CGSize(width: 1, height: 1)
        underline.layer.shadowOpacity = 0.4
        underline.layer.shadowRadius = 2.0
        addSubview(underline)
        bringSubviewToFront(underline)
    }
    
    func textFieldAutoLayout(textField:UITextField,topItem:UILabel,view:UIView,hex:String){
        if view.frame.size.height <= 700 {
            textField.font = UIFont.boldSystemFont(ofSize: 14)
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: topItem.bottomAnchor, constant: 4).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 66).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
        textField.setUnderLine(view: view,hex: hex)
    }
    
    func startTimeTextField(textField:UITextField,topItem:UILabel,view:UIView,hex:String){
        if view.frame.size.height <= 700 {
            textField.font = UIFont.boldSystemFont(ofSize: 14)
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: topItem.bottomAnchor, constant: 4).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.size.width/6).isActive = true
        textField.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
        textField.setShortUnderLine(view: view,hex: hex)
    }
    
    func finishTextField(textField:UITextField,topItem:Any,leftLabel:UILabel,view:UIView,hex:String){
        if view.frame.size.height <= 700 {
            textField.font = UIFont.boldSystemFont(ofSize: 14)
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 4).isActive = true
        textField.leftAnchor.constraint(equalTo: leftLabel.rightAnchor, constant: 7).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 64).isActive = true
        textField.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
        textField.setShortUnderLine(view: view,hex: hex)
    }
}



extension UILabel {
    func setLabelUnderLine(view:UIView) {
        let underline = UIView()
        underline.frame = CGRect(x: 0, y: frame.height, width: view.frame.size.width - 66, height: 1.0)
        underline.backgroundColor = UIColor(hex: "4F54CF")
        underline.layer.shadowColor = UIColor(hex: "4F54CF").cgColor
        underline.layer.shadowOffset = CGSize(width: 1, height: 1)
        underline.layer.shadowOpacity = 0.4
        underline.layer.shadowRadius = 2.0
        addSubview(underline)
        bringSubviewToFront(underline)
    }
    
    func setShortUnderLine(view:UIView){
        let underline = UIView()
        underline.frame = CGRect(x: 0, y: frame.height, width: view.frame.size.width/6, height: 1.0)
        underline.backgroundColor = UIColor(hex: "4F54CF")
        underline.layer.shadowColor = UIColor(hex: "4F54CF").cgColor
        underline.layer.shadowOffset = CGSize(width: 1, height: 1)
        underline.layer.shadowOpacity = 0.4
        underline.layer.shadowRadius = 2.0
        addSubview(underline)
        bringSubviewToFront(underline)
    }
    
    func logInTitleLabel(label:UILabel,topItem:UIImageView){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topItem.bottomAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(equalToConstant: 180).isActive = true
        label.heightAnchor.constraint(equalToConstant: 48).isActive = true
        label.centerXAnchor.constraint(equalTo: topItem.centerXAnchor).isActive = true
    }
    
    func createTitleLabel(label:UILabel,view:UIView){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        if view.frame.size.height <= 700{
            label.heightAnchor.constraint(equalToConstant: view.frame.size.height/29).isActive = true
        }else{
            label.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
        }
    }
    
    func labelAutoLayout(label:UILabel,topItem:Any,view:UIView){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 24).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
    }
    
    func topLabel(label:UILabel,topItem:Any,view:UIView){
        let height = view.frame.size.height
        label.translatesAutoresizingMaskIntoConstraints = false
        if height <= 700 {
            label.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 48).isActive = true
        }else{
            label.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 88).isActive = true
        }
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
    }
    
    func fromLabel(label:UILabel,topItem:Any,leftItem:Any,view:UIView){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 13).isActive = true
        label.leftAnchor.constraint(equalTo: (leftItem as AnyObject).rightAnchor, constant: 7).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
    }
    
    func collectionUserNameLabel(label:UILabel,view:UIView,imageView:UIImageView){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.adjustsFontSizeToFitWidth = true
    }
    
    func topCellLabel(label:UILabel,topItem:Any,leftItem:UIImageView){
    label.translatesAutoresizingMaskIntoConstraints = false
    label.topAnchor.constraint(equalTo: (topItem as AnyObject).topAnchor, constant: 16).isActive = true
    label.leftAnchor.constraint(equalTo: leftItem.rightAnchor, constant: 24).isActive = true
    }
    
    func cellLabel(label:UILabel,topItem:Any,leftItem:UIImageView){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 8).isActive = true
        label.leftAnchor.constraint(equalTo: leftItem.rightAnchor, constant: 24).isActive = true
    }
    
    func profileLabel(label:UILabel,topItem:Any,view:UIView){
        if view.frame.size.height <= 700 {
            label.font = UIFont.boldSystemFont(ofSize: 14)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 4).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.frame.size.width - 66).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
        label.setLabelUnderLine(view: view)
    }
    
    func startTimeLabel(label:UILabel,topItem:UILabel,view:UIView){
        if view.frame.size.height <= 700 {
            label.font = UIFont.boldSystemFont(ofSize: 14)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topItem.bottomAnchor, constant: 4).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.frame.size.width/6).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
        label.setShortUnderLine(view: view)
    }
    
    func finishTimeLabel(label:UILabel,topItem:Any,leftItem:UILabel,view:UIView){
        if view.frame.size.height <= 700 {
            label.font = UIFont.boldSystemFont(ofSize: 14)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 4).isActive = true
        label.leftAnchor.constraint(equalTo: leftItem.rightAnchor, constant: 7).isActive = true
        label.widthAnchor.constraint(equalToConstant: 64).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
        label.setShortUnderLine(view: view)
    }
    
    func searchGenderLabel(label:UILabel,item:UIView,view:UIView){
        label.translatesAutoresizingMaskIntoConstraints = false
        if view.frame.size.height <= 700 {
            label.topAnchor.constraint(equalTo: item.topAnchor, constant: 204).isActive = true
        }else{
            label.topAnchor.constraint(equalTo: item.topAnchor, constant: 304).isActive = true
        }
        label.leftAnchor.constraint(equalTo: item.leftAnchor, constant: 33).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.frame.size.width/6).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.frame.size.height/37).isActive = true
    }
    
    func termsLabel (label:UILabel,item:UIView){
        let width = item.frame.size.width
        let height = item.frame.size.height
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: item.topAnchor, constant: -height/12).isActive = true
        label.widthAnchor.constraint(equalToConstant: width - 56).isActive = true
        label.heightAnchor.constraint(equalToConstant: height).isActive = true
        label.centerXAnchor.constraint(equalTo: item.centerXAnchor).isActive = true
    }
}



extension UIButton {
    func buttonLayout(button:UIButton,topItem:Any,view:UIView,hex:String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor(hex: hex).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 10
        button.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 44).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.size.width - 66).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.frame.size.height/16).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func inviteButtonLayout(button:UIButton,topItem:Any,view:UIView,hex:String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor(hex: hex).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 10
        button.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 32).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.size.width - 66).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.frame.size.height/16).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func searchButton(button:UIButton,item:UIView,view:UIView){
        button.setImage(UIImage(named: "search"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = UIColor(hex: "FFC727")
        button.tintColor = .black
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor(hex: "FFC727").cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: item.rightAnchor, constant: -view.frame.size.width/10).isActive = true
        button.bottomAnchor.constraint(equalTo: item.bottomAnchor, constant: -view.frame.size.height/8).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func settingButton(button:UIButton,view:UIView,topItem:Any){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 8).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        if view.frame.size.height <= 700{
            button.heightAnchor.constraint(equalToConstant: view.frame.size.height/12).isActive = true
        }else{
            button.heightAnchor.constraint(equalToConstant: view.frame.size.height/11).isActive = true
        }
    }
    
    func logInButton(button:UIButton,topItem:Any,view:UIView,hex:String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor(hex: hex).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 10
        button.topAnchor.constraint(equalTo: (topItem as AnyObject).bottomAnchor, constant: 40).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 56).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.size.width - 112).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.frame.size.height/16).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func checkButton(button:UIButton,Item:UIButton,view:UIView){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "797979").cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.centerYAnchor.constraint(equalTo: Item.centerYAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: Item.leftAnchor, constant: -4).isActive = true
    }
    
    func termsButton(button:UIButton,topItem:UILabel,rightItem:UIView,view:UIView){
    button.translatesAutoresizingMaskIntoConstraints = false
    button.topAnchor.constraint(equalTo: topItem.bottomAnchor, constant: (view.frame.size.height/16) + 64).isActive = true
    button.rightAnchor.constraint(equalTo: rightItem.rightAnchor, constant: -56).isActive = true
    }
}



extension UIImageView {
    
    func logInImageView(imageView:UIImageView,view:UIView){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size.width = view.frame.size.width/1.3
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width/1.3).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.size.height/3.5).isActive = true
    }
    
    func createImageView(imageView:UIImageView,topItem:Any,view:UIView){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: (topItem as AnyObject).topAnchor, constant: 40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width/3).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.size.width/3).isActive = true
        imageView.layer.cornerRadius = imageView.frame.size.width/2
    }
    
    func profileImageView(imageView:UIImageView,bottomItem:Any,view:UIView){
        let width = view.frame.size.width
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if view.frame.size.height <= 700 {
            imageView.frame.size.width = width/4
            imageView.widthAnchor.constraint(equalToConstant: width/4).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: width/4).isActive = true
            imageView.bottomAnchor.constraint(equalTo: (bottomItem as AnyObject).bottomAnchor, constant: imageView.frame.size.width/2).isActive = true
        }else{
            imageView.frame.size.width = width/3
            imageView.widthAnchor.constraint(equalToConstant: width/3).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: width/3).isActive = true
            imageView.bottomAnchor.constraint(equalTo: (bottomItem as AnyObject).bottomAnchor, constant: imageView.frame.size.width/2).isActive = true
        }
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.borderWidth = 4.0
        imageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func collectinoViewImage(imageView:UIImageView,view:UIView){
        let width = view.frame.size.width
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size.width = width/2.5
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: width/2.5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: width/2.5).isActive = true
    }
    
    func backImageView(imageView:UIImageView,view:UIView){
        let height = view.frame.size.height
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if height <= 700 {
            imageView.widthAnchor.constraint(equalToConstant: 800).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 800).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/4.8).isActive = true
        }else{
            imageView.widthAnchor.constraint(equalToConstant: 700).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 700).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height/3.8).isActive = true
        }
        imageView.layer.cornerRadius = imageView.frame.size.width/2
    }
    
    func cellImageView(imageView:UIImageView,view:UIView){
        let height = view.frame.size.height
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size.height = height - 16
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: height - 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height - 16).isActive = true
    }
    
    func searchImageView(imageView:UIImageView,view:UIView){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if view.frame.size.height <= 700{
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width/3).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: view.frame.size.height/6).isActive = true
        }else{
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 124).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: view.frame.size.height/5).isActive = true
        }
    }
    
    func settingImageView(imageView:UIImageView,view:UIView){
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88).isActive = true
    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.size.height/2.8).isActive = true
    }
}



extension UINavigationController{
    func navigationBar(navigationcontroller:UINavigationController){
        navigationcontroller.isNavigationBarHidden = false
        navigationcontroller.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationcontroller.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationcontroller.navigationBar.shadowImage = UIImage()
    }
}


class Layout{
    
    static func startAnimation(name:String,view:UIView){
        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.frame = view.bounds
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play{ finished in
            if finished{
                animationView.removeFromSuperview()
            }
        }
    }
    
    static func mailAlertNotification(){
        INNotifications.show(type: .warning, data: INNotificationData(title: "入力が正しくありません。", description: "入力内容を確認して下さい。", delay: 5, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .white, titleColor: .black, descriptionColor: .black, imageSize: CGSize(width: 30, height: 30)))
    }

    static func textAlertNotification(){
        INNotifications.show(type: .warning, data: INNotificationData(title: "入力されていない項目があります。", description: "入力内容を確認して下さい。", delay: 5, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .white, titleColor: .black, descriptionColor: .black, imageSize: CGSize(width: 30, height: 30)))
    }
    
    static func logInEmailNotification(){
        INNotifications.show(type: .warning, data: INNotificationData(title: "登録されていないアドレスです。", description: "入力内容を確認して下さい。", delay: 5, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .white, titleColor: .black, descriptionColor: .black, imageSize: CGSize(width: 30, height: 30)))
    }
    
    static func mailNotification(){
        INNotifications.show(type: .success, data: INNotificationData(title: "メールを送信しました。", description: "メール内のURLからログインできます。", image: UIImage(named:"mail"), delay: 5, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .white, titleColor: .black, descriptionColor: .black, imageSize: CGSize(width: 30, height: 30)))
    }
    
    static func matchNotification(name:String,id:String){
        INNotifications.show(type: .success, data: INNotificationData(title: "\(name)さんとマッチングしました", description: "一緒に勉強の計画を立ててみましょう！", image: UIImage(named:"matching"), delay: 5, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .white, titleColor: .black, descriptionColor: .black, imageSize: CGSize(width: 30, height: 30)))
    }
    
    static func termsNotification(){
        INNotifications.show(type: .warning, data: INNotificationData(title: "利用規約にチェックがついてません。", description: "利用規約を確認して下さい。", delay: 5, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .white, titleColor: .black, descriptionColor: .black, imageSize: CGSize(width: 30, height: 30)))
    }
    
    static func rekognitionNotification(){
        INNotifications.show(type: .warning, data: INNotificationData(title: "不適切な画像が使用されています", description: "画像を確認して下さい。", delay: 5, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .white, titleColor: .black, descriptionColor: .black, imageSize: CGSize(width: 30, height: 30)))
    }
    
    
    static func ChatColor(mySelf:Bool)->UIColor{
        if mySelf == true{
            
            let chatColor = UIColor(hex: "4F30CF")
            return chatColor
        }else{
            
            let chatColor = UIColor(hex: "#e7e7e7")
            return chatColor
        }
    }
}
