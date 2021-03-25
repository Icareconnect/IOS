//
//  PreferenceModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 05/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class PreferenceHeaderProvider: HeaderFooterModelProvider {
    
    typealias CellModelType = PreferenceCellProvider
    
    typealias HeaderModelType = Preference
    
    typealias FooterModelType = Any
    
    var headerProperty: (identifier: String?, height: CGFloat?, model: Preference?)?
    
    var footerProperty: (identifier: String?, height: CGFloat?, model: Any?)?
    
    var items: [PreferenceCellProvider]?
    
    required init(_ _header: (identifier: String?, height: CGFloat?, model: Preference?)?, _ _footer: (identifier: String?, height: CGFloat?, model: Any?)?, _ _items: [PreferenceCellProvider]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    class func getPreferences(preferences: [Preference]?) -> (preferences: [PreferenceHeaderProvider], tableHeight: CGFloat) {
        
        var sections = [PreferenceHeaderProvider]()
        var tableHeight: CGFloat = 0.0
        
        preferences?.forEach({
            let widthOfCell = (UIScreen.main.bounds.width - 80.0) / 2
            let collSizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: widthOfCell, height: 40.0), interItemSpacing: 16.0, lineSpacing: 0, edgeInsets: UIEdgeInsets.init(top: 0, left: 16.0, bottom: 8.0, right: 16.0))
            let tableCellHeight = collSizeProvider.getHeightOfTableViewCell(for: /$0.options?.count, gridCount: 2)
            let sectionHeight: CGFloat = 64.0
            tableHeight += (tableCellHeight + sectionHeight)
            let section = PreferenceHeaderProvider.init((PreferenceHeaderView.identfier, sectionHeight, $0), nil, [PreferenceCellProvider.init((PreferenceCollectionViewCell.identfier, tableCellHeight, PreferenceCustomModel.init($0, collSizeProvider)), nil, nil)])
            sections.append(section)
        })
        
        return (sections, tableHeight)
    }
}


class PreferenceCellProvider: CellModelProvider {
    
    typealias CellModelType = PreferenceCustomModel
    
    var property: (identifier: String, height: CGFloat, model: PreferenceCustomModel?)?
    
    var leadingSwipeConfig: SKSwipeActionConfig?
    
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: (identifier: String, height: CGFloat, model: PreferenceCustomModel?)?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
}

class PreferenceCustomModel {
    var preference: Preference?
    var collSizeProvider: CollectionSizeProvider?
    
    init(_ _preference: Preference?, _ _collSizeProvider: CollectionSizeProvider?) {
        preference = _preference
        collSizeProvider = _collSizeProvider
    }
}
