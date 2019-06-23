// 
//
//  GameScene.swift
//  JumpTower2
//
//  Created by Pawel on 15/06/2019.   ( "Pawel" to nazwa konta na PC )
//  Copyright © 2019 Rafal Walasek. All rights reserved.
//
//     ---------------------------------- KOMENTARZ ---------------------------------------
//
//  W pliku GameElements znajduja sie funkje odpowiedzialne za tworzenie i funkcjonalnosci:
//      tla, tla srodkowego (midground), foreground, gracza oraz platform oraz gwiazd (flowers)
//
//      Pliki: GenericNode, PlatformNode, FlowerNode zawieraja funkcje wazne dla okreslenia  kolizji  ( gracz z platformami(zwykle i zniszczone) i gracz z gwiazdami(zwykle i specjalne))
//
//
//      Paczka Backgrounds zawiera zdjecia tla
//         Assets zawiera zdjecia gracza, gwiazd, platform, galezi
//          W Level01.plist znajduja sie informacje dotyczace rozmieszczenia platform i gwiazd
//
//
//
//      PORUSZANIE SIE: poruszanie sie odbywa sie za pomoca funkcji: touchesMoved. W emulatorze nalezy przycisnac lewy przycisk myszy- gracz bedzie przesuwal sie po OSI X wedug ruchow kursora
//
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {

    //deklaracje
    
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
        
      
        
        super.init(size: size)
        backgroundColor = SKColor.white
        
        
        
        //fizyka

        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        physicsWorld.contactDelegate = self

        //referencja do pliku Level01.plist
        
        let levelPlist = Bundle.main.path(forResource: "Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        endLevelY = (levelData["EndY"]! as AnyObject).integerValue!
        scaleFactor = self.size.width / 320
        
        // ustawienie tla i gracza
        
        background = createBackground()     //tlo
        addChild(background)
        
        midground = createMidGround()           //galezie
        addChild(midground)
        
        foreground = SKNode()
        addChild(foreground)                // gracz, gwiazdy i platformy ida na ten node
        
        player = createPlayer()
        foreground.addChild(player)         // gracz
    
        
        // dodanie platform do mapy z pliku Level01.plist
        
        
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
            let patternX = (platformPosition["x"] as AnyObject).floatValue
            let patternY = (platformPosition["y"] as AnyObject).floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            
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
        
        // dodanie gwiazd do foreground z pliku Level01.plist
        
        
        
        let flowers = levelData["Stars"] as! NSDictionary
        let flowerPatterns = flowers["Patterns"] as! NSDictionary
        let flowerPositions = flowers["Positions"] as! [NSDictionary]
        
        for flowerPosition in flowerPositions {
            let patternX = (flowerPosition["x"] as AnyObject).floatValue
            let patternY = (flowerPosition["y"] as AnyObject).floatValue
            let pattern = flowerPosition["pattern"] as! NSString
            
            
            let flowerPattern = flowerPatterns[pattern] as! [NSDictionary]
            for flowerPoint in flowerPattern {
                let x = (flowerPoint["x"] as AnyObject).floatValue
                let y = (flowerPoint["y"] as AnyObject).floatValue
                let type = FlowerType(rawValue: (flowerPoint["type"]! as AnyObject).integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let flowerNode = createFlowerAtPosition(position: CGPoint(x: positionX, y: positionY), ofType: type!)
                foreground.addChild(flowerNode)
            }
        }
        
        
        // obraz tapToStart do rozpoczecia rozgrywki
        
        tapToStartNode.position = CGPoint(x: self.size.width / 2, y: 180)
        foreground.addChild(tapToStartNode)     //dodanie

    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if player.physicsBody!.isDynamic{
            return
        }
    
        tapToStartNode.removeFromParent() // usuwamy z pola widzenia obraz tapToStart
        player.physicsBody?.isDynamic = true // dynamiczna, gracz podlega fizyce
        
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))       // w gore o 20 po starcie
        
        }
    
    
    //sterowanie graczem wedlug osi x
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            
            let location = touch.location(in: self)
            
            player.position.x = location.x
        }
    }
    
    
        // efekt paralaksy - obraz "porusza sie" z ruchem gracza
    
    
    override func update(_ currentTime: TimeInterval) {
       
        if player.position.y > 200.0 {
            background.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/10))
            midground.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/4))
            foreground.position = CGPoint(x: 0.0, y: -(player.position.y - 200.0))
        }
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact){
        
        // kolizje
        
       // var foregroundUpdate = false
        
        
        let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as! GenericNode
        
        foregroundUpdate = other.collisionWithPlayer(player: player)
        
     
                // if foregroundUpdate {
        
                //}
    }
    
    }
