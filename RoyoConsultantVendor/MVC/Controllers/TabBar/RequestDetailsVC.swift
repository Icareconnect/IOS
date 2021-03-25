//
//  RequestDetailsVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 23/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class RequestDetailsVC: BaseVC {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRequestType: UILabel!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblbookingDates: UILabel!
    @IBOutlet weak var lblSpecialIns: UILabel!
    
    @IBOutlet weak var lblWorkEnvValue: UILabel!
    @IBOutlet weak var lblWorkEnvTitle: UILabel!
    @IBOutlet weak var vwApproval: UIView!
    @IBOutlet weak var lblStatusDescription: UILabel!

    @IBOutlet weak var lblApprovedStatus: UILabel!
    @IBOutlet weak var lblRequestFor: UILabel!
    @IBOutlet weak var lblRequestForName: UILabel!

    @IBOutlet weak var btnDecline: SKLottieButton!
    @IBOutlet weak var btnAccept: SKLottieButton!
    @IBOutlet weak var vwCovid: UIView!
    
    @IBOutlet weak var lblCovidDetails: UILabel!
    
    @IBOutlet weak var btnSeeMore: UIButton!
    //MARK: -

    var item: Requests?
    var reloadTable: (() -> Void)?
    var requestID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDetails()
    }
    
    func getDetails() {
        
        EP_Home.requestDetail(request_id: item?.id == nil ? /requestID : "\(/item?.id)").request(success: { [weak self] (responseData) in

            let request = responseData as? RequestDetailsData
            self?.item = request?.request_detail
            self?.setupData()
        }) { [weak self] (error) in
            self?.btnDecline.stop()
        }
    }
    
    @IBAction func actionButtons(_ sender: UIButton) {
        
        switch sender.tag {
        case 0: //BACK
            popVC()
        case 1: // MAP
            
            let latitude = /item?.extra_detail?.lat
            let longitude = /item?.extra_detail?.long
            
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
            }
        case 2: //Decline Button
           
            btnDecline.setAnimationType(.BtnAppTintLoader)
            btnDecline.playAnimation()
            EP_Home.cancelRequest(requestId: String(/item?.id)).request(success: { [weak self] (responseData) in
                self?.btnDecline.stop()
                self?.item?.canCancel = false
                self?.item?.status = .canceled

                self?.setupData()
            }) { [weak self] (error) in
                self?.btnDecline.stop()
            }
        case 3: // Accept
            
            if item?.status == .pending {
                manageRequest()
            } else if item?.status == .accept {
                startRequestAlert()
            } else if item?.status == .reached || item?.status == .start {//|| item?.status == .inProgress {
                let destVC = Storyboard<TrackingVC>.Other.instantiateVC()
                destVC.request = item
                destVC.modalPresentationStyle = .fullScreen
                destVC.didStatusChanged = { [weak self] (status) in
                    self?.item?.status = status
                    self?.setupData()
                    self?.reloadTable?()
                }
                self.presentVC(destVC)
            } else if item?.status ==  .start_service {
                let destVC = Storyboard<TrackStatusVC>.Other.instantiateVC()
                destVC.request = item
                destVC.modalPresentationStyle = .fullScreen
                destVC.didStatusChanged = { [weak self] (status) in
                    self?.item?.status = status
                    self?.setupData()
                    self?.reloadTable?()
                }
                self.presentVC(destVC)
            }
        case 10:
            
            btnSeeMore.isSelected = !btnSeeMore.isSelected
            lblCovidDetails.numberOfLines = /btnSeeMore.isSelected ? 0 : 3
        default:
            break
        }
    }
    
    private func manageRequest() {
        
        btnAccept.setAnimationType(.BtnAppTintLoader)
        btnAccept.playAnimation()
        EP_Home.acceptRequest(requestId: String(/item?.id)).request(success: { [weak self] (responseData) in
            self?.btnAccept.stop()
            
            self?.item?.status = .accept
            self?.setupData()
        }) { [weak self] (error) in
            self?.btnAccept.stop()
        }
    }
    private func startRequestAlert() {
        UIApplication.topVC()?.alertBox(title: VCLiteral.START_REQUEST.localized, message: VCLiteral.START_REQUEST_ALERT_DESC.localized, btn1: VCLiteral.Cancel.localized, btn2: VCLiteral.START.localized, tapped1: nil, tapped2: { [weak self] in
            self?.startRequestFurtherProceed()
        })
    }
    
    private func startRequestFurtherProceed() {
        btnAccept.setAnimationType(.BtnAppTintLoader)
        btnAccept.playAnimation()
        let service = item
        
        EP_Home.callStatus(requestID: String(/service?.id), status: .start).request(success: { [weak self] (response) in
            self?.btnAccept.stop()
            self?.setupData()

            self?.item?.status = .start
            let destVC = Storyboard<TrackingVC>.Other.instantiateVC()
            destVC.request = self?.item
            destVC.modalPresentationStyle = .fullScreen
            destVC.didStatusChanged = { [weak self] (status) in
                self?.item?.status = status
                self?.setupData()
                self?.reloadTable?()
            }
            self?.presentVC(destVC)
        }) { [weak self] (_) in
            self?.btnAccept.stop()
        }
    }
}
extension RequestDetailsVC {
    
