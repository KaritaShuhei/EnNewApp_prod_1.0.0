//
//  NewsViewController.swift
//  EnNewApp
//
//  Created by Shuhei Karita on 2022/06/26.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

    let PickerCompo1 = setPickerCompo1()
    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()
    let purchaseInfomation = PurchaseInfomation()
    
    @IBOutlet weak var newsWebView: WKWebView!

    override func viewDidLoad() {
        
        pageProperty.initilize2(view: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in

            pageProperty.removeinitilizedViewForActivityIndicator(view: view)
            return
        }
        
        super.viewDidLoad()
        // 7 URLオブジェクトを生成
        let myURL = URL(string:"https://en-new.com/fre-jave/%e3%83%8b%e3%83%a5%e3%83%bc%e3%82%b9/")
        // 8 URLRequestオブジェクトを生成
        let myRequest = URLRequest(url: myURL!)

        // 9 URLを WebView にロード
        newsWebView.load(myRequest)

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
