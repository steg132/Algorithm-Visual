//
//  Array+Util.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/24/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import Foundation

extension Array  {
    func isSorted(isOrderedBefore: (Element, Element) -> Bool) -> Bool {
        for i in 1..<self.count {
            if !isOrderedBefore(self[i-1], self[i]) {
                return false
            }
        }
        return true
    }
}
