//
//  AllRequestsVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 20/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class AllRequestsVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    public var dataSource: TableDataSource<HomeSectionProvider, HomeCellProvider, HomeCellModel>?
    private var items: [Requests]?
    private var after: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }

    
    @IBAction func btnAction(_ sender: UIButton) {
        popVC()
    }
}

//MARK:- VCFuncs
extension AllRequestsVC {
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.REQUESTS.localized
    }
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 16.0
        
        dataSource = TableDataSource<HomeSectionProvider, HomeCellProvider, HomeCellModel>.init(.MultipleSection(items: []), tableView, true)
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getRequestsAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getRequestsAPI()
            }
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
//            (cell as? AppointmentCell)?.item = item
//            (cell as? AppointmentCell)?.reloadTable = { [weak self] in
//                self?.items?[indexPath.row].status = item?.property?.model?.request?.status
//                self?.items?[indexPath.row].canCancel = item?.property?.model?.request?.canCancel
//                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func getRequestsAPI(isRefreshing: Bool? = false) {
        EP_Home.requests(date: nil, serviceType: .all, after: /isRefreshing ? nil : after).request(success: { [weak self] (responseData) in
            let response = responseData as? RequestData
            self?.after = response?.after
            if /isRefreshing {
                self?.items = response?.requests ?? []
            } else {
                self?.items = (self?.items ?? []) + (response?.requests ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoRequests, scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: HomeSectionProvider.getApptsWithoutHeader(requests: self?.items ?? [])), .FullReload)
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
}
