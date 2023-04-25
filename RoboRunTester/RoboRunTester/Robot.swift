//
//  Robot.swift
//  RoboRunTester
//
//  Created by Brandon Torres on 4/26/18.
//  Copyright © 2018 Brandon Torres. All rights reserved.
//

import Foundation
import SpriteKit

//Colliders
let groundCategory: UInt32 = 1 << 0
let robotCategory: UInt32 = 1 << 1
let weaponCategory: UInt32 = 1 << 2 //robots weapons
let enemy1Category: UInt32 = 1 << 3
let enemy2Category: UInt32 = 1 << 4
let enemy3Category: UInt32 = 1 << 5
let enemy4Category: UInt32 = 1 << 6
let coinCategory:UInt32 = 1 << 7
let obstacleCatergory:UInt32 =  1 << 8
let powerupCategory:UInt32 = 1 << 9
let enemyWeaponCategory: UInt32 = 1 << 7 //Enemy weapons
let endOfScreenCategory: UInt32 = 1 << 8 //End of screen
let groundTexture = SKSpriteNode(imageNamed: "Ground")

/*let groundCategory: UInt32 =  0
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
 let endOfScreenCategory: UInt32 = 0b1000 //End of screen*/

/*let groundCategory: UInt32 = 0
 let robotCategory: UInt32 =  1
 let weaponCategory: UInt32 = 2 //robots weapons
 let enemy1Category: UInt32 =  3
 let enemy2Category: UInt32 =  4
 let enemy3Category: UInt32 = 5
 let enemy4Category: UInt32 =  6
 let coinCategory:UInt32 =  7
 let obstacleCatergory:UInt32 =  8
 let powerupCategory:UInt32 =  9
 let enemyWeaponCategory: UInt32 =  7 //Enemy weapons
 let endOfScreenCategory: UInt32 =  8 //End of screen*/


class Robot {
    
    var isDead = false
    var health:Int = 0
    var inventory:Int = 0
    var robot = SKSpriteNode(imageNamed: "robot.png")
    var onGround = false
    //   var size:CGSize
    
    init(health:Int,inventory:Int) {
        // self.init()
        self.health = health
        self.inventory = inventory
    }
    
    //   required  convenience init?(coder aDecoder: NSCoder) {
    //  fatalError("init(coder:) has not been implemented")
    //  }
    
    //Add physics and position to robot
    func createRobot(_ frameWidth: CGFloat) -> SKSpriteNode {
        //robot.position = CGPoint(x:frameWidth / 6, y: robot.size.height * 2.5)
        robot.position = CGPoint(x:frameWidth / 70, y: robot.size.height * 2.5)

        _ = CGSize(width: robot.size.width * 0.6, height: robot.size.height * 0.6) //was let adjustedRobotSize
        robot.physicsBody = SKPhysicsBody(rectangleOf: robot.size)
        robot.physicsBody?.isDynamic = true
        robot.setScale(0.6)
        robot.physicsBody?.restitution = 0.0
        robot.physicsBody?.velocity = CGVector(dx:0, dy:0) //test
        robot.zPosition = 1.0 //see if zpostion fixes the problem
        robot.physicsBody?.allowsRotation = false
        robot.physicsBody!.categoryBitMask = robotCategory
        robot.physicsBody!.contactTestBitMask  = groundCategory //| enemy1Category | enemy2Category | enemy3Category | enemy4Category | coinCategory | powerupCategory | obstacleCatergory | //endOfScreenCategory
        //  robot.physicsBody?.usesPreciseCollisionDetection = true
        robot.physicsBody!.collisionBitMask = groundCategory | enemy1Category | enemy2Category | enemy3Category | enemy4Category | coinCategory | powerupCategory | obstacleCatergory //| endOfScreenCategory //this was on contact
        // addChild(robot)
        self.playWalkAnimation()
        return robot
        
    }
    
