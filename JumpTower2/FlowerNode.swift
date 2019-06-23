//
//  FlowerNode.swift
//  JumpTower2
//
//  Created by Pawel on 20/06/2019.
//  Copyright © 2019 Pawel. All rights reserved.
//

import SpriteKit

enum FlowerType:Int{
    case NormalFlower = 0
    case specialFlower = 1
}

class FlowerNode: GenericNode{
    var flowerType:FlowerType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 400)
        
        self.removeFromParent()
        return true
        
    }
    
}
