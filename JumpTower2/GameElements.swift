//
//  GameElements.swift
//  JumpTower2
//
//  Created by Pawel on 16/06/2019.
//  Copyright © 2019 Rafal Walasek. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    // TLO GRY - OBRAZY Z FOLDERU Backgrounds
    
    func createBackground() -> SKNode{      // wyswietlanie podstawowego tla -
        let backgroundNode = SKNode()       // tj. zdjecia z paczki Backgrounds
        let spacing = 64 * scaleFactor
        
        for index in 0 ... 19{
            let node = SKSpriteNode(imageNamed: String(format: "Background%02d", index+1))
            node.setScale(scaleFactor)
            node.anchorPoint = CGPoint(x: 0.5, y: 0)
            node.position = CGPoint(x: self.size.width / 2, y: spacing * CGFloat(index))
            
            backgroundNode.addChild(node)
        }
        return backgroundNode
    }
    
    //SRODKOWE TLO - GALEZIE Z Assets
    
    func createMidGround () -> SKNode { //funkcja odpowiedzialna za wyswietlanie
    let midgroundNode = SKNode ()        // galezi
    var anchor:CGPoint!
    var xPos:CGFloat!
        
        for index in 0 ... 9 {
            var name:String
            
            let randomNumber = arc4random() % 2
            
            if randomNumber > 0 {
                name = "BranchLeft"
                anchor = CGPoint(x: 0, y: 0.5)
                xPos = 0
            }else{
                name="BranchRight"
                anchor = CGPoint(x: 1,y: 0.5)
                xPos = self.size.width
                
            }
            let branchNode = SKSpriteNode(imageNamed: name)
            branchNode.anchorPoint = anchor
            branchNode.position = CGPoint(x: xPos, y: 500 * CGFloat(index))
            
            midgroundNode.addChild(branchNode)
        }
        
    
    return midgroundNode
    }
    
    // WYWOLANIE GRACZA NA EKRANIE - FUNKCJA 
    
    func createPlayer() ->  SKNode{
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y: 80)
        
        let sprite = SKSpriteNode(imageNamed: "Player")
        playerNode.addChild(sprite)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        
        playerNode.physicsBody?.isDynamic = false  // statyczne przed pierwszym kliknieciem
        playerNode.physicsBody?.allowsRotation = false
        
        playerNode.physicsBody?.restitution = 1
        playerNode.physicsBody?.friction = 0
            playerNode.physicsBody?.angularDamping = 0
            playerNode.physicsBody?.linearDamping = 0
        
        // Kolizje
        
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryBitMask.Player
        
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryBitMask.Flower | CollisionCategoryBitMask.Platform
        
        
        
        return playerNode
    }
    
    // Platformy
    
    func createPlatformAtPosition(position:CGPoint, ofType type:PlatformType)->PlatformNode{
        let node = PlatformNode()
        let thePosition = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = thePosition
        node.name = "PLATFORMMODE"
        node.platformType = type
        
        
        
        var sprite:SKSpriteNode
        if type == .breakablePlatform {
            sprite = SKSpriteNode(imageNamed: "PlatformBreak")
            
        }else
        {
            sprite = SKSpriteNode(imageNamed: "Platform")
        }
    node.addChild(sprite)
    
        node.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        node.physicsBody?.isDynamic = false // statyczne
        
        //Kolizje
        
        node.physicsBody?.categoryBitMask = CollisionCategoryBitMask.Platform
        node.physicsBody?.contactTestBitMask = 0
        
        return node
    }
    
    
    //  GWIAZDA
    // funkcja utworzona poprzez skopiowanie poprzedniej (..platform...) i zmodyfikowanie
    
  
          func createFlowerAtPosition(position:CGPoint, ofType type:FlowerType)->FlowerNode{        let node = FlowerNode()
        let thePosition = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = thePosition
        node.name = "FLOWERNODE"
        
       node.flowerType = type
            
            var sprite: SKSpriteNode
            if type == .specialFlower {
                sprite = SKSpriteNode(imageNamed: "StarSpecial")
            }else{
                sprite = SKSpriteNode(imageNamed: "Star")
            }
            
            node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        
        node.physicsBody?.isDynamic = false
        return node
    }
    
    
}
