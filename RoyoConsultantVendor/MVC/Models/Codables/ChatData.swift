//
//  ChatData.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 02/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ChatData: Codable {
    var lists: [ChatThread]?
    var after: String?
    var before: String?
    var per_page: Int?
}

class ChatThread: Codable {
    var id: Int?
    var from_user: User?
    var to_user: User?
    var booking_date: String?
    var created_at: String?
    var unReadCount: Int?
    var time: String?
    var service_type: String?
    var last_message: Message?
    var duration: Double?
    var status: RequestStatus?
    
    init(_ _id: Int?, _ _from_user: User?, _ _status: RequestStatus, _ _to_user: User?) {
        id = _id
        from_user = _from_user
        status = _status
        to_user = _to_user
    }
}

class Message: Codable {
    var id: Int?
    var message: String?
    var user_id: Int?
    var created_at: String?
    var messageType: MessageType?
    var isDelivered: CustomBool?
    var isRead: CustomBool?
    var imageUrl: String?
    var status: MessageStatus?
    var sentAt: Double?
    var receiverId: Int?
    var senderId: Int?
    var messageId: Int?
    var user: User?
    
    var request_id: Int?
    var senderName: String?
    
    init(_ _imageUrl: String?, _ _message: String?, _ _messageType: MessageType, _ _thread: ChatThread?) {
        senderId = UserPreference.shared.data?.id
        imageUrl = _imageUrl
        message = _message
        receiverId = _thread?.from_user?.id
        messageType = _messageType
        request_id = _thread?.id
        senderName = _thread?.from_user?.name
        sentAt = Date().timeIntervalSince1970 * 1000
        user = UserPreference.shared.data
    }
    
    init(socketResponse: [String : Any]) {
        messageId = Int(String.init(describing: socketResponse["messageId"] ?? ""))
        senderId = Int(String.init(describing: socketResponse["senderId"] ?? ""))
        sentAt = socketResponse["sentAt"] as? Double
        message = socketResponse["message"] as? String
        imageUrl = socketResponse["imageUrl"] as? String
        receiverId = Int(String.init(describing: socketResponse["receiverId"] ?? ""))
        senderName = socketResponse["senderName"] as? String
        messageType = MessageType(rawValue: /(socketResponse["messageType"] as? String))
        request_id = Int(String.init(describing: socketResponse["request_id"] ?? ""))
    }
}

class MessagesData: Codable {
    var messages: [Message]?
    var after: String?
    var before: String?
    var per_page: Int?
    var request_status: RequestStatus?
    var currentTimer: Int?
}

enum MessageType: String, Codable, CaseIterableDefaultsLast {
    case IMAGE
    case TEXT
    
    func getRelatedCellId(userID: Int) -> String {
        switch self {
        case .IMAGE:
            return /UserPreference.shared.data?.id ==  /userID ? SenderImgCell.identfier : RecieverImgCell.identfier
        case .TEXT:
            return /UserPreference.shared.data?.id ==  /userID ? SenderTxtCell.identfier : RecieverTxtCell.identfier
        }
    }
}

enum MessageStatus: String, Codable, CaseIterableDefaultsLast {
    case DELIVERED
    case SENT
    case SEEN
    case NOT_SENT
    
    var statusImage: UIImage? {
        switch self {
        case .NOT_SENT:
            return #imageLiteral(resourceName: "ic_info")
        case .SENT:
            return #imageLiteral(resourceName: "ic_tick")
        case .DELIVERED:
            return #imageLiteral(resourceName: "ic_double_tick")
        case .SEEN:
            return #imageLiteral(resourceName: "ic_double_tick")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .NOT_SENT:
            return ColorAsset.txtWhite.color
        case .SENT:
            return ColorAsset.txtWhite.color
        case .DELIVERED:
            return ColorAsset.txtWhite.color
        case .SEEN:
            return UIColor.green
        }
    }
}
