//
//  ViewController.swift
//  DesignPatterns
//
//  Created by Andres D. Paladines on 7/27/23.
//

import UIKit
/*
 ArchitecturePatterns -> One Single for whole project:
    1. MVC
    2. MVVM -> Model View ViewModel
    3. MVVM-C -> Model View ViewModel Coordinator (Coordinator Pattern)
    4. MVP -> Model View Presenter (this is an old arq not much used now)
    5. TCA -> Clean Architecture
    6. VIPER -> View Interactor Presenter Entity Router

 Design patterns -> Group of smaller related classes, modules or sub functionalities inside one project. In one project can be multiple Design Patterns used:
    1. Creational Design Patterns -> Anything related to Object creation of class, comes under this category (one to one comunication, one to many, etc).
    2. Behavieour Design Patterns -> How your projects are going to comunicate or pass data around or bahave.
    3. Structural Design Patterns: How you assemble objects and classes into a larger group.


 A. Creational Design
    1. Singleton
    2. Factory Design Pattern / Factory Method
    3. Builder
    4. Prototype

 B. Behavioural Design Pattern
    1. Observer Pattern
    2. Chain of responsibility
    3. Memento
    4. Iterator

 C. Structural Design Pattern
    1. Adaptor pattern (Protocol delegate)
    2. Decorator
    3. Facade Design Pattern


 `let obj = User()`

 */
class ViewController: UIViewController {

    @IBAction func doLogInTap(_ sender: Any) {
        doLogIn()
    }
    @IBAction func checkDetailsTap(_ sender: Any) {
        checkDetails()
    }
    @IBAction func logOutTap(_ sender: Any) {
        doLogOut()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
    }
    //MARK: Singleton Pattern
    func doLogIn() {
        let authManager = AuthenticationManager.shared
        authManager.doLogin(token: "my-auth-token")

    }

    func checkDetails() {
        let auth = AuthenticationManager.shared
        print("Is logged In? \(auth.isLoggedIn ? "YES" : "NO")")
        print("Token is: \(auth.authToken)")
    }


    func doLogOut() {
        let auth = AuthenticationManager.shared
        auth.doLogount()
    }

    //MARK: Factory Pattern
    func testFactoryDesignPattern() {

        let factory = SubscriptionFactory()
        let premium = factory.createUsers(type: .premium)
        premium?.checkUserType()

        let normal = factory.createUsers(type: .normal)
        normal?.checkUserType()
    }

    //MARK: Observer Pattern
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(myFuncObserving), name: .somethingHappened, object: nil)
    }

    @objc func myFuncObserving() {
        print("ViewController First Screen!\nThe user made a new subscription!")
    }

}

