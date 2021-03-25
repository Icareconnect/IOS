//
//  LoginEP.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation
import Moya

enum EP_Login {
    case login(provider_type: ProviderType, provider_id: String?, provider_verification: String?, user_type: UserType, country_code: String?)
    case sendEmailOTP(email: String?)
    case verifyEmailOTP(email: String?, otp: String?)
    case sendOTP(phone: String?, countryCode: String?)
    case profileUpdate(name: String?, email: String?, phone: String?, country_code: String?, dob: String?, bio: String?, speciality: String?, call_price: String?, chat_price: String?, category_id: String?, experience: String?, profile_image: String?, workingSince: String?, namePrefix: String?, custom_fields: String?, master_preferences: Any?, address: String?, lat: String?, long: String?)
    case register(name: String?, email: String?, password: String?, phone: String?, code: String?, user_type: UserType, fcm_id: String?, country_code: String?, dob: String?, bio: String?, profile_image: String?, workingSince: String?, provider_type: ProviderType)
    case forgotPsw(email: String?)
    case updatePhone(phone: String?, countryCode: String?, otp: String?)
    case manualUpdateServices(categoryId: String?)
    case getFilters(categoryId: String?)
    case getMasterPreferences(type: String?, preference_type: String?)
    case getMasterDuty(filter_ids: String?)
    case setManualAvailability(manual_available: Bool?, premium_enable: Bool?, notification_enable: Bool?)
    case updatePassword(current_password: String?, new_password: String?)

}

extension EP_Login: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        return URL(string: APIConstants.basepath)!
    }
    
    var path: String {
        switch self {
        case .login:
            return APIConstants.login
        case .sendOTP:
            return APIConstants.sendOTP
        case .profileUpdate:
            return APIConstants.profileUpdate
        case .register:
            return APIConstants.register
        case .forgotPsw:
            return APIConstants.forgotPsw
        case .updatePhone:
            return APIConstants.updatePhone
        case .manualUpdateServices:
            return APIConstants.manualUpdateServices
        case .getFilters:
            return APIConstants.getFilters
        case .getMasterPreferences:
            return APIConstants.masterPreferences
        case .getMasterDuty:
            return APIConstants.masterDuty
        case .setManualAvailability:
            return APIConstants.setManualAvailability
        case .updatePassword:
            return APIConstants.changePsw
        case .sendEmailOTP:
            return APIConstants.sendEmailOTP
        case .verifyEmailOTP:
            return APIConstants.verifyEmail
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFilters, .getMasterPreferences, .getMasterDuty:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        default:
            return Task.requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .profileUpdate, .updatePhone, .manualUpdateServices, .setManualAvailability, .updatePassword:
            return ["Accept" : "application/json",
                    "Authorization":"Bearer " + /UserPreference.shared.data?.token,
                    "devicetype": "IOS",
                    "app-id": APIConstants.UNIQUE_APP_ID,
                    "user-type": UserType.service_provider.rawValue]
        default:
            return ["devicetype": "IOS",
                    "Accept" : "application/json",
                    "app-id": APIConstants.UNIQUE_APP_ID,
                    "user-type": UserType.service_provider.rawValue]
        }
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    //Custom Varaibles
    var parameters: [String: Any]? {
        let locationName: String? = nil
        let latitude: String? = nil
        let longitude: String? = nil
        //    let deviceToken = /UserPreference.shared.firebaseToken
        
        switch self {
        case .login(let provider_type, let provider_id, let provider_verification, let user_type, let country_code):
            return Parameters.login.map(values: [provider_type.rawValue, provider_id, provider_verification, user_type.rawValue, country_code])
        case .sendOTP(let phone, let countryCode):
            return Parameters.sendOTP.map(values: [phone, countryCode])
        case .profileUpdate(let name, let email, let phone, let country_code, let dob, let bio, let speciality, let call_price, let chat_price, let category_id, let experience, let profile_image, let workingSince, let namePrefix, let custom_fields, let master_preferences, let address, let lat, let long):
            return Parameters.profileUpdate.map(values: [name, email, phone, country_code, dob, bio, speciality, call_price, chat_price, category_id, experience, profile_image, workingSince, namePrefix, latitude, longitude, locationName, custom_fields, master_preferences, address, lat, long, UserType.service_provider.rawValue])
        case .register(let name, let email, let password, let phone, let code, let user_type, let fcm_id, let country_code, let dob, let bio, let profile_image, let worlkingSince, let provider_type):
            return Parameters.register.map(values: [name, email, password, phone, code, user_type.rawValue, fcm_id, country_code, dob, bio, profile_image, worlkingSince, provider_type.rawValue])
        case .forgotPsw(let email):
            return Parameters.forgotPsw.map(values: [email])
        case .updatePhone(let phone, let countryCode, let otp):
            return Parameters.updatePhone.map(values: [phone, countryCode, otp])
        case .manualUpdateServices(let categoryId):
            return Parameters.manualUpdateServices.map(values: [categoryId])
        case .getFilters(let categoryId):
            return Parameters.getFilters.map(values: [categoryId])
        case .getMasterPreferences(type: let type, preference_type: let preference_type):
            return Parameters.masterPreference.map(values: [type, preference_type])
        case .getMasterDuty(filter_ids: let filter_ids):
            return Parameters.masterDuty.map(values: [filter_ids])
        case .setManualAvailability(manual_available: let manual_available, let premium_enable, let  notification_enable):
            return Parameters.setManualAvailability.map(values: [manual_available, premium_enable, notification_enable])
            
        case .updatePassword(let password, let newPassword):
            return Parameters.updatePassword.map(values: [password, newPassword])
        case .sendEmailOTP(email: let email):
            return Parameters.sendEmailOtp.map(values: [email])
        case .verifyEmailOTP(email: let email, otp: let otp):
            return Parameters.verifyEmail.map(values: [email, otp])
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getFilters, .getMasterPreferences, .getMasterDuty:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}
