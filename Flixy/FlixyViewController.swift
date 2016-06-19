//
//  FlixyViewController.swift
//  Flixy
//
//  Created by Savannah McCoy on 6/15/16.
//  Copyright © 2016 Savannah McCoy. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class FlixyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]!
    var endpoint: String!
    
        func refreshControlAction(refreshControl: UIRefreshControl) {
       
        
                let apiKey = "9cfb216e8add071efeb194bb175b819e"
                let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
                let request = NSURLRequest(
                    URL: url!,
                    cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                    timeoutInterval: 10)
        
                // Configure session so that completion handler is executed on main UI thread
                let session = NSURLSession(
                    configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                    delegate:nil,
                    delegateQueue:NSOperationQueue.mainQueue()
                            )
        
                let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                                                                        
                
                            self.tableView.reloadData()
                            refreshControl.endRefreshing()
                });
        
            task.resume()
                                                                    }


    
    
        override func viewDidLoad() {
            
            
                super.viewDidLoad()

                    tableView.dataSource = self
                    tableView.delegate = self
                    searchBar.delegate = self
                    filteredData = movies
        
        
                // Initialize a UIRefreshControl
                let refreshControl = UIRefreshControl()
                refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    tableView.insertSubview(refreshControl, atIndex: 0)
        
        
                let apiKey = "9cfb216e8add071efeb194bb175b819e"
                let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
                let request = NSURLRequest(
                    URL: url!,
                    cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                    timeoutInterval: 10)
        
                let session = NSURLSession(
                    configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                    delegate: nil,
                    delegateQueue: NSOperationQueue.mainQueue()
                            )
        
        
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
                let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
        
            MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    
                    
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredData = self.movies
                            self.tableView.reloadData()
                            // Tell the refreshControl to stop spinning
                            refreshControl.endRefreshing()
                
                    }
                    }
            
        });
        task.resume()
        
        
                                    }

    
    
    
        override func didReceiveMemoryWarning() {
            
            super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
                                            }
    
    
    
    
    
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
                if filteredData != nil {
                    return filteredData.count
                } else {
            return 0
                        }

    
    }
    
    
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
                let cell = tableView.dequeueReusableCellWithIdentifier("FlixyCell", forIndexPath: indexPath) as! FlixyCell
                let movie = filteredData![indexPath.row]
                let title = movie["title"] as! String
                let overview = movie ["overview"] as! String
                let baseUrl = "http://image.tmdb.org/t/p/w500"
                let posterPath = movie["poster_path"] as! String
                let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
                    cell.TitleLabel.text = title
                    cell.OverviewLabel.text = overview
                    cell.PosterView.setImageWithURL(imageUrl!)
        
            print ("row\(indexPath.row)")
                            return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = movies!.filter({(dataItem: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let title = dataItem["title"] as! String
                if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
   }


