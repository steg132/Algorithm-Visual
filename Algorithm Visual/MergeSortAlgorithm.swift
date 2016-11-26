//
//  MergeSortAlgorithm.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/24/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import Foundation
import SpriteKit

class MergeSortAlgorithm: SortAlgorithm {
    typealias OpType = (start: Int, mid: Int, end: Int)

    private(set) var data: [Float]
    private var opStack = [OpType]()

    init(size: Int) {
        assert(size > 2)
        data = MergeSortAlgorithm.generateData(size: size)
        resetData()
    }

    func resetData() {
        for _ in 1...10 {
            data = data.sorted(by: BubbleSortAlgorithm.randomComparison )
        }
        clearOpStack()
        buildOpStack()
    }

    func generateScene(rate: Double) -> SKScene {
        let result = BarGraphScene(size: CGSize(width: 1000.0, height: 1000.0))
        result.algorithm = self
        result.rate = rate
        return result
    }

    func step() -> [Action]? {
        guard let op = opStack.popLast() else { return nil }

        var leftIndex = op.start
        var rightIndex = op.mid + 1

        var newData = [Float]()
        var newIndexes = [Int]()

        for _ in op.start...op.end {
            if leftIndex <= op.mid && (rightIndex >= op.end+1 || data[leftIndex] < data[rightIndex]) {
                newData.append(data[leftIndex])
                newIndexes.append(leftIndex)
                leftIndex += 1
            } else {
                newData.append(data[rightIndex])
                newIndexes.append(rightIndex)
                rightIndex += 1
            }
        }

        data.replaceSubrange(op.start...op.end, with: newData)

        return [Action.merge(start: op.start, indices: newIndexes)]
    }

    private func clearOpStack() {
        opStack.removeAll()
    }
    private func buildOpStack(start _start: Int? = nil, end _end: Int? = nil) {
        let start: Int = _start ?? 0
        let end: Int = _end ?? (data.count - 1)
        let mid: Int = start + (end - start) / 2

        let op: OpType = (start: start, mid: mid, end: end)

        opStack.append(op)

        if mid+1 < end {
            buildOpStack(start: mid + 1, end: end)
        }
        if mid > start {
            buildOpStack(start: start, end: mid)
        }
    }
}
