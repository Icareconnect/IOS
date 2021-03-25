//
//  E nums.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 27/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }

extension CaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

enum ProviderType: String, Codable, CaseIterableDefaultsLast{
    case facebook
    case google
    case email
    case phone
    case apple
    
    case unknown
}

enum UserType: String {
    case customer
    case service_provider
}

enum DocStatus: String, Codable, CaseIterableDefaultsLast{
    case in_progress
    case declined
    case approved
}

enum CustomBool: String, Codable, CaseIterableDefaultsLast {
    case TRUE = "1"
    case FALSE = "0"
}

enum PriceType: String, Codable, CaseIterableDefaultsLast {
    case fixed_price
    case price_range
    
    func getRelatedText(model: Service?) -> String {
        switch self {
        case .fixed_price:
            return VCLiteral.FIXED_PRICE.localized
        case .price_range:
            return String.init(format: VCLiteral.PRICE_RANGE.localized, /model?.price_minimum?.roundedString(toPlaces: 2), /model?.price_maximum?.roundedString(toPlaces: 2))
        }
    }
}

enum AvailabilityOptionType: String, Codable, CaseIterable {
    case weekwise
    case specific_date
    case specific_day
    case weekdays
}

enum ServiceType: String {
    case chat
    case call
    case home
    case all
}

enum TransactionType: String, Codable, CaseIterableDefaultsLast {
    case deposit
    case withdrawal
    case payouts
    case add_money
    
    case all
    
    var transactionText: VCLiteral {
        switch self {
        case .withdrawal:
            return .NA
        case .deposit:
            return .RECEIVED_FROM
        case .payouts:
            return .MONEY_SENT_TO_BANK
        case .all:
            return .NA
        case .add_money:
            return .ADDED_TO_WALLET
        }
    }
}

enum RequestStatus: String, Codable, CaseIterableDefaultsLast {
    case pending
    case inProgress = "in-progress"
    case accept
    case completed
    case start_service
    case noAnswer = "no-answer"
    case busy
    case failed
    case canceled
    case start
    case reached
    case cancel_service
    case unknown

    var linkedColor: ColorAsset {
        switch self {
        case .noAnswer:
            return .requestStatusNoAnswer
        case .busy:
            return .requestStatusBusy
        case .failed, .canceled:
            return .requestStatusFailed
        case .unknown:
            return .appTint
        case .start_service, .start, .reached:
            return .appTint
        case .failed, .cancel_service:
            return .requestStatusFailed
        default:
            return .appTint
        }
    }
    
    var title: VCLiteral {
        switch self {
        case .pending:
            return .NEW
        case .inProgress:
            return .INPROGRESS
        case .accept:
            return .ACCEPT
        case .completed:
            return .COMPLETE
        case .noAnswer:
            return .NO_ANSWER
        case .busy:
            return .BUSY
        case .failed:
            return .FAILED
        case .unknown:
            return .NA
        case .canceled, .cancel_service:
            return .CANCELLED
        case .start_service:
            return .STARTED
        case .start:
            return .INPROGRESS
        case .reached:
            return .REACHED
        }
    }
}

enum AddMoneyAmounts: Int {
    case Amount1 = 500
    case Amount2 = 1000
    case Amount3 = 1500
    
    var formattedText: String {
        return "+ " + /Double(self.rawValue).getFormattedPrice()
    }
}

extension String {
    var experience: String {
        if self == "1" {
            return String.init(format: VCLiteral.YR_EXP.localized, /self)
        } else if /self == "" {
            return ""
        } else {
            return String.init(format: VCLiteral.YRS_EXP.localized, /self)
        }
    }
}

enum ClassStatus: String, Codable, CaseIterableDefaultsLast {
    case started
    case completed
    case added
    case Default
}

enum ClassType: String, Codable, CaseIterableDefaultsLast {
    case USER_COMPLETED
    case USER_OCCUPIED
    case VENDOR_ADDED
    case VENDOR_COMPLETED
    case USER_SIDE
    case DEFAULT
}

enum CallStatus: String, Codable, CaseIterableDefaultsLast {
    case CALL_RINGING
    case CALL_ACCEPTED
    case CALL_CANCELED
    case start
    case reached
    case start_service
    case cancel_service
    case completed

}

enum CallType: String {
    case Incoming
    case Outgoing
}

enum AppType: String {
    case UserApp = "1"
    case VendorApp = "2"
}

enum AppUpdateType: Int, Codable, CaseIterableDefaultsLast {
    case MajorUpdate = 2
    case MinorUpdate = 1
    case NoUpdate = 0
}

enum FeedType: String, CaseIterableDefaultsLast, Codable {
    case blog
    case article
    case na
    case faq
    
    var title: String? {
        switch self {
        case .article:
            return VCLiteral.POST_ARTICLE.localized.replacingOccurrences(of: "+", with: "")
        case .blog:
            return VCLiteral.POST_BLOG.localized.replacingOccurrences(of: "+", with: "")
        default:
            return nil
        }
    }
    
    var btnTitle: String {
        switch self {
        case .article:
            return VCLiteral.POST_ARTICLE.localized
        case .blog:
            return VCLiteral.POST_BLOG.localized
        default:
            return ""
        }
    }
    
    var listingTitle: String {
        switch self {
        case .article:
            return VCLiteral.ARTICLES.localized
        case .blog:
            return VCLiteral.BLOGS.localized
        default:
            return ""
        }
    }
}
enum MediaTypeUpload: String, Codable, CaseIterableDefaultsLast {
    case pdf = "PDF"
    case image = "IMAGE"
}

