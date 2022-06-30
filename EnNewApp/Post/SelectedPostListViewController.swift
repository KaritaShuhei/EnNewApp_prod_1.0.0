//
//  selectedApplyListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/04.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import FirebaseMessaging
import Photos
import MobileCoreServices
import AssetsLibrary
import SDWebImage
import PopupDialog
import Charts
import youtube_ios_player_helper
import YoutubePlayer_in_WKWebView

class SelectedPostListViewController: UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    
    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()
    
    weak var firebaseMethodDelegate : FirebaseMethodDelegate!
    weak var movieInfomationDelegate : MovieInfomationDelegate!
    weak var youtubePlayDelegate : YoutubePlayDelegate!
    
    var selectedPostID: String?
    var selectedYoutubeID: String?
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var targetLevelLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var summuryLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var date_yyyyMMddHHmmLabel: UILabel!
    @IBOutlet weak var reviewStarButton: UIButton!
    @IBOutlet weak var youtubePlayerView: WKYTPlayerView!
    @IBOutlet weak var buttonToPostEdit: UIButton!
    
    override func viewDidLoad() {
        
        pageProperty.initilize2(view: view)
        
        switch userInfomation.currentUid {
        case "admin1@gmail.com":

            buttonToPostEdit.isHidden = false

        case "admin2@gmail.com":
            
            buttonToPostEdit.isHidden = false

        default:

            buttonToPostEdit.isHidden = true
            break
        }
        
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        loadMovieData()
        
    }
    //    選択された動画の詳細情報を取得
    func loadMovieData(){
        
        movieInfomation.getDataMovieInformation(selectedPostID: selectedPostID!)
//        movieInfomation.movieImageView = movieImageView

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            //        取得した動画情報を各コンポーネントにセット
            targetLevelLabel.text = movieInfomation.targetLevel
            titleLabel.text = movieInfomation.title
            introductionLabel.text = movieInfomation.introduction
            summuryLabel.text = movieInfomation.summury
            commentLabel.text = movieInfomation.comment
            date_yyyyMMddHHmmLabel.text = movieInfomation.date_yyyyMMddHHmm
            selectedYoutubeID = movieInfomation.youtubeID
            youtubePlayerView.load(withVideoId: "\(selectedYoutubeID ?? "")",playerVars: ["playsinline":1])

//            playVideoButton.addTarget(self, action: #selector(playVideo(_:)), for: .touchUpInside)


            return
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toSelectedPostEditListView"){
            let nextData: SelectedPostListEditViewController = segue.destination as! SelectedPostListEditViewController
            nextData.selectedPostID = self.selectedPostID!

//            if adminStatus == "1"{
//                if #available(iOS 13.0, *) {
//                    let nextData: SelectedPostListEditViewController = segue.destination as! SelectedPostListEditViewController
//                    nextData.selectedPostID = self.selectedPostID!
//                } else {
//                    // Fallback on earlier versions
//                }
//            }else{
//                let alert: UIAlertController = UIAlertController(title: "確認", message: "申込内容を編集できません", preferredStyle:  UIAlertController.Style.alert)
//
//                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                    (action: UIAlertAction!) -> Void in
//                })
//                alert.addAction(defaultAction)
//                present(alert, animated: true, completion: nil)
//            }
        }else{
            
        }
    }
    
    @objc func playVideo(_ sender: UIButton) {
        
        let textVideo = selectedPostID! + ".mp4"
        let refVideo = Storage.storage().reference().child("post").child("\(selectedPostID!)").child("\(textVideo)")
        print(refVideo)
        refVideo.downloadURL{ url, error in
            if (error != nil) {
                print("動画をダウンロードできませんでした")
            } else {
                print("download success!! URL:", url!)

                let player = AVPlayer(url: url! as URL
                )
                
                let controller = AVPlayerViewController()
                controller.player = player
                
                self.present(controller, animated: true) {
                    controller.player!.play()
                }

            }
        }
        
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectedPostEditButtonTapped(_ sender: Any) {

        self.performSegue(withIdentifier: "toSelectedPostEditListView", sender: nil)
        
    }

    func showCustomDialog(animated: Bool = true) {
        
        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "キャンセル", height: 60) {
            print("-")
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "送信する", height: 60) {
            //            self.starLabel.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
            let selectedRef = self.firebaseMethod.Ref.child("post").child("\(self.selectedPostID!)").child("review").child("\(self.userInfomation.currentUid)")
            let data = ["review_star":"\(ratingVC.cosmosStarRating.rating)" as Any] as [String : Any]
            self.firebaseMethodDelegate?.uploadValue(selectedRef: selectedRef, data: data)
            self.reviewStarButton.isHidden = true
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    
    @IBAction func reviewStarButtonTapped(_ sender: Any) {

        showCustomDialog()

//        if adminStatus == "1"{
//            let alert: UIAlertController = UIAlertController(title: "確認", message: "ユーザーによる評価が届くまでお待ちください。", preferredStyle:  UIAlertController.Style.alert)
//            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                (action: UIAlertAction!) -> Void in
//
//            })
//            alert.addAction(defaultAction)
//            present(alert, animated: true, completion: nil)
//        }else{
//            showCustomDialog()
//        }
    }
    
    // 表示スタイルの設定
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // .noneを設定することで、設定したサイズでポップアップされる
        return .none
    }
}
