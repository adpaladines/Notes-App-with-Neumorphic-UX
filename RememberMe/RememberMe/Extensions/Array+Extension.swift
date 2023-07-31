//
//  Array+Extension.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import Foundation

extension Array {

    var isNotEmpty: Bool {
        !isEmpty
    }
    
    var isEven: Bool {
        count % 2 == 0
    }
}
