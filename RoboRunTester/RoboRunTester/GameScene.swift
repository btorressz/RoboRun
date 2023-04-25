//
//  GameScene.swift
//  RoboRunTester
//
//  Created by Brandon Torres on 4/26/18.
//  Copyright © 2018 Brandon Torres. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
import AVFoundation

//TODO Change backgroundcolor V  lower MB V ADD DUCK FEATURE
//Comment out end of screen to test ground and if needed


class GameScene: SKScene,SKPhysicsContactDelegate {
    
    
    var audioPlayer = AVAudioPlayer()
    
    var totalCoins = UserDefaults.standard.integer(forKey:"coins")
    var timer = 0
  //  var score = 0
    let scoreText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    var cloudTexture = SKTexture(imageNamed: "clouds")
    var cloudMoveAndRemove = SKAction()
    var moving: SKNode!
    var enemyImage = SKSpriteNode(imageNamed: "robotenemy")  //enemyIdle
    var skyColor: SKColor!
    let jumpButton = SKSpriteNode(imageNamed: "JumpAttackButton")
    let attackButton = SKSpriteNode(imageNamed: "JumpAttackButton")
    let duckButton = SKSpriteNode(imageNamed: "DuckButton")
    
    //Try
    var score:Int = 0 {
        didSet {
            scoreText.text =  "\(score)"
        }
    } ///https://www.hackingwithswift.com/example-code/games/how-to-write-text-using-sklabelnode
    
    let bot = Robot(health: 1, inventory: UserDefaults.standard.integer(forKey:"inventory"))
    let enemy1 = Enemy(health: 1)
    let enemy2 = Enemy(health: 1)
    let enemy3 = Enemy(health: 1)
    let enemy4 = Enemy(health: 1)
    let fullInventory = UserDefaults.standard.integer(forKey:"inventory")
    let rechargeSpeed = UserDefaults.standard.float(forKey:"rechargeSpeed")
    var timerIsRunning = false
    
    let fire1 = Weapon()
    let fire2 = Weapon()
    let fire3 = Weapon()
    let fire4 = Weapon()
    
    let obstacle = Obstacles(health: 1)
    let bomb = Obstacles(health: 2)
    let spike = Obstacles(health:1)
    let block = Obstacles(health:1)
    
    let shield = PowerUp()
    let magnet = PowerUp()
    let superJump = PowerUp()
    


    
    //Throwing Stars in inventory
    let fireImage1 = SKSpriteNode(imageNamed: "fire")
    let fireImage2 = SKSpriteNode(imageNamed: "fire")
    let fireImage3 = SKSpriteNode(imageNamed: "fire")
    let fireImage4 = SKSpriteNode(imageNamed: "fire")
    
    let playButton = SKSpriteNode(imageNamed: "button")
    //  let pressedPlayButton = SKSpriteNode(imageNamed: "pressedButton")
    let menuButton = SKSpriteNode(imageNamed: "button")
    //  let pressedMenuButton = SKSpriteNode(imageNamed: "pressedButton")
    let displayPanel = SKSpriteNode(imageNamed: "brownPanel")
    let playAgainText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let menuText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let gameOverText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    
    let pauseText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let pauseMenuText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let resumeText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let restartText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let resumeButton = SKSpriteNode(imageNamed: "button")
    let pauseMenuButton = SKSpriteNode(imageNamed: "button")
    let restartButton = SKSpriteNode(imageNamed: "button")
    
    let coinsText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let pausePicture = SKSpriteNode(imageNamed: "pause.png") //pausePic
    var pauseButton = SKSpriteNode(imageNamed: "pause.png")
    
    //let leftEndOfScreen = SKSpriteNode(imageNamed: "endOfScreen")
  //  let rightEndOfScreen = SKSpriteNode(imageNamed: "endOfScreen")
    
    //Colliders
    /*  let groundCategory: UInt32 = 0x1 << 0
     let robotCategory: UInt32 = 0x1 << 1
     //let weaponCategory: UInt32 = 1 << 2 //Not in use because weapon categories below
     let enemy1Category: UInt32 = 0x1 << 3
     let enemy2Category: UInt32 = 0x1 << 4
     let enemy3Category: UInt32 = 0x1 << 5
     let enemy4Category: UInt32 = 0x1 << 6
     let enemyWeaponCategory: UInt32 = 0x1 << 7 //Enemy weapons
     let endOfScreenCategory: UInt32 = 0x1 << 8 //End of screen
     let weapon1Category: UInt32 = 0x1 << 9
     let weapon2Category: UInt32 = 0x1 << 10
     let weapon3Category: UInt32 = 0x1 << 11
     let weapon4Category: UInt32 = 0x1 << 12
     let obstacleCategory:UInt32 = 0x1 << 13
     let coinCatergory:UInt32 = 0x1 << 14*/
    
    
    /* let groundCategory: UInt32 =  0
     let robotCategory: UInt32 =  0b01
     let weaponCategory: UInt32 = 0b10 //robots weapons
     let enemy1Category: UInt32 = 0b11
     let enemy2Category: UInt32 = 0b100
     let enemy3Category: UInt32 = 0b101
     let enemy4Category: UInt32 =  0b110
     let coinCategory:UInt32 = 0b111
     let obstacleCatergory:UInt32 =  0b1000
     let powerupCategory:UInt32 = 0b1001
     let enemyWeaponCategory: UInt32 = 0b111 //Enemy weapons
     let endOfScreenCategory: UInt32 = 0b1000
     let weapon1Category:UInt32 = 0b1001
     let weapon2Category: UInt32 = 1010
     let weapon3Category: UInt32 = 1011
     let weapon4Category: UInt32 =  1100
     let obstacleCategory:UInt32 = 1010
     let coinCatergory:UInt32 = 1010*/
    
