//
//  BanksData.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 13/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class BanksData: Codable {
    var bank_accounts: [Bank]?
}

class Bank: Codable {
    var id: Int?
    var name: String?
    var bank_name: String?
    var account_number: String?
    var last_four_digit: String?
    var ifc_code: String?
    var account_holder_type: String
    var country: String?
    var currency: String?
    var created_at: String?
    var institution_number: String?
    var address: String?
    var city: String?
    var province: String?
    var postal_code: String?
    var customer_type: String?
    
}
