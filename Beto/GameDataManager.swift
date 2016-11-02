//
//  GameDataManager.swift
//  Beto
//
//  Created by Jem on 2/23/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

class GameDataManager {
    // Keys
    fileprivate let starCoinsKey = "starCoins"
    fileprivate let coinsKey = "coins"
    fileprivate let highscoreKey = "highscore"
    fileprivate let gamesPlayedKey = "gamesPlayed"
    fileprivate let coinsUnlockedKey = "coinsUnlocked"
    fileprivate let betDenominationKey = "betDenomination"
    fileprivate let soundMutedKey = "soundMuted"
    fileprivate let musicMutedKey = "musicMuted"
    fileprivate let currentThemeNameKey = "currentThemeName"
    fileprivate let autoLoadEnabledKey = "autoLoadEnabled"
    fileprivate let unlockedThemesKey = "unlockedThemes"
    fileprivate let achievementTrackerKey = "achievementTracker"
    fileprivate let powerUpsKey = "powerUps"
    fileprivate let rewardsDiceKey = "rewardsDice"
    
    // Plist Variables
    fileprivate(set) var starCoins: Int
    fileprivate(set) var coins: Int
    fileprivate(set) var highscore: Int
    fileprivate(set) var gamesPlayed: Int
    fileprivate(set) var coinsUnlocked: Int
    fileprivate(set) var betDenomination: Int
    fileprivate(set) var soundMuted: Bool
    fileprivate(set) var musicMuted: Bool
    fileprivate(set) var autoLoadEnabled: Bool
    fileprivate(set) var currentThemeName: String
    fileprivate(set) var unlockedThemes: [String]
    fileprivate(set) var achievementTracker: [String:Int]
    fileprivate(set) var powerUps: [String:Int]
    fileprivate(set) var rewardsDice: [String:Int]
    fileprivate(set) var rewardChance: Int
    
    var unlockedCoinHandler: (() -> ())?
    var unlockedAchievementHandler: ((Achievement) -> ())?
        
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.appendingPathComponent("GameData.plist")
        let fileManager = FileManager.default
        
