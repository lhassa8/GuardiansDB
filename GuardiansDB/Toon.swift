//
//  Toon.swift
//  GuardiansDB
//
//  Created by User on 4/1/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import Foundation

class Toon {
    private var _name: String!
    private var _id: Int!
    
    var name: String {
        return _name
    }
    
    var id: Int {
        return _id
    }
    
    init(name: String, id: Int) {
        self._name = name
        self._id = id
        
    }
}
