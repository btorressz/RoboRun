//
//  MenuScene.swift
//  RoboRunTester
//
//  Created by Brandon Torres on 4/26/18.
//  Copyright © 2018 Brandon Torres. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var coins = UserDefaults.standard.integer(forKey: "coins")
    let playButton = SKSpriteNode(imageNamed: "otherButton")
    let gameCenterbutton = SKSpriteNode(imageNamed:"GameCenterButton")
    //var pauseButton = SKSpriteNode(imageNamed:"pausebutton")
    var selectButton = SKSpriteNode(imageNamed:"")
    let shopButton = SKSpriteNode(imageNamed: "otherButton")
    let title = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    var moving: SKNode!
    var scoreLabel = SKLabelNode(fontNamed: "")
    //  let startText = SKLabelNode(fontNamed: "")
    //  let shopText = SKLabelNode(fontNamed: "")
    //  let gamecenterText = SKLabelNode(fontNamed:"")
    let gameText = SKLabelNode(fontNamed: "")
    var coinImage = SKSpriteNode(imageNamed: "coin")
    var cloudTexture = SKTexture(imageNamed: "Cloud")
    var cloudMoveAndRemove = SKAction()
    var highScore = UserDefaults.standard.integer(forKey: "highscore")
    var coinText = SKLabelNode(fontNamed: "Futura-CondensedExtraBold ")
    var cheatCount = 0
    var isCheating = false
    //  let leftEndOfScreen = SKSpriteNode(imageNamed: "endOfScreen")
    //   let rightEndOfScreen = SKSpriteNode(imageNamed: "endOfScreen")
    let enemy1Category: UInt32 = 1 << 3
    let enemy2Category: UInt32 = 1 << 4
    let coinCatergory:UInt32 = 1 << 5
    let powerUpCatergory:UInt32 = 1 << 6
    let obstacleCatergory:UInt32 = 1 << 7
   // let endOfScreenCategory: UInt32 = 1 << 8 //End of screen
    
    
    
    override func didMove(to view: SKView) {
        
        /*let notificationCenter = NotificationCenter.default
         notificationCenter.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
         notificationCenter.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
         notificationCenter.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
         notificationCenter.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)*/
        
        
        moving = SKNode()
        self.addChild(moving)
        moving.speed = 0
        createAndMoveClouds()
        //  var skyColor = SKColor(red: 90.0/255.0, green: 192.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        //        var skyColor = SKColor(red: 80.0/255.0, green: 180.0/255.0, blue: 230/255.0, alpha: 1.0)
        let  skyColor = SKColor(red: 0.00, green: 0.05, blue: 0.50, alpha: 1.0)
        
        
        backgroundColor = skyColor
        
        self.playButton.setScale(1.5)
        self.playButton.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.midY + self.playButton.size.height * 0.6)
        self.shopButton.setScale(1.5)
        self.shopButton.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.midY - self.playButton.size.height * 0.6)
        self.gameCenterbutton.setScale(1.5)
        self.gameCenterbutton.position = CGPoint(x: (self.frame.size.width/2), y: self.frame.midY + self.gameCenterbutton.size.height * 0.6)
        self.addChild(self.shopButton)
        self.addChild(self.playButton)
        self.addChild(self.gameCenterbutton)
        //  self.startText.text = ("START")
        //  startText.fontColor = UIColor.black
        //  startText.fontSize = 50
        //  shopText.text = ("SHOP")
        //  shopText.fontColor = UIColor.black
        //  shopText.fontSize = 50
        //  gamecenterText.fontColor = UIColor.red
        //  gamecenterText.fontSize = 50
        //  startText.position = CGPoint(x: 0, y: -self.playButton.size.height / 8)
        //  shopText.position = CGPoint(x: 0, y: -self.shopButton.size.height / 8)
        //   gamecenterText.position = CGPoint(x:0, y: self.gameCenterbutton.size.height/8)
        //   self.playButton.addChild(startText)
        //   self.shopButton.addChild(shopText)
        //   self.gameCenterbutton.addChild(gamecenterText)
        
        coinText.fontSize = 50
        coinText.fontColor = UIColor(red:1.00, green:0.80, blue:0.20, alpha:1.0)
        if (coins > 99999) {
            coinText.text = "99999"
        } else {
            coinText.text = String(coins)
        }
        coinText.position = CGPoint(x: frame.minX + (coinImage.size.width * 1.5), y: frame.maxY - (coinImage.size.height * 2.5))
        self.addChild(coinText)
        coinImage.setScale(0.5)
        coinImage.position = CGPoint(x: frame.minX + (coinImage.size.width * 0.7), y: (frame.maxY - (coinImage.size.height * 4.5)))
        self.addChild(coinImage)
        
        //Text
        title.text = "Robo Run"
        title.fontSize = 130
        title.fontColor = UIColor(red:0.20, green:0.60, blue:1.00, alpha:1.0)
        title.position = CGPoint(x: frame.width/2, y: frame.height/1.35)
        self.addChild(title)
        
        /*TODO: MAKE GROUND LIKE GAMESCENE */
        let groundTexture = SKTexture(imageNamed: "Ground")
        groundTexture.filteringMode = .nearest
        
        let moveLeft = SKAction.moveBy(x: -groundTexture.size().width/2.2, y: 0, duration: 2.5)
        let moveReset = SKAction.moveBy(x: groundTexture.size().width/2.2, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        
        /*let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.006 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))*/
        
        //Move Ground
        // for i:CGFloat in 0..<(2.0 + self.frame.size.width / ( groundTexture.size().width * 0.5 ) {
        //See how works if commented out
        for i in stride(from: 0, to: 2 + self.frame.size.width / groundTexture.size().width, by: 1) {
            
            // let theFloat = CGFloat(i)
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(1.0)
            sprite.position = CGPoint(x:i * sprite.size.width, y:sprite.size.height)
            sprite.run(moveForever, withKey: "moveGroundSprite")
            sprite.physicsBody?.isDynamic = false
            self.moving.addChild(sprite)
        }
        
        //Set initial inventory value
        UserDefaults.standard.integer(forKey: "inventory")
        if (UserDefaults.standard.integer(forKey: "inventory") == 0) {
            UserDefaults.standard.set(1, forKey: "inventory")
            UserDefaults.standard.synchronize()
        }
        UserDefaults.standard.integer(forKey: "inventory")
        
        //Set initial throwing star recharge speed
        UserDefaults.standard.float(forKey: "rechargeSpeed")
        if (UserDefaults.standard.float(forKey: "rechargeSpeed") == 0) {
            UserDefaults.standard.set(2.5, forKey: "rechargeSpeed")
            UserDefaults.standard.synchronize()
        }
        UserDefaults.standard.float(forKey: "rechargeSpeed")
        
        //Display highscore
        if (highScore != 0) {
            scoreLabel.text = ("HIGH SCORE: " + String(highScore))
            scoreLabel.fontColor = UIColor.white
            scoreLabel.fontSize = 55
            scoreLabel.position = CGPoint(x: frame.width/2, y: frame.height/1.5)
            
            self.addChild(scoreLabel)
        }
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            /*  if (self.atPoint(location) == self.startButton) || (self.atPoint(location) == self.startText) {
             let scene = GameScene(size: self.size)
             let skView = self.view as SKView!
             skView?.ignoresSiblingOrder = true
             scene.scaleMode = .resizeFill
             scene.size = (skView?.bounds.size)!
             self.removeAllChildren()
             skView?.presentScene(scene)
             }*/
            
            if (self.atPoint(location) == self.playButton) {
                let scene = GameScene(size: self.size)
                let skView = self.view as SKView?
                skView?.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = (skView?.bounds.size)!
                self.removeAllChildren()
                skView?.presentScene(scene)
            }
            
            
            
            
            
            /* if(self.atPoint(location) == self.pauseButton) {
             if(self.atPoint(location) == pauseButton)||(self.atPoint(location) == self.startText) do {
             pause()
             self.scene?.isPaused = true
             
             }
             
             if (self.pauseButton.frame.contains(touch.location(self)) && (self.view?.isPaused == true)) {
             self.view?.isPaused = false
             }*/
            
            /* if (self.atPoint(location) == self.shopButton) || (self.atPoint(location) == self.shopText) {
             let scene = ShopScene(size: self.size)
             let skView = self.view as SKView!
             skView?.ignoresSiblingOrder = true
             scene.scaleMode = .resizeFill
             scene.size = (skView?.bounds.size)!
             self.removeAllChildren()
             skView?.presentScene(scene)
             
             }*/
            
           /* if (self.atPoint(location) == self.shopButton) {
                let scene = ShopScene(size: self.size)
                let skView = self.view as SKView!
                skView?.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = (skView?.bounds.size)!
                self.removeAllChildren()
                skView?.presentScene(scene)
                
            }*/
            
          /*  if(self.atPoint(location) == self.selectButton) {
                let scene = SelectPlayerScene(size:self.size)
                let skView = self.view as SKView!
                skView?.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = (skView?.bounds.size)!
                self.removeAllChildren()
                skView?.presentScene(scene)
                
            }*/
            
            
            
            if(self.atPoint(location) == gameCenterbutton) {
                
            }
            
            if ((self.atPoint(location) == self.coinImage)) {
                cheatCount += 1
                if (cheatCount == 10) {
                    UserDefaults.standard.set(99999, forKey: "coins")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.integer(forKey: "coins")
                    coins = UserDefaults.standard.integer(forKey: "coins")
                    coinText.text = String(coins)
                    isCheating = true
                } else if (cheatCount > 10) {
                    cheatCount = 0
                }
            }
            
            if ((self.atPoint(location) == self.title) && cheatCount >= 10) {
                cheatCount += 1
                if (cheatCount == 25) {
                    gameText.color = UIColor.black
                    gameText.position = CGPoint(x: self.frame.midX - self.playButton.size.width, y: self.frame.midY)
                    gameText.text = ""
                    self.addChild(gameText)
                }
            }
        }
    }
    
    func createAndMoveClouds() {
        //Cloud spawning
        let spawnACloud = SKAction.run({self.spawnCloud()})
        let spawnThenDelayCloud = SKAction.sequence([spawnACloud, SKAction.wait(forDuration: 6.0)])
        let spawnThenDelayCloudForever = SKAction.repeatForever(spawnThenDelayCloud)
        self.run(spawnThenDelayCloudForever)
        let clouddistanceToMove = CGFloat(self.frame.width + 4.0 * cloudTexture.size().width)
        let cloudmovement = SKAction.moveBy(x: -clouddistanceToMove, y: 0.0, duration: TimeInterval(0.025 * clouddistanceToMove))
        let removeCloud = SKAction.removeFromParent()
        cloudMoveAndRemove = SKAction.sequence([cloudmovement, removeCloud])
    }
    
    //Spawn Cloud
    func spawnCloud() {
        let cloud = SKSpriteNode(imageNamed: "Cloud")
        _ = arc4random() % UInt32(frame.size.height)
        var randomSize = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) - 0.6
        if randomSize < 0.0 {
            randomSize = 0.2
        }
        cloud.zPosition = -11
        let randomHeight = UInt32(self.frame.size.height / 1.5) + (arc4random() % UInt32(self.frame.size.height / 2))
        cloud.setScale(randomSize)
        cloud.position = CGPoint(x: self.frame.size.width + cloud.size.width, y: CGFloat(randomHeight))
        
        cloud.run(cloudMoveAndRemove)
        self.addChild(cloud)
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
}
