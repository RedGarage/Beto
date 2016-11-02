//
//  ThemesScene.swift
//  Beto
//
//  Created by Jem on 6/3/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class ThemesScene: SKScene {
    fileprivate var background: SKSpriteNode!
    fileprivate var container: SKSpriteNode!
    fileprivate var themePreviews: [ButtonNode]!
    fileprivate var starCoinsLabel: SKLabelNode!
    
    fileprivate var currentPage = 0
    fileprivate var perPageCount = 12
    fileprivate let themeManager = ThemeManager()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Default values
        var containerHeight = 401
        var headerPosition = 266
        var previousButtonPosition = CGPoint(x: -25, y: -206)
        var nextButtonPosition = CGPoint(x: 25, y: -206)
        var infoButtonPosition = CGPoint(x: 130, y: -206)
        var shopButtonPosition = CGPoint(x: -120, y: -206)

        // Custom values for iPhone4
        if UIScreen.main.bounds.height == 480 {
            containerHeight = 303
            headerPosition = 221
            previousButtonPosition = CGPoint(x: -25, y: -160)
            nextButtonPosition = CGPoint(x: 25, y: -160)
            infoButtonPosition = CGPoint(x: 130, y: -160)
            shopButtonPosition = CGPoint(x: -120, y: -160)
            perPageCount = 9
        }
        
        let themes = ThemeManager()
        let theme = themes.getTheme(GameData.currentThemeName)
        
        background = SKSpriteNode(imageNamed: theme.background)
        background.size = self.frame.size
        
        container = SKSpriteNode(imageNamed: "themesContainer")
        container.size = CGSize(width: 300, height: containerHeight)
        container.position = CGPoint(x: 0, y: 20)
        
        themePreviews = []
        createPage(currentPage)
        
        // Header
        let header = SKSpriteNode(imageNamed: "headerBackground")
        header.size = CGSize(width: 320, height: 38)
        header.position = CGPoint(x: 0, y: headerPosition)
        
        // Menu Button
        let menuButton = ButtonNode(defaultButtonImage: "menuButton", activeButtonImage: "menuButton_active")
        menuButton.size = CGSize(width: 60, height: 25)
        menuButton.action = presentMenuScene
        menuButton.position = CGPoint(x: (-header.size.width + menuButton.size.width + Constant.Margin) / 2 , y: 0)
        
        // Title label
        let titleLabel = SKLabelNode(text: "THEMES")
        titleLabel.fontName = Constant.FontNameCondensed
        titleLabel.fontColor = UIColor.white
        titleLabel.fontSize = 24
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: 0, y: 0)
        
        let titleShadow = titleLabel.createLabelShadow()
        titleShadow.horizontalAlignmentMode = .center
        titleShadow.verticalAlignmentMode = .center
        
        // Star Coins Button
        let starCoinsNode = ButtonNode(defaultButtonImage: "starCoinsButton")
        starCoinsNode.size = CGSize(width: 80, height: 25)
        starCoinsNode.position = CGPoint(x: (header.size.width - starCoinsNode.size.width) / 2 - Constant.Margin, y: 0)

        starCoinsLabel = SKLabelNode(text: "\(GameData.starCoins.formatStringFromNumberShortenMillion())")
        starCoinsLabel.fontName = Constant.FontNameCondensed
        starCoinsLabel.fontSize = 14
        starCoinsLabel.horizontalAlignmentMode = .center
        starCoinsLabel.verticalAlignmentMode = .top
        starCoinsLabel.position = CGPoint(x: 5, y: 7)
        
        // Add labels to star node
        starCoinsNode.addChild(starCoinsLabel)
        
        // Add nodes to header
        header.addChild(menuButton)
        header.addChild(titleShadow)
        header.addChild(titleLabel)
        header.addChild(starCoinsNode)
        
        // Navigation buttons
        let previousButton = ButtonNode(defaultButtonImage: "previousButton")
        previousButton.size = CGSize(width: 34, height: 35)
        previousButton.action = previousPage
        previousButton.position = previousButtonPosition
        
        let nextButton = ButtonNode(defaultButtonImage: "nextButton")
        nextButton.size = CGSize(width: 34, height: 35)
        nextButton.action = nextPage
        nextButton.position = nextButtonPosition
        
        // Info
        let infoOverlay = ButtonNode(defaultButtonImage: "overlay")
        infoOverlay.action = { infoOverlay.removeFromParent() }
        infoOverlay.setScale(Constant.ScaleFactor)
        
        let infoSprite = SKSpriteNode(imageNamed: "themesInfo")
        
        infoOverlay.addChild(infoSprite)
        
        let infoButton = ButtonNode(defaultButtonImage: "infoButton")
        infoButton.position = infoButtonPosition
        infoButton.action = {
            infoOverlay.alpha = 0.0
            
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
            infoOverlay.run(fadeIn)
            
            self.addChild(infoOverlay)
        }
        
        let shopButton = ButtonNode(defaultButtonImage: "shopButton")
        shopButton.position = shopButtonPosition
        shopButton.action = {
            let shop = BetoShop(type: .StarCoins)
            self.addChild(shop.createLayer())
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateStarCoinsLabelAfterBuy), name: NSNotification.Name(rawValue: "updateStarCoinsLabelAfterBuy"), object: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadShop), name: NSNotification.Name(rawValue: "fromRemoveAdsButton"), object: nil)
        
        
        layer.addChild(header)
        layer.addChild(container)
        layer.addChild(previousButton)
        layer.addChild(nextButton)
        layer.addChild(infoButton)
        layer.addChild(shopButton)
        
        addChild(background)
        addChild(layer)
    }
    
    func updateStarCoinsLabelAfterBuy() {
        starCoinsLabel.text = GameData.starCoins.formatStringFromNumberShortenMillion()
    }
    
    func loadShop() {
        let shop = BetoShop(type: .StarCoins)
        self.addChild(shop.createLayer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateStarCoinsLabelAfterBuy), name: NSNotification.Name(rawValue: "updateStarCoinsLabelAfterBuy"), object: nil)
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
            createPage(currentPage)
        }
    }
    
    func nextPage() {
        var lastPage = themeManager.themes.count / perPageCount

        if themeManager.themes.count % perPageCount == 0 {
            lastPage -= 1
        }
        
        if currentPage < lastPage {
            currentPage += 1
            createPage(currentPage)
        }
    }
    
    func createPage(_ pageNumber: Int) {
        for preview in themePreviews {
            preview.removeFromParent()
        }
        
        themePreviews = []
        
        for index in 0...perPageCount - 1 {
            let position = index + (perPageCount * pageNumber)
            
            if position < themeManager.themes.count {
                let theme = themeManager.themes[position]
                
                let sprite = ButtonNode(defaultButtonImage: "\(theme.name.lowercased())Preview")
                sprite.size = CGSize(width: 92, height: 92)
                sprite.position = pointForPosition(position % perPageCount, size: container.size)
                sprite.action = {
                    GameData.changeTheme(theme)
                    GameData.save()
                        
                    self.background.texture = SKTexture(imageNamed: theme.background)
                }
                
                if !theme.unlocked {
                    let lockSprite = ButtonNode(defaultButtonImage: "themeLocked")
                    lockSprite.action = {
                        let container = SKSpriteNode(imageNamed: "buyThemeBackground")
                        container.position = CGPoint(x: 0, y: ScreenSize.Height)
                        
                        // DELETE: Test
                        if UIScreen.main.bounds.height == 480 {
                            container.setScale(0.81)
                            container.position = CGPoint(x: 0, y: ScreenSize.Height + 40)
                        }
                        
                        let closeButton = ButtonNode(defaultButtonImage: "closeButton")
                        closeButton.size = CGSize(width: 44, height: 45)
                        closeButton.position = CGPoint(x: 140, y: 220)
                        
                        let preview = SKSpriteNode(imageNamed: theme.background)
                        preview.size = CGSize(width: 189, height: 336)
                        preview.position = CGPoint(x: 0, y: -4)
                        
                        let overlay = SKSpriteNode(imageNamed: "buyThemeOverlay")
                        overlay.position = CGPoint(x: 0, y: -3)
                        
                        let priceNode = SKSpriteNode(imageNamed: "priceStarCoin")
                        priceNode.position = CGPoint(x: -10, y: -120)
                        
                        let priceLabel = SKLabelNode(text: "\(theme.tier.rawValue)")
                        priceLabel.fontName = Constant.FontNameCondensed
                        priceLabel.fontColor = UIColor.white
                        priceLabel.fontSize = 14
                        priceLabel.horizontalAlignmentMode = .left
                        priceLabel.verticalAlignmentMode = .center
                        priceLabel.position = CGPoint(x: 30, y: 0)
                        
                        priceNode.addChild(priceLabel)
                        overlay.addChild(priceNode)
                        
                        if theme.tier == .ultimate {
                            let includesLabel = SKLabelNode(text: "Includes a custom dice")
                            includesLabel.fontName = Constant.FontName
                            includesLabel.fontColor = UIColor.white
                            includesLabel.fontSize = 10
                            includesLabel.horizontalAlignmentMode = .center
                            includesLabel.verticalAlignmentMode = .center
                            includesLabel.position = CGPoint(x: 0, y: -135)

                            overlay.addChild(includesLabel)
                        }
                        
                        let buyButton = ButtonNode(defaultButtonImage: "buyButton")
                        buyButton.position = CGPoint(x: 0, y: -200)
                        
                        container.addChild(closeButton)
                        container.addChild(preview)
                        container.addChild(overlay)
                        container.addChild(buyButton)
                        
                        let node = DropdownNode(container: container)
                        closeButton.action = node.close
                        
                        if GameData.starCoins >= theme.tier.rawValue {
                            buyButton.isHidden = false
                            
                            buyButton.action = {
                                theme.purchase()
                                    
                                self.starCoinsLabel.text = "\(GameData.starCoins)"
                                lockSprite.removeFromParent()
                                node.close()
                            }
                        } else {
                            buyButton.isHidden = true
                        
                            let needStarCoins = SKSpriteNode(imageNamed: "needStarCoinsInfo")
                            overlay.addChild(needStarCoins)
                        }
                        
                        self.addChild(node.createLayer())
                    }
                    sprite.addChild(lockSprite)
                }
                
                themePreviews.append(sprite)
            }
        }
        
        for preview in themePreviews {
            container.addChild(preview)
        }
    }
    
    func presentMenuScene() {
        let transition = SKTransition.flipVertical(withDuration: 0.4)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        
        view!.presentScene(menuScene, transition: transition)
    }
    
    func pointForPosition(_ position: Int, size: CGSize) -> CGPoint {
        let row = position / 3
        let column = position % 3
    
        let previewWithMargin: CGFloat = 98
        
        let offsetX = -previewWithMargin + (previewWithMargin * CGFloat(column))
        let offsetY = (size.height - previewWithMargin + 10) / 2 - (previewWithMargin * CGFloat(row))
        
        return CGPoint(x: offsetX, y: -Constant.Margin + offsetY)
    }
}


