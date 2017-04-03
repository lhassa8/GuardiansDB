//
//  ToonDetailVC.swift
//  GuardiansDB
//
//  Created by User on 4/2/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit
import WebKit

class ToonDetailVC: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    //default to Iron Man just in case of error
    var toon = Toon(name: "Iron Man", id: 1009386)
    
    @IBOutlet weak var webView: UIWebView!
    
    let initialUrl = String("https://gateway.marvel.com/v1/public/characters/")
    let postUrl = String("?&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf")
    

    /* func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                // label.text = detail.timestamp!.description
                label.text = detail.url!
                url = URL(string: detail.url!)
                navigationItem.title = detail.title
            }
        }
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = toon.name
        let url = URL(string: initialUrl! + String(toon.id) + postUrl!)

        fetchAPIData(url: url!)
        

        // Do any additional setup after loading the view.
    }


    
    @IBAction func returnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - JSON


    
    
    func fetchAPIData(url: URL) {
        let request = URLRequest(url: url)
        var outputURL = URL(string: "http://marvel.com")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                //var tempToons = [Toon]()
                if let urlContent = data {
                    //process JSON here
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let data = jsonResult["data"] as? NSDictionary! {
                            
                            if let results = data["results"] as? [NSDictionary]! {
                                //print(results[0]["urls"]!)
                                let urls = results[0]["urls"] as? NSArray!
                                
                                let item = urls?[0] as? NSDictionary!
                                
                                let urlString = item?["url"] as! String

                                outputURL = URL(string: urlString)!
                                print(outputURL)

                            
                                //if let urls = results["urls"] as? NSDictionary! {
                                    
                                    //for index in 0...urls.count-1 {
                                
                                        //print(results[index])
                                        
                                        /*
                                         let id = results[index]["id"] as! Int!
                                         let name = results[index]["name"] as! String!
                                 
                                         let newToon = Toon(name: name!, id: id!)
                                         
                                         if let comics = results[index]["comics"] as! NSDictionary? {
                                         if let items = comics["items"] as! [NSDictionary]? {
                                         
                                         for item in items {
                                         
                                         newToon.stories.append(item["name"] as! String)
                                         }
                                         }
                                         }
                                         print(newToon.name)
                                         print(newToon.id)
                                         print(newToon.stories)
                                         tempToons.append(newToon)
                                         */
                                    //}
                               // }
                            }
                        }
                        
                        DispatchQueue.main.sync(execute: {
                            //self.Toons = tempToons
                            //self.collection.reloadData()
                            let request = URLRequest(url: outputURL!)
                            self.webView.loadRequest(request)
                            //return outputURL
                        })
                        
                        
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()
        //return outputURL
    }

}
