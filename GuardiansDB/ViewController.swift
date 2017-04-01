//
//  ViewController.swift
//  GuardiansDB
//
//  Created by User on 4/1/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var Toons: [Toon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAPIData()
        
    }


    func fetchAPIData() {
        let url = URL(string: "https://gateway.marvel.com:443/v1/public/characters?series=16410%2C%204885&&orderBy=-modified&limit=50&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                
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
                                    self.Toons.append(newToon)
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                        /*
                        if let allArticles = jsonResult["articles"] as? [NSDictionary]{
                            for i in 0...allArticles.count-1 {
                                
                                title = allArticles[i]["title"] as! String!
                                url =  allArticles[i]["url"] as! String!
                                //pubDate = allArticles[i]["publishedAt"] as! String!
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                
                                
                                //let tempCell = Cell(title: title, url: url)
                                //tempTableData.append(tempCell)
                                //print("row: \(i) is \(tempTableData[i]) \n\n\n")
                                //save new data
                                let context = self.fetchedResultsController.managedObjectContext
                                let newEvent = Event(context: context)
                                
                                // If appropriate, configure the new managed object.
                                newEvent.title = title
                                newEvent.url = url
                                // newEvent.timestamp = dateFormatter.date(from: pubDate) as NSDate? not working
                                newEvent.timestamp = Date() as NSDate
                                print("PubDate: \(pubDate)")
                                print(newEvent.timestamp?.description)
                                print(newEvent)
                                
                                // Save the context.
                                do {
                                    try context.save()
                                } catch {
                                    // Replace this implementation with code to handle the error appropriately.
                                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                    let nserror = error as NSError
                                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                                }
                                
                            }
                            
                            self.tableView.reloadData()
                            
                        }
                        */
 
                        //DispatchQueue.main.sync(execute: {
                        //    self.tableData = tempTableData
                        //print(self.tableData)
                        //})
                        
                        
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()
    }


}

