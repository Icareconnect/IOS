//
//  EP_Home.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation
import Moya

enum EP_Home {
    case categories(parentId: String?, after: String?)
    case uploadImage(image: UIImage, type: MediaTypeUpload, doc: Document?)
    case getFilters(categoryId: String?, userId: String?)
    case services(categoryId: String?)
    case updateServices(categoryId: String?, filters: Any?, category_services_type: Any?)
    case transactionHistory(transactionType: TransactionType, after: String?)
    case wallet
    case requests(date: String?, serviceType: ServiceType, after: String?)
    case acceptRequest(requestId: String?)
    case startChat(requestId: String?)
    case cancelRequest(requestId: String?)
    case notifications(after: String?)
    case logout
    case chatListing(after: String?)
    case chatMessages(requestId: String?, after: String?)
    case endChat(requestId: String?)
    case vendorDetail(vendorId: String?)
    case getSlots(vendor_id: String?, date: String?, service_id: String?, category_id: String?)
    case classes(type: ClassType, categoryId: String?, after: String?)
    case updateClassStatus(classId: String?, status: ClassStatus)
    case addClass(categoryId: String?, price: String?, date: String?, time: String?, name: String?)
    case updateFCMId
    case revenue
    case makeCall(requestID: String?)
    case callStatus(requestID: String?, status: CallStatus)
    case startRequest(requestId: String?)
    case appversion(app: AppType, version: String?)
    case pages
    case addBank(country: String?, currency: String?, account_holder_name: String?, account_holder_type: String?, ifc_code: String?, account_number: String?, bank_name: String?, bank_id: String?, institution_number: String?, address: String?, city: String?, province: String?, postal_code: String?, customer_type: String?)
    case banks
    case payouts(bankId: String?, amount: String?)
    case addCard(cardNumber: String?, expMonth: String?, expYear: String?, cvv: String?)
    case addMoney(balance: String?, cardId: String?)
    case deleteCard(cardId: String?)
    case updateCard(cardId: String?, name: String?, expMonth: String?, expYear: String?)
    case cards
    case getClientDetail(app: AppType)
    case getAdditionalDetails(id: Int?)
    case addAdditionalDetails(fields: Any?)
    case addFeed(title: String?, desc: String?, type: FeedType?, image: String?)
    case getFeeds(feedType: FeedType?, consultant_id: Int?, after: String?, favourite: CustomBool?)
    case addFav(feedId: Int?, favorite: CustomBool)
    case viewFeed(id: Int?)
    case requestDetail (request_id: String?)
}

