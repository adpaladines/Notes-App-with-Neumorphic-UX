//
//  FactoryDesignPattern.swift
//  DesignPatterns
//
//  Created by Andres D. Paladines on 7/28/23.
//
/*
 Factory Design Pattern:
 It's a creational Design pattern.
 Provides an interface of creating objects of different types just by passing one parameter.

 */

import Foundation

enum UserType {
    case normal
    case premium
    case superPremium
}

class SubscriptionFactory {
    
    func createUsers(type: UserType) -> User? {
        switch type {
        case .normal:
            return Normal()
        case .premium:
            return Premium()
        case .superPremium:
            print("Super Premium users still in development process.")
            return nil
        }
    }
}

protocol User {
    func checkUserType()
    func doXYZTask()
}

class Normal: User {
    func checkUserType() {
        print("This is a normal user.")
    }

    func doXYZTask() {
        print("Doing task by a normal user.")
    }
}

class Premium: User {
    func checkUserType() {
        print("This is a PREMIUM user.")
    }

    func doXYZTask() {
        print("Doing task by a PREMIUM user.")
    }

    func doExtraFunctionalities() {
        print("This function is only for premium users.")
    }
}

class SuperPremium: User {
    func checkUserType() {
        print("This is a PREMIUM user.")
    }

    func doXYZTask() {
        print("Doing task by a PREMIUM user.")
    }

    func doExtraFunctionalities() {
        print("This function is only for premium users.")
    }
}
