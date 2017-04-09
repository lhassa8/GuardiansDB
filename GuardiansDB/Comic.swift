//
//  Comic.swift
//  GuardiansDB
//
//  Created by User on 4/7/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import Foundation
import UIKit

class Comic {
    private var _id: Int!
    private var _title: String!
    var Desc: String?
    var purchaseURL: String?
    
    var title: String {
        return _title
    }
    
    var id: Int {
        return _id
    }
    
    init(title: String, id: Int) {
        self._title = title
        self._id = id
    }
    
    var comicUrl: URL {
        let preUrl = "http://gateway.marvel.com/v1/public/comics/" + String(_id)
        let postHash = "?&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf"
        let output = URL(string: preUrl + postHash)
        return output!
    }
    
}

extension Comic: Equatable {
    static func ==(lhs: Comic, rhs: Comic) -> Bool {
        return (lhs.title, lhs.id) == (rhs.title, rhs.id)
    }
}

extension Comic: Comparable {
    static func <(lhs: Comic, rhs: Comic) -> Bool {
        return (lhs.title, lhs.id) < (rhs.title, rhs.id)
    }
}
