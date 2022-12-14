//
//  Variable.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/7/25.
//

import Foundation
import UIKit
import SpriteKit

class Variable{
    
    static let shared = Variable()
    var dateYear:Int = 1
    var dateMonth:Int = 1
    var dateDay:Int = 1
    var date:String = ""
    var money:Int = 2
    var currentImage:UIImage = UIImage(named: "bird")!
    
    var focusMode:Bool = true
    var clear:Int = 0
    var Mode:Int = 0
    var scene:GameScene!
    
    var category:Int = 0
    
    var AddOnce:Bool = true
    var DeleteOnce:Bool = true
    var FocusOnce:Bool = true
}
