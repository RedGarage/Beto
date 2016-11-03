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
        
        let themes = ThemeManager()
        let theme = themes.getTheme(GameData.currentThemeName)
        
        let background = SKSpriteNode(imageNamed: theme.background)
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
        
        // How To Play Button
        let helpButton = ButtonNode(defaultButtonImage: "helpButton")
        helpButton.size = CGSize(width: 44, height: 45)
        helpButton.position = CGPoint(x: 0, y: -100)
        helpButton.action = showTutorial
        
        // Settings Button
        let settingsButton = ButtonNode(defaultButtonImage: "settingsButton")
        settingsButton.size = CGSize(width: 44, height: 45)
        settingsButton.position = CGPoint(x: 60, y: -100)
        settingsButton.action = displaySettings
        
        // Remove Ads Button
        let removeAdsButton = ButtonNode(defaultButtonImage: "removeAdsButton")
        removeAdsButton.size = CGSize(width: 32, height: 33)
        removeAdsButton.position = CGPoint(x: -140 / Constant.ScaleFactor + Constant.Margin, y: (-ScreenSize.Height / Constant.ScaleFactor + removeAdsButton.size.height) / 2 + 50 / Constant.ScaleFactor)
                
        // Check if remove ads is already purchased
        if Products.store.isProductPurchased(Products.RemoveAds) {
            removeAdsButton.isHidden = true
        } else {
            removeAdsButton.isHidden = false
            removeAdsButton.action = removeAds
            layer.addChild(removeAdsButton)
        }
        
        // Add nodes
        layer.addChild(startGameButton)
        layer.addChild(themesButton)
        layer.addChild(helpButton)
        layer.addChild(settingsButton)
        
        addChild(background)
        addChild(layer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshMenuScene), name: NSNotification.Name(rawValue: Products.RemoveAds), object: nil)
    }
    
    func refreshMenuScene() {
        let transition = SKTransition.flipVertical(withDuration: 0.0)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        
        view!.presentScene(menuScene, transition: transition)
    }
    
    func presentBoardScene() {
        let transition = SKTransition.flipVertical(withDuration: 0.4)
        let boardScene = BoardScene(size: self.size)
        boardScene.scaleMode = .aspectFill
        
        view!.presentScene(boardScene, transition: transition)
    }
    
    func presentThemesScene() {
        let transition = SKTransition.flipVertical(withDuration: 0.4)
        let themesScene = ThemesScene(size: self.size)
        themesScene.scaleMode = .aspectFill
        
        view!.presentScene(themesScene, transition: transition)
    }
    
    func showTutorial() {
        let infoOverlay = ButtonNode(defaultButtonImage: "overlay")
        infoOverlay.action = { infoOverlay.removeFromParent() }
        infoOverlay.setScale(Constant.ScaleFactor)
        
        let infoSprite = SKSpriteNode(imageNamed: "howToPlayInfo")
        infoSprite.position = CGPoint(x: 0, y: 50)
        
        infoOverlay.addChild(infoSprite)
        infoOverlay.alpha = 0.0
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
        infoOverlay.run(fadeIn)
        
        addChild(infoOverlay)
    }
    
    func displaySettings() {
        let settings = Settings()
        let layer = settings.createLayer()
        
        addChild(layer)
    }
    
    func removeAds() {
        presentThemesScene()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "fromRemoveAdsButton"), object: self)
    }

}

