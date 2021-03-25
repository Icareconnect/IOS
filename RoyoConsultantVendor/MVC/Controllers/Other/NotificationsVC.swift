//
//  NotificationsVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 02/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class NotificationsVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<NotificationModel>, DefaultCellModel<NotificationModel>, NotificationModel>?
    private var items: [NotificationModel]?
    private var after: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
    
}

//MARK:- VCFuncs
extension NotificationsVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.NOTIFICATIONS.localized
    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<NotificationModel>, DefaultCellModel<NotificationModel>, NotificationModel>.init(.SingleListing(items: items ?? [], identifier: NotificationCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? NotificationCell)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getNotificationsAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getNotificationsAPI()
            }
        }
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            if item?.property?.model?.module == "request" {
                let destVC = Storyboard<RequestDetailsVC>.Other.instantiateVC()
                destVC.requestID = "\(/item?.property?.model?.module_id)"
                self?.pushVC(destVC)
            }
        }
        dataSource?.refreshProgrammatically()
    }
    
    private func getNotificationsAPI(isRefreshing: Bool? = false) {
        
        EP_Home.notifications(after: /isRefreshing ? nil : after).request(success: { [weak self] (responseData) in
            let response = (responseData as? NotificationData)
            self?.after = response?.after
            if /isRefreshing {
                self?.items = response?.notifications
            } else {
                self?.items = (self?.items ?? []) + (response?.notifications ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoNotifications, scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
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
