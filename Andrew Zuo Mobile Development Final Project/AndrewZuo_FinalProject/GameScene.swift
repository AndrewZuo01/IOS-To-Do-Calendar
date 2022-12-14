//
//  GameScene.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/7/28.
//

import Foundation
import UIKit
import SpriteKit
import SwiftUI

class GameScene: SKScene {
    var node = SKSpriteNode()
    var startTouch = CGPoint()
    var endTouch = CGPoint()
    var nodePosition = CGPoint()
    override func didMove(to view: SKView) {
        Variable.shared.scene = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        let background = SKSpriteNode(imageNamed: "house")
        background.size = self.frame.size
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.name = "background"
        addChild(background)
        
        
        //https://forums.raywenderlich.com/t/my-background-image-wont-fill-up-the-screen-it-keeps-getting-cropped/26439/2
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        startTouch = CGPoint()
        let location = touch.location(in: self)
        print("????")
        print(Variable.shared.category)
        if(Variable.shared.money > 0 && Variable.shared.Mode == 0){
            
            Variable.shared.money -= 1
            let theImage = Variable.shared.currentImage
            let Texture = SKTexture(image: theImage)
            let mySprite = SKSpriteNode(texture: Texture, size: CGSize(width: 50, height: 50))
            mySprite.position = location
            mySprite.physicsBody?.affectedByGravity = false;
            if(Variable.shared.category == 0){
                mySprite.name = "pets"
            }
            if(Variable.shared.category == 1){
                mySprite.name = "furnitures"
            }
            self.addChild(mySprite)
        }
        else if(Variable.shared.money <= 0 && Variable.shared.Mode == 0){
            let alert = UIAlertController(title: "0 coins!", message: "You can get coins when you finsih events under focus mode", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

        }
        if(Variable.shared.Mode == 1){
            startTouch = location
            if(nodes(at: location).count > 0){
                node = nodes(at: location)[0] as! SKSpriteNode
                nodePosition = node.position
            }
        }
        if(Variable.shared.Mode == 2){
            startTouch = location
            if(nodes(at: location).count > 0){
                node = nodes(at: location)[0] as! SKSpriteNode
                node.removeFromParent()
            }
        }
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            let touch = touches.first
        if(Variable.shared.Mode == 1){
            if let location = touch?.location(in: self){
                if(node.name != "background"){
                    node.run(SKAction.move(to: CGPoint(x:  nodePosition.x + location.x - startTouch.x, y: nodePosition.y + location.y - startTouch.y), duration: 0.1))}
            }
        }
    }

}
