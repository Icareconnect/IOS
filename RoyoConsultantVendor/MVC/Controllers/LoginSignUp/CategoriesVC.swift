//
//  CategoriesVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 28/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class CategoriesVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var navView: UIView!
    
    private var dataSource: CollectionDataSource?
    private var items: [Category]?
    public var comingFrom: AvailabilityDataType = .WhileLoginModule
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        collectionViewInit()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
    
}

//MARK:- VCFuncs
extension CategoriesVC {
    private func localizedTextSetup() {
        navView.isHidden = true
        lblTitle.text = VCLiteral.CATEGORY_VC_TITLE.localized
        lblSubTitle.text = VCLiteral.CATEGORY_VC_SUBTITLE.localized
    }
    
    private func collectionViewInit() {
        
        let width = (UIScreen.main.bounds.width - (16 * 3)) / 2
        let height = width * 0.585
        
        let imageSize = CGSize.init(width: height - 16, height: height - 16)
        
        dataSource = CollectionDataSource.init(items, CategoryCell.identfier, collectionView, CGSize.init(width: width, height: height), UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16), 16, 16)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? CategoryCell)?.imageSize = imageSize
            (cell as? CategoryCell)?.item = item
        }
        
        dataSource?.addPullToRefreshVertically({ [weak self] in
            self?.getCategoriesAPI()
        })
        
        dataSource?.didSelectItem = { [weak self] (indexPath, item) in
            if /(item as? Category)?.id == 1 { //Treat filters as subcategory in UI for multiple selection
                let destVC = Storyboard<CustomSubCategoryVC>.LoginSignUp.instantiateVC()
                destVC.category = item as? Category
                destVC.comingFrom = self?.comingFrom ?? .WhileLoginModule
                self?.pushVC(destVC)
            } else if /(item as? Category)?.is_subcategory {
                let destVC = Storyboard<SubCategoryVC>.LoginSignUp.instantiateVC()
                destVC.parentCat = item as? Category
                destVC.comingFrom = self?.comingFrom ?? .WhileLoginModule
                self?.pushVC(destVC)
            } else {
                if /(item as? Category)?.is_additionals {
                    let destVC = Storyboard<UploadDocsVC>.LoginSignUp.instantiateVC()
                    destVC.category = item as? Category
                    self?.pushVC(destVC)
                } else if /(item as? Category)?.is_filters {
                    let destVC = Storyboard<SetPreferencesVC>.LoginSignUp.instantiateVC()
                    destVC.categoryId = String(/(item as? Category)?.id)
                    destVC.comingFrom = self?.comingFrom ?? .WhileLoginModule
                    self?.pushVC(destVC)
                } else {
                    let destVC = Storyboard<ServicesVC>.LoginSignUp.instantiateVC()
                    destVC.categoryId = String(/(item as? Category)?.id)
                    destVC.comingFrom = self?.comingFrom ?? .WhileLoginModule
                    self?.pushVC(destVC)
                }
            }
        }
        
        dataSource?.scrollDirection = { [weak self] (direction) in
            if direction == .Down {
                self?.navView.isHidden = true
            }
            self?.navigationBarAnimationHandling(direction: direction)
        }
        
        dataSource?.refreshProgrammatically()
        
    }
    
    private func getCategoriesAPI() {
        EP_Home.categories(parentId: nil, after: nil).request(success: { [weak self] (responseData) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            let data = responseData as? CategoryData
            self?.items = (data?.classes_category ?? [])
            self?.dataSource?.updateData(self?.items)
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
