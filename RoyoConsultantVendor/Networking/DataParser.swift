//
//  DataParser.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//


import Foundation
import Moya

extension TargetType {
    
    func parseModel(data: Data) -> Any? {
        switch self {
        //EP_Login Endpoint
        case is EP_Login:
            let endpoint = self as! EP_Login
            switch endpoint {
            case .login,
                 .profileUpdate,
                 .register,
                 .updatePhone,
                 .manualUpdateServices:
                let response = JSONHelper<CommonModel<User>>().getCodableModel(data: data)?.data
                UserPreference.shared.data = response
                return response
            case .getFilters:
                return JSONHelper<CommonModel<FilterData>>().getCodableModel(data: data)?.data
            case .getMasterPreferences, .getMasterDuty:
                return JSONHelper<CommonModel<PreferenceData>>().getCodableModel(data: data)?.data

            default:
                return nil
            }
        case is EP_Home:
            let endPoint = self as! EP_Home
            switch endPoint {
            case .uploadImage:
                return JSONHelper<CommonModel<ImageUploadData>>().getCodableModel(data: data)?.data
            case .categories:
                return JSONHelper<CommonModel<CategoryData>>().getCodableModel(data: data)?.data
            case .getFilters:
                return JSONHelper<CommonModel<FilterData>>().getCodableModel(data: data)?.data
            case .services:
                return JSONHelper<CommonModel<ServicesData>>().getCodableModel(data: data)?.data
            case .updateServices:
                let response = JSONHelper<CommonModel<User>>().getCodableModel(data: data)?.data
                UserPreference.shared.data = response
                return response
            case .transactionHistory:
                return JSONHelper<CommonModel<TransactionData>>().getCodableModel(data: data)?.data
            case .wallet:
                return JSONHelper<CommonModel<WalletBalance>>().getCodableModel(data: data)?.data
            case .requests:
                return JSONHelper<CommonModel<RequestData>>().getCodableModel(data: data)?.data
            case .acceptRequest,
                 .startChat,
                 .cancelRequest,
                 .addClass,
                 .updateFCMId,
                 .endChat,
                 .updateClassStatus:
                return nil
            case .logout:
                UserPreference.shared.data = nil
                UserPreference.shared.firebaseToken = nil
                return nil
            case .notifications:
                return JSONHelper<CommonModel<NotificationData>>().getCodableModel(data: data)?.data
            case .chatListing:
                return JSONHelper<CommonModel<ChatData>>().getCodableModel(data: data)?.data
            case .chatMessages:
                return JSONHelper<CommonModel<MessagesData>>().getCodableModel(data: data)?.data
            case .vendorDetail:
                return JSONHelper<CommonModel<VendorDetailData>>().getCodableModel(data: data)?.data?.vendor_data
            case .getSlots:
                return JSONHelper<CommonModel<SlotsData>>().getCodableModel(data: data)?.data
            case .classes:
                return JSONHelper<CommonModel<ClassesData>>().getCodableModel(data: data)?.data
            case .revenue:
                return JSONHelper<CommonModel<RevenueData>>().getCodableModel(data: data)?.data
            case .makeCall, .callStatus(_, _):
                return nil
            case .startRequest:
                return nil
            case .appversion:
                let obj = JSONHelper<CommonModel<AppData>>().getCodableModel(data: data)?.data
                return obj
            case .pages:
                return JSONHelper<CommonModel<PagesData>>().getCodableModel(data: data)?.data?.pages
            case .addBank, .banks:
                return JSONHelper<CommonModel<BanksData>>().getCodableModel(data: data)?.data
            case .payouts:
                return nil
            case .addMoney(_, _):
                return JSONHelper<CommonModel<StripeData>>().getCodableModel(data: data)?.data
            case .addCard, .cards:
                return JSONHelper<CommonModel<CardsData>>().getCodableModel(data: data)?.data
            case .deleteCard, .updateCard:
                return nil
            case .getClientDetail:
                let obj = JSONHelper<CommonModel<ClientDetail>>().getCodableModel(data: data)?.data
                UserPreference.shared.clientDetail = obj
                return obj
            case .getAdditionalDetails:
                return JSONHelper<CommonModel<AdditionalDetailsData>>().getCodableModel(data: data)?.data
            case .addAdditionalDetails:
                return nil
            case .addFeed(_, _, _, _):
                return JSONHelper<CommonModel<FeedsData>>().getCodableModel(data: data)?.data?.feed
            case .getFeeds(_, _, _, _),
                 .viewFeed,
                 .addFav(_, _):
                return JSONHelper<CommonModel<FeedsData>>().getCodableModel(data: data)?.data
            case .requestDetail:
                return JSONHelper<CommonModel<RequestDetailsData>>().getCodableModel(data: data)?.data

            }
        default:
            return nil
        }
        
    }
}
