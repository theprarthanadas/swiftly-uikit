//
//  Person.swift
//  Project10
//
//  Created by Prarthana Das on 04/06/23.
//

import UIKit

class Person: NSObject, Codable {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
