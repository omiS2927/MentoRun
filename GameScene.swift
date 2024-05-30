//
//  GameScene.swift
//  G2
//
//  Created by Pietro Carnevale on 06/12/23.
//

import SpriteKit
import GameplayKit
import SwiftUI

struct PhysicsCategory {
    
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player : UInt32 = 0b1
    static let student : UInt32 = 0b10
    static let candy : UInt32 = 0b11
    static let poop : UInt32 = 0b100
    static let heart : UInt32 = 0b101
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    var player: SKSpriteNode!
    var isJumping: Bool = false
    var isDoubleJumping: Bool = false
    var life: Int = 3
    var heartsNodes: [SKSpriteNode] = []
    let backgroundSpeed: CGFloat = 3.0
    var scoreLabel: SKLabelNode!
    var score:Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: "hasLaunchedBefore")
        }
    }
    
    override func didMove(to view: SKView) {
        
        if isFirstLaunch {
            UserDefaults.standard.setValue(0, forKey: "maxScore")
            showingTutorial()
            isFirstLaunch = false
        }
        self.setUp()
        self.startStudentsCycle()
        self.startCandyAndPoopCycle()
        
    }
    
    func showingTutorial() { 
        
        let tutorialScene = Tutorial()
        tutorialScene.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(tutorialScene)
        
    }
    
    func setUp() {
        
        let backgroundSound = SKAudioNode(fileNamed: "santosong.mp3")
        self.addChild(backgroundSound)
        
        physicsWorld.contactDelegate = self
        
        background1 = SKSpriteNode(imageNamed: "bg")
        background1.position = CGPoint(x: 0, y: 0)
        background1.zPosition = -1
        background1.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        self.addChild(background1)
        
        background2 = SKSpriteNode(imageNamed: "bg")
        background2.position = CGPoint(x: background1.size.width, y: 0)
        background2.zPosition = -1
        background2.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        self.addChild(background2)
        
        
        if(UserDefaults.standard.value(forKey: "player") as! Int == 1){
            player = SKSpriteNode(imageNamed: "player1_1")
            player.name = "player"
            player.position = CGPoint(x: -self.frame.size.width / 2 + 130, y: -self.frame.size.height / 2 + 94)
            player.size = CGSize(width: 80, height: 80)
            
            player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width / 2, height: player.size.height))
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.student
            player.physicsBody?.collisionBitMask = PhysicsCategory.student
            
            let animationAction = SKAction.animate(with: [SKTexture(imageNamed: "player1_1"), SKTexture(imageNamed: "player1_2"), SKTexture(imageNamed: "player1_3"), SKTexture(imageNamed: "player1_4"), SKTexture(imageNamed: "player1_5"), SKTexture(imageNamed: "player1_6"), SKTexture(imageNamed: "player1_7"), SKTexture(imageNamed: "player1_8")], timePerFrame: 0.10)
            let runAction = SKAction.repeatForever(animationAction)
            player.run(runAction)
            
            self.addChild(player)
        }
        
        
        if(UserDefaults.standard.value(forKey: "player") as! Int == 2){
            player = SKSpriteNode(imageNamed: "player2_1")
            player.name = "player"
            player.position = CGPoint(x: -self.frame.size.width / 2 + 130, y: -self.frame.size.height / 2 + 94)
            player.size = CGSize(width: 80, height: 80)
            
            player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width / 2, height: player.size.height))
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.student
            player.physicsBody?.collisionBitMask = PhysicsCategory.student
            
            let animationAction = SKAction.animate(with: [SKTexture(imageNamed: "player2_1"), SKTexture(imageNamed: "player2_2"), SKTexture(imageNamed: "player2_3"), SKTexture(imageNamed: "player2_4"), SKTexture(imageNamed: "player2_5"), SKTexture(imageNamed: "player2_6"), SKTexture(imageNamed: "player2_7"), SKTexture(imageNamed: "player2_8")], timePerFrame: 0.10)
            let runAction = SKAction.repeatForever(animationAction)
            player.run(runAction)
            
            self.addChild(player)
            
        }
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 0, y: self.frame.size.height / 2 - 50)
        scoreLabel.fontName = "AmericanTypewriter"
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        
        let node1 = SKSpriteNode(imageNamed: "heart")
        let node2 = SKSpriteNode(imageNamed: "heart")
        let node3 = SKSpriteNode(imageNamed: "heart")
        heartsNodes.append(node1)
        heartsNodes.append(node2)
        heartsNodes.append(node3)
        SetUpLifePos(node1, i:70.0, j:0.0)
        SetUpLifePos(node2, i:120.0, j:0.0)
        SetUpLifePos(node3, i:170.0, j:0.0)
        
    }
    
    func SetUpLifePos (_ node: SKSpriteNode, i: CGFloat, j: CGFloat) {
        node.zPosition = 50.0
        node.position = CGPoint(x: -self.frame.size.width/2 + i, y: self.frame.size.height/2 - 30)
        self.addChild(node)
    }
    
    func startStudentsCycle() {
        let createStudentAction = SKAction.run(createStudent)
        let waitAction = SKAction.wait(forDuration: Double(Int.random(in: 1...4)))
        let repeatAction = SKAction.run(startStudentsCycle)
        
        let cycleAction = SKAction.sequence([createStudentAction, waitAction, repeatAction])
        
        run(cycleAction)
    }
    
    func startCandyAndPoopCycle() {
        let createAction = SKAction.run(createCandyOrPoop)
        let waitAction = SKAction.wait(forDuration: Double(Int.random(in: 5...10)))
        let repeatAction = SKAction.run(startCandyAndPoopCycle)
        
        let cycleAction = SKAction.sequence([createAction, waitAction, repeatAction])
        
        run(cycleAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackground()
    }
    
    func moveBackground() {
        
        background1.position.x -= backgroundSpeed
        background2.position.x -= backgroundSpeed
        
        if background1.position.x <= -background1.size.width {
            background1.position.x = background2.position.x + background2.size.width
        }
        
        if background2.position.x <= -background2.size.width {
            background2.position.x = background1.position.x + background1.size.width
        }
        
    }
    
}

