//
//  applyFormViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/17.
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
import StoreKit
import YoutubePlayer_in_WKWebView

class PostFormViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate ,DidSelectRowDelegate,ImagePickerMethodDelegate,PagePropertyRefreshPageDelegate{
    
    let PickerCompo1 = setPickerCompo1()
    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()
    let purchaseInfomation = PurchaseInfomation()
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var playVideoButton: UIButton!

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var introdutionTextView: UITextView!
    @IBOutlet weak var summuryTextView: UITextView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var youtubeIDTextField: UITextField!
    @IBOutlet weak var youtubePlayerView: WKYTPlayerView!
    @IBOutlet weak var targetLevelTextField: UITextField!

        
    var date_yyyyMMddHHmmSS = String()
    var date_yyyyMMddHHmm = String()
    var date_yyyy = String()
    var date_mm = String()
    var date_dd = String()
    
    var pickerview0: UIPickerView?
    var targetArray = [String]()
    
    var uploadTaskStatus0 = 0
    var uploadTaskStatus1 = 0
    
    let Ref = Database.database().reference()
    
    override func viewDidLoad() {
        
//        movieInfomation.cameraAuthorization()
        pickerViewData()
        PickerCompo1.delegate = self
        movieInfomation.imagePickerMethodDelegate = self
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func pickerViewData(){
        //        対象レベルのPickerView設定
        targetArray = ["初級編","中級編","上級編"]
        PickerCompo1.selectedArray0 = targetArray
        pickerview0 = UIPickerView()
        pickerview0?.delegate = PickerCompo1
        pickerview0?.dataSource = PickerCompo1
        pickerview0?.tag = 0
        pickerview0?.selectRow(0, inComponent: 0, animated: false)
        targetLevelTextField.inputView = pickerview0
        
    }
    func didSelectRow0() {
    }
    func didSelectRow1() {
        targetLevelTextField.text = "\(PickerCompo1.row0 ?? "")"
    }
    
    func settingToPhotoAccess() {
        
        let alert = UIAlertController(title: "", message: "写真へのアクセスを許可してください", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "設定", style: .default, handler: { (_) -> Void in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else {
                return
            }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        })
        alert.addAction(settingsAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func movieImageSelected() {
        present(movieInfomation.imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func selectedImage(_ sender: Any) {
        
        movieInfomation.movieImageSelected()
        
    }
    func imagePickerDidFinishPickingMediaWithInfo() {
        
        //        let picture = UIImage(named: "play.rectangle.fill")
        //        movieImageViewButton.setImage(picture, for: .normal)
        //        movieInfomation.movieImageView = movieImageView
        movieImageView.image = movieInfomation.movieImageView.image
        
    }
    
    @IBAction func playMovie(_ sender: Any) {
        print("動画再生ボタンが押されました")
        if let videoURL = movieInfomation.videoURL{
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true){
                print("動画再生")
                playerViewController.player!.play()
            }
        }
    }
    
    @IBAction func youtubePlayerViewRefreshButtonTapped(_ sender: Any) {
        
        youtubePlayerView.load(withVideoId: "\(youtubeIDTextField.text ?? "")",playerVars: ["playsinline":1])
        
    }
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        if youtubeIDTextField.text == "" || titleTextView.text == "" || introdutionTextView.text == ""  || commentTextView.text == ""  || summuryTextView.text == "" || targetLevelTextField.text == ""{
            let alert: UIAlertController = UIAlertController(title: "確認", message: "空欄の項目があります。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }else{
            
            let alert: UIAlertController = UIAlertController(title: "確認", message: "この内容で公開しますがよろしいですか？", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ [self]
                (action: UIAlertAction!) -> Void in
                pageProperty.initilize3(view: view)
                self.sendData()
            })
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
    func sendData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 90) { [self] in
            pageProperty.timeout(view: view)
            return
        }
        let timeProperty = TimeProperty()
        let date_yyyyMMddHHmmSS = timeProperty.getData1()
        let date_yyyyMMddHHmm = timeProperty.getData2()
        let date_yyyy = timeProperty.getData3()
        let date_mm = timeProperty.getData4()
        let date_dd = timeProperty.getData5()
        
        let postID = "post_"+"\(date_yyyyMMddHHmmSS)"
        
        let ref0 = self.Ref.child("post").child("\(postID)")
        let data0 = ["youtubeID":"\(self.youtubeIDTextField.text ?? "")","postID":"\(postID)","title":"\(self.titleTextView.text ?? "")","introduction":"\(self.introdutionTextView.text ?? "")","summury":"\(self.summuryTextView.text ?? "")","comment":"\(self.commentTextView.text ?? "")","targetLevel":"\(self.targetLevelTextField.text ?? "")","created_at":"\(date_yyyyMMddHHmmSS)","date_yyyyMMddHHmm":"\(date_yyyyMMddHHmm)","date_yyyyMMdd":"\(date_yyyy)"+"\(date_mm)"+"\(date_dd)","date_yyyyMM":"\(date_yyyy)"+"年"+"\(date_mm)"+"月" as Any] as [String : Any]
        ref0.setValue(data0) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                    self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)
                    self.dismiss(animated: true, completion: nil)
                    return
                }

            }
        }
        
//        if self.movieInfomation.videoURL != nil{
//            let storageReference = Storage.storage().reference().child("post").child("\(postID)").child("\(postID).mp4")
//            let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
//            /// create a temporary file for us to copy the video to.
//            let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(self.self.movieInfomation.videoURL!.lastPathComponent )
//
//            /// Attempt the copy.
//            do {
//                try FileManager().copyItem(at: self.movieInfomation.videoURL!.absoluteURL, to: temporaryFileURL)
//            } catch {
//                print("There was an error copying the video file to the temporary location.")
//            }
//            print("temporaryFileURL:\(temporaryFileURL)")
//            //            let metadata = StorageMetadata()
//            //            metadata.contentType = "image/jpeg"
//
//            let uploadTask0 = storageReference.putFile(from: temporaryFileURL, metadata: nil) { metadata, error in
//                guard let metadata = metadata else {
//                    // Uh-oh, an error occurred!
//                    let alert: UIAlertController = UIAlertController(title: "確認", message: "動画を送信できませんでした。容量を確認してください。", preferredStyle:  UIAlertController.Style.alert)
//                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                        (action: UIAlertAction!) -> Void in
//                    })
//                    alert.addAction(defaultAction)
//                    self.present(alert, animated: true, completion: nil)
//
//                    print("error")
//                    self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)
//                    return
//
//                }
//                // Metadata contains file metadata such as size, content-type.
//                _ = metadata.size
//                // You can also access to download URL after upload.
//                storageReference.downloadURL { [self] (url, error) in
//                    let cloudVideoURL = url?.absoluteString
//                    let videoData = ["cloudVideoURL":"\(cloudVideoURL ?? "")" as Any] as [String : Any]
//                    let ref0 = self.firebaseMethod.Ref.child("post").child("\(postID)")
//                    ref0.updateChildValues(videoData)
//                    guard url != nil else {
//                        // Uh-oh, an error occurred!
//                        return
//                    }
//
//                }
//
//            }
//            let storageReferenceImage = Storage.storage().reference().child("post").child("\(postID)").child("\(postID).png")
//
//            let uploadTask1 = storageReferenceImage.putData(self.movieInfomation.data!, metadata: nil) { metadata, error in
//                guard let metadata = metadata else {
//                    // Uh-oh, an error occurred!
//                    print("error")
//                    return
//                }
//
//                //ここから動画DB格納定義
//                let ref0 = self.Ref.child("post").child("\(postID)")
//                let data0 = ["postID":"\(postID)","title":"\(self.titleTextView.text ?? "")","introduction":"\(self.introdutionTextView.text ?? "")","summury":"\(self.summuryTextView.text ?? "")","comment":"\(self.commentTextView.text ?? "")","targetLevel":"\(self.targetLevelTextField.text ?? "")","created_at":"\(date_yyyyMMddHHmmSS)","date_yyyyMMddHHmm":"\(date_yyyyMMddHHmm)","date_yyyyMMdd":"\(date_yyyy)"+"\(date_mm)"+"\(date_dd)","date_yyyyMM":"\(date_yyyy)"+"年"+"\(date_mm)"+"月" as Any] as [String : Any]
//                ref0.setValue(data0) {
//                    (error:Error?, ref:DatabaseReference) in
//                    if let error = error {
//                        print("Data could not be saved: \(error).")
//                    } else {
//                        print("Data saved successfully!")
//                    }
//                }
//
//            }
//
//            uploadTask0.observe(.progress) { snapshot in
//                // Upload reported progress
//                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//                / Double(snapshot.progress!.totalUnitCount)
//                print("uploadTask0:\(percentComplete)")
//            }
//            uploadTask1.observe(.progress) { snapshot in
//                // Upload reported progress
//                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//                / Double(snapshot.progress!.totalUnitCount)
//                print("uploadTask1:\(percentComplete)")
//            }
//            uploadTask0.observe(.success) { snapshot in
//                // Upload completed successfully
//                self.uploadTaskStatus0 = 1
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    if self.uploadTaskStatus1 == 1{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
//                            self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)
//                            self.dismiss(animated: true, completion: nil)
//                            return
//                        }
//                    }else{
//                        return
//                    }
//                }
//            }
//            uploadTask1.observe(.success) { snapshot in
//                // Upload completed successfully
//                self.uploadTaskStatus1 = 1
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    if self.uploadTaskStatus0 == 1{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
//                            self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)
//                            self.dismiss(animated: true, completion: nil)
//                            return
//                        }
//                    }else{
//                        return
//                    }
//                }
//            }
//
//        }
        
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func refreshPage() {

        self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)

    }
    
}
