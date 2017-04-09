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

class ComicDetailVC: UIViewController {


    
    //let initialUrl = String("https://gateway.marvel.com/v1/public/characters/")
    let postUrl = String("?&ts=1&apikey=67366473d332c7638e072fd713d6c78d&hash=fc0fc0d5738fb7e45d0c9765950abdaf")
    var comics = [Comic]()
    var comicURLString: URL?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let url = comicURLString
        print(url!)
        // let request = URLRequest(url: URL(string: "http://www.marvel.com")!)
        let request = URLRequest(url: url!)

        webView.loadRequest(request)
        //fetchAPIData(url: url)

        

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

 
    
    @IBAction func returnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

    @IBAction func goBackPressed(_ sender: Any) {
        if webView.canGoBack == true {
            webView.goBack()
        }

    }
    
    
    @IBAction func goForwardPressed(_ sender: Any) {
        if webView.canGoForward == true {
            webView.goForward()
        }
    }
    // MARK: - JSON


    

}
