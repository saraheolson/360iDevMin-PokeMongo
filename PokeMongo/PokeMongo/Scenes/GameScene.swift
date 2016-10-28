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

    // So we can keep track of our ball!
    var ball: SKSpriteNode?

    override func sceneDidLoad() {
        
        // If we don't already have a monster, create one.
        if monster == nil {
            createMonster()
        }
        
        // Add a ball to the scene
        if ball == nil {
            createBall()
        }
    }
    
    // MARK: - Ball functions
    
    /**
     * Create a ball node and add it to the scene.
     */
    func createBall() {
        
        // Create the ball node
        ball = SKSpriteNode(imageNamed: "Ball")
        if let ball = ball {
            
            // Set position and scale
            ball.position = CGPoint(x: 0, y: 100)
            ball.zPosition = 2
            ball.scale(to: CGSize(width: 50, height: 50))
            
            // Add to the scene
            addChild(ball)
        }
    }

    
    // MARK: - Monster functions
    
    func createMonster() {
        
        // Create the monster from an atlas instead of an image
        let textureAtlas = SKTextureAtlas(named: "PurpleMonster.atlas")
        let spriteArray = [textureAtlas.textureNamed("PurpleMonster1"),
                           textureAtlas.textureNamed("PurpleMonster2")]
        monster = SKSpriteNode(texture: spriteArray[0])
        
        if let monster = self.monster {
            
            monster.position = CGPoint(x: 0, y: frame.height/2)
            monster.zPosition = 2
            
            moveMonster()
            
            // Animate our monster
            let animateAction = SKAction.animate(with: spriteArray, timePerFrame: 0.2)
            let repeatAnimation = SKAction.repeatForever(animateAction)
            monster.run(repeatAnimation)

            addChild(monster)
        }
    }

    
    func moveMonster() {
        
        guard let monster = self.monster else {
            return
        }
        
        // Moves the monster to the right
        let moveRight = SKAction.move(to: CGPoint(x: self.size.width/2,
                                                  y: self.size.height/2),
                                      duration: 1.0)
        
        // Moves the monster to the left
        let moveLeft = SKAction.move(to: CGPoint(x: -(self.size.width/2),
                                                 y: self.size.height/2),
                                     duration: 1.0)
        
        // Groups the left and right actions together
        let moveSequence = SKAction.sequence([moveLeft, moveRight])
        
        // Repeats the group of actions forever
        let repeatMovesForever = SKAction.repeatForever(moveSequence)
        
        // Runs the repeated group of actions
        monster.run(repeatMovesForever)
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
