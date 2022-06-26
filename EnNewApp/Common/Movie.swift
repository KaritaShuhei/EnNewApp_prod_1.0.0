//
//  Movie.swift
//  EnNewApp
//
//  Created by Shuhei Karita on 2022/05/24.
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
import youtube_ios_player_helper
import YoutubePlayer_in_WKWebView


protocol MovieInfomationDelegate : AnyObject{
    
    func setDataMovieInformation()

}
protocol ImagePickerMethodDelegate: AnyObject{

    func settingToPhotoAccess()
    func movieImageSelected()
    func imagePickerDidFinishPickingMediaWithInfo()

}

class MovieInfomation:NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    let Ref = Database.database().reference()
    var handler: UInt = 0

    var title = String()
    var introduction = String()
    var summury = String()
    var targetLevel = String()
    var youtubeID = String()
    var date_yyyyMMddHHmm = String()
    var comment = String()
    var playerView = WKYTPlayerView()
    
    let imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var playUrl:NSURL?
    var data:Data?
    var videoAseet: PHAsset?
    var movieImageView = UIImageView()
    
    weak var movieInfomationDelegate:MovieInfomationDelegate!
    weak var imagePickerMethodDelegate:ImagePickerMethodDelegate!

//    動画情報一式を取得
    func getDataMovieInformation(selectedPostID: String){

        
        let ref0 = self.Ref.child("post").child("\(selectedPostID)")
        handler = ref0.observe(.value, with: { [self] (snapshot) in
            ref0.removeObserver(withHandle: handler)
            let value = snapshot.value as? NSDictionary
            self.title = value?["title"] as? String ?? ""
            self.introduction = value?["introduction"] as? String ?? ""
            self.summury = value?["summury"] as? String ?? ""
            self.targetLevel = value?["targetLevel"] as? String ?? ""
            self.youtubeID = value?["youtubeID"] as? String ?? ""
            self.date_yyyyMMddHHmm = value?["date_yyyyMMddHHmm"] as? String ?? ""
            self.comment = value?["comment"] as? String ?? ""
            
            let textImage:String = selectedPostID + ".png"
            let refImage = Storage.storage().reference().child("post").child("\(selectedPostID)").child("\(textImage)")
            refImage.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                } else {
                    self.movieImageView.sd_setImage(with: url, placeholderImage: nil)
                }
            }
            
        })
    }

    func cameraAuthorization(){
        
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    // フォトライブラリに写真を保存するなど、実施したいことをここに書く
                } else if status == .denied {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                        settingToPhotoAccess()
                        return
                    }
                    
                }
            }
        } else {
            
        }
    }
    func settingToPhotoAccess(){
        
        imagePickerMethodDelegate.settingToPhotoAccess()
                
    }

    func movieImageSelected() {
        
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    // フォトライブラリに写真を保存するなど、実施したいことをここに書く
                } else if status == .denied {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                        settingToPhotoAccess()
                        return
                    }
                    
                }
            }
        } else {
            imagePickerController.sourceType = .photoLibrary
            //imagePickerController.mediaTypes = ["public.image", "public.movie"]
            imagePickerController.delegate = self
            //動画だけ
            imagePickerController.mediaTypes = ["public.movie"]
            //画像だけ
            //imagePickerController.mediaTypes = ["public.image"]
            imagePickerController.videoQuality = .typeHigh
            imagePickerMethodDelegate?.movieImageSelected()
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //        videoAseet = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
        //        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        
        videoAseet = info[.phAsset] as? PHAsset
        print("videoAseet")
        print("info[.phAsset] as? PHAsset",info[.phAsset] as? PHAsset)

        let options=PHVideoRequestOptions()
        options.version = .original
        print("videoAseet:\(videoAseet)")
        if videoAseet != nil{
            PHImageManager.default().requestAVAsset(forVideo: videoAseet!,options:options){(asset:AVAsset?,audioMix,info:[AnyHashable:Any]?)->Void in
                if let urlAsset = asset as? AVURLAsset{
                    let localURL = urlAsset.url as URL
                    self.videoURL = localURL
                    print("videoURL")
                    print(localURL)
                }else{
                }
            }
        }

        self.movieImageView.image = self.previewImageFromVideo((info[UIImagePickerController.InfoKey.mediaURL] as? URL)!)!
        self.movieImageView.contentMode = .scaleAspectFit
        imagePickerController.dismiss(animated: true, completion: nil)
        imagePickerMethodDelegate?.imagePickerDidFinishPickingMediaWithInfo()
        
    }
    
    func previewImageFromVideo(_ url:URL) -> UIImage? {
        print("動画からサムネイルを生成する")
        let asset = AVAsset(url:url)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value,0)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            data = image.pngData()
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    
}
