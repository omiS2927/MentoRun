//
//  GameViewController.swift
//  G2
//
//  Created by Pietro Carnevale on 06/12/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    //MARK: Tutorial
    var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: "hasLaunchedBefore")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            if isFirstLaunch {
                UserDefaults.standard.setValue(0, forKey: "maxScore")
                let tutorialScene = Tutorial(size: view.bounds.size)
                tutorialScene.scaleMode = .resizeFill
                view.presentScene(tutorialScene)
                isFirstLaunch = false
            }
            else{
                let menuScene = GameMenuScene(size: view.bounds.size)
                menuScene.scaleMode = .resizeFill
                view.presentScene(menuScene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
