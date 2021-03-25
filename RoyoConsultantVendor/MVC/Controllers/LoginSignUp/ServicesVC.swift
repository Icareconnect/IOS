//
//  ServicesVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 30/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ServicesVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(ServiceTypeHeaderView.identfier)
        }
    }
    @IBOutlet weak var btnNext: SKLottieButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    public var filters: [Filter]? = UserPreference.shared.data?.filters
    public var categoryId: String? = String(/UserPreference.shared.data?.categoryData?.id)
    public var comingFrom: AvailabilityDataType = .WhileLoginModule
    
    private var items = [ServiceHeaderProvider]()
    private var dataSource: TableDataSource<ServiceHeaderProvider, ServiceCellProvider, ServiceCellModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Next
            validateData()
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension ServicesVC {
    private func validateData() {
        
        if !(/items.contains(where: {$0.headerProperty?.model?.service?.available == .TRUE})) {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.SERVICE_ALERT.localized)
            btnNext.vibrate()
            return
        }
        
        var isValidValues = true
        
        for sectionItem in items {
            if sectionItem.headerProperty?.model?.service?.available == .TRUE {
                let service = sectionItem.items?.first?.property?.model?.service
                if service?.price_type == .price_range {
                    if /service?.price > /service?.price_maximum || /service?.price < /service?.price_minimum {
                        isValidValues = false
                        Toast.shared.showAlert(type: .validationFailure, message: /service?.price_type?.getRelatedText(model: service))
                        btnNext.vibrate()
                        break
                    }
                }
            }
            isValidValues = true
        }
        
        if isValidValues { //Success
            updateServicesAPI()
        }
    }
    
    private func updateServicesAPI() {
        btnNext.playAnimation()
        
        var filterToSend = [FilterToSend]()
        filters?.forEach({ (filter) in
            if /filter.options?.contains(where: {/$0.isSelected}) {
                let ids = ((filter.options)?.filter({/$0.isSelected}) ?? []).compactMap({/$0.id})
                filterToSend.append(FilterToSend.init(filter.id, ids))
            }
        })
        let jsonFilters = JSONHelper<[FilterToSend]>().toDictionary(model: filterToSend)

        
        //        let servicesEnabled = items.filter({$0.headerProperty?.model?.service?.available == .TRUE})
        //        let subServicesModels = (servicesEnabled.map({$0.items ?? []})).flatMap{$0}
        //        let services = subServicesModels.compactMap({$0.property?.model})
        
        let subServicesModels = (items.map({$0.items ?? []})).flatMap{$0}
        var services = subServicesModels.compactMap({$0.property?.model})
        
        //Appending Switched OFF services in array to send to backend
        items.forEach { (model) in
            if /model.items?.count == 0 {
                let customService = ServiceCellModel.init(model.headerProperty?.model?.service, nil)
                services.append(customService)
            }
        }
        
        
        let jsonCategoryServices = ServiceTypeToSend.getJSONString(services)
        
        EP_Home.updateServices(categoryId: /categoryId, filters: /(jsonFilters as? [[String : Any]])?.count == 0 ? nil : jsonFilters, category_services_type: jsonCategoryServices).request(success: { [weak self] (responseData) in
            self?.btnNext.stop()
            switch self?.comingFrom ?? .WhileLoginModule {
            case .WhileLoginModule:
                UIWindow.replaceRootVC(Storyboard<NavigationTabVC>.TabBar.instantiateVC())
            case .WhileManaging:
                self?.popTo(toControllerType: ProfileDetailVC.self)
                
            default:
                break
            }
        }) { [weak self] (error) in
            self?.btnNext.stop()
        }
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.SERVICE_TYPE_TITLE.localized
        btnNext.setTitle(VCLiteral.NEXT.localized, for: .normal)
    }
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 16.0
        
        dataSource = TableDataSource<ServiceHeaderProvider, ServiceCellProvider, ServiceCellModel>.init(.MultipleSection(items: items), tableView, true)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? ServiceTypeHeaderView)?.item = item
            (view as? ServiceTypeHeaderView)?.didSwitchToggled = { [weak self] (available, service) in
                self?.handleSwitchToggle(available: available, service: service, section: section)
            }
        }
        
        dataSource?.configureCell = { [weak self] (cell, item, indexPath) in
            (cell as? ServiceTypeCell)?.categoryId = self?.categoryId
            (cell as? ServiceTypeCell)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.getServiceAPI()
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func handleSwitchToggle(available: CustomBool, service: Service?, section: Int) {
        
        items[section].headerProperty?.model?.service?.available = available
        
        switch available {
        case .TRUE: //Switch ON
            items[section].items = [ServiceCellProvider((ServiceTypeCell.identfier, UITableView.automaticDimension, ServiceCellModel(service, comingFrom)), nil, nil)]
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .AddRowsAt(indexPaths: [IndexPath(item: 0, section: section)], animation: .bottom, moveToLastIndex: false))
        case .FALSE: //Switch OFF
            items[section].items = []
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .DeleteRowsAt(indexPaths: [IndexPath(item: 0, section: section)], animation: .automatic))
        }
    }
    
    private func getServiceAPI() {
        EP_Home.services(categoryId: categoryId).request(success: { [weak self] (responseData) in
            self?.dataSource?.stopInfiniteLoading(.LoadingContent)
            let tempServices = (responseData as? ServicesData)?.services
            let localServices = UserPreference.shared.data?.services
            tempServices?.forEach({ (service) in
                service.available = localServices?.first(where: {service.service_id == $0.service_id})?.available
                service.price = localServices?.first(where: {service.service_id == $0.service_id})?.price
            })
            self?.items = ServiceHeaderProvider.getSectionWiseArray(tempServices, comingFrom: self?.comingFrom)
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.LoadingContent)
        }
    }
}
