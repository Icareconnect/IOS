//
//  User.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class User: Codable {
    var id: Int?
    var name: String?
    var phone: String?
    var country_code: String?
    var profile_image: String?
    var fcm_id: String?
    var email: String?
    var provider_type: ProviderType?
    var stripe_id: String?
    var stripe_account_id: String?
    var socket_id: String?
    var token: String?
    var categoryData: Category?
    var services: [Service]?
    var filters: [Filter]?
    var profile: ProfileUser?
    var account_verified: Bool?
    var totalRating: Double?
    var reviewCount: Int?
    var address: String?
    var qualification: String?
    var speciality: String?
    var call_price: String?
    var chat_price: String?
    var patientCount: Int?
    var master_preferences: [Preference]?
    var additionals: [AdditionalDetail]?

    var notification_enable: Bool?
    var premium_enable: Bool?
    var manual_available: Bool?
    var account_verified_at: String?
    var custom_fields: [CustomField]?

}

class ProfileUser: Codable {
    var id: Int?
    var dob: String?
//    var qualification: Any?
//    var city: Any?
//    var state: Any?
//    var country: Any?
    var experience: String?
    var speciality: String?
    var rating: Double?
    var about: String?
    var user_id: Int?
    var bio: String?
    var title: String?
    var working_since: String?
    
    var location_name: String?
    var lat: String?
    var long: String?
}
