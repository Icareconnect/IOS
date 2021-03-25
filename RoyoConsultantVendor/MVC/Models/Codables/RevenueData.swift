//
//  RevenueData.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 19/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class RevenueData: Codable {
    var totalRequest: Int?
    var totalChat: Int?
    var totalCall: Int?
    var completedRequest: Int?
    var unSuccesfullRequest: Int?
    var totalRevenue: Double?
    var monthlyRevenue: [RevenueMonth]?
    var services: [RevenueService]?
    
    var totalShiftCompleted : Int?
    var totalShiftDecline: Int?
    var totalHourCompleted: Int?

}

class RevenueMonth: Codable {
    var revenue: Double?
    var monthNumber: String?
    var monthName: String?
    
    init(_ _revenue: Double?, _ _monthName: String?) {
        revenue = _revenue
        monthName = _monthName
    }
}


class RevenueService: Codable {
    var service_name: String?
    var service_id: Int?
    var count: Int?
    var color_code: String?
}

