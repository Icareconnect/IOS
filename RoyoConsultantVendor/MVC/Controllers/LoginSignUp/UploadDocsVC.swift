//
//  UploadDocsVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 04/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import Lightbox

class UploadDocsVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(DocHeaderView.identfier)
        }
    }
    @IBOutlet weak var btnNext: SKLottieButton!
    
    public var filters: [Filter]? = UserPreference.shared.data?.filters
    public var category: Category?
    private var dataSource: TableDataSource<DocHeaderProvider, DocCellProvider, Doc>?
    private var items = [DocHeaderProvider]()
    
    var isUpdating: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
     
        if /isUpdating {//&& /UserPreference.shared.data?.additionals?.count > 0 {
            getVendorDetailAPI()
        } else {
            getAdditionalDetailAPI()
        }
    }
    
    //MARK: - IBBOutlets
    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        var isValidValues = true
        
        for sectionItems in items {
            if /sectionItems.items?.count == 0 || /sectionItems.items?.first?.property?.model?.file_name == "" {
                isValidValues = false
                Toast.shared.showAlert(type: .validationFailure, message: String.init(format: VCLiteral.ADD_ONE_DOC_ALERT.localized, /sectionItems.headerProperty?.model?.name))
                break
            }
            isValidValues = true
        }
        
        if isValidValues == false {
            return
        }
        
        btnNext.playAnimation()
        let jsonObjArray: [AdditionalDetail] = items.map({ ($0.headerProperty?.model)! })
        let jsonString = JSONHelper<[AdditionalDetail]>().toDictionary(model: jsonObjArray)
        EP_Home.addAdditionalDetails(fields: jsonString).request(success: { [weak self] (response) in
            self?.btnNext.stop()
            UIWindow.replaceRootVC(Storyboard<NavigationTabVC>.TabBar.instantiateVC())
            
        }) { [weak self] (_) in
            self?.btnNext.stop()
        }
    }
}

//MARK:- VCFuncs
extension UploadDocsVC {
    private func manualServicesUpdateAPI() {
        btnNext.playAnimation()
        EP_Login.manualUpdateServices(categoryId: "1"/*String(/category?.id)*/).request(success: { [weak self] (responseData) in
            self?.btnNext.stop()
            UIWindow.replaceRootVC(Storyboard<NavigationTabVC>.TabBar.instantiateVC())
        }) { [weak self] (error) in
            self?.btnNext.stop()
        }
    }
    
