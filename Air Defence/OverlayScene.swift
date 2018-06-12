//
//  OverlayScene.swift
//  Air Defence
//
//  Created by user on 2018/6/11.
//  Copyright © 2018年 NTU. All rights reserved.
//

import UIKit
import SpriteKit

class OverlayScene: SKScene {
    
    //    var pauseNode: SKSpriteNode!
    var scoreNode: SKLabelNode!
    
    var score = 0 {
        didSet {
            self.scoreNode.text = "Score: \(self.score)"
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = UIColor.clear
        
        let spriteSize = size.width/12
        //        self.pauseNode = SKSpriteNode(imageNamed: "Pause Button")
        //        self.pauseNode.size = CGSize(width: spriteSize, height: spriteSize)
        //        self.pauseNode.position = CGPoint(x: spriteSize + 8, y: spriteSize + 8)
        
        self.scoreNode = SKLabelNode(text: "Score: 0")
        self.scoreNode.fontName = "DINAlternate-Bold"
        self.scoreNode.fontColor = UIColor.red
        self.scoreNode.fontSize = 36
        self.scoreNode.position = CGPoint(x: size.width/2, y:
            //            self.pauseNode.position.y - 9
            spriteSize - 1
        )
        
        //        self.addChild(self.pauseNode)
        self.addChild(self.scoreNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //    func addScore(){
    //        //this is a function on the scene. You can pass any variable you want through the function.
    //        score=score+5
    //    }
}
