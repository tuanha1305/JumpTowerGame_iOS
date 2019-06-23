//
//  GenericNode.swift
//  JumpTower2
//
//  Created by Pawel on 16/06/2019.
//  Copyright © 2019 Pawel. All rights reserved.
//

import SpriteKit

struct CollisionCategoryBitMask{
    static let Player:UInt32 = 0x00
    static let Flower:UInt32 = 0x01
    static let Platform:UInt32 = 0x02
}

enum PlatformType:Int {
    case normalPlatform = 0
    case breakablePlatform = 1
}

class GenericNode: SKNode {

    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat){
        if playerY > self.position.y + 300 {
            self.removeFromParent()
        }
    }
}
