//
//  ShoppingCartManager.swift
//  DesignPatterns
//
//  Created by Consultant on 7/28/23.
//
/*
 Facade Design Pattern
 - It's a structural design pattern
 - Provides a simplified interface to a complex system
 - It acts as an intermediary between client and complex system

 */

extension Array {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
import Foundation

class ShoppingCartManager {
    private let inventory = Inventory()
    private let paymentProcessor = PaymentProcessor()
    private let paymentAddressManager = ShippingAddressManager()
    private let paymentMethod: PaymentType = .cash

    func checkoutOfItems(items:[String], payment: PaymentType, to shipingAddress: String) {
        guard inventory.checkAvailabilityOfItems(for: items) else {
            return
        }

        guard paymentProcessor.processPayment(method: paymentMethod) else {
            return
        }

        guard paymentAddressManager.ship(items: items, to: shipingAddress) else {
            return
        }

        print("Order was delivered!")
    }
}

class Inventory {
    func checkAvailabilityOfItems(for items: [String]) -> Bool {
//        check intertory status
        return items.isNotEmpty
    }

}

enum PaymentType {
    case cash
    case card
    case transfer
}
class PaymentProcessor {
    func processPayment(method: PaymentType) -> Bool {
        switch method {
        case .cash, .card:
            return true
        case .transfer:
            return false
        }
    }
}


class ShippingAddressManager {
    func ship(items: [String], to address: String) -> Bool {
        //backed call for api to ship items to those specific address
        return true
    }
}
