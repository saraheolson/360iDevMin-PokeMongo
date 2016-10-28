//
//  GameScene.swift
//  PokeMongo
//
//  Created by Floater on 8/21/16.
//  Copyright © 2016 SarahEOlson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // So we can keep track of our monster!
    var monster: SKSpriteNode?

    override func sceneDidLoad() {
        
        // If we don't already have a monster, create one.
        if monster == nil {
            createMonster()
        }
    }
    
    
    // MARK: - Monster functions
    
    func createMonster() {
        
        monster = SKSpriteNode(imageNamed: "PurpleMonster1")
        
        if let monster = self.monster {
            
            monster.position = CGPoint(x: 0, y: frame.height/2)
            monster.zPosition = 2
            
            addChild(monster)
        }
    }

    
    // MARK: - Touch gesture methods
    
    /**
     *  Called when a touch event is initiated.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    /**
     *  Called when a touch event moves.
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    /**
     *  Called when a touch event is ended.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    /**
     *  Called before each frame is rendered.
     */
    override func update(_ currentTime: TimeInterval) {
    }
    
}
