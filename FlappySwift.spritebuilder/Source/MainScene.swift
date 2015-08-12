//
//  MainScene.swift
//  FlappySwift
//
//  Created by Benjamin Reynolds on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

//import Foundation
//
//@objc
//class MainScene: GameplayScene {
//    
//    var _ground1: CCNode!
//    var _ground2: CCNode!
//    var _grounds: [CCNode] = []
//    
//    var _sinceTouch: NSTimeInterval = 0
//    var _obstacles: [Obstacle] = []
//    var powerups: [CCNode] = []
//    
//    var _restartButton: CCButton!
//    
//    var _gameOver:Bool = false
//    var _scoreLabel: CCLabelTTF!
//    var _nameLabel: CCLabelTTF!
//    
//    var trail: CCParticleSystem? = nil
//    var points: Int = 0
//  
//    var g1Pos: CGPoint!
//    var g2Pos: CGPoint!
//    
//    override init() {}
//  
//    // is called when CCB file has completed loading
//    func didLoadFromCCB() {
//        
//        userInteractionEnabled = true
//        
//        _grounds = [_ground1, _ground2]
//        
//        for ground in _grounds {
//            // set collision type
//            ground.physicsBody.collisionType = "level"
//            ground.zOrder = DrawingOrder.Ground.rawValue
//        }
//        
//        _gamePhysicsNode.collisionDelegate = self
//        
//        _obstacles = []
//        powerups = []
//        points = 0
//        
//        let trail = CCBReader.load("Trail") as! CCParticleSystem!
//        trail.particlePositionType = CCParticleSystemPositionType.Relative
//        _gamePhysicsNode.addChild(trail)
//        trail.visible = false
//      
//        g1Pos = _ground1.position
//        g2Pos = _ground2.position
//
//        super.initialize()
//    }
//    
//    override func showScore() {
//        _scoreLabel.visible = true
//    }
//    
//    override func updateScore() {
//        _scoreLabel.string = "\(points)"
//    }
//    
//    func handleTouch() {
//        if !_gameOver {
//            if let cCharacter = character {
//                cCharacter.physicsBody.applyAngularImpulse(10000.0)
//            }
//            _sinceTouch = 0.0
//            
//            self.tap()
//        }
//    }
//    
//    #if os(iOS)
//    override func touchBegan(touch: CCTouch, withEvent event: CCTouchEvent) {
//        handleTouch()
//    }
//    #elseif os(OSX)
//    override func mouseDown(event: NSEvent) {
//        handleTouch()
//    }
//    #endif
//
//    override func gameOver() {
//        if !_gameOver {
//            _gameOver = true
//            if let cRestartButton = _restartButton {
//                cRestartButton.visible = true
//            }
//            
//            if let cCharacter = character {
//                cCharacter.physicsBody.velocity = CGPoint(x:0.0, y:character!.physicsBody.velocity.y)
//                cCharacter.rotation = 90.0
//                cCharacter.physicsBody.allowsRotation = false
//                cCharacter.stopAllActions()
//            }
//            
//            let moveBy:CCActionMoveBy = CCActionMoveBy(duration: 0.2, position:CGPoint(x:-2.0,y:2.0))
//            let reverseMovement:CCActionInterval = moveBy.reverse()
//            let shakeSequence:CCActionSequence = CCActionSequence(one: moveBy, two: reverseMovement)
//            let bounce:CCActionEaseBounce = CCActionEaseBounce(action: shakeSequence)
//            
//            self.runAction(bounce)
//        }
//    }
//
//    override func restart() {
//        _restartButton.visible = false
//        self.resetLevel()
//    }
//
//    override func addObstacle() {
//        let obstacle:Obstacle = CCBReader.load("Obstacle") as! Obstacle
//        let screenPosition = self.convertToWorldSpace(CGPoint(x:380,y:0))
//        if let cPhysicsNode = _gamePhysicsNode {
//            let worldPosition = cPhysicsNode.convertToNodeSpace(screenPosition)
//            obstacle.position = worldPosition
//        }
//        obstacle.setupRandomPosition()
//        
//        obstacle.zOrder = DrawingOrder.Pipes.rawValue
//        if let cPhysicsNode = _gamePhysicsNode {
//            cPhysicsNode.addChild(obstacle)
//        }
//        _obstacles.append(obstacle)
//    }
//
//    override func addPowerup() {
//        let powerup:CCSprite = CCBReader.load("Powerup") as! CCSprite
//        
//        let first:Obstacle = _obstacles[0]
//        let second:Obstacle = _obstacles[1]
//        if let cLast:Obstacle = _obstacles.last {
//            if let cCharacter = character {
//                powerup.position = CGPoint(x:cLast.position.x + (second.position.x-first.position.x)/4.0 + cCharacter.contentSize.width, y:CGFloat(arc4random()%488)+200)
//            }
//        }
//    }
//    
//    override func increaseScore() {
//        points++
//        self.updateScore()
//    }
//  
//    func resetLevel() {
//        _gamePhysicsNode.position = CGPoint(x:0, y:0)
//        _ground1.position = g1Pos
//        _ground2.position = g2Pos
//        for obs in _obstacles {
//            obs.removeFromParent()
//        }
//
//        points = 0
//        self.updateScore()
//        character.removeFromParent()
//        _gameOver = false
//      
//        super.initialize()
//    }
//
//    override func update(delta: CCTime) {
//        _sinceTouch += delta
//        
//        if let cCharacter = character {
//            cCharacter.rotation = clampf(cCharacter.rotation, -30.0, 90.0)
//            if let cTrail = trail {
//                cTrail.position = cCharacter.position
//            }
//        }
//
//        let r = arc4random() % 255
//        let g = arc4random() % 255
//        let b = arc4random() % 255
//        
////        if let cTrail = trail {
////            cTrail.startColor = CCColor(red:r, green:g, blue:b)
////        }
////         set trail color to CCColor(ccColor3b: ccc3(arc4random() % 255, arc4random() % 255, arc4random() % 255))
//        
//        if let cCharacter = character {
//            if cCharacter.physicsBody.allowsRotation {
//                let angularVelocity = clampf(Float(cCharacter.physicsBody.angularVelocity), -2.0, 1.0)
//                cCharacter.physicsBody.angularVelocity = CGFloat(angularVelocity)
//            }
//            
//            if _sinceTouch > 0.5 {
//                cCharacter.physicsBody.applyAngularImpulse(CGFloat(-40000.0 * delta))
//            }
//        }
//
//        if let cCharacter = character {
//            _gamePhysicsNode.position = CGPoint(x:_gamePhysicsNode.position.x - (cCharacter.physicsBody.velocity.x * CGFloat(delta)),y:_gamePhysicsNode.position.y)
//        }
//        
//        for ground in _grounds {
//            let groundWorldPosition = _gamePhysicsNode.convertToWorldSpace(ground.position)
//            let groundScreenPosition = self.convertToNodeSpace(groundWorldPosition)
//            
//            if groundScreenPosition.x <= (-1 * ground.contentSize.width) {
//                ground.position = CGPoint(x:ground.position.x + 2 * ground.contentSize.width, y:ground.position.y)
//            }
//        }
//        
//        var offScreenObstacles:[Obstacle] = []
//        
//        for obstacle in _obstacles {
//            let obstacleWorldPosition = _gamePhysicsNode!.convertToWorldSpace(obstacle.position)
//            let obstacleScreenPosition = self.convertToNodeSpace(obstacleWorldPosition)
//            
//            if obstacleScreenPosition.x < -obstacle.contentSize.width {
//                offScreenObstacles.append(obstacle)
//            }
//        }
//
//        if !_gameOver {
//            if let cCharacter = character {
//                cCharacter.physicsBody.velocity = CGPoint(x:cCharacter.physicsBody.velocity.x, y: min(cCharacter.physicsBody.velocity.y, 200.0))
//            }
//            
//            super.update(delta)
//        }
//    
//    }
//    
//}

