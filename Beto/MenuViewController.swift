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
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.removeAds), name: NSNotification.Name(rawValue: Products.RemoveAds), object: nil)
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
    
    func showInterstitialAD() {
        if interstitialAd.isReady {
            self.interstitialAd.present(fromRootViewController: self)
        }
    }
    
    func removeAds() {
        bannerView.removeFromSuperview()
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
