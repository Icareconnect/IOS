//
//  FilterToSend.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 01/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class FilterToSend: Codable {
    var filter_id: Int?
    var filter_option_ids: [Int]?
    
    init(_ id: Int?, _ optionIds: [Int]?) {
        filter_id = id
        filter_option_ids = optionIds
    }
}
