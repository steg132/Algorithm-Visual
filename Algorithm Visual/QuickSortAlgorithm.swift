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
            guard let op = opList.popLast() else {
                state = .sorted
                return [.clearHighlighted]
            }
            actions.append(.clearHighlighted)

            if op.end - op.start > 2 {
                // TODO: pick a pivot

                let first = op.start
                let last = op.end
                let mid = (last - first) / 2 + first

                let mean = (data[first] + data[mid] + data[last]) / 3.0

                let pivot: Int
                if abs(mean - data[first]) < abs(mean - data[mid]) {
                    if abs(mean - data[first]) < abs(mean - data[last]) { pivot = first
                    } else { pivot = last }
                } else {
                    if abs(mean - data[mid]) < abs(mean - data[last]) { pivot = mid
                    } else { pivot = last }
                }

                actions.append(.move(pivot, op.end))
                data.insert(data.remove(at:pivot), at: op.end)
            }
            actions.append(.highlight(op.end))
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
                if newPovot + 1 < op.end {
                    opList.append((start:newPovot + 1, end: op.end))
                }
                if op.start < newPovot - 1 {
                    opList.append((start:op.start, end: newPovot - 1))
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
