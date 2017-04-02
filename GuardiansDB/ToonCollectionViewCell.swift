//
//  ToonCollectionViewCell.swift
//  GuardiansDB
//
//  Created by User on 4/1/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class ToonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var toon: Toon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        
    }

    
    func configureCell(toon: Toon) {
        self.toon = toon
        nameLbl.text = self.toon.name
        thumbImage.image = UIImage(named: "\(self.toon.id)")
        
    }
    
}
