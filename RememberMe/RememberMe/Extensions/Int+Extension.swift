//
//  Int+Extension.swift
//  RememberMe
//
//  Created by andres paladines on 7/30/23.
//

import Foundation

extension Int {
    var isEven: Bool {
        self % 2 == 0
    }
    
    var isOdd: Bool {
        self % 2 != 0
    }
}
