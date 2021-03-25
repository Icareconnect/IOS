//
//  preference.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 04/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class PreferenceData: Codable {
    var preferences: [Preference]?
}

class Preference: Codable {
    var id: Int?
    var preference_type: String?
    var preference_name: String?
    var is_multi: CustomBool?
    var options: [PreferenceOption]?
    var is_required: Int?

    var isSelectedAll: Bool?

    class func generateNewReferenceArray(preferences: [Preference]) -> [Preference] {
        var items = [Preference]()
        preferences.forEach { items.append(Preference.init(obj: $0)) }
        return items
    }
    
    init(obj: Preference?) {
        id = obj?.id
        preference_name = obj?.preference_name
        preference_type = obj?.preference_type
        is_multi = obj?.is_multi
        var newOptions = [PreferenceOption]()
        obj?.options?.forEach { newOptions.append(PreferenceOption.init(obj: $0)) }
        options = newOptions
    }
}

class PreferenceOption: Codable {
    var id: Int?
    var option_name: String?
    var preference_id: Int?
    var isSelected: Bool?
    
    init(obj: PreferenceOption?) {
        id = obj?.id
        option_name = obj?.option_name
        preference_id = obj?.preference_id
        isSelected = obj?.isSelected
    }
}
