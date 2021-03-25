//
//  Services.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 30/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class ServicesData: Codable {
    var services: [Service]?
    var after: String?
    var before: String?
    var per_page: Int?
}

class Service: Codable {
    var id: Int
    var category_id: Int?
    var service_id: Int?
    var available: CustomBool?
    var price_minimum: Double?
    var price_maximum: Double?
    var minimum_duration: Double?
    var gap_duration: Double?
    var name: String?
    var color_code: String?
    var description: String?
    var need_availability: CustomBool?
    var price_fixed: Double?
    var price_type: PriceType?
    var minimmum_heads_up: String?
    var price: Double?
    var category_service_id: Int?
    var unit_price: Double?
    
}
