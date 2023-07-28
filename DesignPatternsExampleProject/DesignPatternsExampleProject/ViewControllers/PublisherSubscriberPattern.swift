//
//  PublisherSubscriberPattern.swift
//  DesignPatterns
//
//  Created by Consultant on 7/28/23.
//

import UIKit

class PublisherSubscriberPatternViewController: UIViewController {

    @IBAction func newSubscriptionTap(_ sender: Any) {
        testPublisherSubsciberPattern()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
    }

    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(myFuncObserving), name: .somethingHappened, object: nil)
    }

    @objc func myFuncObserving() {
        print("The user made a new subscription!")
    }

    func testPublisherSubsciberPattern() {
        let myPub = MyPublisher()
        myPub.doSubscriptionWorks()
    }


}
