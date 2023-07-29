//
//  FactoryViewController.swift
//  DesignPatterns
//
//  Created by Andres D. Paladines on 7/28/23.
//

import UIKit

class FactoryViewController: UIViewController {

    @IBAction func runFactoryTap(_ sender: Any) {
        testFactoryDesignPattern()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func testFactoryDesignPattern() {
        let factory = SubscriptionFactory()
        let premium = factory.createUsers(type: .premium)
        premium?.checkUserType()
    }

    func checkUserType() {
        let factory = SubscriptionFactory()
        let normal = factory.createUsers(type: .normal)
        normal?.checkUserType()
    }

}
