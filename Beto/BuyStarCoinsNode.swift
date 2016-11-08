//
//  BuyStarCoinsNode.swift
//  Beto
//
//  Created by Jem on 10/26/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

struct Package {
    let name: String
    let starCoins: Int
    let bonusDice: [RewardsDiceKey]
    let price: String // DELETE: Temp? Might have to change for IAP
}

class BuyStarCoinsNode: SKNode {
    var package: Package
    var buyButton: ButtonNode
    var priceLabel: SKLabelNode

    init(package: Package) {
        self.package = package
        
        // Buy button
        buyButton = ButtonNode(defaultButtonImage: "buyButton")
        buyButton.position = CGPoint(x: 80, y: 10)
        
        // Configure price
        let titleLabel = SKLabelNode(text: "PRICE:")
        titleLabel.fontName = Constant.FontNameExtraBold
        titleLabel.fontColor = UIColor.white
        titleLabel.fontSize = 14
        titleLabel.position = CGPoint(x: 65, y: -20)
        
        let titleShadow = titleLabel.createLabelShadow()
        
        priceLabel = SKLabelNode(text: package.price)
        priceLabel.fontName = Constant.FontNameCondensed
        priceLabel.fontColor = UIColor.darkGray
        priceLabel.fontSize = 14
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.position = CGPoint(x: 90, y: -20)
        
        let plusLabel = SKLabelNode(text: "+")
        plusLabel.fontName = Constant.FontNameExtraBold
        plusLabel.fontColor = UIColor.white
        plusLabel.fontSize = 20
        plusLabel.position = CGPoint(x: -46, y: -10)
        
        let plusShadow = plusLabel.createLabelShadow()
        
        super.init()
        
        let container = SKSpriteNode(imageNamed: "dropNodeCellBackground")
        container.size = CGSize(width: 276, height: 60)
        
        let starCoinsNode = SKSpriteNode(imageNamed: "starCoinsCountBackground")
        starCoinsNode.position = CGPoint(x: -90, y: 0)
        
        let countLabel = SKLabelNode(text: "\(package.starCoins)")
        countLabel.fontName = Constant.FontNameCondensed
        countLabel.fontColor = UIColor.white
        countLabel.fontSize = 14
        countLabel.horizontalAlignmentMode = .left
        countLabel.verticalAlignmentMode = .center
        countLabel.position = CGPoint(x: 5, y: 0)
        
        starCoinsNode.addChild(countLabel)
        
        var xPosition = 12
        
        for diceKey in package.bonusDice {
            let imageName = "\(diceKey.rawValue.lowercased())Reward"
            
            let node = SKSpriteNode(imageNamed: imageName)
            node.position = CGPoint(x: xPosition, y: 0)
            
            xPosition -= 16
            
            container.addChild(node)
        }
        
        container.addChild(starCoinsNode)
        container.addChild(plusShadow)
        container.addChild(plusLabel)
        container.addChild(buyButton)
        container.addChild(titleShadow)
        container.addChild(titleLabel)
        container.addChild(priceLabel)
        
        addChild(container)
        
        // Add buy action
        buyButton.action = confirmPurchase
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func confirmPurchase() {
        let container = SKSpriteNode(imageNamed: "confirmPurchaseBackground")
        container.setScale(1.0 / Constant.ScaleFactor)
        
        let confirmPurchaseNode = DropdownNode(container: container)
        
        let purchaseText = "\(package.name) Package"

        let purchaseLabel = SKLabelNode(text: purchaseText.uppercased())
        purchaseLabel.fontName = Constant.FontNameExtraBold
        purchaseLabel.fontColor = UIColor.white
        purchaseLabel.fontSize = 14
        purchaseLabel.position = CGPoint(x: 0, y: 45)

        let purchaseLabelShadow = purchaseLabel.createLabelShadow()
        
        let adFreeLabel = SKLabelNode(text: "+ remove ads")
        adFreeLabel.fontName = Constant.FontName
        adFreeLabel.fontColor = UIColor.darkGray
        adFreeLabel.fontSize = 10
        adFreeLabel.position = CGPoint(x: 0, y: 30)
        
        let packageNode = SKNode()
        packageNode.position = CGPoint(x: 0, y: 5)
        
        // Display starCoin amount
        let starCoinNode = SKSpriteNode(imageNamed: "starCoin")
        starCoinNode.position = CGPoint(x: -50, y: 0)
        
        let starLabel = SKLabelNode(text: "x\(package.starCoins)")
        starLabel.fontName = Constant.FontName
        starLabel.fontColor = UIColor.darkGray
        starLabel.fontSize = 14
        starLabel.horizontalAlignmentMode = .left
        starLabel.position = CGPoint(x: 22, y: -5)
        
        starCoinNode.addChild(starLabel)
        packageNode.addChild(starCoinNode)
        
        // Display bonus rewards dice
        var xPosition = 60

        for diceKey in package.bonusDice {
            let imageName = "\(diceKey.rawValue.lowercased())Reward"
            
            let node = SKSpriteNode(imageNamed: imageName)
            node.position = CGPoint(x: xPosition, y: 0)
            
            xPosition -= 15
            
            packageNode.addChild(node)
        }
        
        let priceTitleLabel = SKLabelNode(text: "PRICE:")
        priceTitleLabel.fontName = Constant.FontNameExtraBold
        priceTitleLabel.fontColor = UIColor.white
        priceTitleLabel.fontSize = 14
        priceTitleLabel.position = CGPoint(x: -20, y: -35)
        
        let priceTitleLabelShadow = priceTitleLabel.createLabelShadow()
        
        let priceLabel = SKLabelNode(text: package.price)
        priceLabel.fontName = Constant.FontNameCondensed
        priceLabel.fontColor = UIColor.darkGray
        priceLabel.fontSize = 14
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.position = CGPoint(x: 25, y: 0)
        
        priceTitleLabel.addChild(priceLabel)
        
        let confirmButton = ButtonNode(defaultButtonImage: "confirmButton")
        confirmButton.position = CGPoint(x: -50, y: -80)
        confirmButton.action = {
            Products.store.requestProducts { (success, products) in
                if success {
                    for product in products! {
                        if product.productIdentifier == "com.redgarage.Beto." + "\(self.package.name)" {
                            Products.store.buyProduct(product)
                        }
                    }
                }
                confirmPurchaseNode.close()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.purchaseConfirmed), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
        
        let cancelButton = ButtonNode(defaultButtonImage: "cancelButton")
        cancelButton.position = CGPoint(x: 50, y: -80)
        cancelButton.action = confirmPurchaseNode.close
        
        container.addChild(purchaseLabelShadow)
        container.addChild(purchaseLabel)
        container.addChild(adFreeLabel)
        container.addChild(packageNode)
        container.addChild(priceTitleLabelShadow)
        container.addChild(priceTitleLabel)
        container.addChild(confirmButton)
        container.addChild(cancelButton)
        
        self.parent?.addChild(confirmPurchaseNode.createLayer())
    }
    
    func purchaseConfirmed() {
        if Products.store.isProductPurchased(Products.RemoveAds) {
            
        } else {
            Products.store.requestProducts { (success, products) in
                if success {
                    for product in products! {
                        if product.productIdentifier == "com.redgarage.Beto." + "RemoveAds" {
                            Products.store.buyProduct(product)
                        }
                    }
                }
            }
        }
        
        GameData.addStarCoins(self.package.starCoins)

        for diceKey in self.package.bonusDice {
            GameData.addRewardsDiceCount(diceKey.rawValue, num: 1)
        }

        GameData.save()
        GameData.iCloud()

        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateStarCoinsLabelAfterBuy"), object: self)
    }
    
}
