//
//  SKDatePicker.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SKDatePicker: UIDatePicker {
    
    typealias DidSelectDate = (_ item: Date) -> ()
    
    var didSelectDate: DidSelectDate?
    
    init(frame: CGRect, mode: UIDatePicker.Mode = .date, maxDate: Date?, minDate: Date?, interval: Int? = nil, configureDate: @escaping DidSelectDate) {
        super.init(frame: frame)
        self.datePickerMode = mode
        self.maximumDate = maxDate
        self.minimumDate = minDate
        self.addTarget(self, action: #selector(dateSlected(sender:)), for: .valueChanged)
        if let intervalInMinutes = interval {
            self.minuteInterval = intervalInMinutes
        }
        if #available(iOS 13.4, *) {
            self.preferredDatePickerStyle = .wheels
        }
        
        self.didSelectDate = configureDate
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @objc func dateSlected(sender: UIDatePicker) {
        if let block = didSelectDate {
            block(sender.date)
        }
    }
}

protocol SKGenericPickerModelProtocol {
    
    associatedtype ModelType
    
    var title: String? { get set }
    var model: ModelType? { get set }
    
    init(_ _title: String?, _ _model: ModelType?)
}

class SKGenericPicker<T: SKGenericPickerModelProtocol>: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    typealias DidSelectItem = (_ item: T?) -> ()

    public var configureItem: DidSelectItem?
    private var items: [T]?
    
    init(frame: CGRect, items: [T]?, configureItem: @escaping DidSelectItem) {
        super.init(frame: frame)
        self.configureItem = configureItem
        self.items = items
        super.dataSource = self
        super.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return /items?.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items?[row].title
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let item = configureItem {
            item(items?[row])
        }
    }
}



