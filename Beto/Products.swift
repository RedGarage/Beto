//
//  Products.swift
//  Beto
//
//  Created by Vince Boogie on 9/20/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

public struct Products {
    public static let RemoveAds = "com.redgarage.Beto.RemoveAds"
    public static let Basic = "com.redgarage.Beto.Basic"
    public static let Plus = "com.redgarage.Beto.Plus"
    public static let Premium = "com.redgarage.Beto.Premium"
    public static let Ultimate = "com.redgarage.Beto.Ultimate"
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Products.RemoveAds,
                                                                         Products.Basic,
                                                                         Products.Plus,
                                                                         Products.Premium,
                                                                         Products.Ultimate]
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
