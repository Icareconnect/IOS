//
//  HomeCollCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 06/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeCollCell: UITableViewCell, ReusableCell {
    
    typealias T = HomeCellProvider
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var isClassesScreen: Bool? = false
    private var collectionDataSource: CollectionDataSource?
    
    var item: HomeCellProvider? {
        didSet {
            let obj = item?.property?.model
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = obj?.scrollDirection ?? .vertical
            }
            
            collectionDataSource = CollectionDataSource.init(obj?.collectionItems, /obj?.identifier, collectionView, obj?.collProvider?.cellSize, obj?.collProvider?.edgeInsets, obj?.collProvider?.lineSpacing, obj?.collProvider?.interItemSpacing)
                    
            collectionDataSource?.configureCell = { (cell, item, indexPath) in
                (cell as? BlogCell)?.item = item
            }
            
            collectionDataSource?.didSelectItem = { [weak self] (indexPath, item) in
                switch /obj?.identifier {
                case BlogCell.identfier:
                    let destVC = Storyboard<BlogDetailVC>.Other.instantiateVC()
                    destVC.feed = item as? Feed
                    destVC.didUpdated = { (feed) in
                        self?.item?.property?.model?.collectionItems?[indexPath.row] = feed!
                        self?.collectionDataSource?.updateData(self?.item?.property?.model?.collectionItems)
                    }
                    UIApplication.topVC()?.pushVC(destVC)
                default:
                    break
                }
            }
        }
    }
}
