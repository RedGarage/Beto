//
//  MenuViewController.swift
//  Beto
//
//  Created by Jem on 3/10/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class MenuViewController: UIViewController, GADInterstitialDelegate {
    var scene: SKScene!
    var interstitialAd: GADInterstitial!

    @IBOutlet weak var bannerView: GADBannerView!
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !Products.store.isProductPurchased(Products.RemoveAds) {
            if GameData.gamesPlayed % 10 == 0 || GameData.coins == 0 {
                showInterstitialAD()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Present the scene.
        skView.presentScene(scene)
        
        if !Products.store.isProductPurchased(Products.RemoveAds) {
            // DELETE: Use TEST Ads during dev and testing. Change to live only on launch
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            let test = GADRequest()
            test.testDevices = ["57738ac8abf9499b8b4df6e379d05c76"]
            bannerView.load(test)
            
            interstitialAd = reloadInterstitialAd()
        }
        
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        updateStarCoins()
        updateUnlockedThemes()
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.removeAds), name: NSNotification.Name(rawValue: Products.RemoveAds), object: nil)
>>>>>>> 91de14b... Added 4 packages to IAP
=======
>>>>>>> fdf0798... 4 packages added
=======
=======
        updateStarCoins()
        updateUnlockedThemes()
>>>>>>> e549d9a... Star coins and themes save to iCloud
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.removeAds), name: NSNotification.Name(rawValue: Products.RemoveAds), object: nil)
>>>>>>> 6cdfa8e... Added 4 packages to IAP
=======
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.removeAds), name: NSNotification.Name(rawValue: Products.RemoveAds), object: nil)
>>>>>>> faed6f0... Previous purchases restored
=======
        updateStarCoins()
        updateUnlockedThemes()
>>>>>>> 8fc22d00649fad5c81e31bf5515c8791ae86b3ff
    }
    
    func reloadInterstitialAd() -> GADInterstitial {
        // DELETE: Test only. Change unit ID to real one
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
//        request.testDevices = ["57738ac8abf9499b8b4df6e379d05c76"]
        interstitial.delegate = self
        interstitial.load(request)
        
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        self.interstitialAd = reloadInterstitialAd()
    }
    
    func updateStarCoins() {
        if let starCoins = NSUbiquitousKeyValueStore.default().object(forKey: "starCoins") as? Int {
            GameData.setStarCoins(starCoins)
        } else {
            print("iCloud error")
        }
    }
    
    func updateUnlockedThemes() {
        if let unlockedThemes = NSUbiquitousKeyValueStore.default().object(forKey: "unlockedThemes") as? NSArray {
            for theme in unlockedThemes {
                GameData.addPurchasedTheme(theme as! String)
            }
        } else {
            print("iCloud error")
        }
    }
    
    func showInterstitialAD() {
        if interstitialAd.isReady {
            self.interstitialAd.present(fromRootViewController: self)
        }
    }
    
    func removeAds() {
        bannerView.removeFromSuperview()
    }
    
    func iCloudChangedNotification(notification: NSNotification) {
        print("iCloud changed")
        if let userInfo = notification.userInfo {
            if let changeReason = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? NSNumber {
                print("Change reason = \(changeReason)")
            }
            if let changedKeys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] {
                print("ChangedKeys = \(changedKeys)")
            }
        }
        
        let keyStore = NSUbiquitousKeyValueStore.default()
        
        if let starCoins = keyStore.object(forKey: "starCoins") as? Int {
            GameData.addCoins(starCoins)
        } else {
            print("iCloud error")
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let boardScene = sender as? BoardScene {
            if segue.identifier == "showGameScene" {
                let destinationVC = segue.destination as! GameViewController
                destinationVC.boardScene = boardScene
            }
        }
    }
}