    private func localizedTextSetup() {
        btnNext.setTitle(VCLiteral.SUBMIT.localized, for: .normal)
        lblTitle.text = VCLiteral.UPLOAD_DOCS.localized
    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<DocHeaderProvider, DocCellProvider, Doc>.init(.MultipleSection(items: items), tableView)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? DocHeaderView)?.item = item
            (view as? DocHeaderView)?.didTapAdd = { [weak self] in
                let destVC = Storyboard<UploadDocPopUpVC>.LoginSignUp.instantiateVC()
                destVC.modalPresentationStyle = .overFullScreen
                destVC.didTapAdd = { (doc) in
                    self?.addDoc(at: section, doc: doc)
                }
                self?.presentVC(destVC)
            }
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? DocumentCell)?.item = item
            (cell as? DocumentCell)?.didTapFor = { (btnType) in
                switch btnType {
                case .Delete:
                    var tempItems = self.items[indexPath.section].items

                    tempItems?.remove(at: indexPath.row)
                    tempItems?.insert(DocCellProvider.init((DocumentCell.identfier, UITableView.automaticDimension, Doc.init("", "", "", nil, "")), nil, nil), at: 0)

                    self.items[indexPath.section].items = tempItems
                    //self.dataSource?.updateAndReload(for: .MultipleSection(items: self.items), .DeleteRowsAt(indexPaths: [indexPath], animation: .automatic))
                    self.dataSource?.updateAndReload(for: .MultipleSection(items: self.items), .Reload(indexPaths: [indexPath], animation: .automatic))
                    
                case .Edit:
                    let destVC = Storyboard<UploadDocPopUpVC>.LoginSignUp.instantiateVC()
                    destVC.modalPresentationStyle = .overFullScreen
                    destVC.doc = item?.property?.model
                    destVC.didTapAdd = { (doc) in
                        self.addDoc(at: indexPath.section, doc: doc)
//
//                        self.items[indexPath.section].items?[indexPath.row].property?.model = doc
//                        self.dataSource?.updateAndReload(for: .MultipleSection(items: self.items), .Reload(indexPaths: [indexPath], animation: .automatic))
                    }
                    self.presentVC(destVC)
                case .Add:
                    let destVC = Storyboard<UploadDocPopUpVC>.LoginSignUp.instantiateVC()
                    destVC.modalPresentationStyle = .overFullScreen
                    destVC.didTapAdd = { (doc) in
                        self.addDoc(at: indexPath.section, doc: doc)
                        
                    }
                    self.presentVC(destVC)
                }
            }
        }
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            switch /item?.property?.model?.type {
            case MediaTypeUpload.image.rawValue:
                if let imageUrl = URL(string: ImageBasePath.original.url + /item?.property?.model?.file_name) {
                    var images = [LightboxImage]()
                    
                    images.append(LightboxImage(imageURL: imageUrl))
                    
                    let controller = LightboxController(images: images)
                    controller.modalPresentationStyle = .fullScreen
                    self?.present(controller, animated: true, completion: nil)
                    
                }
                
            case MediaTypeUpload.pdf.rawValue:
                let destVC = Storyboard<WebLinkVC>.Other.instantiateVC()
                destVC.linkTitle = (/PDFBasePath.original.url + /item?.property?.model?.file_name , "")
                self?.pushVC(destVC)

            default:
                break
            }
        }
    }
    
    private func getAdditionalDetailAPI() {
        EP_Home.getAdditionalDetails(id: /*category?.id*/ 1).request(success: { [weak self] (responseData) in
            let docTypes = (responseData as? AdditionalDetailsData)?.additional_details
            self?.items = DocHeaderProvider.getSectionWiseData(docTypes)
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
        }) { (error) in
            
        }
    }
    
    private func addDoc(at section: Int, doc: Doc?) {
        guard let document = doc else { return }
        
        items[section].items?.removeAll()
        items[section].items?.append(DocCellProvider.init((DocumentCell.identfier, UITableView.automaticDimension, document), nil, nil))
        let tempDocs: [Doc] = (items[section].items ?? []).map({($0.property?.model)!})
        items[section].headerProperty?.model?.documents = tempDocs

        self.dataSource?.updateAndReload(for: .MultipleSection(items: self.items), .FullReload)
//

//        items[section].items?.insert(DocCellProvider.init((DocumentCell.identfier, UITableView.automaticDimension, document), nil, nil), at: 0)
//        let tempDocs: [Doc] = (items[section].items ?? []).map({($0.property?.model)!})
//        items[section].headerProperty?.model?.documents = tempDocs
//        dataSource?.updateAndReload(for: .MultipleSection(items: items), .AddRowsAt(indexPaths: [IndexPath.init(row: 0, section: section)], animation: .automatic, moveToLastIndex: false))
    }
    
    public func getVendorDetailAPI() {
        playLineAnimation()
        EP_Login.profileUpdate(name: nil, email: nil, phone: nil, country_code: nil, dob: nil, bio: nil, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: nil, workingSince: nil, namePrefix: nil, custom_fields: nil, master_preferences: nil, address: nil, lat: nil, long: nil).request(success: { [weak self] (responseData) in
            
            UserPreference.shared.data = responseData as? User
            
            let docTypes = UserPreference.shared.data?.additionals
            self?.items = DocHeaderProvider.getSectionWiseData(docTypes)
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
            
            self?.stopLineAnimation()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
}