    func playWalkAnimation() {
        // let walkanim: SKAction = SKAction(named:"walk")!
        //  let walkAction = SKAction.moveBy(x: 0, y:-100, duration:0.2)
        //  let group = SKAction.group([walkanim, walkAction])
        //  let seq = SKAction.sequence([group])
        
        
        
        let walkAnimArray = [SKTexture(imageNamed: "walk1"),SKTexture(imageNamed: "robot1walk2"), SKTexture(imageNamed: "robot1walk3"),  SKTexture(imageNamed: "robot1walk4")] //test
        //   let walkMove = SKAction.moveBy(x: 10, y: -15, duration: 0.8)
        
        //  let walk1 = SKTexture(imageNamed: "walk1")
        //   let walk2 = SKTexture(imageNamed: "robot1walk2")
        //   let walk3 = SKTexture(imageNamed: "robot1walk3")
        //   let walk4 = SKTexture(imageNamed: "robot1walk4")
        
        
        //  let walkAnim = SKAction.animate(with: [walk1, walk2, walk3, walk4, walk3, walk2], timePerFrame: 0.1,resize:true, restore:true)
        
        //  let walkAnim = SKAction.animate(withWarps: walkAnimArray, times: walkMove, restore: 0.1)
        let walkAnim = SKAction.animate(with: walkAnimArray, timePerFrame: 0.1)
        
        let walk = SKAction.repeatForever(walkAnim)
        robot.run(walk) //walk
        
        
    }
    
    func playJumpAnimation() {
        let jump1 = SKTexture(imageNamed: "robot1jump")
        //see if need to add walk anim or other jump
        let jumpAnim = SKAction.animate(with: [jump1], timePerFrame: 0.1)
        
        // move up 20
        let jumpUpAction = SKAction.moveBy(x: 0, y:20, duration:0.2)
        // move down 20
        let jumpDownAction = SKAction.moveBy(x: 0, y:-20, duration:0.2)
        // sequence of move yup then down
        let jumpSequence = SKAction.sequence([jumpAnim, jumpUpAction, jumpDownAction])
        
        let j = SKAction.repeatForever(jumpSequence) //jumpAnim
        robot.run(j)
    }
    
    /* func playJumpAnimation() {
     
     let jump1 = SKTexture(imageNamed: "jump")
     let jumpAnim = SKAction.animate(with: [jump1], timePerFrame: 0.1)
     let j = SKAction.repeatForever(jumpAnim)
     robot.run(j)
     
     }*/
    
    /*   func jump() {
     robot.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
     robot.physicsBody?.restitution = 0.5
     playJumpAnimation()
     onGround = false
     
     }*/
    
    func jump() {
        if onGround {
            self.robot.physicsBody?.velocity = CGVector(dx: 0.1, dy: 100.0)
            self.robot.physicsBody?.applyImpulse(CGVector(dx: 200.0, dy: 300.0)) //200 300
            playJumpAnimation()
            onGround = false
        } else {
            onGround = true
            playWalkAnimation()
        }
        
    }
    
    
    
    
    func playDuckAnimation() {
        let duck1 = SKTexture(imageNamed: "robotDuck")
        let duckAnim = SKAction.animate(with: [duck1], timePerFrame: 0.2)
        let d = SKAction.repeatForever(duckAnim) //was let d
        robot.run(d)
    }
    
    func duck() {
        robot.physicsBody?.applyForce(CGVector(dx:100, dy:0))
        playDuckAnimation()
        onGround = true
    }
    
    
    
    func playThrowAnimation() {
        let Tthrow = SKTexture(imageNamed: "throw")
        let playThrow = SKAction.animate(with: [Tthrow], timePerFrame: 20.0)
        robot.run(playThrow)
    }
    
    func playDeadAnimation() {
        isDead = true
        robot.physicsBody!.collisionBitMask = groundCategory
        let dead = SKTexture(imageNamed: "robotover")
        let deadAnim = SKAction.repeatForever(SKAction.animate(with: [dead], timePerFrame: 20.0))
        robot.run(deadAnim)
        robot.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
    }
    
}

class Enemy {
    var enemyMoveAndRemove: SKAction!
    var isDead = false
    var dying = false
    var isSpawning = false
    var willJump = false
    var canJump = false
    var health: Int = 0
    var jumper = false
    var fakeHealth: Int = 0
    var robot = SKSpriteNode(imageNamed: "enemyIdle")
    var onGround = false
    init(health: Int) {
        //   self.init()
        self.health = health
        self.fakeHealth = health
        //   super.init(health:health, size:size)
    }
    
    // required  convenience init?(coder aDecoder: NSCoder) {
    //  fatalError("init(coder:) has not been implemented")
    //   }
    
