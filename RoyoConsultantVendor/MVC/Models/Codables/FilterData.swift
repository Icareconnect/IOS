//
//  FilterData.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 28/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class FilterData: Codable {
    var filters: [Filter]?
}

class Filter: Codable {
    var id: Int?
    var category_id: Int?
    var filter_name: String?
    var preference_name: String?
    var is_multi: CustomBool?
    var options: [FilterOption]?
}

class FilterOption: Codable {
    var id: Int?
    var option_name: String?
    var filter_type_id: Int?
    var isSelected: Bool?
    var image: String?
}

