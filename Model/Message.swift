//
//  Message.swift
//  boostudy
//

import Foundation
import MessageKit

struct Message: MessageType{

    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var userImagePath:String
    var date:TimeInterval
    var messageImageString:String
}

struct ImageMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init (image:UIImage){
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
    init(imageURL:URL) {
        self.url = imageURL
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}

struct Sender:SenderType {
    var senderId: String
    var displayName: String
    
}

