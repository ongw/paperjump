//
//  GameScene.swift
//  Paperjump
//
//  Created by Wes Ong on 2020-02-26.
//  Copyright © 2020 Wes Ong. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let FROG_SPEED: Int = 350
    
    // GameScene Nodes
    var cameraNode: SKCameraNode!
    var frog1: Frog!
    var frog2: Frog!
    
    var frog1ScoreLabel: SKLabelNode!
    var frog1Score: Int = 0 {
        didSet {
            self.frog1ScoreLabel.text = "\(String(self.frog1Score))"
        }
    }
    var frog2ScoreLabel: SKLabelNode!
    var frog2Score: Int = 0 {
        didSet {
            self.frog2ScoreLabel.text = "\(String(self.frog2Score))"
        }
    }
    
    var lilyPads: [Lilypad] = []
    
    override func didMove(to view: SKView) {
        
        frog1 = self.childNode(withName: "frog1") as? Frog
        frog2 = self.childNode(withName: "frog2") as? Frog
        
        frog1ScoreLabel = self.childNode(withName: "frog1ScoreLabel") as? SKLabelNode
        frog2ScoreLabel = self.childNode(withName: "frog2ScoreLabel") as? SKLabelNode
        
        /* Set physics contact delegate */
        physicsWorld.contactDelegate = self
        
        self.isPaused = true
        self.isPaused = false
        
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        self.camera = cameraNode
        
        self.enumerateChildNodes(withName: "//lilypad") {
            (node, stop) in
            self.lilyPads.append(node as! Lilypad)
        }
        
        lilyPads.last?.lotus.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let frogNode = touch.location(in: self.camera!).y < -10 ? frog1! : frog2!
            
            let xVelocity = CGFloat(FROG_SPEED) * sin(frogNode.zRotation) * -1
            let yVelocity = CGFloat(FROG_SPEED) * cos(frogNode.zRotation)
            
            frogNode.physicsBody?.velocity = CGVector(dx: xVelocity, dy: yVelocity)
            
            frogNode.removeAllActions()
            frogNode.currentLilypad?.removeAllActions()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        /* Get references to bodies involved in collision */
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if (String(describing: nodeA.classForCoder) == "Lilypad" || String(describing: nodeB.classForCoder) == "Lilypad") {
            
            let lilypadNode = String(describing: nodeA.classForCoder) == "Lilypad" ? nodeA as! Lilypad : nodeB as! Lilypad
            
            let frogNode = nodeA.name == "frog1" || nodeB.name == "frog1" ? frog1! : frog2!
            
            
            if (!lilypadNode.isOccupied) {
                
                lilypadNode.isOccupied = true
                
                if (frogNode.currentLilypad != nil ) {
                    frogNode.currentLilypad?.isOccupied = false
                }
                
                if(!lilypadNode.lotus.isHidden) {
                    lilypadNode.lotus.isHidden = true
                    if (nodeA.name == "frog1" || nodeB.name == "frog1") { frog1Score+=1
                    }
                    else {
                        frog2Score+=1
                    }
                    generateNewLotus()
                }
                
                frogNode.currentLilypad = lilypadNode
                
                setFrog(frog: frogNode, toLilyPad: lilypadNode)
            }
        }
        
        if (nodeA.name == "boundary" || nodeB.name == "boundary") {
            let frogNode = nodeA.name == "frog1" || nodeB.name == "frog1" ? frog1! : frog2!
            setFrog(frog: frogNode, toLilyPad: frogNode.currentLilypad!)
            
            if ((nodeA.name == "frog1" || nodeB.name == "frog1") && frog1Score > 0) {
                frog1Score-=1
            }
            else if ((nodeA.name == "frog2" || nodeB.name == "frog2") && frog2Score > 0) {
                frog2Score-=1
            }
        }
    }
    
    func setFrog(frog frogNode:Frog, toLilyPad lilypadNode: Lilypad) {
        let lilypadPosition = lilypadNode.convert(lilypadNode.position, to: self)
        
        if (frogNode.position == lilypadPosition) {
            return
        }
        
        frogNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        let tempBody = frogNode.physicsBody
        frogNode.physicsBody = nil
        
        frogNode.position = lilypadPosition
        frogNode.physicsBody = tempBody
        
        frogNode.run(SKAction(named: "FrogRotation")!)
        lilypadNode.run(SKAction(named: "FrogRotation")!)
    }
    
    func generateNewLotus() {
        var randomLilyPad = lilyPads.randomElement()
        while randomLilyPad!.isOccupied {
            randomLilyPad = lilyPads.randomElement()
        }
        randomLilyPad!.lotus.isHidden = false
    }
}