    let groundCategory: UInt32 = 1 << 0
    let robotCategory: UInt32 =  1 << 1
    //let weaponCategory: UInt32 = 1 << 2 //Not in use because weapon categories below
    let enemy1Category: UInt32 =  1 << 3
    let enemy2Category: UInt32 =  1 << 4
    let enemy3Category: UInt32 =  1 << 5
    let enemy4Category: UInt32 =  1 << 6
    let enemyWeaponCategory: UInt32 = 1 << 7 //Enemy weapons
    let endOfScreenCategory: UInt32 =  1 << 8 //End of screen
    let weapon1Category: UInt32 =  1 << 9
    let weapon2Category: UInt32 =  1 << 10
    let weapon3Category: UInt32 =  1 << 11
    let weapon4Category: UInt32 =  1 << 12
    let obstacleCategory:UInt32 =  1 << 13
    let coinCatergory:UInt32 =  1 << 14
    
    
    
    
    override func didMove(to view: SKView) {
        // self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pauseButton.isHidden = false
        moving = SKNode()
        self.addChild(moving)
        moving.speed = 1
        //   skyColor = SKColor(red: 90.0/255.0, green: 192.0/255.0, blue: 231.0/255.0, alpha: 1.0)
     //   skyColor = SKColor(red: 0.00, green: 0.05, blue: 0.50, alpha: 1.0)
        skyColor = SKColor(red:0.00, green:0.75, blue:1.00, alpha:1.0)

        //  skyColor = UIColor(red:0.00, green:0.00, blue:1.00, alpha:1.0) o
        
        // skyColor = UIColor(red:0.00, green:0.00, blue:0.80, alpha:1.0)
        
        
        self.backgroundColor = skyColor
        self.physicsWorld.contactDelegate = self
        //  self.physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate
        self.physicsWorld.gravity = CGVector(dx:0.0, dy:-12.8)
        
        //Set up the scene
        createScoreBoard()
    //    createEndOfScreen()
        //createPauseButton()
        // createAndMoveGround()
        //   moveGronnd()
        createGround()
        // createGrounds()
        //   moveGronnds()
        createJumpAndAttackButtons()
        // showInventory()
        createAndMoveClouds()
        //Coin.moveCoins(coins)
     //   createEndPanel() thread 1 sigbart
        
        //Add robot
     //   bot.playWalkAnimation()
        //    bot.playJumpAnimation()
        self.addChild(bot.createRobot(self.frame.width))
        //self.addChild(bot)
        bot.isDead = false
        
        enemy1.isDead = true
    }
    
    
    // GAME CENTER FUNCTIONS
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func saveHighScore(_ identifier:String, score:Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: identifier)
            scoreReporter.value = Int64(score)
            let scoreArray:[GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: {
                error -> Void in
                if error != nil {
                    print("error")
                } else {
                    print("posted score of \(score)")
                }
            })
        }
    }
    
    func playBackgroundMusic() {
        let backgroundSound = URL(fileURLWithPath: Bundle.main.path(forResource: "backgroundmusic", ofType: "mp3")!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        let error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundSound)
        } catch let error1 as NSError {
            error = error1
            //audioPlayer2 = nil
        }
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 0.6
        audioPlayer.play()
    }
    
    //Contact
   // func didBeginContact(contact: SKPhysicsContact) {
    func didBegin(_ contact:SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        print("contact")
        NSLog("contact", "contactT") //try
        switch(contactMask) {
        case groundCategory | robotCategory:
            if !bot.isDead {
                bot.onGround = true
                bot.playWalkAnimation()
            } else {
                endGame()
            }
        case enemy1Category | weapon1Category:
            enemy1.health = enemy1.health - 1
            if (!enemy1.dying) {
                fire1.fire.removeFromParent()
            }
            if enemy1.health == 0 {
                enemy1.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy1.playDeadAnimation(frame.size.width)
            }
            
        case enemy2Category | weapon1Category:
            enemy2.health = enemy2.health - 1
            if (!enemy2.dying) {
                fire1.fire.removeFromParent()
            }
            if enemy2.health == 0 {
                enemy2.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy2.playDeadAnimation(frame.size.width)
            }
            
        case enemy3Category | weapon1Category:
            enemy3.health = enemy3.health - 1
            if (!enemy3.dying) {
                fire1.fire.removeFromParent()
            }
            if enemy3.health == 0 {
                enemy3.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy3.playDeadAnimation(frame.size.width)
            }
            
        case enemy4Category | weapon1Category:
            enemy4.health = enemy4.health - 1
            if (!enemy4.dying) {
                fire3.fire.removeFromParent()
            }
            if enemy4.health == 0 {
                enemy4.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy4.playDeadAnimation(frame.size.width)
            }
            
        case enemy1Category | weapon2Category:
            enemy1.health = enemy1.health - 1
            if (!enemy1.dying) {
                fire2.fire.removeFromParent()
            }
            if enemy1.health == 0 {
                enemy1.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy1.playDeadAnimation(frame.size.width)
            }
            
        case enemy2Category | weapon2Category:
            enemy2.health = enemy2.health - 1
            if (!enemy2.dying) {
                fire3.fire.removeFromParent()
            }
            if enemy2.health == 0 {
                enemy2.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy2.playDeadAnimation(frame.size.width)
            }
            
        case enemy3Category | weapon2Category:
            enemy3.health = enemy3.health - 1
            if (!enemy3.dying) {
                fire2.fire.removeFromParent()
            }
            if enemy3.health == 0 {
                enemy3.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy3.playDeadAnimation(frame.size.width)
            }
            
        case enemy4Category | weapon2Category:
            enemy4.health = enemy4.health - 1
            if (!enemy4.dying) {
                fire2.fire.removeFromParent()
            }
            if enemy4.health == 0 {
                enemy4.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy4.playDeadAnimation(frame.size.width)
            }
            
        case enemy1Category | weapon3Category:
            enemy1.health = enemy1.health - 1
            if (!enemy1.dying) {
                fire3.fire.removeFromParent()
            }
            if enemy1.health == 0 {
                enemy1.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy1.playDeadAnimation(frame.size.width)
            }
            
        case enemy2Category | weapon3Category:
            enemy2.health = enemy2.health - 1
            if (!enemy2.dying) {
                fire3.fire.removeFromParent()
            }
            if enemy2.health == 0 {
                enemy2.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy2.playDeadAnimation(frame.size.width)
            }
            
        case enemy3Category | weapon3Category:
            enemy3.health = enemy3.health - 1
            if (!enemy3.dying) {
                fire3.fire.removeFromParent()
            }
            if enemy3.health == 0 {
                enemy3.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy3.playDeadAnimation(frame.size.width)
            }
            
        case enemy4Category | weapon3Category:
            enemy4.health = enemy4.health - 1
            if (!enemy4.dying) {
                fire3.fire.removeFromParent()
            }
            if enemy4.health == 0 {
                enemy4.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy4.playDeadAnimation(frame.size.width)
            }
            
        case enemy1Category | weapon4Category:
            enemy1.health = enemy1.health - 1
            if (!enemy1.dying) {
                fire4.fire.removeFromParent()
            }
            if enemy1.health == 0 {
                enemy1.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy1.playDeadAnimation(frame.size.width)
            }
            
        case enemy2Category | weapon4Category:
            enemy2.health = enemy2.health - 1
            if (!enemy2.dying) {
                fire4.fire.removeFromParent()
            }
            if enemy2.health == 0 {
                enemy2.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy2.playDeadAnimation(frame.size.width)
            }
            
        case enemy3Category | weapon4Category:
            enemy3.health = enemy3.health - 1
            if (!enemy3.dying) {
                fire4.fire.removeFromParent()
            }
            if enemy3.health == 0 {
                enemy3.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy3.playDeadAnimation(frame.size.width)
            }
            
        case enemy4Category | weapon4Category:
            enemy4.health = enemy4.health - 1
            if (!enemy4.dying) {
                fire4.fire.removeFromParent()
            }
            if enemy4.health == 0 {
                enemy4.dying = true
                score += 1
                self.scoreText.text = String(self.score)
                enemy4.playDeadAnimation(frame.size.width)
            }
            
        case obstacleCategory | weapon1Category:
            obstacle.health = obstacle.health - 1
            if(!obstacle.isGone) {
                fire1.fire.removeFromParent()
            }
            if obstacle.health == 0 {
                obstacle.isGone = true
                score += 1
                self.scoreText.text = String(self.score)
                
            }
            
        case (enemy1Category | robotCategory):
            if (!bot.isDead && !enemy1.dying) {
                die()
            }
        case (enemy2Category | robotCategory):
            if (!bot.isDead && !enemy2.dying){
                die()
            }
        case (enemy3Category | robotCategory):
            if (!bot.isDead && !enemy3.dying) {
                die()
            }
           //tesst
      /*  case (enemy1Category | robotCategory):
            if !bot.isDead{
                die()
                endGame()
            } else {
                enemy1.isDead = true
            }
            
        case (enemy2Category | robotCategory):
            if !bot.isDead{
                die()
                endGame()
            } else {
                enemy2.isDead = true
            }
            
        case (enemy3Category | robotCategory):
            if !bot.isDead{
                die()
                endGame()
            } else {
                enemy3.isDead = true
            }*/
            
            
        case (enemy4Category | robotCategory):
            if !bot.isDead{
                die()
                endGame()
            } else {
                enemy4.isDead = true
            }
            
            
     /*   case (enemy1Category | robotCategory) {
            if bot.jump() {
                enemy1.dying
                score += 1
            } else {
                bot.isDead
            }
            }*/
            
            /*       //when robot jumps over enemy make score up
             case(robotCategory | enemy1Category):
             if enemy1.isDead == true {
             die()
             score += 1
             } else {
             bot.isDead = true
             }
             case(robotCategory | enemy2Category):
             if enemy2.isDead == true {
             die()
             score += 1
             } else {
             bot.isDead = true
             }
             
             case(robotCategory | enemy3Category):
             if enemy3.isDead == true {
             score += 1
             die()
             }*/
             
           /*  case(robotCategory | obstacleCategory):
             if bot.jump() {
             score += 1
             } else {
             bot.isDead = true*/
 
            
            
        //death of enemy
        case (enemy1Category | endOfScreenCategory):
            enemy1.isDead = true
            
        case (enemy2Category | endOfScreenCategory):
            enemy2.isDead = true
            
        case (enemy3Category | endOfScreenCategory):
            enemy3.isDead = true
            
        case (enemy4Category | endOfScreenCategory):
            enemy4.isDead = true
            
        //enemy jumping
        case enemy1Category | groundCategory:
            if (enemy1.health != 0 && enemy1.jumper == true) {
                enemy1.jump()
            }
        case enemy2Category | groundCategory:
            if (enemy2.health != 0 && enemy2.jumper == true) {
                enemy2.jump()
            }
        case enemy3Category | groundCategory:
            if (enemy3.health != 0 && enemy3.jumper == true) {
                enemy3.jump()
            }
            
        case enemy4Category | groundCategory:
            if (enemy4.health != 0 && enemy4.jumper == true) {
                enemy4.jump()
            }
            
            
        case (obstacleCatergory | robotCategory):
           if(!bot.isDead && !obstacle.isGone) {
                die()
          /*  if bot.jump {
                score += 1
            } else {
                bot.isDead = true
            }*/
           }
        //TODO Implement
        case (obstacleCatergory | endOfScreenCategory):
            obstacle.isGone = true
            // case (obstacleCatergory | enemy1Category | robotCategory):
            //  bot.isDead = true
            
        case (obstacleCatergory | groundCategory):
            if(obstacle.health != 0 && obstacle.isMoving == true) {
                obstacle.obstacleMove()
            }
            
        case (obstacleCategory | weapon1Category):
            obstacle.health = obstacle.health - 1
            if(obstacle.isGone) {
                fire1.fire.removeFromParent()
            }
            
            if obstacle.health == 0 {
                obstacle.isGone = true
                score += 1
                self.scoreText.text = String(self.score)
            }
            
        case (obstacleCategory | weapon2Category):
            block.health  = block.health - 1
            if(block.gone) {
                fire2.fire.removeFromParent()
            }
            if block.health == 0 {
                block.isGone = true
                score += 1
                self.scoreText.text = String(self.score)
            }
            
        case obstacleCategory | weapon3Category:
            bomb.health = bomb.health - 1
            if(bomb.gone) {
                fire3.fire.removeFromParent()
            }
            if bomb.health == 0 {
                bomb.isGone = true
                score += 1
                self.scoreText.text = String(self.score)
            }
        case obstacleCategory | weapon4Category:
            obstacle.health = obstacle.health - 1
            if (!obstacle.gone) {
                fire4.fire.removeFromParent()
                
            }
            if obstacle.health == 0 {
                obstacle.isGone = true
                score += 1
                self.scoreText.text = String(self.score)
                // enemy4.playDeadAnimation(frame.size.width)
            }
            
            
            
        case (coinCatergory | robotCategory): break
            
            //if coin.IsCollected { coin += 1 }
            
        default:
            return
        }
        
    }
    
    
    //Run everytime frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
        if enemy1.isDead {
            enemy1.isDead = false
            let respawnSequence = SKAction.sequence([SKAction.run({self.enemy1.robot.removeFromParent()}), SKAction.run({
                self.enemy1.health = 1
                self.addChild(self.enemy1.createEnemy(self.frame.size.width))
                self.enemy1.robot.physicsBody!.categoryBitMask = self.enemy1Category
            })])
            self.run(respawnSequence)
        }
        if enemy2.isDead {
            enemy2.isDead = false
            let respawnSequence = SKAction.sequence([SKAction.run({self.enemy2.robot.removeFromParent()}), SKAction.run({
                self.enemy2.health = 1
                self.addChild(self.enemy2.createEnemy(self.frame.size.width))
                self.enemy2.robot.physicsBody!.categoryBitMask = self.enemy2Category
            })])
            self.run(respawnSequence)
        }
        
        if enemy3.isDead {
            enemy3.isDead = false
            let respawnSequence = SKAction.sequence([SKAction.run({self.enemy3.robot.removeFromParent()}), SKAction.run({
                self.enemy3.health = 1
                self.addChild(self.enemy3.createEnemy(self.frame.size.width))
                self.enemy3.robot.physicsBody!.categoryBitMask = self.enemy3Category
            })])
            self.run(respawnSequence)
        }
        
        if enemy4.isDead {
            enemy4.isDead = false
            let respawnSequence = SKAction.sequence([SKAction.run({self.enemy4.robot.removeFromParent()}), SKAction.run({
                self.enemy4.health = 1
                self.addChild(self.enemy4.createEnemy(self.frame.size.width))
                self.enemy4.robot.physicsBody!.categoryBitMask = self.enemy4Category
            })])
            self.run(respawnSequence)
        }
        
        if obstacle.isGone {
            obstacle.isGone = false
            let respawnSequence = SKAction.sequence([SKAction.run({self.obstacle.gone}), SKAction.run({
                self.obstacle.health = 1
                self.addChild(self.obstacle.createObstacles(self.frame.size.width))
                self.physicsBody!.categoryBitMask = self.obstacleCategory //obstacle
            })])
            self.run(respawnSequence)
        }
        
        //timer/scaling difficulty
        if (!bot.isDead) {
            timer += 1
            if ((timer > 400) && (!enemy2.isSpawning)) {
                enemy2.isSpawning = true
                enemy2.isDead = true
            }
            if (timer > 100 && timer < 800) {
                enemy1.willJump = false
                enemy1.canJump = true
            }
            if ((timer > 900) && (!enemy3.isSpawning)) {
                enemy3.isSpawning = true
                enemy3.isDead = true
                enemy2.canJump = true
            }
            if (timer > 200) {
                enemy1.willJump = true
            }
            if (timer > 1400) {
                enemy1.willJump = true
            }
            if ((timer > 2000) && (!enemy4.isSpawning)) {
                enemy4.isSpawning = true
                enemy4.isDead = true
                enemy2.willJump = true
            }
            if (timer > 3000) {
                enemy4.canJump = true
            }
            
            if(timer > 500) && (!obstacle.isSpawning) {
                obstacle.isSpawning = true
            }
            if(timer > 1000) && (!obstacle.isMoving) {
                obstacle.isMoving = true
            }
        }
    }
    
    //Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch: AnyObject in touches {
            let location = touch.location(in:self)
            
            //Throwing stars
            if (attackButton.frame.contains(touch.location(in: self)) && (!bot.isDead) && (bot.inventory != 0)) {
                bot.playThrowAnimation()
                bot.inventory -= 1
                updateInventory(bot.inventory)
                if (!fire1.isThrown) {
                    fire1.fire.removeFromParent()
                    fire1.createWeapons()
                    fire1.fire.physicsBody!.categoryBitMask = weapon1Category
                    self.addChild(fire1.fire)
                    fire1.throwFire(bot.robot.position.x, positiony: bot.robot.position.y)
                } else if (!fire2.isThrown) {
                    fire2.fire.removeFromParent()
                    fire2.createWeapons()
                    fire2.fire.physicsBody!.categoryBitMask = weapon2Category
                    self.addChild(fire2.fire)
                    fire2.throwFire(bot.robot.position.x, positiony: bot.robot.position.y)
                } else if (!fire3.isThrown) {
                    fire3.fire.removeFromParent()
                    fire3.createWeapons()
                    fire3.fire.physicsBody!.categoryBitMask = weapon3Category
                    self.addChild(fire3.fire)
                    fire3.throwFire(bot.robot.position.x, positiony: bot.robot.position.y)
                } else if (!fire4.isThrown) {
                    fire4.fire.removeFromParent()
                    fire4.createWeapons()
                    fire4.fire.physicsBody!.categoryBitMask = weapon4Category
                    self.addChild(fire4.fire)
                    fire4.throwFire(bot.robot.position.x, positiony: bot.robot.position.y)
                }
                if (!timerIsRunning) {
                    rechargeInventory()
                }
            }
            
            //Jumping
            if (jumpButton.frame.contains(touch.location(in: self)) && (bot.onGround) && (!bot.isDead))  {
             //   bot.jump()
                bot.playJumpAnimation()
            }
            
            
           // move up 20
            //it works here
          //  let jumpUpAction = SKAction.moveBy(x: 0, y:20, duration:0.2)
            // move down 20
          //  let jumpDownAction = SKAction.moveBy(x:0, y:-20,  duration:0.2)
            // sequence of move yup then down
          //  let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
           // bot.playJumpAnimation()
            bot.jump()
            
            if (duckButton.frame.contains(touch.location(in: self)) && (bot.onGround) && (!bot.isDead))  {
                bot.duck()
                
            }
            
            if (self.menuButton.frame.contains(touch.location(in: displayPanel))) {
                if let scene = MenuScene.unarchiveFromFile("MenuScene") as? MenuScene {
                    //   if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                    let skView = self.view as SKView?
                    skView?.ignoresSiblingOrder = true
                    scene.scaleMode = .aspectFill
                    skView?.presentScene(scene)
                }
            }
            
            if (self.playButton.frame.contains(touch.location(in: displayPanel))) {
                self.removeAllChildren()
                let scene = GameScene(size: self.size)
                let skView = self.view as SKView?
                skView?.ignoresSiblingOrder = false
                scene.scaleMode = .resizeFill
                scene.size = (skView?.bounds.size)!
                skView?.presentScene(scene)
            }
            
            //Pause button doesn't work yet
            
          /*    if (self.pauseButton.frame.contains(touch.location(in:self)) && (self.view?.isPaused == false)) {
                pauseGame()
             self.view?.isPaused = true
             }
             
             if (self.pauseButton.frame.contains(touch.location(in:self)) && (self.view?.isPaused == true)) {
             self.view?.isPaused = false
             }*/
        //    createPauseButton()
            //2
            if pauseButton.contains(location){
                if self.isPaused == false{
                    self.isPaused = true
                    pauseButton.texture = SKTexture(imageNamed: "play")
                } else {
                    self.isPaused = false
                    
                    pauseButton.texture = SKTexture(imageNamed: "pause.png")
                }
            }
            //figure out pause
            
          /*  if pauseButton.contains(location) {
                if ((self.view?.isPaused = true) != nil) {
                    pauseGame()
                } else {
                    unPauseGame()
                }
            }*/
            
        }
        
    }
    
    
    /*   func pauseGame() {
     self.physicsWorld.speed = 0.0
     self.speed = 0.0
     self.scene?.isPaused = true
     
     pauseButton = SKSpriteNode(imageNamed: "PauseButton")
     pauseButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
     pauseButton.position = CGPoint(x: 0, y: 0)
     pauseButton.zPosition = 10
     
     NotificationCenter.default.addObserver(self, selector: Selector(("pauseScene")),name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
     let delay = SKAction.wait(forDuration: 0.5)
     let block = SKAction.run({
     self.view!.isPaused = true
     
     let resume = SKSpriteNode(imageNamed: "Play")
     let home = SKSpriteNode(imageNamed: "Quit")
     
     resume.name = "Resume"
     resume.anchorPoint = CGPoint(x: 0.5, y: 0.5)
     resume.position = CGPoint(x: -155, y: 0)
     resume.zPosition = 11
     resume.setScale(0.75)
     
     home.name = "Quit"
     home.anchorPoint = CGPoint(x: 0.5, y: 0.5)
     home.position = CGPoint(x: 155, y: 0)
     home.zPosition = 11
     home.setScale(0.75)
     
     self.pauseButton.addChild(resume)
     self.pauseButton.addChild(home)
     
     self.addChild(self.pauseButton)
     
     
     })
     
     let sequence = SKAction.sequence([delay, block])
     self.run(sequence)
     }*/
    
    func unPauseGame() {
        self.view?.isPaused = false
    }
    
    //You die
    func die() {
        bot.isDead = true
        moving.speed = 0
        bot.playDeadAnimation()
        jumpButton.removeFromParent()
        attackButton.removeFromParent()
        duckButton.removeFromParent()
        enemy1.robot.physicsBody!.collisionBitMask = groundCategory
        SKAction.sequence([SKAction.run({
            self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        }), SKAction.wait(forDuration: TimeInterval(0.08)), SKAction.run({self.backgroundColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)})])
        
        highScoring()
    }
    
    //Game Over Screen
    func endGame() {
        audioPlayer.stop()
        let tintScreen = SKSpriteNode()
        enemy1.robot.physicsBody!.collisionBitMask = groundCategory
        tintScreen.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        tintScreen.size = CGSize(width: frame.size.width, height: frame.size.height)
        tintScreen.color = SKColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        tintScreen.zPosition = 1
        let gameOver = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run({self.addChild(tintScreen)}), SKAction.run({self.createEndPanel()})])
        self.run(gameOver)
        
        
        
        
        /* TODO: Add to end panel
         let popUpWindow = SKShapeNode(rect: CGRect(x: size.width / 4, y: size.height / 4 , width: size.width / 2, height: size.height / 2), cornerRadius: 15)
         popUpWindow.fillColor = UIColor.white
         
         
         let replayButton = SKSpriteNode(imageNamed: "restartButton")
         replayButton.position  = CGPoint(x:frame.size.width / 2, y:frame.size.height * (6/16))
         
         let popUpScoreLabel = SKLabelNode(text: "Score:")
         let popUPScoreNumLabel = SKLabelNode(text: "\(score)")
         
         let shareButton = SKSpriteNode()
         
         popUpScoreLabel.position = CGPoint(x:frame.size.width / 2 , y:10 * (frame.size.height / 16))
         popUPScoreNumLabel.position = CGPoint(x:frame.size.width / 2 , y:8.8 * (frame.size.height / 16))
         popUpScoreLabel.fontColor = UIColor.black
         popUPScoreNumLabel.fontColor = UIColor.black
         popUPScoreNumLabel.fontSize = 45
         popUPScoreNumLabel.fontName = "Arial-Bold"
         
         let textToShare = "I just did \(String(describing: scoreText)) on the game! Try to beat me, it's free!"
         
         let objectsToShare = [textToShare]
         let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
         activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.print]
         
         let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
         currentViewController.present(activityVC, animated: true, completion: nil)
         
         
         
         shareButton.position = CGPoint(x:frame.size.width / 2 , y:10 * (frame.size.height / 16))
         
         
         addChild(popUpWindow)
         addChild(popUpScoreLabel)
         addChild(popUPScoreNumLabel)
         addChild(replayButton)*/
        
        
    }
    
    //Create end game panel
    func createEndPanel() {
        playAgainText.fontSize = 42
        playAgainText.fontColor = UIColor.black
        playAgainText.position = CGPoint(x:0, y:-self.playButton.size.height/7)
        gameOverText.position = CGPoint(x:0, y:displayPanel.size.height/4)
        menuText.position = CGPoint(x:0, y:-self.menuButton.size.height/7)
        menuText.fontSize = 42
        menuText.fontColor = UIColor.black
        gameOverText.fontSize = 20
        gameOverText.fontColor = UIColor.black
        gameOverText.text = "GAME OVER"
        menuText.text = "MENU"
        playAgainText.text = "PLAY AGAIN"
        scoreText.text = String(self.score)
        scoreText.fontSize = 10
        scoreText.fontColor = UIColor.white
        coinsText.fontColor = UIColor.black
        coinsText.fontSize = 20
        var coins = (score / 2) * (timer/150) //change
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.zPosition = 10
        coinImage.setScale(0.14)
        coinsText.text = (String(coins))
        coinsText.position = CGPoint(x:-coinImage.size.width * 1.1, y:displayPanel.size.height - self.playButton.size.height * 2)
        coinImage.position = CGPoint(x:coinImage.size.width, y:displayPanel.size.height - self.playButton.size.height * 1.9)
        displayPanel.addChild(coinsText)
        displayPanel.addChild(coinImage)
        displayPanel.addChild(scoreText)
        
        displayPanel.zPosition = 10
        self.menuButton.addChild(menuText)
        self.playButton.addChild(playAgainText)
        self.playButton.position = CGPoint(x:0, y:displayPanel.size.height - self.playButton.size.height*2.25)
        self.menuButton.position = CGPoint(x:0, y:displayPanel.size.height - self.playButton.size.height*2.65)
        displayPanel.setScale(2.7)
        self.playButton.setScale(0.28)
        self.menuButton.setScale(0.28)
        displayPanel.addChild(gameOverText)
        displayPanel.addChild(self.playButton)
        displayPanel.addChild(self.menuButton)
        // displayPanel.addChild(self.leaderboardButton)
        displayPanel.position = CGPoint(x:frame.size.width/2, y:frame.size.height + displayPanel.size.height)
        self.addChild(displayPanel)
        let moveDisplay = SKAction.moveBy(x: 0, y: -(frame.size.height/2 + displayPanel.size.height), duration: 1)
        displayPanel.run(moveDisplay)
        
        addCoins(coins: coins)
        
    }
    
    func highScoring() {
        UserDefaults.standard.integer(forKey:"highscore")
        
        //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
        if score > UserDefaults.standard.integer(forKey:"highscore") {
            UserDefaults.standard.set(score, forKey: "highscore")
            UserDefaults.standard.synchronize()
        }
        
        UserDefaults.standard.integer(forKey:"highscore")
        
    }
    
    func pauseGame() {
        
        self.view?.isPaused = true
        self.physicsWorld.speed = 0.0
        
        pauseMenuText.fontSize = 45
        pauseMenuText.fontColor = UIColor.black
        pauseMenuText.text = ("MENU")
        resumeText.fontSize = 45
        resumeText.fontColor = UIColor.black
        resumeText.text = ("RESUME")
        restartText.fontSize = 45
        restartText.fontColor = UIColor.black
        restartText.text = ("NEW GAME")
        pauseMenuButton.setScale(0.8)
        pauseMenuButton.position = CGPoint(x:(frame.size.width/2) + (pauseMenuButton.size.width * 1.2), y:(frame.size.height/2 + pauseMenuButton.size.height))
        resumeButton.setScale(0.8)
        resumeButton.position = CGPoint(x:(frame.size.width/2) - (pauseMenuButton.size.width * 1.2), y:(frame.size.height/2 + pauseMenuButton.size.height))
        restartButton.setScale(0.8)
        restartButton.position = CGPoint(x:(frame.size.width/2), y:(frame.size.height/2 - pauseMenuButton.size.height))
        self.addChild(pauseMenuButton)
        self.addChild(restartButton)
        self.addChild(resumeButton)
        pauseMenuButton.addChild(pauseMenuText)
        resumeButton.addChild(resumeText)
        restartButton.addChild(restartText)
        pauseText.position = CGPoint(x:frame.size.width/2, y:frame.size.height/2 + pauseMenuButton.size.height * 2)
        self.addChild(pauseText)
    }
    
    func showInventory() {
        fireImage1.setScale(0.7) //0.6
        fireImage1.position = CGPoint(x: self.frame.minX + (fireImage1.size.width), y: self.frame.maxY - (1.07 * pauseButton.size.height)) //1.07
        fireImage2.setScale(0.7) //0.6
        fireImage2.position = CGPoint(x: self.frame.minX + (fireImage2.size.width * 1.5), y: self.frame.maxY - (1.07 * pauseButton.size.height))
        fireImage3.setScale(1.7)
        fireImage3.position = CGPoint(x: self.frame.minX + (fireImage3.size.width * 2), y: self.frame.maxY - (1.07 * pauseButton.size.height))
        fireImage4.setScale(1.7) //0.6
        fireImage4.position = CGPoint(x: self.frame.minX + (fireImage4.size.width * 2.5), y: self.frame.maxY - (1.07 * pauseButton.size.height))
        fireImage1.isHidden = true
        fireImage2.isHidden = true
        fireImage3.isHidden = true
        fireImage4.isHidden = true
        self.addChild(fireImage1)
        self.addChild(fireImage2)
        self.addChild(fireImage3)
        self.addChild(fireImage4)
        updateInventory(bot.inventory)
        
    }
    
    func updateInventory(_ inventory: Int) {
        if (inventory > 0) {
            fireImage1.isHidden = false
        } else {
            fireImage1.isHidden = true
        }
        if (inventory > 1) {
            fireImage2.isHidden = false
        } else {
            fireImage2.isHidden = true
        }
        if (inventory > 2) {
            fireImage3.isHidden = false
        } else {
            fireImage3.isHidden = true
        }
        if (inventory > 3) {
            fireImage4.isHidden = false
        } else {
            fireImage4.isHidden = true
        }
        
    }
    
    func rechargeInventory() {
        self.timerIsRunning = true
        let recharge = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(rechargeSpeed)), SKAction.run({
            if (self.fire1.isThrown == true) {
                self.fire1.isThrown = false
            } else if (self.fire2.isThrown == true) {
                self.fire2.isThrown = false
            } else if (self.fire3.isThrown == true) {
                self.fire3.isThrown = false
            } else if (self.fire4.isThrown == true) {
                self.fire4.isThrown = false
            }
            self.bot.inventory += 1
            self.updateInventory(self.bot.inventory)
            if (self.bot.inventory < self.fullInventory) {
                self.rechargeInventory()
            } else {
                self.timerIsRunning = false
            }
        })])
        self.run(recharge)
    }
    
    //If needed to comment out tha comment out
  /* func createEndOfScreen() {
        //End of Screen stuff
        let endScreenSize = CGSize(width: leftEndOfScreen.size.width, height: leftEndOfScreen.size.height)
        leftEndOfScreen.physicsBody = SKPhysicsBody(rectangleOf: endScreenSize)
        leftEndOfScreen.position = CGPoint(x:-enemy1.robot.size.width, y:frame.size.height/2)
        leftEndOfScreen.isHidden = true //was false
        leftEndOfScreen.physicsBody!.categoryBitMask = endOfScreenCategory
        leftEndOfScreen.physicsBody!.contactTestBitMask = weaponCategory | enemy1Category | enemy2Category | enemy3Category | enemy4Category
        //  leftEndOfScreen.physicsBody?.collisionBitMask = groundCategory
        leftEndOfScreen.physicsBody?.isDynamic = false
        
        rightEndOfScreen.physicsBody = SKPhysicsBody(rectangleOf: endScreenSize)
        rightEndOfScreen.position = CGPoint(x:frame.size.width + fire1.fire.size.width, y:frame.size.height/2)
        rightEndOfScreen.physicsBody!.categoryBitMask = endOfScreenCategory
        rightEndOfScreen.physicsBody!.contactTestBitMask = weaponCategory
        // rightEndOfScreen.physicsBody?.collisionBitMask = groundCategory
        
        rightEndOfScreen.physicsBody?.isDynamic = false
        
        self.addChild(leftEndOfScreen)
        self.addChild(rightEndOfScreen)
        
    }*/
    
    func createScoreBoard() {
        //Score
        self.scoreText.text = "\(score)"
        self.scoreText.fontSize = 70
        self.scoreText.zPosition = 35
        // scoreText.verticalAlignmentMode = .top
        //   self.scoreText.horizontalAlignmentMode = .center
        self.scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.scoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        //  self.scoreText.position = CGPoint(x: self.frame.width/1.05, y: self.frame.height/1.1)
        self.scoreText.position = CGPoint(x:40,  y:665)
        
        //       self.scoreText.position = CGPoint(x:80,  y:665)
        
        self.scoreText.fontColor = UIColor.white
        
        
        // scoreText = SKLabelNode(fontNamed: "Menlo-Bold")
        /* scoreText.fontSize = 35
         scoreText.zPosition = 35
         
         scoreText.position = CGPoint(x: frame.midX, y: frame.maxY - 20)
         scoreText.horizontalAlignmentMode = .center
         scoreText.text =  "\(score)"
         scoreText.fontColor =  UIColor.white*/
        /*   scoreText.fontSize = 50
         scoreText.zPosition = 35
         scoreText.position = CGPoint(x:frame.midX, y:frame.midY - 20)
         scoreText.verticalAlignmentMode = .top
         scoreText.horizontalAlignmentMode = .center
         scoreText.text = "\(score)"
         scoreText.fontColor = UIColor.white*/
        
        //  self.scoreText.fontColor = SKColor.white
        //   self.scoreText.fontSize = 50
        //    self.scoreText.zPosition = 50
        //   self.scoreText.text = "\(score)"
        //   scoreText.verticalAlignmentMode = .top
        //  self.scoreText.horizontalAlignmentMode = .center
        //  scoreText.position = CGPoint(x:self.frame.width - 10, y: self.frame.height - 10 + self.frame.height/2.5)
        //   self.scoreText.position  = CGPoint(x:self.size.width/350, y:self.size.height/350 + self.size.height/350) //test
        //scoreText.position = CGPoint(x:self.size.width - 10, y:self.size.height - 10)
        
        self.addChild(scoreText)
        
    }
    
   func createPauseButton() {
        //Pause Button
        //Pause Button
        pauseButton.setScale(10)
        //  pauseButton.position = CGPoint(x: self.frame.minX + (0.4 * pauseButton.size.width), y: self.frame.maxY - (0.4 * pauseButton.size.height))
   //    pauseButton.position = CGPoint(x: self.frame.minX + (1.05 * pauseButton.size.width), y: self.frame.maxY - (1.05 * pauseButton.size.height)) //original
    
        self.pauseButton.position = CGPoint(x:40,  y:500)

        
      //  self.pauseButton.position = CGPoint(x:(self.frame.maxX) - pauseButton.frame.width/2 , y:(self.frame.maxY) - pauseButton.frame.height/2)

    //    self.pauseButton.position = CGPoint(x: self.frame.maxX) - pauseButton.frame.width,

        

     //   pauseButton.position = CGPoint(x: -self.frame.width/2 + 20, y: self.frame.height/2 - 20) //test
        pauseButton.zPosition = 10

        pauseButton.addChild(pausePicture)
        self.addChild(pauseButton)
    }
    
 /*   func createPauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.size = CGSize(width:40, height:40)
        pauseButton.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseButton.zPosition = 6
        self.addChild(pauseButton)
    }*/
    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "Ground")
        groundTexture.filteringMode = .nearest
        
        //    for i in 0 ... 1 {
        for _ in stride(from: 0, to: 2 + self.frame.size.width / groundTexture.size().width, by: 1) { //i
            
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10 //-10'
            ground.anchorPoint = CGPoint(x:0.5,y:0.5)
            //ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 4.0)
            
            //  ground.position = CGPoint(x: 0, y: groundTexture.size().height / +0)  //+ 0
            ground.position = CGPoint(x: 0 - self.size.width / 2 + ground.size.width / 2, y: 0 - self.size.height / 2 + ground.size.height / 2)
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 2.0, height: groundTexture.size().height / 1.0)) //erase  * 4 test
            ground.setScale(1.1)
            //    ground.size = CGSize(width: 1.5, height: 1.5) //test size instead of setScale
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.allowsRotation  = false
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.usesPreciseCollisionDetection = true
            ground.physicsBody!.categoryBitMask = groundCategory
            ground.physicsBody!.contactTestBitMask = robotCategory | enemy1Category | enemy2Category | enemy3Category | enemy4Category | obstacleCategory | coinCatergory
            ground.physicsBody!.collisionBitMask =  robotCategory | enemy1Category | enemy2Category | enemy3Category | enemy4Category | obstacleCategory | coinCatergory
            //  ground.physicsBody!.collisionBitMask =  robotCategory //test
            ground.physicsBody?.restitution = 0.0
            //ground.zPosition = 4.0 //see if zPosition makes the robot stay
            //    self.addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width/2.2, y: 0, duration: 2.5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width/2.2, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            
            
            /*TEST*/
            //   let groundMovement = SKAction.moveBy(x: -350, y: 1, duration: 2.0)
            //    let groundReplacement = SKAction.moveBy(x: 350, y: 0, duration: 0)
            //   let moveLoop = SKAction.sequence([groundMovement, groundReplacement])
            //     let moveForever = SKAction.repeatForever(moveLoop)         //ground.run(SKAction.repeatForever(SKAction.sequence([groundMovement, groundReplacement])))
            
            // let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(5.0 * groundTexture.size().width * 2.0))
            //    let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
            //    let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
            
            // let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: TimeInterval(5 * groundTexture.size().width * 2.0))
            //  let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            //   let moveForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
            //   let moveForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite]))
            
            //
            ground.run(moveForever)
            self.addChild(ground)
        }
    }
    
    
    func createJumpAndAttackButtons () {
        //Jump and Attack buttons
        //Jump and Attack buttons
        //Add duck button
        attackButton.position = CGPoint(x: self.frame.midX * 1.5, y: self.frame.midY)
        jumpButton.position = CGPoint(x: self.frame.midX / 2, y: self.frame.midY)
        duckButton.position = CGPoint(x:self.frame.midX * 1.0, y:self.frame.midY)
        jumpButton.physicsBody?.isDynamic = false
        attackButton.physicsBody?.isDynamic = false
        duckButton.physicsBody?.isDynamic = false
        attackButton.isHidden = true
        jumpButton.isHidden = true
        duckButton.isHidden = true
        jumpButton.setScale(1.1)
        attackButton.setScale(1.1)
        duckButton.setScale(1.1)
        
        
        self.addChild(jumpButton)
        self.addChild(attackButton)
        self.addChild(duckButton)
    }
    
    func createAndMoveClouds() {
        //Cloud spawning
        let spawnACloud = SKAction.run({self.spawnCloud()})
        let spawnThenDelayCloud = SKAction.sequence([spawnACloud, SKAction.wait(forDuration: 6.0)])
        let spawnThenDelayCloudForever = SKAction.repeatForever(spawnThenDelayCloud)
        self.run(spawnThenDelayCloudForever)
        let clouddistanceToMove = CGFloat(self.frame.width + 3.0 * cloudTexture.size().width)
        let cloudmovement = SKAction.moveBy(x: -clouddistanceToMove, y: 0.0, duration: TimeInterval(0.025 * clouddistanceToMove))
        let removeCloud = SKAction.removeFromParent()
        cloudMoveAndRemove = SKAction.sequence([cloudmovement, removeCloud])
    }
    
    //Spawn Cloud
    func spawnCloud() {
        let cloud = SKSpriteNode(imageNamed: "clouds")
        _ = arc4random() % UInt32(frame.size.height) //let y
        var randomSize = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) - 0.6
        if randomSize < 0.0 {
            randomSize = 0.2
        }
        cloud.zPosition = -11
        let randomHeight = UInt32(self.frame.size.height / 1.5) + (arc4random() % UInt32(self.frame.size.height / 2)) // var randomHeight
        cloud.setScale(randomSize)
        cloud.position = CGPoint(x:self.frame.size.width + cloud.size.width, y:CGFloat(randomHeight))
        
        cloud.run(cloudMoveAndRemove)
        self.addChild(cloud)
    }
    
    func getCoins() {
        let coin = SKSpriteNode(imageNamed: "")
        let MinValue = self.size.width / 8
        let MaxValue = self.size.width - 20
        let SpawnPoint = UInt32(MaxValue - MinValue)
        coin.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: self.size.height - 100)
        coin.physicsBody!.categoryBitMask  = coinCategory
        coin.physicsBody!.contactTestBitMask = robotCategory
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = true
        
    }
    
    func SpawnPowerUp(){
        
        let PowerUp = SKSpriteNode(imageNamed: "PowerUp.png")
        let MinValue = self.size.width / 8
        let MaxValue = self.size.width - 20
        let SpawnPoint = UInt32(MaxValue - MinValue)
        PowerUp.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: self.size.height - 100)
        
        //Physics
        PowerUp.physicsBody = SKPhysicsBody(rectangleOf: PowerUp.size)
        PowerUp.physicsBody!.categoryBitMask = powerupCategory //Sätter unikt ID för Enemy, hämtat från PhysicsCategory som vi gjorde där uppe
        // Creating unique ID for Enemy, taken from PhysicsCategory as we did up there
        
        PowerUp.physicsBody!.contactTestBitMask = robotCategory //Kolla om Enemy nuddar Bullet
        //  Check out Enemy Nuddar Bullet
        PowerUp.physicsBody?.affectedByGravity = false
        PowerUp.physicsBody?.isDynamic = true
        
        let action = SKAction.moveTo(y: -128, duration: 5)
        let actionDone = SKAction.removeFromParent()
        PowerUp.run(SKAction.sequence([action, actionDone]))
        PowerUp.run(SKAction.rotate(byAngle: 5, duration: 5))
        
        
        let powerUp = SKSpriteNode(imageNamed: "PowerUp.png")
        let powerUpTrail = SKEmitterNode(fileNamed: "PowerUpTrail.sks")!
        powerUpTrail.targetNode = self
        powerUp.addChild(powerUpTrail)
        
        self.addChild(PowerUp)
        
    }
    
    func touchDown(atPoint pos: CGPoint) {
        bot.playJumpAnimation()
    }
    
    func addCoins(coins: Int) {
        totalCoins += coins
        UserDefaults.standard.set(totalCoins, forKey: "coins")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.integer(forKey: "coins")
    }
}
