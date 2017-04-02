//
//  ViewController.swift
//  GuardiansDB
//
//  Created by User on 4/1/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate  {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var Toons: [Toon] = []
    var defaultToon = Toon(name: "Iron Man", id: 1009386)
    var inSearchMode = false
    var filteredToons: [Toon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        Toons.append(defaultToon)
        searchBar.isTranslucent = true
        searchBar.keyboardAppearance = .dark
        searchBar.returnKeyType = .done  
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
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject

                        if let data = jsonResult["data"] as? NSDictionary! {
                            
                            if let results = data["results"] as! [NSDictionary]! {
                                
                                for index in 0...results.count-1 {
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
            
            if inSearchMode {
                
                if indexPath.row  < filteredToons.count {
                    let toonName = filteredToons[indexPath.row].name
                    let toonId = filteredToons[indexPath.row].id
                    toon = Toon(name: toonName, id: toonId)
                    
                }
            } else {
                
                if indexPath.row  < Toons.count {
                    let toonName = Toons[indexPath.row].name
                    let toonId = Toons[indexPath.row].id
                    toon = Toon(name: toonName, id: toonId)
                    
                }
            }
            
            cell.configureCell(toon: toon)
            return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var toon = defaultToon
        
        if inSearchMode {
            toon = filteredToons[indexPath.row]
        } else {
            toon = Toons[indexPath.row]
        }
        
        performSegue(withIdentifier: "ToonDetailVC", sender: toon)
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
        
            return filteredToons.count
        }
        
        return Toons.count

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 132)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            view.endEditing(true)
            inSearchMode = false
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()

            filteredToons = Toons.filter({$0.name.range(of: lower, options: .caseInsensitive) != nil})
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToonDetailVC" {
            if let detailsVC = segue.destination as? ToonDetailVC {
                if let toon = sender as? Toon {
                    detailsVC.toon = toon
                }
            }
        }
    }
    
    

}

