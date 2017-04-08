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
    var stories = [String]()
    
    var name: String {
        return _name
    }
    
    var id: Int {
        return _id
    }
    
    var toonUrl: URL {
        let preUrl = "http://gateway.marvel.com/v1/public/characters/" + String(_id)
        let postHash = "?&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf"
        let output = URL(string: preUrl + postHash)
        return output!
    }
    
    var comicUrl: URL {
        let preUrl = "http://gateway.marvel.com/v1/public/characters/" + String(_id) + "/comics?limit=50"
        let postHash = "&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf"
        let output = URL(string: preUrl + postHash)
        return output!
    }
    
    var seriesUrl: URL {
        let preUrl = "http://gateway.marvel.com/v1/public/characters/" + String(_id) + "/series"
        let postHash = "?&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf"
        let output = URL(string: preUrl + postHash)
        return output!
    }
    
    init(name: String, id: Int) {
        self._name = name
        self._id = id
    }
    
}
