//
//  GameScene.swift
//  JumpTower2
//
//  Created by Pawel on 15/06/2019.
//  Copyright © 2019 Pawel. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {

    var endLevelY = 0
    
    
    var background:SKNode!
    var midground:SKNode!
    var foreground:SKNode!
    
    var foregroundUpdate:Bool!
    let tapToStartNode = SKSpriteNode(imageNamed: "TapToStart")
    
    var player:SKNode!
    
    var scaleFactor:CGFloat!
    
    var startButton = SKSpriteNode(imageNamed: "NacisnijAbyRozpoczac")
    
    var endOfGamePosition = 0
    
  
    
    
    
    var scoreLabel:SKLabelNode!
    var flowerLabel:SKLabelNode!
    
    var playersMaxY:Int!
    
    var gameOver = false
    
    
    
  
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(size:CGSize)
    {
        
        let levelPlist = Bundle.main.path(forResource: "Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        endLevelY = (levelData["EndY"]! as AnyObject).integerValue!
        
        super.init(size: size)
        backgroundColor = SKColor.white
        

        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        physicsWorld.contactDelegate = self

        scaleFactor = self.size.width / 320
        
        background = createBackground()
        addChild(background)
        
        midground = createMidGround()
        addChild(midground)
        
        foreground = SKNode()
        addChild(foreground)
        
        player = createPlayer()
        foreground.addChild(player)
        
      
        
        
        
     //   let platform = createPlatformAtPosition(position: CGPoint(x: 160, y: 320), ofType: PlatformType.normalPlatform)
        
     //   foreground.addChild(platform)
        
        
        
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
            let patternX = (platformPosition["x"] as AnyObject).floatValue
            let patternY = (platformPosition["y"] as AnyObject).floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            // Look up the pattern
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                let x = (platformPoint["x"] as AnyObject).floatValue
                let y = (platformPoint["y"] as AnyObject).floatValue
                let type = PlatformType(rawValue: (platformPoint["type"]! as AnyObject).integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let platformNode = createPlatformAtPosition(position: CGPoint(x: positionX, y: positionY), ofType: type!)
                foreground.addChild(platformNode)
            }
        }
        
        
        let stars = levelData["Stars"] as! NSDictionary
        let starPatterns = stars["Patterns"] as! NSDictionary
        let starPositions = stars["Positions"] as! [NSDictionary]
        
        for starPosition in starPositions {
            let patternX = (starPosition["x"] as AnyObject).floatValue
            let patternY = (starPosition["y"] as AnyObject).floatValue
            let pattern = starPosition["pattern"] as! NSString
            
            // Look up the pattern
            let starPattern = starPatterns[pattern] as! [NSDictionary]
            for starPoint in starPattern {
                let x = (starPoint["x"] as AnyObject).floatValue
                let y = (starPoint["y"] as AnyObject).floatValue
                let type = FlowerType(rawValue: (starPoint["type"]! as AnyObject).integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let starNode = createFlowerAtPosition(position: CGPoint(x: positionX, y: positionY), ofType: type!)
                foreground.addChild(starNode)
            }
        }
        
        
        
        
        
    //    let flower = createFlowerAtPosition(position: CGPoint( x: 160, y: 220), ofType: .specialFlower)
   //     foreground.addChild(flower)
        
       // let flower = createFlowerAtPosition(position: CGPoint(x: 160, y: 220), ofType: FlowerType.NormalFlower)
     //   foreground.addChild(flower)

        
        tapToStartNode.position = CGPoint(x: self.size.width / 2, y: 180)
        foreground.addChild(tapToStartNode)
        
    
     

    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if player.physicsBody!.isDynamic{
            return
        }
    
        tapToStartNode.removeFromParent()
        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        
        }
    
    
    //sterowanie graczem
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            
            let location = touch.location(in: self)
            
            player.position.x = location.x
        }
    }
    
    
        // efekt paralaksy
    
    
    override func update(_ currentTime: TimeInterval) {
        // Calculate player y offset
        if player.position.y > 200.0 {
            background.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/10))
            midground.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/4))
            foreground.position = CGPoint(x: 0.0, y: -(player.position.y - 200.0))
        }
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact){
        print("Collision")
        var foregroundUpdate = false
        
        
        let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as! GenericNode
        
        foregroundUpdate = other.collisionWithPlayer(player: player)
        
        if foregroundUpdate {
            
        }
        
    }
}
