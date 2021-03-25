//
//  SubCategoryVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 28/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SubCategoryVC: BaseVC {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Category>, DefaultCellModel<Category>, Category>?
    private var items: [Category]?
    public var parentCat: Category?
    public var comingFrom: AvailabilityDataType = .WhileLoginModule
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }
    
    @IBAction func btnBacAction(_ sender: UIButton) {
        popVC()
    }
}

extension SubCategoryVC {
    private func localizedTextSetup() {
        tableView.contentInset.top = 16.0
        navView.isHidden = true
        lblTitle.text = VCLiteral.SUBCATEGORY_TITLE.localized
        lblSubTitle.text = VCLiteral.CATEGORY_VC_SUBTITLE.localized
    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<Category>, DefaultCellModel<Category>, Category>.init(.SingleListing(items: items ?? [], identifier: SubcategoryCell.identfier, height: 56.0, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.getSubCategoriesAPI()
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? SubcategoryCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            let obj = item?.property?.model
            if /obj?.is_subcategory {
                let destVC = Storyboard<SubCategoryVC>.LoginSignUp.instantiateVC()
                destVC.comingFrom = self?.comingFrom ?? .WhileLoginModule
                destVC.parentCat = obj
                self?.pushVC(destVC)
            } else {
                if /obj?.is_additionals {
                    let destVC = Storyboard<UploadDocsVC>.LoginSignUp.instantiateVC()
                    destVC.category = obj
                    self?.pushVC(destVC)
                } else if /obj?.is_filters {
                    let destVC = Storyboard<SetPreferencesVC>.LoginSignUp.instantiateVC()
                    destVC.comingFrom = self?.comingFrom ?? .WhileLoginModule
                    destVC.categoryId = String(/obj?.id)
                    self?.pushVC(destVC)
                } else {
                    let destVC = Storyboard<ServicesVC>.LoginSignUp.instantiateVC()
                    destVC.comingFrom = self?.comingFrom ?? .WhileLoginModule
                    destVC.categoryId = String(/obj?.id)
                    self?.pushVC(destVC)
                }
            }
        }
        
        dataSource?.refreshProgrammatically()
        
        dataSource?.scrollDirection = { [weak self] (direction) in
            if direction == .Down {
                self?.navView.isHidden = true
            }
            self?.navigationBarAnimationHandling(direction: direction)
        }
    }
    
    private func getSubCategoriesAPI() {
        EP_Home.categories(parentId: String(/parentCat?.id), after: nil).request(success: { [weak self] (responseData) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            let data = responseData as? CategoryData
            self?.items = (data?.classes_category ?? [])
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
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
