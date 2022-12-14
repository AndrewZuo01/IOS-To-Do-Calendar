//
//  BlinkLabel.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/8/5.
//
import Foundation
import UIKit
//https://stackoverflow.com/questions/56038362/swift-uilabel-blink-textcolor-animated
class BlinkLabel: UILabel, CAAnimationDelegate {

    var colours: [UIColor] = []
    var speed: Double = 1.0
    fileprivate var shouldAnimate = true
    fileprivate var currentColourIndex = 0

    func startBlinking() {
        if colours.count <= 1 {
            /// Can not blink
            return
        }

        shouldAnimate = true
        currentColourIndex = 0
        let toColor = self.colours[self.currentColourIndex]
        animateToColor(toColor)
    }

    func stopBlinking() {
        shouldAnimate = false
        self.layer.removeAllAnimations()
    }

    fileprivate func animateToColor(_ color: UIColor) {

        if !shouldAnimate {return}

        let changeColor = CATransition()
        changeColor.duration = speed
        changeColor.type = .fade
        changeColor.repeatCount = 1
        changeColor.delegate = self
        changeColor.isRemovedOnCompletion = true
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.layer.add(changeColor, forKey: nil)
            self.textColor = color
        }
        CATransaction.commit()
    }

    // MARK:- CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {

            if !self.shouldAnimate {return}

            /// Calculating the next colour
            self.currentColourIndex += 1
            if self.currentColourIndex == self.colours.count {
                self.currentColourIndex = 0
            }

            let toColor = self.colours[self.currentColourIndex]

            /// You can remove this delay and directly call the function self.animateToColor(toColor) I just gave this to increase the visible time for each colour.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                self.animateToColor(toColor)
            })
        }
    }
}

