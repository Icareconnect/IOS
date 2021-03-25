//
//  TrackingVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 10/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import GoogleMaps

class TrackingVC: BaseVC {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnCancel: SKLottieButton!
    @IBOutlet weak var btnStart: SKLottieButton!
    @IBOutlet weak var btnReached: SKLottieButton!
    @IBOutlet weak var statusView: UIView! {
        didSet {
            statusView.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 24)
        }
    }
    
    public var request: Requests?
    public var didStatusChanged: ((_ status: RequestStatus) -> Void)?
    
    var polyPath : GMSMutablePath?
    var polyline : GMSPolyline?
    var demoPolyline = GMSPolyline()

    var timer: Timer!
    var i: UInt = 0
    var animationPath = GMSMutablePath()
    var animationPolyline = GMSPolyline()
    
    private lazy var startLocationMarker = GMSMarker()
    private lazy var currentLocationMarker = GMSMarker()
    private lazy var destinationLocationMarker  = GMSMarker()

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        initialSetup()
        
        LocationManager.shared.startTrackingUser()
        let loc = LocationManager.shared.locationData
        
        LocationManager.shared.changeLocationBlock = {[weak self] (loc) in
            self?.updateLocation(loc)
        }
        
        fetchRoute(from: CLLocationCoordinate2D.init(latitude: loc.latitude, longitude: loc.longitude), to: CLLocationCoordinate2D.init(latitude: /Double(/request?.extra_detail?.lat), longitude: /Double(/request?.extra_detail?.long)))

    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            dismissVC()
        case 1: //Call
            
            guard let number = URL(string: "tel://" + /request?.extra_detail?.country_code + "\(/request?.extra_detail?.phone_number)") else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        case 2: //Cancel Service
            btnCancel.playAnimation()
            EP_Home.callStatus(requestID: String(/request?.id), status: .cancel_service).request { [weak self] (response) in
                self?.btnCancel.stop()
                self?.request?.status = .cancel_service
                self?.didStatusChanged?(.cancel_service)
                self?.dismissVC()
            } error: { [weak self] (_) in
                self?.btnCancel.stop()
            }
        case 3: //Start Service
            btnStart.playAnimation()
            EP_Home.callStatus(requestID: String(/request?.id), status: .start_service).request { [weak self] (response) in
                self?.btnStart.stop()
                self?.request?.status = .start_service
                self?.didStatusChanged?(.start_service)
                self?.initialSetup()
                self?.dismissVC()
            } error: { [weak self] (_) in
                self?.btnStart.stop()
            }
        case 4: //Reached Destination
            
            let coordinate₀ = CLLocation(latitude: LocationManager.shared.locationData.latitude, longitude: LocationManager.shared.locationData.longitude)
            let coordinate₁ = CLLocation(latitude: /Double(/request?.extra_detail?.lat), longitude: /Double(/request?.extra_detail?.long))

            let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
            if distanceInMeters > 300 {
                Toast.shared.showAlert(type: .apiFailure, message: VCLiteral.REACHED_DEST_ERROR.localized)
                return
            }
            
            btnReached.playAnimation()
            EP_Home.callStatus(requestID: String(/request?.id), status: .reached).request { [weak self] (response) in
                self?.btnReached.stop()
                self?.request?.status = .reached
                self?.didStatusChanged?(.reached)
                self?.initialSetup()
            } error: { [weak self] (_) in
                self?.btnReached.stop()
            }
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension TrackingVC {
    private func localizedTextSetup() {
        btnCancel.setAnimationType(.BtnAppTintLoader)
        btnCancel.setTitle(VCLiteral.CANCEL_SERVICE.localized, for: .normal)
        btnStart.setTitle(VCLiteral.START_SERVICE.localized, for: .normal)
        btnReached.setTitle(VCLiteral.REACHED_DEST_TITLE.localized, for: .normal)
    }
    
    private func initialSetup() {
        imgView.setImageNuke(/request?.from_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        lblName.text =  "\(/request?.from_user?.profile?.title) \(/request?.from_user?.name)"
        lblETA.text = String.init(format: VCLiteral.ESTIMATE_TIME.localized, "10 min")
        lblStatus.text = ""
        
        guard let status = request?.status else { return }
        switch status {
        case .start:
            btnCancel.isHidden = true
            btnStart.isHidden = true
            btnReached.isHidden = false
        case .reached:
            btnCancel.isHidden = false
            btnStart.isHidden = false
            btnReached.isHidden = true
            
            lblETA.text = ""
            lblStatus.text = ""//"Status: \(VCLiteral.REACHED.localized)"
        default:
            break
        }
    }
    
    private func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(SDK.GooglePlaceKey.rawValue)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResult["routes"] as? [Any] else {
                return
            }
            
            guard let route = routes.first as? [String: Any] else {
                return
            }

            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            //Call this method to draw path on map
            self.drawPath(from: polyLineString)
            DispatchQueue.main.async {
                self.addMarkers(from: source, to: destination)
            }
        })
        task.resume()
    }
    
    private func addMarkers(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        startLocationMarker.icon = #imageLiteral(resourceName: "ic_start_point")
        startLocationMarker.icon?.withTintColor(ColorAsset.appTint.color, renderingMode: .alwaysTemplate)
        startLocationMarker.position = source
        startLocationMarker.map = mapView
        
        currentLocationMarker.icon = #imageLiteral(resourceName: "ic_start_point")
        currentLocationMarker.icon?.withTintColor(ColorAsset.appTint.color, renderingMode: .alwaysTemplate)
        currentLocationMarker.position = source
        currentLocationMarker.map = mapView
        
        destinationLocationMarker.icon = #imageLiteral(resourceName: "ic_end_point")
        destinationLocationMarker.icon?.withTintColor(ColorAsset.appTint.color, renderingMode: .alwaysTemplate)
        destinationLocationMarker.position = destination
        destinationLocationMarker.map = mapView
        destinationLocationMarker.title = /request?.extra_detail?.service_address
    }
    
    private func drawPath(from polyString: String){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            
            guard let path = GMSMutablePath(fromEncodedPath: /polyString) else { return }
            let bounds = GMSCoordinateBounds(path: path)
            self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            CATransaction.commit()
            
            
            // let path = GMSMutablePath(fromEncodedPath: polyStr) // Path
            self.polyPath = path
            self.polyline = GMSPolyline(path: path)
            self.polyline?.geodesic = true
            self.polyline?.strokeWidth = 3
            
            self.polyline?.strokeColor = ColorAsset.appTint.color
           
            self.polyline?.map = self.mapView
            
            self.cleanPath()
            self.timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
        }
    }
    
    private func cleanPath() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc private func animatePolylinePath() {
        guard let path = polyPath else { return }
        
        if (self.i < path.count()) {
            self.animationPath.add(path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            
            self.animationPolyline.strokeColor = .lightGray
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    private func updateLocation(_ location: LocationManagerData) {
        
        guard location.latitude != nil else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: 15)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        currentLocationMarker.position = CLLocationCoordinate2D.init(latitude: location.latitude, longitude: location.longitude)
        SocketIOManager.shared.sendLocation(request: request)

        //
//        let originalLoc: String = "\(location.latitude),\(location.longitude)"
//        let destiantionLoc: String = "\(/request?.extra_detail?.lat),\(/request?.extra_detail?.long)"
//
//        let lat = location.latitude
//        let lng = location.longitude
//
//        let latitudeDiff: Double = lat - /(Double(/request?.extra_detail?.lat))
//        let longitudeDiff: Double = lng - /(Double(/request?.extra_detail?.long))
//
//        let waypointLatitude = location.latitude - latitudeDiff
//        let waypointLongitude = location.longitude - longitudeDiff

//        getDirectionsChangedPolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointLongitude)"], travelMode: nil, completionHandler: nil)

    }
    
    
//    func getDirectionsChangedPolyLine(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
//    {
//
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//
//            if let originLocation = origin {
//                if let destinationLocation = destination {
//                    var directionsURLString = "https://maps.googleapis.com/maps/api/directions/json?" + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=\(SDK.GooglePlaceKey.rawValue)"
//                    if let routeWaypoints = waypoints {
//                        directionsURLString += "&waypoints=optimize:true"
//
//                        for waypoint in routeWaypoints {
//                            directionsURLString += "|" + waypoint
//                        }
//                    }
//
//                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//
//                    let directionsURL = NSURL(string: directionsURLString)
//                    DispatchQueue.main.async( execute: { () -> Void in
//                        let directionsData = NSData(contentsOf: directionsURL! as URL)
//                        do{
//                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
//
//                            let status = dictionary["status"] as! String
//                            if status == "OK" {
//
//                                guard let routes = dictionary["routes"] as? [Any] else {
//                                    return
//                                }
//
//                                guard let route = routes.first as? [String: Any] else {
//                                    return
//                                }
//
//                                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
//                                    return
//                                }
//                                guard let polyLineString = overview_polyline["points"] as? String else {
//                                    return
//                                }
//
//                                let path: GMSPath = GMSPath(fromEncodedPath: polyLineString)!
//
//                                self.polyline = self.demoPolyline
//                                self.polyline?.strokeColor = UIColor.blue
//                                self.polyline?.strokeWidth = 3.0
//                                self.polyline?.map = self.mapView
//                                self.polyline?.map = nil
//
//                                self.polyline = GMSPolyline(path: path)
//                                self.polyline?.map = self.mapView
//                                self.polyline?.strokeColor = UIColor.blue
//                                self.polyline?.strokeWidth = 3.0
//                                self.polyline?.map = nil
//
//
//                            } else {
//
//                                self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
//                            }
//                        } catch {
//
//                            self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
//                        }
//                    })
//                } else {
//
//                    print("Destination Location Not Found")
//                }
//            } else {
//
//                print("Origin Location Not Found")
//            }
//        }
//    }
}
