//
//  ViewController.swift
//  Project12
//
//  Created by Prarthana Das on 14/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userDefaults.set(30, forKey: "Age")
        userDefaults.set(true, forKey: "UseTouchID")
        userDefaults.set(CGFloat.pi, forKey: "Pi")
        userDefaults.setValue("Paul Hudson", forKey: "Name")
        userDefaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hello", "World"]
        userDefaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name": "Paul", "Country": "UK"]
        userDefaults.set(dict, forKey: "SavedDict")
        
        let arrayRetrieved = userDefaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        print(arrayRetrieved)
        
        let dictionaryRetrieved = userDefaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
        print(dictionaryRetrieved)
        
    }


}