import Foundation

class MainScene : CCNode, CCPhysicsCollisionDelegate {
    var scrollSpeed: CGFloat = 100
    
    weak var _gamePhysicsNode: CCPhysicsNode!
    
    weak var _hero: Character!
    weak var _ground1: CCSprite!
    weak var _ground2: CCSprite!
    weak var _obstaclesLayer: CCNode!
    weak var _restartButton: CCButton!
    weak var _scoreLabel: CCLabelTTF!

    var grounds: [CCSprite] = []  // initializes an empty array
    var obstacles: [CCNode] = []
    
    var sinceTouch: CCTime = 0
    var isGameOver = false
    var points: NSInteger = 0
    
    let firstObstaclePosition: CGFloat = 200
    let distanceBetweenObstacles: CGFloat = 160
    
    func didLoadFromCCB() {
        _gamePhysicsNode.collisionDelegate = self
        _gamePhysicsNode.gravity = CGPoint(x:0, y:-850)
        
        userInteractionEnabled = true
        
        grounds.append(_ground1)
        grounds.append(_ground2)
        
        // spawn the first obstacles
        for i in 1...3 {
            spawnNewObstacle()
        }
    }
    
    override func update(delta: CCTime) {
        _hero.position = ccp(_hero.position.x + scrollSpeed * CGFloat(delta), _hero.position.y)
        _gamePhysicsNode.position = ccp(_gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta), _gamePhysicsNode.position.y)
        
