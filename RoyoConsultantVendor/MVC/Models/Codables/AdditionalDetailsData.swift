//
//  AdditionalDetailsData.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 11/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class AdditionalDetailsData: Codable {
    var additional_details: [AdditionalDetail]?
}

class AdditionalDetail: Codable {
    var id: Int?
    var name: String?
    var category_id: Int?
    var type: String?
    var documents: [Doc]?
}

class Doc: Codable {
    var description: String?
    var file_name: String?
    var title: String?
    var status: DocStatus?
    var type: String?
    
    init(_ _title: String?, _ _desc: String?, _ _fileName: String?, _ _status: DocStatus?, _ _type: String?) {
        title = _title
        description = _desc
        file_name = _fileName
        status = _status
        type = _type
    }
}
