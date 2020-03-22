//
//  Equip.swift
//  Paperjump
//
//  Created by Frank Dong on 2020-03-21.
//  Copyright © 2020 Wes Ong. All rights reserved.
//

import Foundation
import SpriteKit

class Equip: SKSpriteNode {
    var selectedHandler: () -> Void = { print("No action set") }
    
    var isSelected: Bool = false{
        didSet {
            /* Update label */
            if isSelected {
                self.childNode(withName: "equipBorder")?.isHidden = false
            }
            else {
                self.childNode(withName: "equipBorder")?.isHidden = true
            }
        }
    }
    
    var bottomTexture: SKTexture!
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isSelected = false
        self.isUserInteractionEnabled = true
    }
    
    /* You are required to implement this for your subclass to work */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
    }
    
    func disableBtn(){
        self.alpha = 0.7
        self.isUserInteractionEnabled = false
    }
    
    func clearBtn(){
        self.alpha = 1
        self.isUserInteractionEnabled = true
    }
}

