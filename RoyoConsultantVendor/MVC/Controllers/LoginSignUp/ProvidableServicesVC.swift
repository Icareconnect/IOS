//
//  ProvidableServicesVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 15/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ProvidableServicesVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var btnContinue: SKLottieButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<PreferenceOption>, DefaultCellModel<PreferenceOption>, PreferenceOption>?
    private var categories = [PreferenceOption]()
    private var preferenceId = String()
    public var comingFrom: AvailabilityDataType = .WhileLoginModule

    var filterIds = String()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewInit()
    }
    
    @IBAction func actionSelectAll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        categories.forEach({ $0.isSelected = sender.isSelected })
        tableView.reloadData()
    }
    //MARK: - IBActions
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        
        let ids = (categories.filter({/$0.isSelected})).compactMap({/$0.id})
        if ids.count == 0 {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.PROVIDABLE_SERVICES_ERROR.localized)

            return
        }
        let preference = ["option_ids": ids, "preference_id": /preferenceId] as [String : Any]

        var myJsonString = ""
        do {
            let data =  try JSONSerialization.data(withJSONObject:[preference], options: .prettyPrinted)
            myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
        }
        btnContinue.playAnimation()

        EP_Login.profileUpdate(name: nil, email: nil, phone: nil, country_code: nil, dob: nil, bio: nil, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: nil, workingSince: nil, namePrefix: nil, custom_fields: nil, master_preferences: myJsonString, address: nil, lat: nil, long: nil).request(success: { [weak self] (response) in
            self?.view.isUserInteractionEnabled = true
            self?.btnContinue.stop()
            if self?.comingFrom != .WhileManaging {
                
                let destVC = Storyboard<WorkEnvironmentVC>.LoginSignUp.instantiateVC()
                self?.pushVC(destVC)
            } else {
                self?.popVC()
            }
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.btnContinue.stop()
        }
    }
}
extension ProvidableServicesVC {
    
    private func setupViews() {
        
        var servicesArr = [Preference]()
    
        for item in UserPreference.shared.data?.master_preferences ?? [] {
            
            switch /item.preference_type {
            case "duty":
                servicesArr.append(item)
            default:
                break
            }
        }
        self.categories.forEach({ (category) in
            category.isSelected = servicesArr.first?.options?.contains(where: {/$0.id == /category.id})
        })
        
        dataSource?.updateAndReload(for: .SingleListing(items: categories ), .FullReload)
        dataSource?.stopInfiniteLoading(.FinishLoading)

    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<PreferenceOption>, DefaultCellModel<PreferenceOption>, PreferenceOption>.init(.SingleListing(items: categories, identifier: PreferencesCell.identfier, height: 48.0, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? PreferencesCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            self?.categories[indexPath.row].isSelected = !(/self?.categories[indexPath.row].isSelected)
            self?.tableView.reloadData()
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getMasterPreferences()
        }
        dataSource?.refreshProgrammatically()
    }
    
    
    private func getMasterPreferences() {
        
        EP_Login.getMasterDuty(filter_ids: /filterIds).request(success: { [weak self] (responseData) in
           
            self?.categories = (responseData as? PreferenceData)?.preferences?.first?.options ?? []
            self?.lblTitle.text = (responseData as? PreferenceData)?.preferences?.first?.preference_name
            self?.preferenceId = "\(/(responseData as? PreferenceData)?.preferences?.first?.id)"
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.categories ?? []), .FullReload)
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.setupViews()
        }) { [weak self] (error) in
          
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
            if /self?.categories.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
}

