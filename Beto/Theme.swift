//
//  Theme.swift
//  Beto
//
//  Created by Jem on 6/3/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

enum PriceTier: Int {
    case free = 0
    case basic = 25
    case premium = 50
    case ultimate = 100
}

class Theme {
    let name: String
    let background: String
    let board: String
    
    var unlocked: Bool
    var tier: PriceTier
     
    init(themeName: String, tier: PriceTier) {
        name = themeName
        background = "\(name.lowercased())Background"
        board = "\(name.lowercased())Board"
        
        if tier == .free || GameData.unlockedThemes.contains(themeName) {
            unlocked = true
        } else {
            unlocked = false
        }
        
        self.tier = tier
    }
    
    func purchase() {
        unlocked = true
        GameData.subtractStarCoins(tier.rawValue)
        GameData.addPurchasedTheme(name)
        GameData.save()
        GameData.iCloud()
    }
}
