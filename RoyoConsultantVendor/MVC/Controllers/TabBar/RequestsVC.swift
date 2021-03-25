//
//  RequestsVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 01/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class RequestsVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(HomeHeaderView.identfier)
        }
    }
    public var dataSource: TableDataSource<DefaultHeaderFooterModel<Requests>, DefaultCellModel<Requests>, Requests>?
    private var items: [Requests]?

    private var after: String?
    private var currentSelectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
//        #if !DEBUG
        
        if /UserPreference.shared.data?.account_verified == false {

            let destVC = Storyboard<VerificationPendingVC>.LoginSignUp.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            pushVC(destVC, animated: false)
            //            //            present(destVC, animated: false, completion: nil)
        } else {
            dataSource?.refreshProgrammatically()

        }
        //
//        #endif
    }
    @IBAction func ntmSideMenuAction(_ sender: UIButton) {
        toggleSideMenuView()
    }
    
    @IBAction func actionNotifications(_ sender: UIButton) {
        
        pushVC(Storyboard<NotificationsVC>.Other.instantiateVC())
    }
}

//MARK:- VCFuncs
extension RequestsVC {
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 16.0
        dataSource = TableDataSource<DefaultHeaderFooterModel<Requests>, DefaultCellModel<Requests>, Requests>.init(.SingleListing(items: items ?? [], identifier: AppointmentCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            if /UserPreference.shared.data?.account_verified == false {
                self?.getProfileAPI()
            } else {
                self?.getRequestsAPI(isRefreshing: true)
            }
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getRequestsAPI()
            }
        }
        dataSource?.configureCell = { (cell, item, indexPath) in

            (cell as? AppointmentCell)?.item = item
            (cell as? AppointmentCell)?.reloadTable = { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            
            let destVC = Storyboard<RequestDetailsVC>.TabBar.instantiateVC()
            destVC.item = item?.property?.model//?.request
            destVC.reloadTable = {
                self?.dataSource?.refreshProgrammatically()
            }
            self?.pushVC(destVC)
        }
    }
    
    private func getProfileAPI() {
        EP_Home.vendorDetail(vendorId: String(/UserPreference.shared.data?.id)).request(success: { [weak self] (responseData) in
            let userData = (responseData as? User)
//            if /userData?.account_verified {
                let tempData = UserPreference.shared.data
                tempData?.account_verified = true
                UserPreference.shared.data = tempData
                self?.getRequestsAPI()
//            } else {
//                self?.dataSource?.stopInfiniteLoading(.FinishLoading)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
//                    self?.showVCPlaceholder(type: .AccountNotApproved, scrollView: self?.tableView)
//                }
//            }
        }) { [weak self] (_) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
        }
    }
    
    private func getRequestsAPI(isRefreshing: Bool? = false) {
        EP_Home.requests(date: nil, serviceType: .all, after: /isRefreshing ? nil : after).request(success: { [weak self] (responseData) in
            let response = responseData as? RequestData
            self?.after = response?.after
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /isRefreshing {
                self?.items = response?.requests
            } else {
                self?.items = (self?.items ?? []) + (response?.requests ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoRequests, scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
            
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /self?.dataSource?.getMultipleSectionItems().count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    public func reloadViaNotification() {
        guard let _ = tableView  else {
            return
        }
        errorView.removeFromSuperview()
        getRequestsAPI(isRefreshing: true)
    }

}
