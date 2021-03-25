//
//  CovidFormVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 07/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class CovidFormVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(PreferenceHeaderView.identfier)
        }
    }
    @IBOutlet weak var btnApply: SKLottieButton!
    
    private var dataSource: TableDataSource<PreferenceHeaderProvider, PreferenceCellProvider, PreferenceCustomModel>?
    private var items: [PreferenceHeaderProvider]?
    public var preferences: [Preference]?
    public var preferencesApplied: ((_ _preferences: [Preference]?, _ isCleared: Bool?) -> Void)?
    public var comingFrom: AvailabilityDataType = .WhileLoginModule

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
        
        
        getMasterPreferences()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Cancel
            popVC()
        case 1: //Apply
            
            var resposeArr = [[String: Any]]()
            for pref in preferences ?? [] {
                
                let optionId = (pref.options?.filter({ /$0.isSelected }).compactMap( {"\(/$0.id)"} ))
                
                if optionId?.count == 0 {
                    
                    Toast.shared.showAlert(type: .validationFailure, message: "Required: " + /pref.preference_name)
                    return
                }
                let preferenceId = "\(/pref.id)"
                
                resposeArr.append(["option_ids" : optionId ?? [], "preference_id": preferenceId])
            }
            if /preferences?.compactMap({$0.options}).flatMap({$0}).filter({/$0.isSelected}).count < /preferences?.count {
                btnApply.vibrate()
            } else {
                
                var myJsonString = ""
                do {
                    let data =  try JSONSerialization.data(withJSONObject:resposeArr, options: .prettyPrinted)
                    myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                } catch {
                    print(error.localizedDescription)
                }
                
                btnApply.playAnimation()
                EP_Login.profileUpdate(name: nil, email: nil, phone: nil, country_code: nil, dob: nil, bio: nil, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: nil, workingSince: nil, namePrefix: nil, custom_fields: nil, master_preferences: myJsonString, address: nil, lat: nil, long: nil).request(success: { [weak self] (response) in
                    self?.view.isUserInteractionEnabled = true
                    self?.btnApply.stop()
                    if self?.comingFrom != .WhileManaging {
                        
                        let destVC = Storyboard<UploadDocsVC>.LoginSignUp.instantiateVC()
                        self?.pushVC(destVC)
                    } else {
                        self?.popVC()
                    }

                    
                }) { [weak self] (error) in
                    self?.view.isUserInteractionEnabled = true
                    self?.btnApply.stop()
                }
            }
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension CovidFormVC {
    
    private func localizedTextSetup() {
        
        btnApply.setTitle(VCLiteral.SUBMIT.localized, for: .normal)
    }
    
    private func tableViewInit() {
        
        dataSource = TableDataSource<PreferenceHeaderProvider, PreferenceCellProvider, PreferenceCustomModel>.init(.MultipleSection(items: items ?? []), tableView, false)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? PreferenceHeaderView)?.item = item
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? PreferenceCollectionViewCell)?.item = item
        }
    }
}
extension CovidFormVC {
    
    private func getMasterPreferences() {
        EP_Login.getMasterPreferences(type: "All", preference_type: "covid").request(success: { [weak self] (responseData) in
            
            var covidArr = [Preference]()
            
            for item in UserPreference.shared.data?.master_preferences ?? [] {
                
                switch /item.preference_type {
                case "covid":
                    covidArr.append(item)
                default:
                    break
                }
            }
            
            let pref = (responseData as? PreferenceData)?.preferences
            pref?.forEach({ (category) in
                category.options?.forEach({ (option) in
                     covidArr.forEach({ (prefre) in
                        if (/prefre.options?.first?.id == /option.id) {
                            option.isSelected = true
                        }
                    })
                })
            })
            
            let requiredData = PreferenceHeaderProvider.getPreferences(preferences: pref)
            self?.preferences = pref//(responseData as? PreferenceData)?.preferences
            self?.items = requiredData.preferences
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)

        }) { [weak self] (error) in
          
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
        }
    }
}
