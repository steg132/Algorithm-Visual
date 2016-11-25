//
//  BubbleSortAlgorithm.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/24/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import Foundation
import SpriteKit

class BubbleSortAlgorithm: SortAlgorithm {

    enum State {
        case sorting(index: Int)
        case sorted
    }

    private(set) var data: [Float]
    private var state: State

    init(size: Int) {
        assert(size > 2)
        data = BubbleSortAlgorithm.generateData(size: size)
        state = .sorting(index: 1)
        shuffleData()
    }

    func shuffleData() {
        state = .sorting(index: 1)
        for _ in 1...10 {
            data = data.sorted(by: BubbleSortAlgorithm.randomComparison )
        }
    }

    func generateScene(rate: Double) -> SKScene {
        let result = BarGraphScene(size: CGSize(width: 1000.0, height: 1000.0))
        result.algorithm = self
        result.rate = rate
        return result
    }

    func step() -> [Action]? {
        guard case .sorting(let index) = state else { return nil }
        guard !(data.isSorted() { $0 < $1 }) else { state = .sorted; return nil }

        var result: [Action] = []

        if data[index-1] > data[index] {
            let tmp = data[index - 1]
            data[index - 1] = data[index]
            data[index] = tmp

            result.append(.swap(index-1, index))
        }

        if index == data.count - 1 {
            state = .sorting(index: 1)
        } else {
            state = .sorting(index: index + 1)
        }

        return result
    }
}
