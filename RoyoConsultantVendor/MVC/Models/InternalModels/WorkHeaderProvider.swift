//
//  DocModels.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 04/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class WorkHeaderProvider: HeaderFooterModelProvider {
    
    typealias CellModelType = WorkCellProvider
    
    typealias HeaderModelType = Preference
    
    typealias FooterModelType = Any
    
    var headerProperty: HeaderProperty?
    
    var footerProperty: FooterProperty?
    
    var items: [WorkCellProvider]?
    
    required init(_ _header: HeaderProperty?, _ _footer: FooterProperty?, _ _items: [WorkCellProvider]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    class func getSectionWiseData(_ array: [Preference]?) -> [WorkHeaderProvider] {
        
        var sections = [WorkHeaderProvider]()
        
        array?.forEach({ (detail) in
            
            var cells = [WorkCellProvider]()
            
            detail.options?.forEach({
                cells.append(WorkCellProvider.init((WorkCell.identfier, 40.0, $0), nil, nil))
            })
            sections.append(WorkHeaderProvider.init((WorkHeaderView.identfier, 80.0, detail), nil, cells))
        })
        return sections
    }
}


class WorkCellProvider: CellModelProvider {
    
    typealias CellModelType = PreferenceOption

    var property: Property?
    
    var leadingSwipeConfig: SKSwipeActionConfig?
    
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: Property?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
}
