//
//  File.swift
//  EnNewApp
//
//  Created by Shuhei Karita on 2022/05/24.
//

import Foundation
import Firebase
import FirebaseAuth
import AVFoundation
import AVKit
import Messages
import FirebaseMessaging
import UserNotifications
import StoreKit
import YoutubePlayer_in_WKWebView

protocol YoutubePlayDelegate : AnyObject{
    func setYoutubePlay(selectedYoutubeID:String)
}

class YoutubePlay:NSObject,YoutubePlayDelegate,WKYTPlayerViewDelegate{

    var playerView: WKYTPlayerView = WKYTPlayerView()
    var youtubeID = [String]()

    
    func setYoutubePlay(selectedYoutubeID: String) {
        print(selectedYoutubeID)

        playerView.load(withVideoId: "\(selectedYoutubeID)",playerVars: ["playsinline":1])
//全画面ではなくViewの範囲内で再生。//最初の動画の後に自動再生されるプレイリスト。
    }

    
}
