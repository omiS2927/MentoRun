//
//  GameOverScene.swift
//  G2
//
//  Created by Pietro Carnevale on 12/12/23.
//

import SpriteKit
import GameplayKit
import SwiftUI

class GameOverScene: SKScene {
    
    var background: SKSpriteNode!
    var tryAgainButton: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var goMenu: SKSpriteNode!
    
    //   var finalScore: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.setUp()
    }
    
    func setUp() {
        
        let gameOverSound = SKAudioNode(fileNamed: "gameover")
        gameOverSound.autoplayLooped = false
        self.addChild(gameOverSound)
        
        let playAction = SKAction.play()
        gameOverSound.run(playAction)
        
        background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        self.addChild(background)
        
        
        gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 100)
        gameOver.scale(to: CGSize(width: self.frame.width/4, height: self.frame.height/4))
        
        self.addChild(gameOver)
        
        tryAgainButton = SKSpriteNode(imageNamed: "restart")
        tryAgainButton.position = CGPoint(x: self.frame.size.width/2 - 120, y: self.frame.size.height/2 - 106)
        tryAgainButton.scale(to: CGSize(width: self.frame.width/4, height: self.frame.height/4))
        tryAgainButton.name = "tryAgainButton"
        
        self.addChild(tryAgainButton)
        
        goMenu = SKSpriteNode(imageNamed: "returnMenu")
        goMenu.position = CGPoint(x: self.frame.size.width / 2 + 120, y: self.frame.size.height / 2 - 100 )
        goMenu.zPosition = 50
        goMenu.scale(to: CGSize(width: self.frame.width / 4, height: self.frame.height / 4))
        goMenu.name = "ReturnToMenu"
        
        self.addChild(goMenu)
        
        let scoreLab = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLab.text = "Final Score: \( UserDefaults.standard.value(forKey: "score") as? Int ?? 0)"
        scoreLab.fontSize = 40
        scoreLab.fontColor = SKColor.white
        scoreLab.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 30)
        
        self.addChild(scoreLab)
        
        let score = UserDefaults.standard.integer(forKey: "score")
        var maxScore = UserDefaults.standard.integer(forKey: "maxScore")
        if score > maxScore {
            maxScore = score
            UserDefaults.standard.setValue(maxScore, forKey: "maxScore")
        }
        
        let maxLab = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        maxLab.text = "Your personal best: \(maxScore)"
        maxLab.fontSize = 25
        maxLab.fontColor = SKColor.white
        maxLab.position = CGPoint(x: self.frame.size.width / 2 + 250, y: self.frame.size.height - 100)
        self.addChild(maxLab)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if (touchedNode.name == "tryAgainButton") {
                restartGame()
            }
            
            if (touchedNode.name == "ReturnToMenu") {
                goToMenu()
            }
        }
    }
    
    func restartGame() {
        if let gameScene = GameScene(fileNamed: "GameScene") {
            gameScene.scaleMode = .resizeFill
            view?.presentScene(gameScene)
        }
    }
    
    func goToMenu() {
        if let game = GameMenuScene(fileNamed: "GameMenuScene"){
            game.scaleMode = .resizeFill
            game.anchorPoint = CGPoint(x: 0, y: 0)
            view?.presentScene(game)
        }
    }
    
}



