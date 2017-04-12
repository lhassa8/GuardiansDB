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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowComicDetail" {
            
            let comicDetailVC = segue.destination as! ComicDetailVC
            
            // Get the selected cell
            if let selectedComic = sender as? Comic {
                print(selectedComic.comicUrl)
                comicDetailVC.comicURLString = URL(string: selectedComic.purchaseURL)
            }
            
        }
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
        let request = URLRequest(url: url)
        var outputURL = URL(string: "http://marvel.com")
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
                                var urlString = String()
                                let urls = results[0]["urls"] as? NSArray!
                                for i in 0...results.count {
                                    let item = urls?[i] as? NSDictionary!
                                    //print(item!)
                                    if let urlType = item?["type"] as? String {
                                        if urlType == "detail" {
                                            urlString = item?["url"] as! String
                                            //print(urlString)
                                        }
                                    }
                                }
                                outputURL = URL(string: urlString)!
                                //print(outputURL!)
                            }
                        }
                        
                        DispatchQueue.main.sync(execute: {
                            //self.Toons = tempToons
                            //self.collection.reloadData()
                            //let request = URLRequest(url: outputURL!)
                            //self.webView.loadRequest(request)
                            if outputDesc == "" {
                                outputDesc = "Description not available.  Tap character image to see full wiki page."
                            }
                            self.toonDescriptionLbl.text = outputDesc 
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
    
    func fetchComicsData(url: URL) {
        var fetchedComics = [Comic]()
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
                                for i in 0...results.count-1 {
                                    if let comicID = results[i]["id"] as? Int {
                                        if let comicTitle = results[i]["title"] as? String {
                                            var purchaseURL = "https://marvel.com/comics/unlimited"
                                            if let urls = results[i]["urls"] as? [NSDictionary] {
                                                //print(urls)
                                                for i in 0...urls.count-1 {
                                                    //print(urls[i]["type"])
                                                    if String(describing: urls[i]["type"]!) == "purchase" {
                                                        if let purchURL = urls[i]["url"] as? String {
                                                            purchaseURL = purchURL
                                                        }
                                                    }
                                                }
                                                //print(urls)
                                            }
                                            let comic = Comic(title: comicTitle, id: comicID, purchaseURL: purchaseURL)
                                            comic.Desc = results[i]["description"] as? String ?? "No Description Avail"
                                            
                                            //print(comic.title, comic.comicUrl)
                                            fetchedComics.append(comic)

                                            
                                        }
                                    }
                                }
                                /*
                                var urlString = String()
                                let urls = results[0]["urls"] as? NSArray!
                                for i in 0...results.count {
                                    let item = urls?[i] as? NSDictionary!
                                    print(item!)
                                    if let urlType = item?["type"] as? String {
                                        if urlType == "detail" {
                                            urlString = item?["url"] as! String
                                            print(urlString)
                                        }
                                    }
                                }
                                outputURL = URL(string: urlString)!
                                print(outputURL!)
 */
                            }
                        }
                        
                        DispatchQueue.main.sync(execute: {
                            //self.Toons = tempToons
                            //self.collection.reloadData()
                            //let request = URLRequest(url: outputURL!)
                            //self.webView.loadRequest(request)
                            //return outputURL
                            
                            fetchedComics.sort()
                            self.comics = fetchedComics
                            //print(self.comics.count)
                            //print(self.comics[0].title)
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
