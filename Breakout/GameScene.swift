//
//  GameScene.swift
//  Breakout
//
//  Created by Emeka Ezike on 7/14/18.
//  Copyright © 2018 Emeka Ezike. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKShapeNode()
    var paddle = SKSpriteNode()
    var brick = SKSpriteNode()
    var loseZone = SKSpriteNode()
    var bricks = [SKSpriteNode]()
    
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBackground()
        makeBall()
        makePaddle()
        bricks = [SKSpriteNode]()
        
        var index = frame.minX + 30
        
        for x in 1...3
        {
            while index < frame.maxX - 30
            {
                if x > 1
                {
                    makeBrick(positionX: index, positionY: 30*CGFloat(x), color: UIColor.green)//blue
                   
                }
                else
                {
                    makeBrick(positionX: index, positionY: 30*CGFloat(x), color: UIColor.green)
                }
                index += 55
            }
            
            index = frame.minX + 30
        }
        makeLoseZone()
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 5))
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x: 0, y: starsBackground.size.height * CGFloat(i))
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = UIColor.black
        ball.fillColor = UIColor.yellow
        ball.name = "ball"
        
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        ball.physicsBody?.isDynamic = false
        // use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        // gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        // bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        // does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball) // add ball object to the view
    }
    
    func makePaddle() {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/4, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    func makeBrick(positionX: CGFloat, positionY: CGFloat, color: UIColor) {
        brick = SKSpriteNode(color: color, size: CGSize(width: 50, height: 20))
        brick.position = CGPoint(x: frame.midX - positionX, y: frame.maxY - positionY)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
        bricks.append(brick)
    }
    
    func makeLoseZone() {
        loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if(ball.physicsBody?.velocity.dx == 0 || ball.physicsBody?.velocity.dy == 0)
        {
            ball.removeFromParent()
            makeBall()
        }
        
        for brick in bricks
        {
            if contact.bodyA.node == brick && brick.color == UIColor.blue || contact.bodyB.node == brick && brick.color == UIColor.blue
            {
                brick.removeFromParent()
                bricks.remove(at: bricks.index(of: brick)!)
            }
            else if contact.bodyA.node == brick || contact.bodyB.node == brick && brick.color == UIColor.green
            {
                brick.color = UIColor.blue
                break
            }
        }
        
        if bricks.count == 0
        {
            win()
        }
       /* if contact.bodyA.node?.name == "brick" ||
            contact.bodyB.node?.name == "brick" {
            print("You win!")
            brick.removeFromParent()
            ball.removeFromParent()
        }*/
        if contact.bodyA.node?.name == "loseZone" ||
            contact.bodyB.node?.name == "loseZone" {
            print("You lose!")
            ball.removeFromParent()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.makeBall()
                self.ball.physicsBody?.isDynamic = true
                self.ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 5))
            }
            
        }
    }
    
    func win()
    {
    
    }
        
}
