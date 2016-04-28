//
//  BoardScene.swift
//  Beto
//
//  Created by Jem on 4/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class BoardScene: SKScene {
    var board: Board!
    var gameHUD: GameHUD!
    var boardLayer: SKNode!
    var gameHUDLayer: SKNode!
    var backgroundMusic = SKAudioNode(fileNamed: "Mining by Moonlight.mp3")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
                
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        GameData.showUnlockedCoinHandler = showUnlockedCoin
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.frame.size
        
        board = Board(scene: self)
        boardLayer = board.createLayer()
        
        gameHUD = GameHUD(scene: self)
        gameHUDLayer = gameHUD.createLayer()

        addChild(background)
        addChild(gameHUDLayer)
        addChild(boardLayer)
    }
    
    override func didMoveToView(view: SKView) {
        board.toggleReplayButton()
        
        if !Audio.musicMuted {
            runAction(SKAction.waitForDuration(0.5), completion: {
                self.addChild(self.backgroundMusic)
            })
        }
    }
    
    func showUnlockedCoin() {
        let reward = Rewards()
        addChild(reward.createLayer())
    }
    
    func presentGameScene() {
        self.view!.window!.rootViewController!.performSegueWithIdentifier("showGameScene", sender: self)
    }
    
    func presentMenuScene() {
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .AspectFill
        
        view!.presentScene(menuScene, transition: transition)
    }
}
