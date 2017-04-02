//
//  ToonDetailVC.swift
//  GuardiansDB
//
//  Created by User on 4/2/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class ToonDetailVC: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    //default to Iron Man just in case of error
    var toon = Toon(name: "Iron Man", id: 1009386)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = toon.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
