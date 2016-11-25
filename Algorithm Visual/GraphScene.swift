//
//  BarGraphScene.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/23/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import Foundation
import SpriteKit

class BarGraphScene: SKScene {

    var algorithm: SortAlgorithm!

    var rate: Double = 1.0

    var bars: [SKNode] = []

    private var dataCount: Int { return algorithm.data.count }

    private var barWidth: CGFloat { return size.width / CGFloat(dataCount) }

    override func didMove(to view: SKView) { createContent() }

    private var createdContent = false
    private func createContent() {
        guard !createdContent else { return }

        backgroundColor = UIColor.black

        createNodes()

        // Do On Success
        createdContent = true
    }

    func createNodes() {
        bars = bars.filter() { $0.removeFromParent(); return false }
        let barWidth: CGFloat = (size.width / CGFloat(dataCount))
        let saturation = CGFloat(arc4random_uniform(75) + 25) / 100.0
        let brightness = CGFloat(arc4random_uniform(30) + 70) / 100.0


        for (index, value) in algorithm.data.enumerated() {
            let barHeight = size.height * CGFloat(value)
            let color = UIColor(hue: CGFloat(value), saturation: saturation,
                                brightness: brightness, alpha: 1.0)
            let node = SKSpriteNode(color: color,
                                    size: CGSize(width: barWidth, height: barHeight))
            node.anchorPoint = CGPoint(x: 0.5, y: 0)
            node.position = barPosition(at: index)
            scene?.addChild(node)
            bars.append(node)
        }
    }

    private func barPosition(at index: Int) -> CGPoint {
        let posY: CGFloat = 0.0

        let segment = size.width / CGFloat(dataCount)

        let posX = (segment * CGFloat(index)) + (segment * 0.5)

        return CGPoint(x: posX, y: posY)
    }

    var nextStep: TimeInterval?
    override func update(_ currentTime: TimeInterval) {
        guard nextStep == nil || nextStep! < currentTime else {
            return
        }

        guard var actions = algorithm.step() else { return }
        while actions.count == 0 {
            guard let a = algorithm.step() else { return }
            actions = a
        }

        for action in actions {
            switch action {
            case .swap(let s1, let s2):

                let left = bars[s1]
                let right = bars[s2]

                left.run(SKAction.move(to: barPosition(at: s2), duration: 1.0 * rate))
                right.run(SKAction.move(to: barPosition(at: s1), duration: 1.0 * rate))

                nextStep = currentTime + 1.0 * rate

                bars[s1] = right
                bars[s2] = left
            case .move(let start, let end):
                bars[start].run(SKAction.move(to: barPosition(at: end), duration: 1.0 * rate))
            case .merge(let start, let indices):
                var newBars = [SKNode]()
                for index in indices {
                    let bar = bars[index]
                    newBars.append(bar)
                    let newIndex = start + newBars.count - 1

                    bar.run(SKAction.move(to: barPosition(at: newIndex), duration: 1.0 * rate))
                }
                bars.replaceSubrange(start...(start + newBars.count - 1), with: newBars)

                nextStep = currentTime + 1.0 * rate

            }
        }
    }
}
