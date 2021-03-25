//
//  Toast.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import SwiftEntryKit

enum AlertType: String {
  case success
  case apiFailure
  case validationFailure
  case notification
  
  var title: String {
    return NSLocalizedString(self.rawValue, comment: "")
  }
  
  var color: UIColor {
    return ColorAsset.appTint.color
  }
}
class Toast {
  
  static let shared = Toast()
  
  func showAlert(type: AlertType, message: String) {
    var attributes = EKAttributes()
    attributes.windowLevel = .statusBar
    attributes.position = .top
    attributes.displayDuration = 2.0
    attributes.entryBackground = .color(color: EKColor.init(type.color))
    attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
    let title = EKProperty.LabelContent.init(text: type.title, style: .init(font: UIFont.systemFont(ofSize: 18), color: EKColor.init(ColorAsset.txtWhite.color)))
    let description = EKProperty.LabelContent.init(text: message, style: .init(font: UIFont.systemFont(ofSize: 14), color: EKColor.init(ColorAsset.txtWhite.color)))
    let simpleMessage = EKSimpleMessage.init(title: title, description: description)
    let notificationMessage = EKNotificationMessage.init(simpleMessage: simpleMessage)
    let contentView = EKNotificationMessageView(with: notificationMessage)
    SwiftEntryKit.display(entry: contentView, using: attributes)
  }
}

