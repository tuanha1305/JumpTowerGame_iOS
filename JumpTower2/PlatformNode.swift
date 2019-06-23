//
//  PlatformNode.swift
//  JumpTower2
//
//  Created by Pawel on 16/06/2019.
//  Copyright © 2019 Pawel. All rights reserved.
//

import SpriteKit

class PlatformNode: GenericNode {
    
    var platformType:PlatformType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        
        
        
        if (player.physicsBody?.velocity.dy)! < CGFloat(0) {
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 250)
            
            if platformType == .breakablePlatform {
                self.removeFromParent()
            }
        
        }
        
        return false
    }
    

}
