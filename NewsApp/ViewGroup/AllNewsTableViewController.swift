//
//  TableViewController.swift
//  NewsApp
//
//  Created by Francis Ngunjiri on 13/06/2019.
//  Copyright © 2019 Francis Ngunjiri. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AllNewsTableViewController: UITableViewController,UISearchBarDelegate {
    var articleList = [ArticleData.Article]()
    var newsSelected: ArticleData.Article?
    var source: ArticleSourceData.Source?
    let searchController = UISearchController(searchResultsController: nil)
    var myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = myRefreshControl
        } else {
            tableView.addSubview(myRefreshControl)
        }
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self as? UISearchBarDelegate
        searchController.dimsBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.lightGray
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var url:String
        if(source == nil){
            url = "https://newsapi.org/v2/everything?domains=wsj.com,nytimes.com&apiKey=4fbaeaa420d946e4b05e270c484a94c2"
        }else{
            url = "https://newsapi.org/v2/everything?sources=" + (source?.id)! + "&apiKey=4fbaeaa420d946e4b05e270c484a94c2"
        }
        
        getStories(url: url)
        
        myRefreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing Feed")
        myRefreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        
        func searchBarSearchButtonClicked(searchBar: UISearchBar) {
            // Start the search
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        // Perform actions to refresh the content
        // ...
        // and then dismiss the control
        var url:String
        if(source == nil){
            url = "https://newsapi.org/v2/everything?domains=wsj.com,nytimes.com&apiKey=4fbaeaa420d946e4b05e270c484a94c2"
        }else{
            url = "https://newsapi.org/v2/everything?sources=" + (source?.id)! + "&apiKey=4fbaeaa420d946e4b05e270c484a94c2"
        }
        
        getStories(url: url)
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNews", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        let placeholderImage = UIImage(named: "ic_placeholder")!
        
        let filterStory = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cell.imgStory!.frame.size,
            radius: 12.0
        )
        
        cell.imgStory!.af_setImage(
            withURL: URL(string : articleList[indexPath.row].urlToImage ?? "https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image-300x225.png")!,
            placeholderImage: placeholderImage,
            filter: filterStory,
            imageTransition: .crossDissolve(0.2)
        )
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: articleList[indexPath.row].publishedAt) {
            cell.lblTimeStamp.text = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        
        cell.lblSource.text = articleList[indexPath.row].source.name
        //cell.lblTimeStamp.text = articleList[indexPath.row].publishedAt
        cell.lblTitle.text = articleList[indexPath.row].title
        cell.lblContent.text = articleList[indexPath.row].content
        
        return cell
    }
    
    @objc func getStories(url: String
        //, parameters:[String:String]
        ) {
        Alamofire.request(url
            //,method: .get, parameters: parameters
            ).responseJSON {response in
                switch response.result {
                case .success:
                    //let priceJson:JSON = JSON(response.result.value!)
                    do{
                        let jsonDecoder = JSONDecoder()
                        let faqItems = try! jsonDecoder.decode(ArticleData.NewsResponse.self, from: response.data!)
                        print(faqItems)
                        
                        self.articleList.removeAll()
                        
                        for (news) in faqItems.articles!{
                            self.articleList.append(news)
                        }
                        self.tableView.reloadData()
                        self.myRefreshControl.endRefreshing()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsSelected = self.articleList[indexPath.row]
        performSegue(withIdentifier: "Show News", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "Show News") {
            
            let showNewsDetailViewController: NewsDetailViewController = segue.destination as! NewsDetailViewController
            
            showNewsDetailViewController.newsArticle = newsSelected
        }
    }
    
    
    private func filterArtcles(for searchText: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getStories(url : "https://newsapi.org/v2/everything?q=" + searchText + "&apiKey=4fbaeaa420d946e4b05e270c484a94c2")
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}


extension AllNewsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //self.filterArtcles(for: searchController.searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.filterArtcles(for: searchController.searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        var url:String
        if(source == nil){
            url = "https://newsapi.org/v2/everything?domains=wsj.com,nytimes.com&apiKey=4fbaeaa420d946e4b05e270c484a94c2"
        }else{
            url = "https://newsapi.org/v2/everything?sources=" + (source?.id)! + "&apiKey=4fbaeaa420d946e4b05e270c484a94c2"
        }
        
        getStories(url: url)
    }
    //    func updateSearchResults(for searchController: UISearchController) {
    //        //Add 10 second delay for typing
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
    //            self.filterArtcles(for: searchController.searchBar.text ?? "")
    //        })
    //    }
}
