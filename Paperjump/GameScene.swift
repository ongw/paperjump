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
    
    /* Inventory */
    var isPlayerOne = true
    
    var invSelectBtn: MSButtonNode!
    var invPlayerLabel: SKLabelNode!
    var invOptOne: Equip!
    var invOptTwo: Equip!
    var invOptThree: Equip!
    var invOptFour: Equip!
    var invOptFive: Equip!
    var invOptSix: Equip!
    /* ----------------- */
    
    
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
        
/* ---------------------------------- Equipment ------------------------ */
        
        //Persistent Data
        //For Storing use:
        UserDefaults.standard.set("smartfrog", forKey: "player1_equip")
        UserDefaults.standard.set("rainbowfrog", forKey: "player2_equip")
        
        //for loading use:
        //let storageVal =  UserDefaults.standard.string(forKey: "testkey")
        
        //to check if it worked use:
        //if (storageVal == "Kayla is lame"){
        //    print("true")
        //}
        //print (UserDefaults.standard.string(forKey: "testkey"))
        
        //to delete values use:
        // UserDefaults.standard.removeObject(forKey: "testkey")
        
        //source: stackoverflow.com/questions/31203241/how-can-i-use-userdefaults-in-swift

        // -------------------------------------------------
        invOptOne = childNode(withName: "equip_option1") as? Equip
        invOptTwo = childNode(withName: "equip_option2") as? Equip
        invOptThree = childNode(withName: "equip_option3") as? Equip
        invOptFour = childNode(withName: "equip_option4") as? Equip
        invOptFive = childNode(withName: "equip_option5") as? Equip
        invOptSix = childNode(withName: "equip_option6") as? Equip
        //self.clear_selection()
        
        let player_storageVal =  UserDefaults.standard.string(forKey: "player1_equip")
        let opponent_storageVal = UserDefaults.standard.string(forKey: "player2_equip")
        self.clearOpponentValues()
        self.clear_selection()
        self.loadOptionValues(optionVal: player_storageVal!)
        self.loadOpponentValues(opponentVal: opponent_storageVal!)
        
        invSelectBtn = childNode(withName: "equip_changePlayerBtn") as? MSButtonNode
        invSelectBtn.selectedHandler = {
            self.inv_switchPlayer()
            if (self.isPlayerOne){
                let player_storageVal =  UserDefaults.standard.string(forKey: "player1_equip")
                let opponent_storageVal = UserDefaults.standard.string(forKey: "player2_equip")
                self.clearOpponentValues()
                self.clear_selection()
                self.loadOptionValues(optionVal: player_storageVal!)
                self.loadOpponentValues(opponentVal: opponent_storageVal!)
            } else{
                let player_storageVal =  UserDefaults.standard.string(forKey: "player2_equip")
                let opponent_storageVal = UserDefaults.standard.string(forKey: "player1_equip")
                self.clearOpponentValues()
                self.clear_selection()
                self.loadOptionValues(optionVal: player_storageVal!)
                self.loadOpponentValues(opponentVal: opponent_storageVal!)
            }
        }

        invOptOne.selectedHandler = {
            print("option 1")
            self.clear_selection()
            self.invOptOne.isSelected = true
            self.saveSelection(optionVal: "frog1")
        }
        invOptTwo.selectedHandler = {
            print("option 2")
            self.clear_selection()
            self.invOptTwo.isSelected = true
            self.saveSelection(optionVal: "frog2")
        }
        invOptThree.selectedHandler = {
            print("option 3")
            self.clear_selection()
            self.invOptThree.isSelected = true
            self.saveSelection(optionVal: "coolfrog")
        }
        invOptFour.selectedHandler = {
            print("option 4")
            self.clear_selection()
            self.invOptFour.isSelected = true
            self.saveSelection(optionVal: "mustachefrog")
        }
        invOptFive.selectedHandler = {
            print("option 5")
            self.clear_selection()
            self.invOptFive.isSelected = true
            self.saveSelection(optionVal: "smartfrog")
        }
        invOptSix.selectedHandler = {
            print("option 6")
            self.clear_selection()
            self.invOptSix.isSelected = true
            self.saveSelection(optionVal: "rainbowfrog")
        }
/* ------------------------------ End Equipment ------------------------------- */
        
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
        
        let playerOne_Skin =  UserDefaults.standard.string(forKey: "player1_equip")
        let playerTwo_Skin = UserDefaults.standard.string(forKey: "player2_equip")
        
        let texture1 = SKTexture(imageNamed: playerOne_Skin!)
        frog1.texture = texture1
        
        let texture2 = SKTexture(imageNamed:playerTwo_Skin!)
        frog2.texture = texture2
        
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
    
/* ---------------------------------- Equipment ------------------------------- */
    func inv_switchPlayer() {
        invPlayerLabel = childNode(withName: "equip_playerLabel") as? SKLabelNode
        if isPlayerOne{
            self.invPlayerLabel.text = "Player 2"
            self.isPlayerOne = false
        }
        else{
            self.invPlayerLabel.text = "Player 1"
            self.isPlayerOne = true
        }
    }
    
    func clear_selection(){
        self.invOptOne.isSelected = false
        self.invOptTwo.isSelected = false
        self.invOptThree.isSelected = false
        self.invOptFour.isSelected = false
        self.invOptFive.isSelected = false
        self.invOptSix.isSelected = false
    }
    
    func saveSelection(optionVal: String){
        if (self.isPlayerOne){
            UserDefaults.standard.set(optionVal, forKey: "player1_equip")
        } else{
            UserDefaults.standard.set(optionVal, forKey: "player2_equip")
        }
    }
    
    func loadOptionValues(optionVal: String){
        if (optionVal == "frog1"){
            self.invOptOne.isSelected = true
        } else if (optionVal == "frog2"){
            self.invOptTwo.isSelected = true
        } else if (optionVal == "coolfrog"){
            self.invOptThree.isSelected = true
        } else if (optionVal == "mustachefrog"){
            self.invOptFour.isSelected = true
        } else if (optionVal == "smartfrog"){
            self.invOptFive.isSelected = true
        } else if (optionVal == "rainbowfrog"){
            self.invOptSix.isSelected = true
        } else {
            self.invOptOne.isSelected = true
        }
    }
    
    func loadOpponentValues(opponentVal: String){
        if (opponentVal == "frog1"){
            self.invOptOne.disableBtn()
        } else if (opponentVal == "frog2"){
            self.invOptTwo.disableBtn()
        } else if (opponentVal == "coolfrog"){
            self.invOptThree.disableBtn()
        } else if (opponentVal == "mustachefrog"){
            self.invOptFour.disableBtn()
        } else if (opponentVal == "smartfrog"){
            self.invOptFive.disableBtn()
        } else if (opponentVal == "rainbowfrog"){
            self.invOptSix.disableBtn()
        } else {
            self.invOptOne.disableBtn()
        }
    }
    
    func clearOpponentValues(){
        self.invOptOne.clearBtn()
        self.invOptTwo.clearBtn()
        self.invOptThree.clearBtn()
        self.invOptFour.clearBtn()
        self.invOptFive.clearBtn()
        self.invOptSix.clearBtn()
    }
/* -------------------------------- End Equipment ------------------------ */
}
