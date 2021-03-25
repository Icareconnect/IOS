//
//  HomeModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 06/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeSectionProvider: HeaderFooterModelProvider {
    
    typealias CellModelType = HomeCellProvider
    
    typealias HeaderModelType = HomeSectionModel
    
    typealias FooterModelType = Any
    
    var headerProperty: (identifier: String?, height: CGFloat?, model: HomeSectionModel?)?
    
    var footerProperty: (identifier: String?, height: CGFloat?, model: Any?)?
    
    var items: [HomeCellProvider]?
    
    required init(_ _header: (identifier: String?, height: CGFloat?, model: HomeSectionModel?)?, _ _footer: (identifier: String?, height: CGFloat?, model: Any?)?, _ _items: [HomeCellProvider]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    class func getApptsWithoutHeader(requests: [Requests]) -> [HomeSectionProvider] {
        var cells = [HomeCellProvider]()
        requests.forEach({
            cells.append(HomeCellProvider.init((AppointmentCell.identfier, UITableView.automaticDimension, HomeCellModel.init($0)), nil, nil))
        })
        
        return [HomeSectionProvider.init(("", 0.0, nil), nil, cells)]
    }
    
    class func getAppointments(requests: [Requests]) -> [HomeSectionProvider] {
        let prefixedArray = Array(requests.prefix(5))
        
        var cells = [HomeCellProvider]()
        
        prefixedArray.forEach({
            cells.append(HomeCellProvider.init((AppointmentCell.identfier, UITableView.automaticDimension, HomeCellModel.init($0)), nil, nil))
        })
        
        return cells.count == 0 ? [] : [HomeSectionProvider.init((HomeHeaderView.identfier, 72.0, HomeSectionModel.init(.APPOINTMENT, .REQUESTS, .VIEW_ALL, requests.count <= 5, .RequestViewAll)), nil, cells)]
    }
    
    class func getBlogs(articles: [Feed]?) -> HomeSectionProvider {
        let width = UIScreen.main.bounds.width * 0.4
        let height = width * (200 / 152)
        
        
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 0, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16))
        
        let heightOfTV_Cell = height + sizeProvider.edgeInsets.bottom + sizeProvider.edgeInsets.top
        
        let cells = [HomeCellProvider.init((HomeCollCell.identfier, heightOfTV_Cell, HomeCellModel.init(sizeProvider, .horizontal, articles ?? [Feed](), BlogCell.identfier)), nil, nil)]
        
        let section = HomeSectionProvider.init((HomeHeaderView.identfier, 48.0, HomeSectionModel.init(nil, .BLOGS, /articles?.count == 5 ? .VIEW_ALL : .POST_BLOG, false, /articles?.count == 5 ? .BlogViewAll : .BlogAddNew)), nil, /articles?.count == 0 ? [] : cells)
        
        return section
    }
}

class HomeSectionModel {
    var titleRegular: VCLiteral?
    var titleBold: VCLiteral?
    var btnText: VCLiteral?
    var isBtnHidden: Bool?
    var action: HeaderActionType?
    
    init(_ titleR: VCLiteral?, _ titleB: VCLiteral?, _ _btnText: VCLiteral, _ _isBtnHidden: Bool, _ _action: HeaderActionType) {
        titleRegular = titleR
        titleBold = titleB
        btnText = _btnText
        isBtnHidden = _isBtnHidden
        action = _action
    }
}

enum HeaderActionType {
    case RequestViewAll
    
    case BlogAddNew
    case BlogViewAll
}

class HomeCellProvider: CellModelProvider {
    
    typealias CellModelType = HomeCellModel

    var property: (identifier: String, height: CGFloat, model: HomeCellModel?)?
    
    var leadingSwipeConfig: SKSwipeActionConfig?
    
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: (identifier: String, height: CGFloat, model: HomeCellModel?)?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
}

class HomeCellModel {
    var collProvider: CollectionSizeProvider?
    var scrollDirection: UICollectionView.ScrollDirection?
    var collectionItems: [Any]?
    var identifier: String?
    
    var request: Requests?
    
    init(_ _collProvider: CollectionSizeProvider, _ _scrollDirection: UICollectionView.ScrollDirection, _ _collectionItems: [Any]?, _ _identifier: String?) {
        collProvider = _collProvider
        scrollDirection = _scrollDirection
        collectionItems = _collectionItems
        identifier = _identifier
    }
    
    init(_ _request: Requests?) {
        request = _request
    }
}

class CustomService {
    var image: UIImage?
    var title: String?
    
    init(_ _image: UIImage?, _ _title: String?) {
        image = _image
        title = _title
    }
}

