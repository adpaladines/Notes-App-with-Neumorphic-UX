//
//  PublisherSubscriberPattern.swift
//  DesignPatterns
//
//  Created by Andres D. Paladines on 7/28/23.
//
/*
 Publisher Subscriber Pattern
 Also known as Observer Pattern
  - This is one to many communication (one class many views can be modified).
  - This avoid tight coupling of code.


 */
import Foundation
import UIKit

extension Notification.Name {
    static let somethingHappened = Notification.Name("PurchasedFinished")

}

class MyPublisher {

    func doSubscriptionWorks() {
        print("Pushing in a notification what I am doing.")
        NotificationCenter.default.post(name: NSNotification.Name.somethingHappened, object: "Subscribed!")
    }
}
