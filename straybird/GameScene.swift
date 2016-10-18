//
//  GameScene.swift
//  straybird
//
//  Created by yu ni on 2016-08-18.
//  Copyright (c) 2016 yu ni. All rights reserved.
//

import SpriteKit


struct PhysicsCatagory {
    static let Flybird : UInt32 = 0x1 << 1
    static let Turtle : UInt32 = 0x1 << 2
    static let Seahorse : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // var Seahorse = SKSpriteNode()
    var Flybird = SKSpriteNode()
    
    var AnimalPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()
    
    var scoreLbl = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        

        
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 200 )
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        addChild(scoreLbl)
        
        Flybird = SKSpriteNode(imageNamed: "Flybird")
        Flybird.size = CGSize(width: 100, height: 100)
        Flybird.position = CGPoint(x: self.frame.width / 2, y: Flybird.frame.height  / 2.5 + 100 )
        
        Flybird.physicsBody=SKPhysicsBody(circleOfRadius: Flybird.frame.height/2)
        Flybird.physicsBody?.categoryBitMask=PhysicsCatagory.Flybird
        Flybird.physicsBody?.collisionBitMask=PhysicsCatagory.Turtle | PhysicsCatagory.Seahorse
        Flybird.physicsBody?.contactTestBitMask=PhysicsCatagory.Turtle | PhysicsCatagory.Seahorse | PhysicsCatagory.Score
        Flybird.physicsBody?.affectedByGravity=false
        Flybird.physicsBody?.dynamic=true
        
        Flybird.zPosition = 3
        
        self.addChild(Flybird)
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPointZero
            background.position = CGPointMake(CGFloat(i) * self.frame.width, 0)
            //0, CGFloat(i) * self.frame.height)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstbody = contact.bodyA
        let secondbody = contact.bodyB
        
        if firstbody.categoryBitMask == PhysicsCatagory.Score && secondbody.categoryBitMask == PhysicsCatagory.Flybird {
            score+=1
            scoreLbl.text = "\(score)"
            firstbody.node?.removeFromParent()
        }
        else if firstbody.categoryBitMask == PhysicsCatagory.Flybird && secondbody.categoryBitMask == PhysicsCatagory.Score
            
        {
            score+=1
            scoreLbl.text = "\(score)"
            secondbody.node?.removeFromParent()
            
            
        }
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gameStarted == false{
            
            gameStarted = true
            
            Flybird.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.runBlock({
                
                ()in
                
                self.createSeaAnimal()
            })
            
            let delay = SKAction.waitForDuration(3)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let SpawnDelayForever = SKAction.repeatActionForever(SpawnDelay)
            self.runAction(SpawnDelayForever)
            
            let distance = CGFloat(self.frame.height + AnimalPair.frame.height)
            let moveAnimal = SKAction.moveByX( 0, y: -distance, duration: NSTimeInterval( 0.008 * distance))
            let removeAnimal = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([moveAnimal, removeAnimal])
            
            Flybird.physicsBody?.velocity = CGVectorMake(0,0)
            Flybird.physicsBody?.applyImpulse( CGVectorMake(0,90))
            
        }
        else {
            
            
            Flybird.physicsBody?.velocity = CGVectorMake(0,0)
            Flybird.physicsBody?.applyImpulse( CGVectorMake(0,150))
        }
        
    }
    
    
    
    func createSeaAnimal(){
        
        let scoreNode = SKSpriteNode(imageNamed: "Coin")
        
        scoreNode.size = CGSize (width:30, height: 30)
        scoreNode.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask=PhysicsCatagory.Flybird
        scoreNode.color = SKColor.blueColor()
        
        
        
        
        
        AnimalPair = SKNode()
        AnimalPair.runAction(moveAndRemove)
        
        
        let LeftAnimal = SKSpriteNode(imageNamed: "Turtle")
        let RightAnimal = SKSpriteNode(imageNamed: "Seahorse")
        
        LeftAnimal.position = CGPoint (x: self.frame.width/2 - 150, y: self.frame.height + 200 )
        RightAnimal.position = CGPoint (x: self.frame.width/2 + 150, y: self.frame.height)
        
        LeftAnimal.setScale(0.2)
        RightAnimal.setScale(0.2)
        
        LeftAnimal.physicsBody=SKPhysicsBody(circleOfRadius: Flybird.frame.height/2)
        LeftAnimal.physicsBody?.categoryBitMask=PhysicsCatagory.Turtle | PhysicsCatagory.Seahorse
        LeftAnimal.physicsBody?.collisionBitMask=PhysicsCatagory.Flybird
        LeftAnimal.physicsBody?.contactTestBitMask=PhysicsCatagory.Flybird
        LeftAnimal.physicsBody?.affectedByGravity=false
        LeftAnimal.physicsBody?.dynamic=false
        
        RightAnimal.physicsBody=SKPhysicsBody(circleOfRadius: Flybird.frame.height/2)
        RightAnimal.physicsBody?.categoryBitMask=PhysicsCatagory.Turtle | PhysicsCatagory.Seahorse
        RightAnimal.physicsBody?.collisionBitMask=PhysicsCatagory.Flybird
        RightAnimal.physicsBody?.contactTestBitMask=PhysicsCatagory.Flybird
        RightAnimal.physicsBody?.affectedByGravity=false
        RightAnimal.physicsBody?.dynamic=false
        
        
        
        
        AnimalPair.addChild(LeftAnimal)
        AnimalPair.addChild(RightAnimal)
        
        AnimalPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -100, max:100)
        AnimalPair.position.x = AnimalPair.position.x + randomPosition
        AnimalPair.addChild(scoreNode)
        
        self.addChild(AnimalPair)
        
        
    }
    
    override func update(currentTime: CFTimeInterval){
  
        /* Called before each frame is rendered */
    }
    
}