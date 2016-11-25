//
//  Action.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/23/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import Foundation

enum Action {
    case swap(Int, Int)
    case move(Int, Int)
    case merge(start: Int, indices:[Int])
}