    private func setupData() {
        
        lblWorkEnvTitle.text = VCLiteral.WorkEnvironment.localized
        
        let obj = item
        lblName.text = /obj?.from_user?.name
        lblRequestType.text = (/obj?.service_type).uppercased()
       // lblStatus.text = /obj?.status?.title.localized
        if /obj?.status?.title.localized == VCLiteral.CANCELLED.localized {
            
            if /obj?.canceled_by?.id != /UserPreference.shared.data?.id {
                lblStatus.text = "CANCELLED"//obj?.status?.title.localized

            } else {
                lblStatus.text = "DECLINED"///obj?.status?.title.localized

            }
                
        } else {
            lblStatus.text = /obj?.status?.title.localized
        }
        
        imgVIew.setImageNuke(/obj?.from_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        
        lblAddress.text = /obj?.extra_detail?.service_address
        lblDistance.text = /obj?.extra_detail?.distance
        lblTime.text = "\(/obj?.extra_detail?.start_time) - \(/obj?.extra_detail?.end_time)"
        lblSpecialIns.text = /obj?.extra_detail?.reason_for_service
        var dutiesArr = [String]()
        for val in obj?.duties ?? [] {
            dutiesArr.append(/val.option_name)
        }
        lblRequestType.text = /dutiesArr.joined(separator: ", ")
        
        lblRequestFor.text = /obj?.extra_detail?.service_for
        lblRequestForName.text = /obj?.extra_detail?.first_name
        
        let dates = /obj?.extra_detail?.working_dates
        let datesArr = dates.components(separatedBy: ",")

        var localArr = [String]()
        for dateStr in datesArr {
            let utcDate1 = Date(fromString: dateStr, format: DateFormat.custom("yyyy-MM-dd"), timeZone: .local)
            localArr.append(utcDate1.toString(DateFormat.custom("dd MMM yyyy"), timeZone: .local))
        }
        
        lblbookingDates.text = localArr.joined(separator: " | ")
        lblStatus.textColor = obj?.status?.linkedColor.color
        
        lblApprovedStatus.text = /obj?.user_status?.uppercased()
        lblStatusDescription.text = /obj?.user_comment
        vwApproval.isHidden = !(/obj?.userIsApproved)
        
        btnDecline.isHidden = !(/obj?.canCancel)
        btnDecline.setTitle(VCLiteral.CANCEL.localized, for: .normal)
        btnAccept.backgroundColor = ColorAsset.callAccept.color
        var covidArr = [Preference]()

        for item in obj?.from_user?.master_preferences ?? [] {

            switch /item.preference_type {
            case "covid":
                covidArr.append(item)

            default:
                break
            }
        }
        var covidStrArr = [String]()
        for item in covidArr {
            
            if let options = item.options {
                let filterTitle = options.map({ /$0.option_name })
                
                covidStrArr.append("\(/item.preference_name)\n\(filterTitle.joined(separator: ", "))\n\n")
            }
        }
        lblCovidDetails.text = covidStrArr.joined(separator: "")
        vwCovid.isHidden = covidStrArr.count == 0
        
        switch obj?.status ?? .unknown {
        case .canceled, .completed, .failed:
            btnDecline.isHidden = true
            btnAccept.isHidden = true
        case .accept:
            btnDecline.isHidden = true
            btnAccept.backgroundColor = ColorAsset.appTint.color
            btnAccept.setTitle(VCLiteral.START.localized, for: .normal)
        case .pending:
            btnDecline.isHidden = false
            btnAccept.setTitle(VCLiteral.ACCEPT_TITLE.localized, for: .normal)
        case .start, .inProgress, .reached:
            btnDecline.isHidden = true
            btnAccept.setTitle(VCLiteral.TRACK_STATUS.localized, for: .normal)
            btnAccept.backgroundColor = ColorAsset.appTint.color
        case .start_service:
            btnDecline.isHidden = true
            btnAccept.isHidden = false
            btnAccept.setTitle(VCLiteral.TRACK_STATUS.localized, for: .normal)
            btnAccept.backgroundColor = ColorAsset.appTint.color
        default:
            btnAccept.isHidden = true
        }
        var workArr = [Preference]()

        for item in obj?.from_user?.master_preferences ?? [] {

            switch /item.preference_type {
            case "work_environment":
                workArr.append(item)
            default:
                break
            }
        }

        if workArr.count > 0 {
            if let options = workArr[0].options {
                let filterTitle = options.map({ /$0.option_name })
                
                lblWorkEnvValue.text = filterTitle.joined(separator: ", ")
            }
        }
    }
}
