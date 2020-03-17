//
//  Lilypad.swift
//  Paperjump
//
//  Created by Wes Ong on 2020-02-26.
//  Copyright © 2020 Wes Ong. All rights reserved.
//

import Foundation
import SpriteKit

class Lilypad: SKSpriteNode {
    
    public var isOccupied: Bool = false
    
    var lotus: SKSpriteNode!
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        lotus = self.childNode(withName: "lotus") as? SKSpriteNode
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: texture!.size().width/2-120)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.pinned = true
        self.zPosition = 0
        /* Set up physics masks */
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 2
        self.physicsBody?.contactTestBitMask = 1
    }
    
    /* You are required to implement this for your subclass to work */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
}
