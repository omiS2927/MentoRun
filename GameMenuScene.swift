//
//  FirstView.swift
//  G2
//
//  Created by maria gabriella sica on 14/12/23.
//

import SwiftUI
import SpriteKit
import GameplayKit

class GameMenuScene: SKScene, SKPhysicsContactDelegate {
    
    var firstBackground: SKSpriteNode!
    var playButton: SKSpriteNode!
    var playerButton: SKSpriteNode!
    var gameName: SKSpriteNode!
    
    var SantoPlayer: SKSpriteNode!
    var MaraPlayer: SKSpriteNode!
    
    var player: Int = 1
    
    
    override func didMove(to view: SKView) {
        createMenu()
    }
    
    func createMenu() {
        
        let backgroundSound = SKAudioNode(fileNamed: "menu.mp3")
        self.addChild(backgroundSound)
        
        firstBackground = SKSpriteNode(imageNamed: "bg")
        firstBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        firstBackground.zPosition = -1
        firstBackground.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        self.addChild(firstBackground)
        
        gameName = SKSpriteNode(imageNamed: "gameName")
        gameName.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        gameName.size = CGSize(width: self.frame.size.width / 3, height: self.frame.size.height / 3)
        
        self.addChild(gameName)
        
        SantoPlayer = SKSpriteNode(imageNamed: "SantoPlayerSelected")
        SantoPlayer.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2 - 30)
        SantoPlayer.size = CGSize(width: self.frame.size.width / 4, height: self.frame.size.height / 2.5)
        SantoPlayer.name = "SantoPlayer"
        
        self.addChild(SantoPlayer)
        
        
        MaraPlayer = SKSpriteNode(imageNamed: "maraPlayer")
        MaraPlayer.position = CGPoint(x: size.width / 2 + 100, y: size.height / 2 - 30)
        MaraPlayer.size = CGSize(width: self.frame.size.width / 4, height: self.frame.size.height / 2.5)
        MaraPlayer.name = "MaraPlayer"
        
        self.addChild(MaraPlayer)
        
        
        playButton = SKSpriteNode(imageNamed: "play")
        playButton.name = "playButton"
        playButton.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2 - 150)
        playButton.scale(to: CGSize(width: self.frame.width / 4, height: self.frame.height / 4))
        
        self.addChild(playButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "playButton" {
                let gameMainScene = GameScene(size: size)
                gameMainScene.scaleMode = scaleMode
                gameMainScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                UserDefaults.standard.setValue(player, forKey: "player")
                view?.presentScene(gameMainScene, transition: .crossFade(withDuration: 0.5))
            }
            
            
            switch touchedNode.name {
                
            case "SantoPlayer":
                
                MaraPlayer.texture = SKTexture(imageNamed: "maraPlayer")
                SantoPlayer.texture = SKTexture(imageNamed: "SantoPlayerSelected")
                
                player = 1
                
            case "MaraPlayer":
                
                SantoPlayer.texture = SKTexture(imageNamed: "santoPlayer")
                MaraPlayer.texture = SKTexture(imageNamed: "MaraPlayerSelected")
                
                player = 2
                
            case .none:
                SantoPlayer.texture = SKTexture(imageNamed: "SantoPlayerSelected")
            case .some(_):
                MaraPlayer.texture = SKTexture(imageNamed: "maraPlayer")
            }
        }
    }
}
