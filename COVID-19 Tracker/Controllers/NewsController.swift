//
//  ViewController.swift
//  AlamofireTest
//
//  Created by SCG on 6/6/20.
//  Copyright © 2020 SCG. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class NewsController: UITableViewController {
    
    
    var articles: [Article] = []
    var items: [Displayable] = []
    var selectedItem: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.titleLabelText
        cell.detailTextLabel?.text = item.subtitleLabelText
        return cell
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destination = segue.destination as? WebViewController
                destination?.data = items[indexPath.row].website
            }
        }        
    }
}

// MARK: - Alamofire

extension NewsController {
    func fetchNews() {
        AF.request("http://newsapi.org/v2/everything?q=coronavirus&sortBy=latest&apiKey=dee142a160b4462b9258ac52eaf98161").validate().responseDecodable(of: Articles.self) { (response) in
            guard let articles = response.value else { return }
            self.articles = articles.all
            self.items = articles.all
            self.tableView.reloadData()
        }
    }
}

//MARK: - WebViewController

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var data: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: data)
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
}