    func createEnemy(_ frameWidth: CGFloat)-> SKSpriteNode{
        dying = false
        if (canJump == true && willJump == false) {
            let check = arc4random_uniform(2)
            if (check < 1) {
                self.jumper = true
            } else {
                self.jumper = false
            }
        } else if (willJump == true) {
            self.jumper = true
        }
        //Random stats
        var speed = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 0.01
        var size = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        //if size or speed are too low or fast
        if size < 0.4 || size > 0.7 {
            size = 0.55
        }
        if speed < 0.0035 || self.jumper == true {
            speed = 0.0047
            if (size < 0.42) {
                size = 0.46
            }
            
        }
        
        robot.position = CGPoint(x: frameWidth + robot.size.width, y: groundTexture.size.height)
        //   let adjustedNinjaSize = CGSize(width: robot.size.width * (size / 1.5), height: robot.size.height * size)
        let adjustedRobotSize = CGSize(width: robot.size.width * (size / 2.0), height: robot.size.height * size)
        robot.physicsBody = SKPhysicsBody(rectangleOf: adjustedRobotSize)
        robot.physicsBody?.isDynamic = true
        robot.setScale(size)
        robot.physicsBody?.restitution = 0.0
        robot.zPosition = 1.0
        robot.physicsBody?.allowsRotation = false
        let enemyDistanceToMove = CGFloat(frameWidth * robot.size.width)
        let enemyMovement = SKAction.moveBy(x: -enemyDistanceToMove, y: 0.0, duration: TimeInterval(speed * enemyDistanceToMove))
        let delaytime = TimeInterval(arc4random_uniform(4))
        enemyMoveAndRemove = SKAction.sequence([SKAction.wait(forDuration: delaytime), enemyMovement, SKAction.run({self.playDeadAnimation(frameWidth)})])
        
        robot.physicsBody!.contactTestBitMask = robotCategory | groundCategory
        robot.physicsBody!.collisionBitMask = groundCategory
        
        playWalkAnimation()
        robot.run(enemyMoveAndRemove, withKey: "enemyMoveAndRemove")
        // self.addChild(robot)
        return robot
    }
    
    func playWalkAnimation() {
        
        let walk1 = SKTexture(imageNamed: "robot2walk1")  //enemyWalk1
        let walk2 = SKTexture(imageNamed: "robot2walk2") //enemy2walk
        let walk3 = SKTexture(imageNamed: "robot2walk3") //enemyWalk3
    //    let walk4 = SKTexture(imageNamed: "enemyWalk4") //enemyWalk4
        
        let walkAnim = SKAction.animate(with: [walk1, walk2, walk3, walk3, walk2], timePerFrame: 0.1) //walk4
        let walk = SKAction.repeatForever(walkAnim)
        
        robot.physicsBody!.contactTestBitMask = robotCategory | groundCategory
        robot.physicsBody!.collisionBitMask = groundCategory
        robot.run(walk)
        
    }
    
    func playJumpAnimation() {
        
        let jump1 = SKTexture(imageNamed: "enemyJump")
        let jumpAnim = SKAction.animate(with: [jump1], timePerFrame: 0.1)
        let jump = SKAction.repeatForever(jumpAnim)
        
        robot.run(jump)
    }
    
 /*   func jump() {
        robot.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
        robot.physicsBody?.restitution = 0.5
        playJumpAnimation()
        onGround = false
    }*/
    
    func jump() {
        if onGround {
            self.robot.physicsBody?.velocity = CGVector(dx: 0.1, dy: 100.0)
            self.robot.physicsBody?.applyImpulse(CGVector(dx: 200.0, dy: 1000.0))
            playJumpAnimation()
            onGround = false
        } else {
            onGround = true
        }
        
    }
    
    func playThrowAnimation() {
        let Tthrow = SKTexture(imageNamed: "enemyThrow")
        let playThrow = SKAction.animate(with: [Tthrow], timePerFrame: 0.1)
        robot.run(playThrow)
    }
    
    func playDeadAnimation(_ frameWidth: CGFloat) {
        robot.physicsBody!.collisionBitMask = groundCategory
        let dead = SKTexture(imageNamed: "enemyDead")
        let deadAnim = SKAction.animate(with: [dead], timePerFrame: 0.4)
        robot.run(deadAnim)
        let enemyDistanceToMove = CGFloat(frameWidth * robot.size.width)
        _ = SKAction.moveBy(x: -enemyDistanceToMove, y: 0.0, duration: TimeInterval(0.006 * enemyDistanceToMove)) //was let enemyMovement
        let died = SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run({
            self.isDead = true
        })])
        robot.run(died)
    }
}

