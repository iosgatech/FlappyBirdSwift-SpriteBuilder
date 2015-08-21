import Foundation

class MainScene : GamePlayScene { //explain how this is a subclass of GamePlayScene.swift
    
    var points: Int = 0
    let firstObstaclePosition: CGFloat = 200
    let distanceBetweenObstacles: CGFloat = 160
    
    weak var _obstaclesLayer: CCNode!
    weak var _restartButton: CCButton!
    weak var _scoreLabel: CCLabelTTF!
    
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB() //explain how to super a method
        userInteractionEnabled = true //just explain what this does
        _gamePhysicsNode.collisionDelegate = self
        
        hero = CCBReader.load("Character") as? Character
        _gamePhysicsNode.addChild(hero)
        
        // spawn the first obstacles
        for i in 1...3 {
            spawnNewObstacle() //have them look this up on how to do a for loop
        }
    }
    
    override func update(delta: CCTime) {
        super.update(delta)
        
        //checking for removeable obstacles
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
            hero?.flap()
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
    
    func gameOver() {
        if (isGameOver == false) {
            isGameOver = true
            _restartButton.visible = true
            scrollSpeed = 0
            hero?.rotation = 90
            hero?.physicsBody.allowsRotation = false
            
            // just in case
            hero?.stopAllActions()
            
            var move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            var moveBack = CCActionEaseBounceOut(action: move.reverse())
            var shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
    
    func restart() {
        var scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
}
