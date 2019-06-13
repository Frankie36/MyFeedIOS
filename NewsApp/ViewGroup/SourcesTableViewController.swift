//
//  SourcesTableViewController.swift
//  NewsApp
//
//  Created by Francis Ngunjiri on 13/06/2019.
//  Copyright © 2019 Francis Ngunjiri. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SourcesTableViewController: UITableViewController {
    var sourcesList = [ArticleSourceData.Source]()
    var sourceSelected : ArticleSourceData.Source?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getSources(url: "https://newsapi.org/v2/sources?language=en&country=us&apiKey=4fbaeaa420d946e4b05e270c484a94c2")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sourcesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSource", for: indexPath) as! SourceTableViewCell
        
        // Configure the cell...
        cell.lblTitle.text = sourcesList[indexPath.row].name
        cell.lblDescription.text = sourcesList[indexPath.row].sourceDescription
        
        return cell
    }
    
    func getSources(url: String
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
                        let newsSourceItems = try! jsonDecoder.decode(ArticleSourceData.NewsSourceModel.self, from: response.data!)
                        print(newsSourceItems)
                        
                        for (source) in newsSourceItems.sources{
                            self.sourcesList.append(source)
                        }
                        
                        self.tableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sourceSelected = self.sourcesList[indexPath.row]
        performSegue(withIdentifier: "Show Source News ", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "Show Source News ") {
            
            let showAllNewsViewController: AllNewsTableViewController = segue.destination as! AllNewsTableViewController
            
            showAllNewsViewController.source = sourceSelected
        }
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
