//
//  ViewController.swift
//  GuardiansDB
//
//  Created by User on 4/1/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    var Toons: [Toon] = []
    var defaultToon = Toon(name: "Iron Man", id: 1009386)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        Toons.append(defaultToon)
        fetchAPIData()
        
    }


    func fetchAPIData() {
        let url = URL(string: "https://gateway.marvel.com:443/v1/public/characters?series=16410%2C%204885&&orderBy=-modified&limit=50&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                var tempToons = [Toon]()
                if let urlContent = data {
                    //process JSON here
                    do {
                        
                        //var title = "not avail"
                        //var url = "http://www.economist.com"
                        //var pubDate = "2017-03-24T17:40:14Z"
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        //var tempTableData = [Cell]()
                        //print(jsonResult)
                        
                        if let data = jsonResult["data"] as? NSDictionary! {
                            //var dataValue = data["data"]["count"] as? String!
                            //print("the data \(data)")
                            
                            if let results = data["results"] as! [NSDictionary]! {
                                
                                for index in 0...results.count-1 {
                                    let id = results[index]["id"] as! Int!
                                    let name = results[index]["name"] as! String!
                                    
                                    
                                    
                                    //print("the ID is: \(String(describing: results[0]["id"]))")
                                    //print("the name is: \(results[0]["name"]))")
                                    let newToon = Toon(name: name!, id: id!)
                                    //print("Adding: \(newToon.name), with id: \(newToon.id)")
                                    if let comics = results[index]["comics"] as! NSDictionary? {
                                        if let items = comics["items"] as! [NSDictionary]? {
                                            //print ("the items: \(items)")
                                            for item in items {
                                                //print(item["name"])
                                                newToon.stories.append(item["name"] as! String)
                                            }
                                        }
                                    }
                                    print(newToon.name)
                                    print(newToon.id)
                                    print(newToon.stories)
                                    tempToons.append(newToon)
                                    //self.Toons.append(newToon)
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        

 
                        DispatchQueue.main.sync(execute: {
                            self.Toons = tempToons
                            self.collection.reloadData()
                        })
                        
                        
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToonCell", for: indexPath) as? ToonCollectionViewCell {
            print(indexPath.row)
            
            var toon = defaultToon
            if indexPath.row  < Toons.count {
                let toonName = Toons[indexPath.row].name
                let toonId = Toons[indexPath.row].id
                toon = Toon(name: toonName, id: toonId)
                
            }
            
            cell.configureCell(toon: toon)
            return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 22
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 132)
        
    }
}

