//
//  CommonModel.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class CommonModel<T: Codable>: Codable {
    var status: String?
    var statuscode: Int?
    var message: String?
    var data: T?
}
