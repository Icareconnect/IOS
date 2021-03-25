//
//  LocationManager.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 13/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

class Address {
    var latitude: Double?
    var longitude: Double?
    var name: String?
    
    init(_ _latitude: Double?, _ _longitude: Double?, _ _name: String?) {
        latitude = _latitude
        longitude = _longitude
        if _name == nil {
            CLGeocoder().reverseGeocodeLocation(CLLocation.init(latitude: /_latitude, longitude: /_longitude), preferredLocale: nil) { (clPlacemark: [CLPlacemark]?, error: Error?) in
                guard let place = clPlacemark?.first else {
                    print("No placemark from Apple: \(String(describing: error))")
                    return
                }

                let postalAddressFormatter = CNPostalAddressFormatter()
                postalAddressFormatter.style = .mailingAddress
                var addressString: String?
                if let postalAddress = place.postalAddress {
                    addressString = postalAddressFormatter.string(from: postalAddress)
                }
                self.name = addressString
            }
        } else {
            name = _name
        }
    }
}

struct LocationManagerData {
    var latitude: Double = 0
    var longitude: Double = 0
    var isLocationAllowed: Bool = false
    
    var locationName: String?
    var address: String?
}

typealias DidChangeLocation = ((_ location: LocationManagerData) -> ())
typealias LocationAuthChanged = ((_ isLocationAllowed: Bool) -> ())

enum LocationStrings: String {
    case LOC_PERMISSION_DENIED_TITLE
    case LOC_PERMISSION_DENIED_MESSAGE
    
    var localized: String {
        switch self {
        case .LOC_PERMISSION_DENIED_MESSAGE:
            return VCLiteral.LOC_PERMISSION_DENIED_MESSAGE.localized
        case .LOC_PERMISSION_DENIED_TITLE:
            return VCLiteral.LOC_PERMISSION_DENIED_TITLE.localized
        }
    }
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let lmInstance = CLLocationManager()
    var locationData = LocationManagerData() {
        didSet {
            address = Address(locationData.latitude, locationData.longitude, nil)
        }
    }
    var address: Address?
    public var changeLocationBlock: DidChangeLocation?
    private var locationAuthChanged: LocationAuthChanged?
    
    func isLocationEnabled(auth: LocationAuthChanged?) {
        locationAuthChanged = auth
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                locationAuthChanged?(false)
            case .authorizedAlways, .authorizedWhenInUse:
                locationAuthChanged?(true)
            @unknown default:
                break
            }
        } else {
            locationAuthChanged?(false)
        }
    }
    
    func startTrackingUser(didChangeLocation: DidChangeLocation? = nil) {
        lmInstance.delegate = self
        lmInstance.desiredAccuracy = kCLLocationAccuracyBest
        lmInstance.requestAlwaysAuthorization()
        lmInstance.requestWhenInUseAuthorization()
        lmInstance.startUpdatingLocation()
        //Background Features
        lmInstance.allowsBackgroundLocationUpdates = true
        lmInstance.startMonitoringSignificantLocationChanges()
        changeLocationBlock = didChangeLocation
    }
    
    func showSettingAlert() {
        UIApplication.topVC()?.alertBoxOKCancel(title: LocationStrings.LOC_PERMISSION_DENIED_TITLE.localized, message: LocationStrings.LOC_PERMISSION_DENIED_MESSAGE.localized, tapped: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }, cancelTapped: {
            self.locationAuthChanged?(false)
        })
    }
    
}

//MARK:- CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            lmInstance.startUpdatingLocation()
            locationData.isLocationAllowed = true
            locationAuthChanged?(true)
        case .denied, .restricted:
            showSettingAlert()
            locationData.isLocationAllowed = false
            locationAuthChanged?(false)
        case .notDetermined:
            lmInstance.startUpdatingLocation()
            lmInstance.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationData.isLocationAllowed = true
        let latLng = locations.last?.coordinate
        locationData = LocationManagerData(latitude: /latLng?.latitude, longitude: /latLng?.longitude, isLocationAllowed: true)
        changeLocationBlock?(locationData)
    }
}
