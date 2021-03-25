//
//  UserPreferences.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit


class IQView: UIView {
    
}


final class UserPreference {
    
    let DEFAULTS_KEY = "ROYO_CONSULTANT_APP_VENDOR"
    let SETTINGS_KEY = "ROYO_CONSULTANT_APP_SETTINGS_VENDOR"
    
    static let shared = UserPreference()
    
    private init() {
        
    }
    
    var data : User? {
        get{
            return fetchData(key: DEFAULTS_KEY)
        }
        set{
            if let value = newValue {
                saveData(value, key: DEFAULTS_KEY)
            } else {
                removeData(key: DEFAULTS_KEY)
            }
        }
    }
    
       var clientDetail : ClientDetail? {
        get{
            return fetchData(key: SETTINGS_KEY)
        }
        set{
            if let value = newValue {
                saveData(value, key: SETTINGS_KEY)
            } else {
                removeData(key: SETTINGS_KEY)
            }
        }
    }
    
    public var firebaseToken: String?
    
    public var pages: [Page]?

    public var appleData: GoogleAppleFBUserData?
    
    public func getCurrencyAbbr() -> String {
        let localeID = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : /UserPreference.shared.clientDetail?.currency])
        let locale = Locale.init(identifier: localeID)
        return /locale.currencySymbol
    }
    
    //MARK:- Generic function used anywhere directly copy it
    private func saveData<T: Codable>(_ value: T, key: String) {
        
        guard let data = JSONHelper<T>().getData(model: value) else {
            removeData(key: key)
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private func fetchData<T: Codable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        return JSONHelper<T>().getCodableModel(data: data)
    }
    
    private func removeData(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
