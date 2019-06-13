//
//  FirstViewController.swift
//  NewsApp
//
//  Created by Francis Ngunjiri on 12/06/2019.
//  Copyright © 2019 Francis Ngunjiri. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage


class HeadlinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tbNews: UITableView!
    var articleList = [ArticleData.Article]()
    var newsSelected: ArticleData.Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        tbNews.delegate=self
        tbNews.dataSource=self
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getStories(url: "https://newsapi.org/v2/top-headlines?country=us&apiKey=4fbaeaa420d946e4b05e270c484a94c2")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNews", for: indexPath) as! NewsTableViewCell
        
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
        
        cell.lblSource.text = articleList[indexPath.row].source.name
        cell.lblTimeStamp.text = articleList[indexPath.row].publishedAt
        cell.lblTitle.text = articleList[indexPath.row].title
        cell.lblContent.text = articleList[indexPath.row].content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func getStories(url: String
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
                    
                    for (news) in faqItems.articles!{
                        self.articleList.append(news)
                    }
                    
                    self.tbNews.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false

                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //    func updateListItems(json : JSON){
    //
    ////        for (title, description, url) in json["articles"].array{
    ////            let news = News(image: url, title: title, content: description)
    ////            newsList += news
    ////        }
    ////
    //        do{
    //            let jsonDecoder = JSONDecoder()
    //            let faqItems = try! jsonDecoder.decode(NewsResponse.self, from: response.data!)
    //            print(faqItems)
    //            self.faqItems = faqItems
    //            self.cntrl?.tbFaqs.reloadData()
    //            //                    print(lsShops)
    //        }
    //    }
    

}