        // clamp physics node and _hero position to the next nearest pixel value to avoid black line artifacts
        let scale = CCDirector.sharedDirector().contentScaleFactor
        _hero.position = ccp(round(_hero.position.x * scale) / scale, round(_hero.position.y * scale) / scale)
        _gamePhysicsNode.position = ccp(round(_gamePhysicsNode.position.x * scale) / scale, round(_gamePhysicsNode.position.y * scale) / scale)
        
        // loop the ground whenever a ground image was moved entirely outside the screen
        for ground in grounds {
            // get the world position of the ground
            let groundWorldPosition = _gamePhysicsNode.convertToWorldSpace(ground.position)
            // get the screen position of the ground
            let groundScreenPosition = convertToNodeSpace(groundWorldPosition)
            // if the left corner is one complete width off the screen, move it to the right
            if groundScreenPosition.x <= (-ground.contentSize.width) {
                ground.position = ccp(ground.position.x + ground.contentSize.width * 2, ground.position.y)
            }
        }
        
        // clamp velocity
        let velocityY = clampf(Float(_hero.physicsBody.velocity.y), -Float(CGFloat.max), 200)
        _hero.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        
        // clamp angular velocity
        sinceTouch += delta
        _hero.rotation = clampf(_hero.rotation, -30, 90)
        if (_hero.physicsBody.allowsRotation) {
            let angularVelocity = clampf(Float(_hero.physicsBody.angularVelocity), -2, 1)
            _hero.physicsBody.angularVelocity = CGFloat(angularVelocity)
        }
        // rotate downwards if enough time passed since last touch
        if (sinceTouch > 0.55) {
            let impulse = -18000.0 * delta
            _hero.physicsBody.applyAngularImpulse(CGFloat(impulse))
        }
        
        // checking for removable obstacles
        for obstacle in obstacles.reverse() {
            let obstacleWorldPosition = _gamePhysicsNode.convertToWorldSpace(obstacle.position)
            let obstacleScreenPosition = convertToNodeSpace(obstacleWorldPosition)
            
            // obstacle moved past left side of screen?
            if obstacleScreenPosition.x < (-obstacle.contentSize.width) {
                obstacle.removeFromParent()
                obstacles.removeAtIndex(find(obstacles, obstacle)!)
                
                // for each removed obstacle, add a new one
                spawnNewObstacle()
            }
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (isGameOver == false) {
            // move up and rotate
            _hero.flap()
            sinceTouch = 0
        }
    }
    
    func spawnNewObstacle() {
        var prevObstaclePos = firstObstaclePosition
        if obstacles.count > 0 {
            prevObstaclePos = obstacles.last!.position.x
        }
        
        // create and add a new obstacle
        let obstacle = CCBReader.load("Obstacle") as! Obstacle
        obstacle.position = ccp(prevObstaclePos + distanceBetweenObstacles, 0)
        obstacle.setupRandomPosition()
        _obstaclesLayer.addChild(obstacle)
        obstacles.append(obstacle)
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!,hero: CCNode!,goal: CCNode!) -> Bool {
        goal.removeFromParent()
        points++
        _scoreLabel.string = String(points)
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!,hero: CCNode!,level: CCNode!) -> Bool {
        gameOver()
        return true
    }
    
    
    func restart() {
        var scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
    func gameOver() {
        if (isGameOver == false) {
            isGameOver = true
            _restartButton.visible = true
            scrollSpeed = 0
            _hero.rotation = 90
            _hero.physicsBody.allowsRotation = false
            
            // just in case
            _hero.stopAllActions()
            
            var move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            var moveBack = CCActionEaseBounceOut(action: move.reverse())
            var shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
}
