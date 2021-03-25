//
//  APIConstants.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

//com.codebrew.ABTPvendor

enum CloneIds: String {
    case NURSE = "fc3eda974104a85c07d59108190ad6056"
}

enum Constants: String {
    case APPLE_APP_ID = "1551275485" //App store link
    case FIREBASE_PAGE_LINK = "royoconsult.page.link"
    case DEEP_URL_SCHEME = "com.team.iCare-Nurse"
    case ANDROID_PACKAGE_NAME = "com.intely.nurse"
    
    case PageLink = "icareconnect.page.link"
}

enum DynamicLinkPage: String {
    case Invite
}

enum ImageBasePath {
    case thumbs
    case upload
    case original
    
    var url: String {
        switch self {
        case .thumbs:
            return "https://consultants3assets.sfo2.digitaloceanspaces.com/thumbs/"
        case .upload:
            return "https://consultants3assets.sfo2.digitaloceanspaces.com/uploads/"
        case .original:
            return "https://consultants3assets.sfo2.digitaloceanspaces.com/original/"
        }
    }
}

enum PDFBasePath {
    case original
    
    var url: String {
        switch self {
        case .original:
            return "https://consultants3assets.sfo2.digitaloceanspaces.com/pdf/"
        }
    }
}
enum BasePath: String {
    case Developement = "https://royoconsult.com/"
    case socketBasePath = "https://node.royoconsult.com"
    case JitsiServerURL = "https://meet.royoapps.com/"
}

internal struct APIConstants {
    
    static let basepath = BasePath.Developement.rawValue
    static let UNIQUE_APP_ID = CloneIds.NURSE.rawValue

    static let login = "api/login"
    static let register = "api/register"
    static let profileUpdate = "api/profile-update"
    static let uploadImage = "api/upload-image"
    static let updatePhone = "api/update-phone"
    static let updateFCMId = "api/update-fcm-id"
    static let forgotPsw = "api/forgot_password"
    static let changePsw = "api/password-change"
    static let sendEmailOTP = "api/send-email-otp"
    static let verifyEmail = "api/email-verify"
    static let logout = "api/app_logout"
    static let sendOTP = "api/send-sms"
    static let categories = "api/categories"
    static let getFilters = "api/get-filters"
    static let services = "api/services"
    static let updateServices = "api/update-services"
    static let transactionHistory = "api/wallet-history-sp"
    static let wallet = "api/wallet-sp"
    static let requests = "api/requests"
    static let acceptRequest = "api/accept-request"
    static let cancelRequest = "api/cancel-request"
    static let notifications = "api/notifications"
    static let vendorDetail = "api/doctor-detail"
    static let getSlots = "api/get-slots"
    static let classes = "api/classes"
    static let updateClassStatus = "api/class/status"
    static let addClass = "api/add-class"
    static let revenue = "api/revenue"
    static let callStatus = "api/call-status"
    static let makeCall = "api/make-call"
    static let startRequest = "api/start-request"
    static let appVersion = "api/appversion"
    static let pages = "api/pages"
    static let addBank = "api/add-bank"
    static let banks = "api/bank-accounts"
    static let payouts = "api/payouts"
    static let addMoney = "api/add-money"
    static let addCard = "api/add-card"
    static let deleteCard = "api/delete-card"
    static let updateCard = "api/update-card"
    static let cards = "api/cards"
    static let clientDetail = "api/clientdetail"
    static let additionalDetails = "api/additional-details"
    static let additionalDetailData = "api/additional-detail-data"
    static let manualUpdateServices = "api/manual-update-services"
    static let feeds = "api/feeds"
    static let addFav = "api/feeds/add-favorite"
    static let viewFeed = "api/feeds/view"
    
    //Chat
    static let chatListing = "api/chat-listing"
    static let chatMessages = "api/chat-messages"
    static let endChat = "api/complete-chat"
    static let startChat = "api/start-chat"
    
    static let termsConditions = "terms-conditions"
    static let privacyPolicy = "privacy-policy"
    
    static let masterPreferences = "api/master/preferences"
    static let masterDuty = "api/master/duty"
    static let setManualAvailability = "api/manual-available"
    static let requestDetails = "api/request-detail"
}

enum SDK: String {
    case GoogleSignInKey = "952614479078-ibeh87gtthl05g6481aegn7mcn9i422q.apps.googleusercontent.com"
    case GooglePlaceKey = "AIzaSyCWRLStt_5Kmgd877p8o_fPM2W5pdZ4WbU"
}

