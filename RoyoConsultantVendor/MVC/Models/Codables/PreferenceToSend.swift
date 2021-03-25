//
//  FilterToSend.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 01/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class PreferenceToSend: Codable {
    var preference_id: Int?
    var preference_option_ids: [Int]?
    
    init(_ id: Int?, _ optionIds: [Int]?) {
        preference_id = id
        preference_option_ids = optionIds
    }
}
