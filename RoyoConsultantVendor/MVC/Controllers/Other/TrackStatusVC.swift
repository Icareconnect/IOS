//
//  TrackStatusVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 24/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TrackStatusVC: BaseVC {

    //MARK: - IBOutlets
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnStatusUpdate: SKLottieButton!
    @IBOutlet weak var vwUpdateStatus: UIView!

    @IBOutlet weak var imgVwComplete: UIImageView!
    
    public var request: Requests?
    public var didStatusChanged: ((_ status: RequestStatus) -> Void)?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBActions
    @IBAction func actionClose(_ sender: Any) {
        dismissVC()
    }
    
    @IBAction func actionUpdateStatus(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.vwUpdateStatus.alpha = 1.0
        }) { [weak self] (finished) in
            self?.vwUpdateStatus.isHidden = false
        }
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
    
        if !btnComplete.isSelected {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.UPDATE_STATUS.localized)
            return
        } else {
            
            btnStatusUpdate.playAnimation()
            EP_Home.callStatus(requestID: String(/request?.id), status: .completed).request { [weak self] (response) in
                self?.btnStatusUpdate.stop()
                self?.request?.status = .reached
                self?.didStatusChanged?(.completed)
                self?.dismissVC()
                
            } error: { [weak self] (_) in
                self?.btnStatusUpdate.stop()
            }
        }
    }
    
    @IBAction func actionSelectComplete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgVwComplete.isHighlighted = sender.isSelected
    }
    
    @IBAction func actionClear(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.vwUpdateStatus.alpha = 0.0
        }) { [weak self] (finished) in
            self?.vwUpdateStatus.isHidden = true
        }
    }
}
