//
//  PagesData.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 08/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class PagesData: Codable {
    var pages: [Page]?
}

class Page: Codable {
    var slug: String?
    var title: String?
}