extension EP_Home: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL.init(string: APIConstants.basepath)!
    }
    
    var path: String {
        switch self {
        case .uploadImage:
            return APIConstants.uploadImage
        case .categories:
            return APIConstants.categories
        case .getFilters:
            return APIConstants.getFilters
        case .services:
            return APIConstants.services
        case .updateServices:
            return APIConstants.updateServices
        case .transactionHistory:
            return APIConstants.transactionHistory
        case .wallet:
            return APIConstants.wallet
        case .requests:
            return APIConstants.requests
        case .acceptRequest:
            return APIConstants.acceptRequest
        case .startChat:
            return APIConstants.startChat
        case .logout:
            return APIConstants.logout
        case .cancelRequest:
            return APIConstants.cancelRequest
        case .notifications:
            return APIConstants.notifications
        case .chatListing:
            return APIConstants.chatListing
        case .chatMessages:
            return APIConstants.chatMessages
        case .endChat:
            return APIConstants.endChat
        case .vendorDetail:
            return APIConstants.vendorDetail
        case .getSlots:
            return APIConstants.getSlots
        case .classes:
            return APIConstants.classes
        case .updateClassStatus:
            return APIConstants.updateClassStatus
        case .addClass:
            return APIConstants.addClass
        case .updateFCMId:
            return APIConstants.updateFCMId
        case .revenue:
            return APIConstants.revenue
        case .makeCall:
            return APIConstants.makeCall
        case .callStatus:
            return APIConstants.callStatus
        case .startRequest:
            return APIConstants.startRequest
        case .appversion:
            return APIConstants.appVersion
        case .pages:
            return APIConstants.pages
        case .addBank:
            return APIConstants.addBank
        case .banks:
            return APIConstants.banks
        case .payouts:
            return APIConstants.payouts
        case .addCard:
            return APIConstants.addCard
        case .addMoney:
            return APIConstants.addMoney
        case .deleteCard:
            return APIConstants.deleteCard
        case .updateCard:
            return APIConstants.updateCard
        case .cards:
            return APIConstants.cards
        case .getClientDetail:
            return APIConstants.clientDetail
        case .getAdditionalDetails:
            return APIConstants.additionalDetails
        case .addAdditionalDetails:
            return APIConstants.additionalDetailData
        case .addFeed(_, _, _, _),
             .getFeeds(_, _, _, _):
            return APIConstants.feeds
        case .addFav(let id, _):
            return "\(APIConstants.addFav)/\(/id)"
        case .viewFeed(let id):
            return "\(APIConstants.viewFeed)/\(/id)"
        case .requestDetail:
            return APIConstants.requestDetails
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categories,
             .getFilters,
             .services,
             .transactionHistory,
             .wallet,
             .requests,
             .notifications,
             .chatListing,
             .chatMessages,
             .vendorDetail,
             .getSlots,
             .classes,
             .revenue,
             .pages,
             .banks,
             .cards,
             .getClientDetail,
             .getAdditionalDetails,
             .getFeeds(_, _, _, _),
             .viewFeed,
             .requestDetail:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .categories(let parentId, let after):
            return Parameters.categories.map(values: [parentId, after])
        case .getFilters(let categoryId, let userId):
            return Parameters.getFilters.map(values: [categoryId, userId])
        case .services(let categoryId):
            return Parameters.services.map(values: [categoryId])
        case .updateServices(let categoryId, let filters, let category_services_type):
            return Parameters.updateServices.map(values: [categoryId, filters, category_services_type])
        case .transactionHistory(let transactionType, let after):
            return Parameters.transactionHistory.map(values: [transactionType.rawValue, after])
        case .requests(let date, let serviceType, let after):
            return Parameters.requests.map(values: [date, serviceType.rawValue, after])
        case .acceptRequest(let requestId):
            return Parameters.acceptRequest.map(values: [requestId])
        case .startChat(let requestId):
            return Parameters.startChat.map(values: [requestId])
        case .cancelRequest(let requestId):
            return Parameters.acceptRequest.map(values: [requestId])
        case .notifications(let after):
            return Parameters.notifications.map(values: [after])
        case .chatListing(let after):
            return Parameters.chatListing.map(values: [after])
        case .chatMessages(let requestId, let after):
            return Parameters.chatMessages.map(values: [requestId, after])
        case .endChat(let requestId):
            return Parameters.endChat.map(values: [requestId])
        case .vendorDetail(let vendorID):
            return Parameters.vendorDetail.map(values: [vendorID])
        case .getSlots(let vendor_id, let date, let service_id, let category_id):
            return Parameters.getSlots.map(values: [vendor_id, date, service_id, category_id])
        case .classes(let type, let categoryId, let after):
            return Parameters.classes.map(values: [type.rawValue, categoryId, after])
        case .updateClassStatus(let classId, let status):
            return Parameters.updateClassStatus.map(values: [classId, status.rawValue])
        case .addClass(let categoryId, let price, let date, let time, let name):
            return Parameters.addClass.map(values: [categoryId, price, date, time, name])
        case .updateFCMId:
            return Parameters.updateFCMId.map(values: [UserPreference.shared.firebaseToken])
        case .makeCall(let requestID):
            return Parameters.makeCall.map(values: [requestID])
        case .callStatus(let requestID, let status):
            return Parameters.callStatus.map(values: [requestID, status.rawValue])
        case .startRequest(let requestId):
            return Parameters.startRequest.map(values: [requestId])
        case .appversion(let app, let version):
            return Parameters.appversion.map(values: [app.rawValue, version, "1"]) //1-IOS
        case .addBank(let country, let currency, let account_holder_name, let account_holder_type, let ifc_code, let account_number, let bank_name, let bank_id, let instNumber, let address, let city, let province, let postal_code, let customer_type):
            return Parameters.addBank.map(values: [country, currency, account_holder_name, account_holder_type, ifc_code, account_number, bank_name, bank_id, instNumber, address, city, province, postal_code, customer_type])
        case .payouts(let bankId, let amount):
            return Parameters.payouts.map(values: [bankId, amount])
        case .addCard(let cardNumber, let expMonth, let expYear, let cvv):
            return Parameters.addCard.map(values: [cardNumber, expMonth, expYear, cvv])
        case .addMoney(let balance, let cardId):
            return Parameters.addMoney.map(values: [balance, cardId])
        case .deleteCard(let cardId):
            return Parameters.deleteCard.map(values: [cardId])
        case .updateCard(let cardId, let name, let expMonth, let expYear):
            return Parameters.updateCard.map(values: [cardId, name, expMonth, expYear])
        case .getClientDetail(let app):
            return Parameters.clientDetail.map(values: [app.rawValue])
        case .getAdditionalDetails(let id):
            return Parameters.services.map(values: [id])
        case .addAdditionalDetails(let fields):
            return Parameters.addAdditionalDetails.map(values: [fields])
        case .addFeed(let title, let desc, let type, let image):
            return Parameters.addFeed.map(values: [title, desc, type?.rawValue, image])
        case .getFeeds(let feedType, let consultant_id, let after, let favourite):
            return Parameters.getFeeds.map(values: [feedType?.rawValue, consultant_id, after, favourite?.rawValue])
        case .addFav(_, let favorite):
            return Parameters.addFav.map(values: [/Int(favorite.rawValue)])
        case .requestDetail(let request_id):
            return Parameters.requestDetails.map(values: [request_id])
        case .uploadImage(_, let type, _):
            return Parameters.uploadMedia.map(values: [type.rawValue])
            
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .uploadImage:
            return Task.uploadMultipart(multipartBody ?? [])
        default:
            return Task.requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appversion:
            return ["Accept" : "application/json",
                    "devicetype": "IOS",
                    "app-id": APIConstants.UNIQUE_APP_ID,
                    "user-type": UserType.service_provider.rawValue]
        default:
            return ["Accept" : "application/json",
                    "Authorization":"Bearer " + /UserPreference.shared.data?.token,
                    "devicetype": "IOS",
                    "app-id": APIConstants.UNIQUE_APP_ID,
                    "user-type": UserType.service_provider.rawValue]
        }
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .categories,
             .getFilters,
             .services,
             .transactionHistory,
             .wallet,
             .requests,
             .notifications,
             .chatListing,
             .chatMessages,
             .vendorDetail,
             .getSlots,
             .classes,
             .revenue,
             .pages,
             .banks,
             .cards,
             .getClientDetail,
             .getAdditionalDetails,
             .getFeeds(_, _, _, _),
             .viewFeed,
             .requestDetail:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        var multiPartData = [MultipartFormData]()

        switch self {
        case .uploadImage(let image, let mediaType, let doc):

            switch mediaType {
            case .image:
                let data = image.jpegData(compressionQuality: 0.5) ?? Data()
                multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: "image.jpg", mimeType: "image/jpeg"))
            case .pdf:
                let data = doc?.data ?? Data()
                multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: /doc?.fileName, mimeType: "application/pdf"))
            }
        default:
            break
            
        }
        
        parameters?.forEach({ (key, value) in
            let tempValue = /(value as? String)
            let data = tempValue.data(using: String.Encoding.utf8) ?? Data()
            multiPartData.append(MultipartFormData.init(provider: .data(data), name: key))
        })
        return multiPartData
    }
    
}
