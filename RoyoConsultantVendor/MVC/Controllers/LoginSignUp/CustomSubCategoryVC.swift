//
//  CustomSubCategoryVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 17/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class CustomSubCategoryVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var btnNext: SKLottieButton!
    
    public var category: Category?
    
    private var dataSource: CollectionDataSource?
    private var filter: Filter?
    public var comingFrom: AvailabilityDataType = .WhileLoginModule
    public var isUpdatingFiltersOnly: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        collectionViewInit()
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Next
            validateFilters()
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension CustomSubCategoryVC {
    private func localizedTextSetup() {
        navView.isHidden = true
        lblTitle.text = VCLiteral.SUBCATEGORY_TITLE.localized
        lblSubTitle.text = VCLiteral.CATEGORY_VC_SUBTITLE.localized
        btnNext.setTitle(VCLiteral.NEXT.localized, for: .normal)
    }
    
    private func validateFilters() {
        let filters = [filter!]
        
        var isValidValues = true
        
        for filter in (filters) {
            if !(/filter.options?.contains(where: {/$0.isSelected})) {
                let alertMessage = String.init(format: filter.is_multi == .TRUE ? VCLiteral.SET_PREFERENCES_VALIDATION_ALERT_MULTI.localized : VCLiteral.SET_PREFERENCES_VALIDATION_ALERT_SINGLE.localized, /filter.filter_name?.lowercased())
                Toast.shared.showAlert(type: .validationFailure, message: alertMessage)
                isValidValues = false
                break
            }
            
        }
        
        if isValidValues {
            if isUpdatingFiltersOnly {
                hitAPIToUpdateFilters(filters: filters)
            } else if /category?.is_additionals {
                let destVC = Storyboard<UploadDocsVC>.LoginSignUp.instantiateVC()
                destVC.filters = filters
                destVC.category = category
                pushVC(destVC)
            } else {
                let destVC = Storyboard<ServicesVC>.LoginSignUp.instantiateVC()
                destVC.filters = filters
                destVC.categoryId = String(/category?.id)
                destVC.comingFrom = comingFrom
                pushVC(destVC)
            }
        }
    }
    
    private func hitAPIToUpdateFilters(filters: [Filter]?) {
        var filterToSend = [FilterToSend]()
        filters?.forEach({ (filter) in
            if /filter.options?.contains(where: {/$0.isSelected}) {
                let ids = ((filter.options)?.filter({/$0.isSelected}) ?? []).compactMap({/$0.id})
                filterToSend.append(FilterToSend.init(filter.id, ids))
            }
        })
        let jsonFilters = JSONHelper<[FilterToSend]>().toDictionary(model: filterToSend)
        
        btnNext.playAnimation()
        EP_Home.updateServices(categoryId: String(/category?.id), filters: jsonFilters, category_services_type: nil).request(success: { [weak self] (responseData) in
            self?.btnNext.stop()
            let destVC = Storyboard<UploadDocsVC>.LoginSignUp.instantiateVC()
            destVC.category = self?.category
            self?.pushVC(destVC)
        }) { [weak self] (_) in
            self?.btnNext.stop()
        }
    }
    
    private func collectionViewInit() {
        
        let width = (UIScreen.main.bounds.width - (16 * 3)) / 2
        let height = width * 0.585
            
        dataSource = CollectionDataSource.init(filter?.options, CustomCollectionViewCell.identfier, collectionView, CGSize.init(width: width, height: height), UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16), 16, 16)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? CustomCollectionViewCell)?.item = item
        }
        
        dataSource?.addPullToRefreshVertically({ [weak self] in
            self?.getFiltersAPI()
        })
        
        dataSource?.didSelectItem = { [weak self] (indexPath, item) in
            (item as? FilterOption)?.isSelected = !(/(item as? FilterOption)?.isSelected)
            self?.filter?.options?[indexPath.row].isSelected = (item as? FilterOption)?.isSelected
            self?.collectionView.reloadItems(at: [indexPath])
        }
        
        dataSource?.scrollDirection = { [weak self] (direction) in
            if direction == .Down {
                self?.navView.isHidden = true
            }
            self?.navigationBarAnimationHandling(direction: direction)
        }
        
        dataSource?.refreshProgrammatically()
        
    }
    
    private func getFiltersAPI() {
        EP_Home.getFilters(categoryId: String(/category?.id), userId: String(/UserPreference.shared.data?.id)).request(success: { [weak self] (responseData) in
            let filters = (responseData as? FilterData)?.filters
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.filter = filters?.first
            self?.dataSource?.updateData(self?.filter?.options)
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
        }
    }
    
    //MARK:- Handling Animation for navigation bar
    private func navigationBarAnimationHandling(direction: ScrollDirection) {
        constraintTop.constant = direction == .Up ? -44 : 0
        UIView.transition(with: lblTitle, duration: 0.2, options: .curveLinear, animations: { [weak self] in
            self?.lblTitle.textAlignment = direction == .Up ? .center : .left
            self?.lblSubTitle.text = direction == .Up ? nil : VCLiteral.CATEGORY_VC_SUBTITLE.localized
        })
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.lblTitle?.transform = direction == .Up ? CGAffineTransform.init(scaleX: 0.7, y: 0.7) : CGAffineTransform.identity
            self?.view.layoutSubviews()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navView.isHidden = (direction == .Down)
        }
    }
}
