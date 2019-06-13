//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Francis Ngunjiri on 13/06/2019.
//  Copyright © 2019 Francis Ngunjiri. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTimestamp: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var newsArticle: ArticleData.Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeholderImage = UIImage(named: "ic_placeholder")!
        
        let filterStory = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: imgNews!.frame.size,
            radius: 12.0
        )
        
        imgNews!.af_setImage(
            withURL: URL(string : newsArticle?.urlToImage ?? "https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image-300x225.png")!,
            placeholderImage: placeholderImage,
            filter: filterStory,
            imageTransition: .crossDissolve(0.2)
        )
        
        lblAuthor.text = newsArticle?.author
        lblTimestamp.text = newsArticle?.publishedAt
        lblTitle.text = newsArticle?.title
        lblSource.text = newsArticle?.source.name
        lblDescription.text = newsArticle?.articleDescription
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