        // check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the bundle
            if let bundlePath = Bundle.main.path(forResource: "GameData", ofType: "plist") {
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                } catch {
                    print("Error copying file")
                }
            } else {
                print("GameData.plist not found. Please make sure it is part of the bundle.")
            }
        }
        
        let dict = NSDictionary(contentsOfFile: path)!
        
        starCoins = dict.object(forKey: starCoinsKey) as! Int
        coins = dict.object(forKey: coinsKey) as! Int
        highscore = dict.object(forKey: highscoreKey) as! Int
        gamesPlayed = dict.object(forKey: gamesPlayedKey) as! Int
        coinsUnlocked = dict.object(forKey: coinsUnlockedKey) as! Int
        betDenomination = dict.object(forKey: betDenominationKey) as! Int
        soundMuted = dict.object(forKey: soundMutedKey) as! Bool
        musicMuted = dict.object(forKey: musicMutedKey) as! Bool
        autoLoadEnabled = dict.object(forKey: autoLoadEnabledKey) as! Bool
        currentThemeName = dict.object(forKey: currentThemeNameKey) as! String
        unlockedThemes = dict.object(forKey: unlockedThemesKey) as! [String]
        achievementTracker = dict.object(forKey: achievementTrackerKey) as! [String:Int]
        powerUps = dict.object(forKey: powerUpsKey) as! [String:Int]
        rewardsDice = dict.object(forKey: rewardsDiceKey) as! [String:Int]

        rewardChance = 0
    }
    
    func save() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.appendingPathComponent("GameData.plist")
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        
        // save values
        dict.setObject(starCoins, forKey: starCoinsKey as NSCopying)
        dict.setObject(coins, forKey: coinsKey as NSCopying)
        dict.setObject(highscore, forKey: highscoreKey as NSCopying)
        dict.setObject(gamesPlayed, forKey: gamesPlayedKey as NSCopying)
        dict.setObject(coinsUnlocked, forKey: coinsUnlockedKey as NSCopying)
        dict.setObject(betDenomination, forKey: betDenominationKey as NSCopying)
        dict.setObject(soundMuted, forKey: soundMutedKey as NSCopying)
        dict.setObject(musicMuted, forKey: musicMutedKey as NSCopying)
        dict.setObject(autoLoadEnabled, forKey: autoLoadEnabledKey as NSCopying)
        dict.setObject(currentThemeName, forKey: currentThemeNameKey as NSCopying)
        dict.setObject(unlockedThemes, forKey: unlockedThemesKey as NSCopying)
        dict.setObject(achievementTracker, forKey: achievementTrackerKey as NSCopying)
        dict.setObject(powerUps, forKey: powerUpsKey as NSCopying)
        dict.setObject(rewardsDice, forKey: rewardsDiceKey as NSCopying)
        
        // write to GameData.plist
        dict.write(toFile: path, atomically: true)
    }
    
    func iCloud() {
        let keyStore = NSUbiquitousKeyValueStore.default()
        keyStore.set(GameData.starCoins, forKey: "starCoins")
        keyStore.set(GameData.unlockedThemes, forKey: "unlockedThemes")
        keyStore.synchronize()
    }
    
    func changeTheme(_ theme: Theme) {
        currentThemeName = theme.name
    }
    
    func addPurchasedTheme(_ themeName: String) {
        unlockedThemes.append(themeName)
    }
    
    func setMusic(_ musicMuted: Bool) {
        self.musicMuted = musicMuted
    }
    
    func setSound(_ soundMuted: Bool) {
        self.soundMuted = soundMuted
    }
    
    func toggleAutoLoad() {
        autoLoadEnabled = !autoLoadEnabled
    }
    
    func setDenomination(_ value: Int) {
        betDenomination = value
    }
    
    func setStarCoins(_ amount: Int) {
        starCoins += amount
    }
    
    func addStarCoins(_ amount: Int) {
        starCoins += amount

        if let value = achievementTracker[AchievementName.StarCoin.rawValue] {
            achievementTracker[AchievementName.StarCoin.rawValue] = value + amount
        } else {
            Achievements.update(.StarCoin)
            achievementTracker[AchievementName.StarCoin.rawValue] = amount
        }

        Achievements.update(.StarCoin)
    }
    
    func subtractStarCoins(_ amount: Int) {
        starCoins -= amount
    }
    
    func addCoins(_ amount: Int) {
        let max = 999999999
        
        if (coins + amount) > max {
            coins = max
        } else {
            coins += amount
        }
        
        if coins > highscore {
            highscore = coins
            
            achievementTracker[AchievementName.MoneyInTheBank.rawValue] = highscore
            Achievements.update(.MoneyInTheBank)
            
            var index = 0

            for value in Constant.CoinUnlockedAt {                
                if highscore >= value {
                    index = 1 + Constant.CoinUnlockedAt.index(of: value)!
                } else {
                    break
                }
            }
            
            while index > coinsUnlocked {
                coinsUnlocked += 1
                unlockedCoinHandler!()
            }

            achievementTracker[AchievementName.CoinCollector.rawValue] = coinsUnlocked
            Achievements.update(.CoinCollector)
        }
    }
    
    func subtractCoins(_ amount: Int) {
        coins -= amount
    }
    
    func incrementGamesPlayed() {
        gamesPlayed += 1
    }
    
    func increaseRewardChance(_ num: Int) {
        // Reward chance increases by 3/6/9 % based on number of colors selected
        rewardChance += num * 3
    }
    
    func resetRewardChance() {
        rewardChance = 0
    }
    
    func addNewAchievementTracker(_ name: String) {
        achievementTracker[name] = 0
    }
    
    func incrementAchievement(_ name: AchievementName) {
        if let value = achievementTracker[name.rawValue] {
            achievementTracker[name.rawValue] = value + 1
        }
        
        Achievements.update(name)        
    }
    
    func updateHighestWager(_ wager: Int) {
        let key = AchievementName.HighestWager.rawValue
        
        if let value = achievementTracker[key] {
            if wager > value {
                achievementTracker[key] = wager
                Achievements.update(.HighestWager)
            }
        } else {
            achievementTracker[key] = wager
            Achievements.update(.HighestWager)
        }
    }
    
    func addPowerUpCount(_ powerUpKey: String, num: Int) {
        if let value = powerUps[powerUpKey] {
            powerUps[powerUpKey] = value + num
        }
    }
    
    func subtractPowerUpCount(_ powerUpKey: String, num: Int) {
        if let value = powerUps[powerUpKey] {
            powerUps[powerUpKey] = value - num
        }
    }
    
    func getRewardsDiceCount(_ diceKey: String) -> Int {
        if let value = rewardsDice[diceKey] {
            return value
        } else {
            return -1
        }
    }
    
    func addRewardsDiceCount(_ diceKey: String, num: Int) {
        if let value = rewardsDice[diceKey] {
            rewardsDice[diceKey] = value + num
        
            NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleDiceVaultButton"), object: self)
        }
    }
    
    func subtractRewardsDiceCount(_ diceKey: String, num: Int) {
        if let value = rewardsDice[diceKey] {
            rewardsDice[diceKey] = value - num
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleDiceVaultButton"), object: self)
        }
    }
}
