//
//  MenuScene.swift
//  Beto
//
//  Created by Jem on 2/17/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
        let background = SKSpriteNode(imageNamed: GameData.theme.background)
        background.size = self.frame.size
        
        // Start Game Button
        let startGameButton = ButtonNode(defaultButtonImage: "startGame", activeButtonImage: "startGame_active")
        startGameButton.size = CGSize(width: 86, height: 103)
        startGameButton.addWobbleAnimation()
        startGameButton.action = presentBoardScene
        
        // Themes Button
        let themesButton = ButtonNode(defaultButtonImage: "themesButton")
        themesButton.size = CGSize(width: 44, height: 45)
        themesButton.position = CGPoint(x: -60, y: -100)
        themesButton.action = presentThemesScene
        
        // Achievements Button
        let helpButton = ButtonNode(defaultButtonImage: "helpButton")
        helpButton.size = CGSize(width: 44, height: 45)
        helpButton.position = CGPoint(x: 0, y: -100)
        helpButton.action = showTutorial
        
        // Settings Button
        let settingsButton = ButtonNode(defaultButtonImage: "settingsButton")
        settingsButton.size = CGSize(width: 44, height: 45)
        settingsButton.position = CGPoint(x: 60, y: -100)
        settingsButton.action = displaySettings
        
        // Add nodes
        layer.addChild(startGameButton)
        layer.addChild(themesButton)
        layer.addChild(helpButton)
        layer.addChild(settingsButton)
        
        addChild(background)
        addChild(layer)
    }
    
    func presentBoardScene() {
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let boardScene = BoardScene(size: self.size)
        boardScene.scaleMode = .AspectFill
        
        view!.presentScene(boardScene, transition: transition)
    }
    
    func presentThemesScene() {
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let themesScene = ThemesScene(size: self.size)
        themesScene.scaleMode = .AspectFill
        
        view!.presentScene(themesScene, transition: transition)
    }
    
    func showTutorial() {
        print("DELETE: Test")
    }
    
    func displaySettings() {
        let settings = Settings()
        let layer = settings.createLayer()
        
        addChild(layer)
    }
}

