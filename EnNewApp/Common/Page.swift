//
//  PageProperty.swift
//  EnNewApp
//
//  Created by Shuhei Karita on 2022/05/20.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFoundation
import AVKit
import Messages
import FirebaseMessaging
import UserNotifications
import StoreKit

protocol PagePropertyMoveToAnotherPageDelegate{
    
    func moveToAnotherPage()
    
}

protocol PagePropertyRefreshPageDelegate{
    
    func refreshPage()
    
}


//ロード時またはタイムアウト時のページ取得
public class PageProperty {
    
    var ActivityIndicator: UIActivityIndicatorView!
    var initilizedViewForActivityIndicator: UIView = UIView()
    var initilizedViewForShowObject: UIView = UIView()
    var messageView: UIView = UIView()
    var settingTextLabel = UILabel()
    var settingTextLabel2 = UILabel()
    var settingButton: UIButton = UIButton()
    var settingButton2: UIButton = UIButton()
    
    var pagePropertyMoveToAnotherPageDelegate:PagePropertyMoveToAnotherPageDelegate?
    var pagePropertyRefreshPageDelegate:PagePropertyRefreshPageDelegate?

    //    timeoutあり_透過
    func initilize1(view:UIView){
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        
        initilizedViewForActivityIndicator.frame = CGRect.init(x: 0, y: 0, width: viewWidth, height: viewHeight)
        initilizedViewForActivityIndicator.backgroundColor = .lightGray
        initilizedViewForActivityIndicator.alpha = 0.5
        
        removeAllSubviews(parentView: initilizedViewForActivityIndicator)
        
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = view.center
        ActivityIndicator.color = .white
        ActivityIndicator.backgroundColor = .black
        ActivityIndicator.startAnimating()
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        //Viewに追加
        initilizedViewForActivityIndicator.addSubview(ActivityIndicator)
        
        view.addSubview(initilizedViewForActivityIndicator)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
            if view.contains(initilizedViewForActivityIndicator){
                timeout(view: view)
            }
            return
        }
    }
    //    timeoutあり_白
    func initilize2(view:UIView){
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        
        initilizedViewForActivityIndicator.frame = CGRect.init(x: 0, y: 0, width: viewWidth, height: viewHeight)
        initilizedViewForActivityIndicator.backgroundColor = .white
        
        removeAllSubviews(parentView: initilizedViewForActivityIndicator)
        
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = view.center
        ActivityIndicator.color = .gray
        ActivityIndicator.startAnimating()
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        //Viewに追加
        initilizedViewForActivityIndicator.addSubview(ActivityIndicator)
        
        view.addSubview(initilizedViewForActivityIndicator)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
            if view.contains(initilizedViewForActivityIndicator){
                timeout(view: view)
            }
            return
        }
    }
    //    timeoutなし_透過
    func initilize3(view:UIView){
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        
        initilizedViewForActivityIndicator.frame = CGRect.init(x: 0, y: 0, width: viewWidth, height: viewHeight)
        initilizedViewForActivityIndicator.backgroundColor = .lightGray
        initilizedViewForActivityIndicator.alpha = 0.5
        
        removeAllSubviews(parentView: initilizedViewForActivityIndicator)
        
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = view.center
        ActivityIndicator.color = .white
        ActivityIndicator.backgroundColor = .black
        ActivityIndicator.startAnimating()
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        //Viewに追加
        initilizedViewForActivityIndicator.addSubview(ActivityIndicator)
        
        view.addSubview(initilizedViewForActivityIndicator)
        
    }
    //    timeoutなし_白
    func initilize4(view:UIView){
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        
        initilizedViewForActivityIndicator.frame = CGRect.init(x: 0, y: 50, width: viewWidth, height: viewHeight)
        initilizedViewForActivityIndicator.backgroundColor = .white
        
        removeAllSubviews(parentView: initilizedViewForActivityIndicator)
        
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = view.center
        ActivityIndicator.color = .gray
        ActivityIndicator.startAnimating()
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        //Viewに追加
        initilizedViewForActivityIndicator.addSubview(ActivityIndicator)
        
        view.addSubview(initilizedViewForActivityIndicator)
        
    }
    //    timeoutなし_課金誘導ページ
    func initilizeNotPurchased(view:UIView){
        
        let viewWidth = Int(UIScreen.main.bounds.width)
        let viewHeight = Int(UIScreen.main.bounds.height)
        let viewHeightWithoutTitle = 130

        initilizedViewForShowObject.frame = CGRect.init(x: 0, y: viewHeightWithoutTitle, width: viewWidth, height: viewHeight-viewHeightWithoutTitle)
        initilizedViewForShowObject.backgroundColor = .white
        
        removeAllSubviews(parentView: initilizedViewForShowObject)
        
        settingTextLabel.text = "プレミアム動画を視聴するためには\n入会が必要です"
        settingTextLabel.numberOfLines = 0
        settingTextLabel.frame = CGRect(x: 20, y: (viewHeight-viewHeightWithoutTitle)/2, width: viewWidth-40, height: 100)
        settingTextLabel.textColor = .black
        settingTextLabel.textAlignment = NSTextAlignment.center
        
        settingButton.setTitle("入会手続きへ", for: .normal)
        settingButton.frame = CGRect(x: 20, y: (viewHeight-viewHeightWithoutTitle)/2 + 100, width: viewWidth - 40, height: 50)
        settingButton.backgroundColor = .systemRed
        settingButton.cornerRadius = 2
        settingButton.setTitleColor(UIColor.white, for: .normal)
        settingButton.contentHorizontalAlignment = .center
        settingButton.addTarget(self, action: #selector(moveToAnotherPageButtonTapped(_:)), for: .touchUpInside)
        
        
        settingButton2.setTitle("既に入会済みの方", for: .normal)
        settingButton2.frame = CGRect(x: 20, y: (viewHeight-viewHeightWithoutTitle)/2 + 160, width: viewWidth - 40, height: 50)
        settingButton2.backgroundColor = .white
        settingButton2.borderColor = .systemRed
        settingButton2.borderWidth = 1
        settingButton2.cornerRadius = 2
        settingButton2.setTitleColor(UIColor.systemRed, for: .normal)
        settingButton2.contentHorizontalAlignment = .center
        settingButton2.addTarget(self, action: #selector(RefreshPageButtonTapped(_:)), for: .touchUpInside)
        
        
        initilizedViewForShowObject.addSubview(settingTextLabel)
        initilizedViewForShowObject.addSubview(settingButton)
        initilizedViewForShowObject.addSubview(settingButton2)
        
        view.addSubview(initilizedViewForShowObject)
        
    }
    func processing(view:UIView){
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        
        initilizedViewForActivityIndicator.frame = CGRect.init(x: 0, y: 0, width: viewWidth, height: viewHeight)
        initilizedViewForActivityIndicator.backgroundColor = .white
        
        removeAllSubviews(parentView: initilizedViewForActivityIndicator)
        
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = view.center
        ActivityIndicator.color = .gray
        ActivityIndicator.startAnimating()
        
        //        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        //
        //        //Viewに追加
        initilizedViewForActivityIndicator.addSubview(ActivityIndicator)
        
        settingTextLabel.text = "ただいま、動画を送信中です。\nしばらくこのままでお待ちください。\n1分ほどかかる場合があります。"
        settingTextLabel.numberOfLines = 0
        settingTextLabel.frame = CGRect(x: 20, y: viewHeight/2 + 50, width: viewWidth-40, height: 100)
        settingTextLabel.textColor = .black
        settingTextLabel.textAlignment = NSTextAlignment.center
        
        initilizedViewForActivityIndicator.addSubview(settingTextLabel)
        view.addSubview(initilizedViewForActivityIndicator)
    }
    func timeout(view:UIView){
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        
        removeAllSubviews(parentView: initilizedViewForActivityIndicator)
        
        settingTextLabel.text = "タイムアウトにより処理が完了できませんでした。\n通信環境をご確認ください。"
        settingTextLabel.numberOfLines = 0
        settingTextLabel.frame = CGRect(x: 20, y: viewHeight/2 + 50, width: viewWidth-40, height: 100)
        settingTextLabel.textColor = .black
        settingTextLabel.textAlignment = NSTextAlignment.center
        
        settingButton.setTitle("リトライ", for: .normal)
        settingButton.frame = CGRect(x: 20, y: viewHeight/2 + 150, width: viewWidth - 40, height: 50)
        settingButton.backgroundColor = .systemRed
        settingButton.cornerRadius = 2
        settingButton.setTitleColor(UIColor.white, for: .normal)
        settingButton.contentHorizontalAlignment = .center
        settingButton.addTarget(self, action: #selector(RefreshPageButtonTapped(_:)), for: .touchUpInside)
        
        initilizedViewForActivityIndicator.addSubview(settingTextLabel)
        initilizedViewForActivityIndicator.addSubview(settingButton)
        
        view.addSubview(initilizedViewForActivityIndicator)
    }
    
    func removeinitilizedViewForActivityIndicator(view:UIView){
        
        initilizedViewForActivityIndicator.removeFromSuperview()
        
    }
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        print("removeAllSubviews")
    }
    
    //    ボタンタップ後の処理一覧
    @objc func moveToAnotherPageButtonTapped(_ sender: UIButton) {
        
        pagePropertyMoveToAnotherPageDelegate?.moveToAnotherPage()
        
    }
    @objc func RefreshPageButtonTapped(_ sender: UIButton) {
        
        pagePropertyRefreshPageDelegate?.refreshPage()
        
    }
    
}
