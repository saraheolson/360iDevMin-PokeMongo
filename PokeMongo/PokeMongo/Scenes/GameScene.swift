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

    // Defines where user touched
    var startTouchLocation: CGPoint = CGPoint.zero
    var endTouchLocation: CGPoint = CGPoint.zero

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
    
    // MARK: - Monster functions
    
    func createMonster() {
        
        // Create the monster from an atlas instead of an image
        let textureAtlas = SKTextureAtlas(named: "PurpleMonster.atlas")
        let spriteArray = [textureAtlas.textureNamed("PurpleMonster1"),
                           textureAtlas.textureNamed("PurpleMonster2")]
        monster = SKSpriteNode(texture: spriteArray[0])
        
        if let monster = self.monster {
            
            monster.name = "monster"
            
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

    func monsterHit() {
        
        monster?.removeAllActions()
        monster?.removeFromParent()
        monster = nil

        createMonster()
        
        // Wait 1 second to display it.
        monster?.isHidden = true
        let waitAction = SKAction.wait(forDuration: 1)
        monster?.run(waitAction) {
            self.monster?.isHidden = false
        }
    }
    
    // MARK: - Touch gesture methods
    
    /**
     *  Called when a touch event is initiated.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Record the beginning of the touch event
        startTouchLocation = touches.first!.location(in: self)
    }
    
    /**
     *  Called when a touch event moves.
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Move the ball along with the user's touch gesture
        let currentTouchLocation = touches.first!.location(in: self)
        if let ball = ball {
            ball.position = currentTouchLocation
        }
    }
    
    /**
     *  Called when a touch event is ended.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Record the end of the touch event
        endTouchLocation = touches.first!.location(in: self)
        
        // Continue the ball's movement along the same path as the touch gesture
        let factor: CGFloat = 50
        let vector = CGVector(dx: factor * (endTouchLocation.x - startTouchLocation.x), dy: factor * (endTouchLocation.y - startTouchLocation.y))
        ball?.physicsBody?.applyImpulse(vector)
    }
    
    /**
     *  Called before each frame is rendered.
     */
    override func update(_ currentTime: TimeInterval) {
        
        guard let ball = self.ball else {
            return
        }
        
        // Check to see if the ball node has left the scene bounds
        if (ball.position.x > self.size.width/2 + ball.size.width/2 ||
            ball.position.x < -(self.size.width/2 + ball.size.width/2) ||
            ball.position.y > self.size.height + ball.size.height) {
            
            // The ball is outside the bounds of the visible view
            resetBall()
        }
        
        checkCollisions()
    }
    
    
    // MARK: - Ball functions
    
    /**
     * Create a ball node and add it to the scene.
     */
    func createBall() {
        
        // Create the ball node
        ball = SKSpriteNode(imageNamed: "Ball")
        if let ball = ball {
            
            ball.name = "ball"
            
            // Set position and scale
            ball.position = CGPoint(x: 0, y: 100)
            ball.zPosition = 2
            ball.scale(to: CGSize(width: 50, height: 50))
            
            // Add physics
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.affectedByGravity = false
            ball.physicsBody?.allowsRotation = false
            ball.physicsBody?.mass = 50

            // Add to the scene
            addChild(ball)
        }
    }
    
    /**
     * Reset the ball to the default position.
     */
    func resetBall() {
        
        // Remove the current ball from the scene
        ball?.removeAllActions()
        ball?.removeFromParent()
        ball = nil
        
        // Reset touch locations
        startTouchLocation = CGPoint.zero
        endTouchLocation = CGPoint.zero
        
        // Create a new ball and add to the scene
        createBall()
    }
    
    // MARK: - Collision detection
    func checkCollisions() {
        
        guard let ball = self.ball, let monster = self.monster else {
            return
        }
        
        if ball.frame.insetBy(dx: 20, dy: 20).intersects(monster.frame) {
            monsterHit()
        }
    }
}
