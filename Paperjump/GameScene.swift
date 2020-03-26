//
//  GameScene.swift
//  Paperjump
//
//  Created by Wes Ong on 2020-02-26.
//  Copyright © 2020 Wes Ong. All rights reserved.
//

// PAPERLAND FONT https://www.dafont.com/paperland.font

import SpriteKit
import GameplayKit

enum GameSceneState {
    case active, gameOver
}

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
            self.frog1.setScale(CGFloat(1+Double(frog1Score)*0.1));
            self.setFrogBorders()
        }
    }
    var frog2ScoreLabel: SKLabelNode!
    var frog2Score: Int = 0 {
        didSet {
            self.frog2ScoreLabel.text = "\(String(self.frog2Score))"
            self.frog2.setScale(CGFloat(1+Double(frog2Score)*0.1));
            self.setFrogBorders()
        }
    }
    
    var gameState: GameSceneState = .active
    
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
    
    /* Main Menu */
    var clickToPlay: MSButtonNode!
    var clickToCustomize: MSButtonNode!
    var clickToBack: MSButtonNode!
    var menuFrog: SKSpriteNode!
    var menuFrogTwo: SKSpriteNode!


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
        
        /* Main Menu */
     
        
        clickToPlay = childNode(withName: "click_play_button") as? MSButtonNode
        clickToCustomize = childNode(withName: "customize_button") as? MSButtonNode
        
        clickToBack = childNode(withName: "equip_back_button") as? MSButtonNode
        
        clickToPlay.selectedHandler = {
            self.cameraNode.position = CGPoint(x: 0.0,  y: 0.0)
        }
        
        clickToCustomize.selectedHandler = {
            self.cameraNode.position = CGPoint(x: 1610.427,  y: 143.204)
        }
        
        clickToBack.selectedHandler = {
            self.cameraNode.position = CGPoint(x: 2878.803,  y: 96.367)
        }
               
        menuFrog = childNode(withName: "main_menu_frog") as? SKSpriteNode
        
        menuFrogTwo = childNode(withName: "main_menu_frog2") as? SKSpriteNode
               
        
    
           
        /* ------------------ */
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameState != .active { return }
        
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
        /* Setup changing of skins*/
        let playerOne_Skin =  UserDefaults.standard.string(forKey: "player1_equip")
        let playerTwo_Skin = UserDefaults.standard.string(forKey: "player2_equip")
        
        let texture1 = SKTexture(imageNamed: playerOne_Skin!)
        frog1.texture = texture1
        
        let texture2 = SKTexture(imageNamed:playerTwo_Skin!)
        frog2.texture = texture2
        
        if(self.menuFrog.position.y  > 1200 || self.menuFrog.position.x  > 3700) {
            let new_y  = Double.random(in: -800.0 ..< 200.0)
            self.menuFrog.position = CGPoint(x: 2100.0, y: new_y)
            
            let frog_type  = Int.random(in: 0 ..< 6)

            if(frog_type == 0) {
                menuFrog.texture = SKTexture(imageNamed: "smartfrog")
            } else if (frog_type == 1) {
                menuFrog.texture = SKTexture(imageNamed: "frog1")
            } else if (frog_type == 2) {
                menuFrog.texture = SKTexture(imageNamed: "frog2")
            } else if (frog_type == 3) {
                menuFrog.texture = SKTexture(imageNamed: "coolfrog")
            } else if (frog_type == 4) {
                menuFrog.texture = SKTexture(imageNamed: "mustachefrog")
            } else {
                 menuFrog.texture = SKTexture(imageNamed: "rainbowfrog")
            }


        } else {
            let new_y  = self.menuFrog.position.y + 5.0
            let new_x  = self.menuFrog.position.x + 5.0
            self.menuFrog.position = CGPoint(x: new_x,  y: new_y)
        }
        
                
        if(self.menuFrogTwo.position.y  < -900.0  || self.menuFrogTwo.position.x  < 2230.707) {
            let new_y  = Double.random(in: 200.0 ..< 900.0)
            self.menuFrogTwo.position = CGPoint(x: 3600.0, y: new_y)
            
            let frog_type  = Int.random(in: 0 ..< 6)

             if(frog_type == 0) {
                 menuFrogTwo.texture = SKTexture(imageNamed: "smartfrog")
             } else if (frog_type == 1) {
                 menuFrogTwo.texture = SKTexture(imageNamed: "frog1")
             } else if (frog_type == 2) {
                 menuFrogTwo.texture = SKTexture(imageNamed: "frog2")
             } else if (frog_type == 3) {
                 menuFrogTwo.texture = SKTexture(imageNamed: "coolfrog")
             } else if (frog_type == 4) {
                 menuFrogTwo.texture = SKTexture(imageNamed: "mustachefrog")
             } else {
                  menuFrogTwo.texture = SKTexture(imageNamed: "rainbowfrog")
             }
            
           } else {
               let new_y  = self.menuFrogTwo.position.y - 5.0
               let new_x  = self.menuFrogTwo.position.x - 5.0
               self.menuFrogTwo.position = CGPoint(x: new_x,  y: new_y)
           }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameState != .active { return }
        
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
            else if (lilypadNode.isOccupied && lilypadNode != frogNode.currentLilypad) {
                if (frog1Score > frog2Score) {
                    gameState = .gameOver
                    setFrog(frog: frogNode, toLilyPad: lilypadNode)
                    frog2.isHidden = true
                    print("Player 1 wins!")
                }
                else if (frog2Score > frog1Score) {
                    gameState = .gameOver
                    setFrog(frog: frogNode, toLilyPad: lilypadNode)
                    frog1.isHidden = true
                    print("Player 2 wins!")
                }
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
    
    func setFrogBorders() {
        frog1.childNode(withName: "yellowBorder")?.isHidden = true
        frog1.childNode(withName: "redBorder")?.isHidden = true
        frog2.childNode(withName: "yellowBorder")?.isHidden = true
        frog2.childNode(withName: "redBorder")?.isHidden = true
        
        if (frog1Score > frog2Score) {
            frog1.childNode(withName: "yellowBorder")?.isHidden = false
            frog2.childNode(withName: "redBorder")?.isHidden = false
        }
        else if (frog2Score > frog1Score) {
            frog1.childNode(withName: "redBorder")?.isHidden = false
            frog2.childNode(withName: "yellowBorder")?.isHidden = false
        }
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

