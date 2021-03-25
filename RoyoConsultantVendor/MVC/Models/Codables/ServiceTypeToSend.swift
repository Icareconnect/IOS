//
//  ServiceTypeToSend.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 01/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class ServiceTypeToSend: Codable {
    var id: Int?
    var available: CustomBool?
    var price: Double?
    var minimmum_heads_up: Int?
    var availability: AvailabilityToSend?
    var isAvailabilityChanged: Bool?

    
    init(_ _id: Int?, _ _available: CustomBool?, _ _price: Double?, _ _minimmum_heads_up: Int?, _ _availability: AvailabilityToSend?, _ _isAvailabilityChanged: Bool?) {
        id = _id
        available = _available
        price = _price
        minimmum_heads_up = _minimmum_heads_up
        availability = _availability
        isAvailabilityChanged = _isAvailabilityChanged
    }
    
    class func getJSONString(_ items: [ServiceCellModel]) -> Any? {
        var array = [ServiceTypeToSend]()
        
        items.forEach { (model) in
            let price = model.service?.price_type == .price_range ? model.service?.price : model.service?.price_fixed
            var days = [Bool]()
            var slots = [SlotToSend]()
            if model.applyOption == .weekwise {
                days = model.weekDays.compactMap({/$0.isSelected})
            }
            model.timeSlots.forEach { (timeSlot) in
                if timeSlot.startTime != nil && timeSlot.endTime != nil {
                    slots.append(SlotToSend.init(timeSlot.startTime?.toString(DateFormat.custom("HH:mm"), timeZone: .local), timeSlot.endTime?.toString(DateFormat.custom("HH:mm"), timeZone: .local)))
                }
            }
            if let option = model.applyOption {
                switch option {
                case .weekwise:
                    array.append(ServiceTypeToSend.init(model.service?.id, model.service?.available ?? .FALSE, price, 5, AvailabilityToSend.init(model.applyOption, nil, nil, days, slots), false))
                case .specific_date, .specific_day:
                    let selectedDate = model.weekDays.first(where: {/$0.isSelected})?.date?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local)
                    array.append(ServiceTypeToSend.init(model.service?.id, model.service?.available ?? .FALSE, price, 5, AvailabilityToSend.init(model.applyOption, nil, selectedDate, nil, slots), true))
                case .weekdays:
                    array.append(ServiceTypeToSend.init(model.service?.id, model.service?.available ?? .FALSE, price, 5, AvailabilityToSend.init(model.applyOption, nil, nil, nil, slots), true))
                }
            } else {
                array.append(ServiceTypeToSend.init(model.service?.id, model.service?.available ?? .FALSE, price, 5, nil, false))
            }
            
            
        }
        return JSONHelper<[ServiceTypeToSend]>().toDictionary(model: array)
        
    }
    
}

class AvailabilityToSend: Codable {
    var applyoption: AvailabilityOptionType?
    var day: Int?
    var date: String?
    var days: [Bool]?
    var slots: [SlotToSend]?
    
    init(_ _type: AvailabilityOptionType?, _ _day: Int?, _ _date: String?, _ _days: [Bool]?, _ _slots: [SlotToSend]?) {
        applyoption = _type
        date = _date
        day = _day
        days = _days
        slots = _slots
    }
}

class SlotToSend: Codable {
    var start_time: String?
    var end_time: String?
    
    init(_ _startTime: String?, _ _endTime: String?) {
        start_time = _startTime
        end_time = _endTime
    }
}

