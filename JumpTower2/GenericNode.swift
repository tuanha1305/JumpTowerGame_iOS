//
//  GenericNode.swift
//  JumpTower2
//
//  Created by Pawel on 16/06/2019.
//  Copyright © 2019 Rafal Walasek. All rights reserved.
//

import SpriteKit

//kategorie

struct CollisionCategoryBitMask{
    static let Player:UInt32 = 0x00
    static let Flower:UInt32 = 0x01
    static let Platform:UInt32 = 0x02
}

//platformy

enum PlatformType:Int {
    case normalPlatform = 0             // zwykle
    case breakablePlatform = 1          //zniszczone
}

class GenericNode: SKNode {

    func collisionWithPlayer(player: SKNode) -> Bool {
        return false            // funkcja kolizji -> jest nadpisana w PlatformNode i FlowerNode
    }
    
    func checkNodeRemoval(playerY: CGFloat){
        if playerY > self.position.y + 300 {
            self.removeFromParent()
        }
    }
}
