//
//  QuickSortAlgorithm.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/25/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import Foundation
import SpriteKit

class QuickSortAlgorithm : SortAlgorithm {

    typealias OpType = (start: Int, end: Int)
    enum State {
        case selectPivot
        case sorting(op: OpType, currentIndex: Int,  pivotIndex: Int)
        case sorted
    }

    private(set) var data: [Float]
    private var state: State

    private var opList = [OpType]()


    init(size: Int) {
        data = QuickSortAlgorithm.generateData(size: size)
        state = .sorted
        resetData()
    }

    func generateScene(rate: Double) -> SKScene {
        let result = BarGraphScene(size: CGSize(width: 1000.0, height: 1000.0))
        result.algorithm = self
        result.rate = rate
        return result
    }

    func step() -> [Action]? {

        var actions = [Action]()

        switch state {
        case .selectPivot:
            guard opList.count > 0 else {
                state = .sorted
                return [.clearHighlighted]
            }
            let op = opList.removeFirst()
            actions.append(.clearHighlighted)
            actions.append(.highlight(op.end))

            // TODO: pick a pivot

            state = .sorting(op: op, currentIndex: op.start, pivotIndex: op.end)

        case .sorting(let op, let currentIndex, let pivotIndex):
            var newPovot = pivotIndex
            var newIndex = currentIndex

            if data[currentIndex] > data[pivotIndex] {
                let value = data.remove(at: currentIndex)
                data.insert(value, at: pivotIndex)
                actions.append(.move(currentIndex, pivotIndex))
                newPovot -= 1
            } else {
                newIndex += 1
            }

            if newIndex >= newPovot {
                if op.start < newPovot - 1 {
                    opList.append((start:op.start, end: newPovot - 1))
                }
                if newPovot + 1 < op.end {
                    opList.append((start:newPovot + 1, end: op.end))
                }
                state = .selectPivot
            } else {
                state = .sorting(op: op, currentIndex: newIndex, pivotIndex: newPovot)
            }
        case .sorted:
            return nil
        }

        return actions
    }

    func resetData() {
        opList.removeAll()
        opList.append((start: 0, end: data.count - 1))
        state = .selectPivot
        for _ in 1...10 { data.sort(by: QuickSortAlgorithm.randomComparison ) }
    }

}