// MARK: - User Interaction

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isJumping && !isDoubleJumping){
            playerJump()
        }
        else{
            if (!isDoubleJumping) {
                doubleJump()
            }
        }
    }
    
    func playerJump() {
        isJumping = true
        isDoubleJumping = true
        
        let jumpUpAction = SKAction.moveBy(x: 0, y: 100, duration: 0.3)
        let enableDoubleJump = SKAction.run {
            self.isDoubleJumping = false
        }
        let stayUpAction = SKAction.moveBy(x: 0, y: 20 , duration: 0.1)
        let StayDownAction = SKAction.moveBy(x: 0, y: -20, duration: 0.1)
        let jumpDownAction = SKAction.moveBy(x: 0, y: -100, duration: 0.3)
        let jumpSequence = SKAction.sequence([jumpUpAction, enableDoubleJump, stayUpAction, StayDownAction, jumpDownAction])
        
        player.run(jumpSequence) {
            self.isJumping = false
        }
    }
    
    func doubleJump() {
        isDoubleJumping = true
        
        let jumpUpAction = SKAction.moveBy(x: 0, y: 150, duration: 0.25)
        let stayUpAction = SKAction.moveBy(x: 0, y: 20 , duration: 0.1)
        let StayDownAction = SKAction.moveBy(x: 0, y: -20, duration: 0.1)
        let jumpDownAction = SKAction.moveBy(x: 0, y: -150, duration: 0.25)
        let jumpSequence = SKAction.sequence([jumpUpAction, stayUpAction, StayDownAction, jumpDownAction])
        
        player.run(jumpSequence) {
            self.isDoubleJumping = false
        }
        
    }
}

// MARK: - Students

extension GameScene {
    
    private func createStudent() {
        newStudent()
    }
    
