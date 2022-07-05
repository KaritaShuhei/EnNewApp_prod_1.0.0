//
//  applyListViewController.swift
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

class PostListViewController: UIViewController,PagePropertyMoveToAnotherPageDelegate,PagePropertyRefreshPageDelegate,PurchaseInfomationPuchaseStatusReloadedDelegate{
        
    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()
    let purchaseInfomation = PurchaseInfomation()

    @IBOutlet var TableView: UITableView!
    @IBOutlet weak var adminStatus: UILabel!
    @IBOutlet weak var authStatus: UIButton!
    @IBOutlet weak var coachingPlan: UILabel!
    @IBOutlet weak var personalLessonGuideButton: UIButton!
    @IBOutlet weak var buttonToPostForm: UIButton!
    
    var array = [Any]()
    var twoDimArray:[[Any]] = []
    var twoDimArray_re:[[Any]] = []
    var dicArray = [String:NSDictionary]()
    
    var selectedPostID: String?

    let Ref = Database.database().reference()

    
    override func viewDidLoad() {
                
        purchaseInfomation.purchaseInfomationPuchaseStatusReloadedDelegate = self
        pageProperty.pagePropertyMoveToAnotherPageDelegate = self
        pageProperty.pagePropertyRefreshPageDelegate = self
        
        buttonToPostForm.isHidden = true

        switch userInfomation.currentEmail {
        case "s.nakashima@en-new.com":

            tableViewData()
            buttonToPostForm.isHidden = false

        case "frejave@en-new.com":
            
            tableViewData()

        default:

            fetchPurchaseStatus()
            tableViewData()
            break
        }

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        

    }
    func fetchPurchaseStatus(){
        
        pageProperty.initilize2(view: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in

            purchaseInfomation.fetchPurchaseStatus()

        }

    }
    
    func puchaseStatusReloaded() {
                
        print("purchaseStatus")
        print(purchaseInfomation.purchaseStatus)
        switch purchaseInfomation.purchaseStatus {
        case "0":

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in

                pageProperty.removeinitilizedViewForActivityIndicator(view: view)
                pageProperty.initilizeNotPurchased(view: view)

                return
            }

        case "1":
            
            tableViewData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                pageProperty.removeinitilizedViewForActivityIndicator(view: view)
                return
            }

        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in

                pageProperty.removeinitilizedViewForActivityIndicator(view: view)
                pageProperty.timeout(view: view)

                return
            }
            break
        }

    }

    func tableViewData(){
        
        TableView?.delegate = self
        TableView?.dataSource = self

        dicArray.removeAll()
        twoDimArray.removeAll()
        twoDimArray_re.removeAll()
        
        let ref = Ref.child("post")
        ref.observeSingleEvent(of: .value, with: { [self]
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    array.removeAll()
                    let snap = snapdata[key]
                                        
                    let data0 = snap!["postID"] ?? ""
                    let data1 = snap!["date_yyyyMMddHHmm"] ?? ""
                    
                    array = [data0 as Any,data1 as Any]
                    arrayDataSet(data0: data0 as! String, key: key, snapdata: snapdata)

                    TableView.reloadData()
                }
            }else{

            }
        })
        
    }
    func arrayDataSet(data0:String,key:String,snapdata:[String:NSDictionary]){
        
        twoDimArray.append(array)
        self.dicArray.updateValue(snapdata[key]! as NSDictionary, forKey: data0)
        twoDimArray_re = twoDimArray.sorted{$0[0] as! String > $1[0] as! String}
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSelectedPostListView") {
            if #available(iOS 13.0, *) {
                let nextData: SelectedPostListViewController = segue.destination as! SelectedPostListViewController
                nextData.selectedPostID = self.selectedPostID ?? ""
            } else {
                // Fallback on earlier versions
            }
        }
    }
     
    @IBAction func personalLessonGuideButtonTapped(_ sender: AnyObject) {

        print("customButtonTapped!")
        
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        
        tableViewData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            pageProperty.removeinitilizedViewForActivityIndicator(view: view)
            return
        }

    }
    func moveToAnotherPage() {
        
        performSegue(withIdentifier: "toPurchasePlan1View", sender: nil)

    }

    func refreshPage() {

        fetchPurchaseStatus()

    }
    
    
    
    
}
extension PostListViewController:UITableViewDelegate,UITableViewDataSource {
 
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimArray.count
    }
    
    
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "postListCell", for: indexPath as IndexPath) as? PostListTableViewCell
        
        cell!.title.text = dicArray[(twoDimArray_re[indexPath.row][0] as? String)!]?["title"] as? String
        cell!.information.text = dicArray[(twoDimArray_re[indexPath.row][0] as? String)!]?["introduction"] as? String
        cell!.targetLevel.text = dicArray[(twoDimArray_re[indexPath.row][0] as? String)!]?["targetLevel"] as? String
        cell!.date_yyyyMMddHHmm.text = dicArray[(twoDimArray_re[indexPath.row][0] as? String)!]?["date_yyyyMMddHHmm"] as? String
        
        let selectedYouTubeID = dicArray[(twoDimArray_re[indexPath.row][0] as? String)!]?["youtubeID"] as? String
        cell!.playerView.load(withVideoId: "\(selectedYouTubeID ?? "")",playerVars: ["playsinline":1])

//        let postID_textImage = (dicArray[(twoDimArray_re[indexPath.row][0] as? String)!]?["postID"] as! String)
//        let textImage = postID_textImage + ".png"
//        let refImage = Storage.storage().reference().child("post").child("\(postID_textImage)").child("\(textImage)")
//        refImage.downloadURL { url, error in
//            if error != nil {
//                print("movieImageViewダウンロードできませんでした")
//                // Handle any errors
//            } else {
//                cell!.movieImageView.sd_setImage(with: url, placeholderImage: nil)
//                print("movieImageViewダウンロードできました")
//            }
//        }
//        cell!.playVideoButton.addTarget(self, action: #selector(playVideo(_:)), for: .touchUpInside)
//        cell!.playVideoButton.tag = indexPath.row
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPostID = dicArray[(twoDimArray_re[indexPath.row][0] as? String)!]?["postID"] as? String
        performSegue(withIdentifier: "toSelectedPostListView", sender: nil)

    }
    
    @objc func playVideo(_ sender: UIButton) {
        
        let postID_textVideo = (dicArray[(twoDimArray_re[sender.tag][0] as? String)!]?["postID"] as! String)
        let textVideo = postID_textVideo + ".mp4"
        let refVideo = Storage.storage().reference().child("post").child("\(postID_textVideo)").child("\(textVideo)")
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
}