class Weapon {
    var isThrown = false
    var fire = SKSpriteNode(imageNamed: "fire")
    
    func createWeapons() {
        self.fire.setScale(0.8)
        //  let shurikenSize = CGSize(width: fire.size.width * 0.3, height: fire.size.height * 0.3)
        let fireSize = CGSize(width: fire.size.width * 0.3, height: fire.size.height * 0.3)
        self.fire.physicsBody = SKPhysicsBody(rectangleOf: fireSize)
        self.fire.physicsBody?.isDynamic = true
        self.fire.physicsBody?.affectedByGravity = false
        self.fire.physicsBody!.collisionBitMask = 0
        self.fire.physicsBody!.contactTestBitMask = enemy1Category | enemy2Category | enemy3Category | enemy4Category | obstacleCatergory | obstacleCatergory //| //endOfScreenCategory
    }
    
    func throwFire(_ positionx: CGFloat, positiony: CGFloat) {
        self.fire.position = CGPoint(x: positionx / 1.5, y: positiony)
        self.fire.run(SKAction.rotate(byAngle: -150, duration: 5))
        self.fire.physicsBody?.velocity = CGVector(dx: 19, dy: 0)
        self.fire.physicsBody?.applyImpulse(CGVector(dx: 19, dy: 0))
        self.isThrown = true
    }
    
    func getShield() {
        let shield = SKSpriteNode(imageNamed:"shield")
        //  shield.physicsBody = SKPhysicsBody(rectangleOf: size)
        shield.physicsBody?.isDynamic = false
        shield.physicsBody?.affectedByGravity = false
        //   shield.collisionBitMask = 0
        //   self.addChild(shield)
        
    }
    
}

class ShootFire {
    var isThrown = false
    var fire = SKSpriteNode(imageNamed: "fire.png")
    
    func createFire() {
        self.fire.setScale(0.8)
        let fireSize = CGSize(width: fire.size.width * 0.3, height: fire.size.height * 0.3)
        self.fire.physicsBody = SKPhysicsBody(circleOfRadius: fireSize.width * 0.03)
        self.fire.physicsBody?.isDynamic = false
        self.fire.physicsBody?.affectedByGravity = false
        self.fire.physicsBody!.collisionBitMask = 0
        self.fire.physicsBody!.contactTestBitMask =  enemy1Category | enemy2Category | enemy3Category | enemy4Category | obstacleCatergory // | //endOfScreenCategory
    }
    
    func fireThrown(_ posX:CGFloat, posY:CGFloat) {
        self.fire.position = CGPoint(x:posX/1.5, y: posY)
        self.fire.run(SKAction.rotate(byAngle: -150, duration: 5))
        self.fire.physicsBody?.velocity = CGVector(dx: 19, dy: 0)
        self.fire.physicsBody?.applyImpulse(CGVector(dx: 19, dy: 0))
        self.isThrown = true
    }
    
}

class Obstacles {
    var obstacle = SKSpriteNode(imageNamed:"")
    var obstacleMoveAndRemove:SKAction!
    var gone = false
    var isGone = false
    var isSpawning = false
    var isMoving = false
    var onGround = false
    var willFly = false
    var fly = false
    var health:Int
    var fakeHealth:Int
    init(health: Int) {
        self.health = health
        self.fakeHealth = health
    }
    
    func createObstacles(_ frameWidth:CGFloat) -> SKSpriteNode {
        //Random stats
        
        isGone = false
        
        if (isMoving == true && willFly == false) {
            let check = arc4random_uniform(2)
            if (check < 1) {
                self.fly = true
            } else {
                self.fly = false
            }
        } else if (willFly == true) {
            self.fly = true
        }
        //Random stats
        var speed = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 0.01
        var size = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        //if size or speed are too low or fast
        if size < 0.4 || size > 0.7 {
            size = 0.55
        }
        if speed < 0.0035 || self.fly == true {
            speed = 0.0047
            if (size < 0.42) {
                size = 0.46
            }
            
        }
        _ = CGSize(width:obstacle.size.width * 0.2, height: obstacle.size.height * 0.3) //was let obstacleSize
        self.obstacle.physicsBody?.isDynamic = true
        obstacle.zPosition = 0.2
        self.obstacle.physicsBody?.affectedByGravity = false
        self.obstacle.physicsBody!.collisionBitMask = groundCategory
        self.obstacle.physicsBody!.contactTestBitMask  =  robotCategory | endOfScreenCategory  //ADD
        
        //    var speed = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 0.01
        //  var size = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        
        
        let obstacleDistanceToMove = CGFloat(frameWidth * obstacle.size.width)
        let obstacleMovement = SKAction.moveBy(x: -obstacleDistanceToMove, y: 0.0, duration: TimeInterval(speed * obstacleDistanceToMove))
        let delaytime = TimeInterval(arc4random_uniform(4))
        
        
        obstacleMoveAndRemove = SKAction.sequence([SKAction.wait(forDuration: delaytime), obstacleMovement, SKAction.run({(frameWidth)})]) //self
        
        obstacle.run(obstacleMoveAndRemove, withKey: "obstacleMoveAndRemove")
        
        return obstacle
        
    }
    func ObstacleMoving() {
        obstacle.physicsBody?.applyForce(CGVector(dx:0,dy:15))
        isMoving = true
        onGround = true
    }
    
