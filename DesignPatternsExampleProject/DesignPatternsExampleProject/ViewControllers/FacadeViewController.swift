//
//  FacadeViewController.swift
//  DesignPatterns
//
//  Created by Consultant on 7/28/23.
//

import Foundation
import UIKit

class FacadeViewController: UIViewController {

    func shoppingAction() {
        let shoppingManager = ShoppingCartManager()
        shoppingManager.checkoutOfItems(items: ["iPhone", "Airpods", "Cable"], payment: .card, to: "123 flowers RD, 1234, apt. 1928")
    }
}

