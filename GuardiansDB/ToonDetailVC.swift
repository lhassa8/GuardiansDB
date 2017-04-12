//
//  ToonDetailVC.swift
//  GuardiansDB
//
//  Created by User on 4/2/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ToonDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var toonProfileImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var toonDescriptionLbl: UILabel!
    @IBOutlet weak var wikiButton: UIButton!
    
    //default to Iron Man just in case of error
    var toon = Toon(name: "Iron Man", id: 1009386)
    
    //let initialUrl = String("https://gateway.marvel.com/v1/public/characters/")
    let postUrl = String("?&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf")
    var comics = [Comic]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = toon.name
        toonProfileImage.clipsToBounds = true
        toonProfileImage.layer.cornerRadius = 25
        toonProfileImage.image = UIImage(named: "\(self.toon.id)")
        self.table.backgroundColor = UIColor.clear
        
    
        var url = toon.toonUrl
        //let url = URL(string: initialUrl! + String(toon.id) + postUrl!)

        // test spinner
        let x = (self.view.bounds.width / 2) - 25
        let y = (self.view.bounds.height / 2) 
        let spinner:SpinnerView = SpinnerView(frame: CGRect(x: x, y: y, width: 50, height: 50))
        spinner.tag = 100
        self.view.addSubview(spinner)
        
        fetchAPIData(url: url)
        url = toon.comicUrl
        fetchComicsData(url: url)
        

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let value = self.comics[indexPath.row].title
        cell.textLabel?.font = UIFont(name:"Avenir", size:14)
        cell.textLabel?.text = value
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.purple
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(comics[indexPath.row].purchaseURL)
        if let url = URL(string: comics[indexPath.row].purchaseURL) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
        //self.performSegue(withIdentifier: "ShowComicDetail", sender: comics[indexPath.row]);
    }

    
    
    @IBAction func returnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func wikiBtnPressed(_ sender: Any) {
        if let url = URL(string: toon.wikiURL) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    // MARK: - JSON


    
    
    func fetchAPIData(url: URL) {
        var outputDesc = String()
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
                                if let desc = results[0]["description"]! as? String {
                                    outputDesc = desc
                                }
                            }
                        }
                        
                        DispatchQueue.main.sync(execute: {

                            if outputDesc == "" {
                                outputDesc = "Description not available.  Tap character image to see full wiki page."
                            }
                            self.toonDescriptionLbl.text = outputDesc 

                        })
                        
                        
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()

    }
    
    func fetchComicsData(url: URL) {
        var fetchedComics = [Comic]()
//        var outputURL = URL(string: "http://marvel.com")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                if let urlContent = data {
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let data = jsonResult["data"] as? NSDictionary! {
                            
                            if let results = data["results"] as? [NSDictionary]! {
                                for i in 0...results.count-1 {
                                    if let comicID = results[i]["id"] as? Int {
                                        if let comicTitle = results[i]["title"] as? String {
                                            var purchaseURL = "https://marvel.com/comics/unlimited"
                                            if let urls = results[i]["urls"] as? [NSDictionary] {
                                                for i in 0...urls.count-1 {
                                                    if String(describing: urls[i]["type"]!) == "purchase" {
                                                        if let purchURL = urls[i]["url"] as? String {
                                                            purchaseURL = purchURL
                                                        }
                                                    }
                                                }
                                            }
                                            let comic = Comic(title: comicTitle, id: comicID, purchaseURL: purchaseURL)
                                            comic.Desc = results[i]["description"] as? String ?? "No Description Avail"
                                            
                                            fetchedComics.append(comic)

                                            
                                        }
                                    }
                                }
                                                            }
                        }
                        
                        DispatchQueue.main.sync(execute: {
                            
                            fetchedComics.sort()
                            self.comics = fetchedComics
                            
                            if let viewWithTag = self.view.viewWithTag(100) {
                                print("Tag 100 found")
                                viewWithTag.removeFromSuperview()
                            }
                            else {
                                print("tag not found")
                            }
                            self.table.reloadData()
                        })
                        
                        
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()

    }
    
    

}