    private func newStudent() {
        let i = Int.random(in: 1...4)
        let newStudent = SKSpriteNode(texture: SKTexture(imageNamed: "student\(i)_1"))
        newStudent.name = "student"
        newStudent.size = CGSize(width: 60, height: 60)
        newStudent.position = CGPoint(x: self.frame.size.width / 2 + 80, y: -self.frame.size.height / 2 + 90)
        
        
        newStudent.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newStudent.size.width / 2, height: newStudent.size.height))
        newStudent.physicsBody?.affectedByGravity = false
        
        newStudent.physicsBody?.categoryBitMask = PhysicsCategory.student
        
        newStudent.physicsBody?.contactTestBitMask = PhysicsCategory.player
        newStudent.physicsBody?.collisionBitMask = PhysicsCategory.player
        
        addChild(newStudent)
        
        let animationAction = SKAction.animate(with: [SKTexture(imageNamed: "student\(i)_1"), SKTexture(imageNamed: "student\(i)_2"), SKTexture(imageNamed: "student\(i)_3"), SKTexture(imageNamed: "student\(i)_4"), SKTexture(imageNamed: "student\(i)_5"), SKTexture(imageNamed: "student\(i)_6"), SKTexture(imageNamed: "student\(i)_7"), SKTexture(imageNamed: "student\(i)_8")], timePerFrame: 0.10)
        let moveAction = SKAction.moveBy(x: -self.frame.size.width - 50, y: 0, duration: 3.2)
        let removeAction = SKAction.removeFromParent()
        
        let animationSequence = SKAction.repeat(animationAction, count: 4)
        
        // Use group to run animation and movement simultaneously
        let groupAction = SKAction.group([animationSequence, moveAction])
        
        // Use sequence to ensure that removeAction is performed after groupAction
        let sequenceAction = SKAction.sequence([groupAction, removeAction])
        
        newStudent.run(sequenceAction) {
            self.score += 1
        }
    }
}

// MARK: - Candy and Poop

extension GameScene {
    
    private func createCandyOrPoop() {
        
        let j: Int = Int.random(in: 0...10)
        if j < 7 {
            newCandy()
        } else if j > 7 {
            newPoop()
        } else {
            if life < 3 {
                newHeart()
            } else {
                newCandy()
            }
        }
    }
    
    private func newHeart() {
        
        let newHeart = SKSpriteNode(texture: SKTexture(imageNamed: "heart"))
        newHeart.name = "heart"
        newHeart.size = CGSize(width: 70, height: 40)
        newHeart.position = CGPoint(x: self.frame.size.width / 2 + 80, y: 10)
        
        
        newHeart.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newHeart.size.width / 2, height: newHeart.size.height))
        newHeart.physicsBody?.affectedByGravity = false
        
        newHeart.physicsBody?.categoryBitMask = PhysicsCategory.heart
        
        newHeart.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        addChild(newHeart)
        
        let moveAction = SKAction.moveBy(x: -self.frame.size.width - 50, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        
        newHeart.run(sequenceAction)
        
    }
    
    private func newCandy() {
        
        let i = Int.random(in: 1...3)
        let newCandy = SKSpriteNode(texture: SKTexture(imageNamed: "candy\(i)"))
        newCandy.name = "candy"
        newCandy.size = CGSize(width: 50, height: 50)
        newCandy.position = CGPoint(x: self.frame.size.width / 2 + 80, y: 10)
        
        
        newCandy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newCandy.size.width / 2, height: newCandy.size.height))
        newCandy.physicsBody?.affectedByGravity = false
        
        newCandy.physicsBody?.categoryBitMask = PhysicsCategory.candy
        
        newCandy.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        addChild(newCandy)
        
        let moveAction = SKAction.moveBy(x: -self.frame.size.width - 50, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        
        newCandy.run(sequenceAction)
        
    }
    
    private func newPoop() {
        
        let newPoop = SKSpriteNode(texture: SKTexture(imageNamed: "poop1"))
        newPoop.name = "poop"
        newPoop.size = CGSize(width: 75, height: 45)
        newPoop.position = CGPoint(x: self.frame.size.width / 2 + 80, y: 10)
        
        newPoop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newPoop.size.width / 2, height: newPoop.size.height))
        newPoop.physicsBody?.affectedByGravity = false
        
        newPoop.physicsBody?.categoryBitMask = PhysicsCategory.poop
        
        newPoop.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        addChild(newPoop)
        
        let animationAction = SKAction.animate(with: [SKTexture(imageNamed: "poop1"), SKTexture(imageNamed: "poop2")], timePerFrame: 0.10)
        let moveAction = SKAction.moveBy(x: -self.frame.size.width - 50, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        
        let animationSequence = SKAction.repeat(animationAction, count: 25)
        
        let groupAction = SKAction.group([animationSequence, moveAction])
        
        let sequenceAction = SKAction.sequence([groupAction, removeAction])
        
        newPoop.run(sequenceAction)
    }
}