    func flyingObstacle() {
        obstacle.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
        // playJumpAnimation()
        onGround = false
    }
    
    func obstacleMove() {
        isMoving = true
        isSpawning = true
        //Implement
    }
    
}

class Coin:SKNode {
    
    var coin = SKSpriteNode(imageNamed:"")
    var isHere = false
    var coinNum = 0
    
    
    func createCoin() {
        // coin.physicsBody = SKPhysicsBody(circleOfRadius: self)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = false
        self.addChild(coin)
        coin.setScale(0.7)
         coin.zPosition = 8
        // self.run( SKAction.repeatForever(SKAction.animate(with: self.FramesRun, timePerFrame: 0.1, resize: false, restore: true)), withKey:"coinanimate")
         coin.physicsBody = SKPhysicsBody(circleOfRadius: 15 , center: CGPoint(x: 0, y: -20))
         coin.physicsBody?.allowsRotation = false
         coin.physicsBody?.restitution = 0
         coin.physicsBody?.friction = 0.2
         coin.physicsBody?.mass = 80
         coin.physicsBody?.affectedByGravity = true
         coin.physicsBody?.categoryBitMask = coinCategory
         coin.physicsBody!.contactTestBitMask = robotCategory | groundCategory
         moveCoins()

    }
    
    func moveCoins() {
        let moveCoin = SKAction.moveTo(y: -UIScreen.main.bounds.height, duration: 4)
        self.run(moveCoin) {
            self.removeFromParent()
        }
        
    }
    
    //think
    func animateCoin() {
        let frontCoin = SKTexture()
        let backCoin = SKTexture()
        let sideCoin = SKTexture()
        
    }
    
    func getCoin () {
        coin.physicsBody!.categoryBitMask = coinCategory
        coin.physicsBody!.contactTestBitMask = robotCategory
    }
    
}


class PowerUp:SKSpriteNode {
    var powerUp = SKSpriteNode(imageNamed: "")
    var coinMagnet = SKSpriteNode(imageNamed: "")
    var shield = SKSpriteNode(imageNamed: "")
    var isShowing = false
    
    
    func collectPowerUp() {
        powerUp.physicsBody?.categoryBitMask = powerupCategory
        powerUp.physicsBody?.contactTestBitMask = obstacleCatergory | enemy1Category | enemy2Category | enemy3Category | enemy4Category
        powerUp.physicsBody?.collisionBitMask = robotCategory
    }
    
    func spawnPowerUp() {
        
        powerUp.physicsBody?.allowsRotation = false
        powerUp.physicsBody?.affectedByGravity = false
        powerUp.physicsBody?.isDynamic  = false
        powerUp.physicsBody!.categoryBitMask = powerupCategory
        powerUp.physicsBody!.contactTestBitMask = robotCategory
        
        
        coinMagnet.physicsBody?.allowsRotation = true
        coinMagnet.physicsBody?.affectedByGravity = false
        coinMagnet.physicsBody?.isDynamic  = false
        coinMagnet.physicsBody!.categoryBitMask = powerupCategory
        coinMagnet.physicsBody!.contactTestBitMask = robotCategory
        
        
        shield.physicsBody?.allowsRotation = true
        shield.physicsBody?.affectedByGravity = false
        shield.physicsBody?.isDynamic  = false
        shield.physicsBody!.categoryBitMask = powerupCategory
        shield.physicsBody!.contactTestBitMask = robotCategory
        
        self.addChild(powerUp)
        self.addChild(coinMagnet)
        self.addChild(shield)
        
    }
}
