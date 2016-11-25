//
//  Algorithm.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/23/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import Foundation
import SpriteKit

protocol Algorithm {
    func generateScene(rate: Double) -> SKScene

    func step() -> [Action]?

    func shuffleData()
}

protocol SortAlgorithm: Algorithm {
    var data: [Float] { get }
}

extension SortAlgorithm {
    static func generateData(size: Int) -> [Float] {
        var result = [Float]()
        let increment = 1.0 / Float(size - 1)

        for i in 0...(size-1) {
            result.append( Float(i) * increment )
        }

        return result
    }

    static func randomComparison<T>(s1: T, s2: T) -> Bool {
        return arc4random() % 2 == 0
    }
}
