//
//  PreferenceCollectionViewCell.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 07/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit


class PreferenceCollectionViewCell: UITableViewCell, ReusableCell {
    
    typealias T = PreferenceCellProvider
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: CollectionDataSource?
    
    var item: PreferenceCellProvider? {
        didSet {
            let filterOptions = item?.property?.model?.preference?.options
            let cellId = item?.property?.model?.preference?.is_multi == .TRUE ? PreferenceMultiSelectionCell.identfier : PreferenceSingleSelectionCell.identfier
            let collectionProperty = item?.property?.model?.collSizeProvider
            dataSource = CollectionDataSource.init(filterOptions, cellId, collectionView, collectionProperty?.cellSize, collectionProperty?.edgeInsets, collectionProperty?.lineSpacing, collectionProperty?.interItemSpacing)
            
            dataSource?.configureCell = { (cell, item, indexPath) in
                (cell as? PreferenceSingleSelectionCell)?.item = item
                (cell as? PreferenceMultiSelectionCell)?.item = item
            }
            
            dataSource?.didSelectItem = { [weak self] (indexPath, item) in
                let options = self?.item?.property?.model?.preference?.options
                switch  self?.item?.property?.model?.preference?.is_multi ?? .FALSE {
                case .TRUE:
                    options?[indexPath.row].isSelected = !(/options?[indexPath.row].isSelected)
                    self?.dataSource?.updateData(options)
                case .FALSE:
                    options?.forEach({$0.isSelected = false})
                    options?[indexPath.row].isSelected = true
                    self?.item?.property?.model?.preference?.options = options
                    self?.dataSource?.updateData(options)
                }
            }
            
            collectionView.roundCorners(with: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 4.0)
            collectionView.clipsToBounds = true
        }
    }

}