// MARK: - Contacts and Collisions

extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if let node = firstBody.node, node.name == "student" {
            node.removeFromParent()
            handleGameOver()
        }
        if let node = secondBody.node, node.name == "student" {
            node.removeFromParent()
            handleGameOver()
        }
        if let node = firstBody.node, node.name == "candy" {
            let sparkleNode = SKSpriteNode(imageNamed: "sparkle_1")
            sparkleNode.size = CGSize(width: 50, height: 50)
            sparkleNode.position = node.position
            node.removeFromParent()
            self.addChild(sparkleNode)
            let moveAction = SKAction.moveBy(x: -15, y: 0, duration: 0.15)
            let imageAction = SKAction.animate(with: [SKTexture(imageNamed: "sparkle_1"), SKTexture(imageNamed: "sparkle_2"), SKTexture(imageNamed: "sparkle_3"), SKTexture(imageNamed: "sparkle_4")], timePerFrame: 0.05)
            let animationAction = SKAction.group([moveAction, imageAction])
            let removeAction = SKAction.removeFromParent()
            let sequenceAction = SKAction.sequence([animationAction, removeAction])
            sparkleNode.run(sequenceAction)
            score += 5
        }
        if let node = secondBody.node, node.name == "candy" {
            let sparkleNode = SKSpriteNode(imageNamed: "sparkle_1")
            sparkleNode.size = CGSize(width: 50, height: 50)
            sparkleNode.position = node.position
            node.removeFromParent()
            self.addChild(sparkleNode)
            let moveAction = SKAction.moveBy(x: -15, y: 0, duration: 0.15)
            let imageAction = SKAction.animate(with: [SKTexture(imageNamed: "sparkle_1"), SKTexture(imageNamed: "sparkle_2"), SKTexture(imageNamed: "sparkle_3"), SKTexture(imageNamed: "sparkle_4")], timePerFrame: 0.05)
            let animationAction = SKAction.group([moveAction, imageAction])
            let removeAction = SKAction.removeFromParent()
            let sequenceAction = SKAction.sequence([animationAction, removeAction])
            sparkleNode.run(sequenceAction)
            score += 5
        }
        if let node = firstBody.node, node.name == "poop" {
            node.removeFromParent()
            if score > 9 {
                score -= 10
            } else {
                score = 0
            }
        }
        if let node = secondBody.node, node.name == "poop" {
            node.removeFromParent()
            if score > 9 {
                score -= 10
            } else {
                score = 0
            }
        }
        if let node = firstBody.node, node.name == "heart" {
            node.removeFromParent()
            heartsNodes[life].texture = SKTexture(imageNamed: "heart")
            life += 1
        }
        if let node = secondBody.node, node.name == "heart" {
            node.removeFromParent()
            heartsNodes[life].texture = SKTexture(imageNamed: "heart")
            life += 1
        }
    }
}

// MARK: - GameOver

extension GameScene {
    
    func handleGameOver() {
        life -= 1
        heartsNodes[life].texture = SKTexture(imageNamed: "heart2")
        if (life == 0) {
            presentNewScene()
        }
    }
    
    func presentNewScene() {
        let newScene = GameOverScene(size: self.size)
        newScene.scaleMode = .aspectFill
        UserDefaults.standard.set(score, forKey: "score")
        self.view?.presentScene(newScene, transition: SKTransition.crossFade(withDuration: 0.0))
    }
}
