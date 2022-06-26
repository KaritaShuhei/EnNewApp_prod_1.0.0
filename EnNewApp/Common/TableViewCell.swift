//
//  TableView.swift
//  EnNewApp
//
//  Created by Shuhei Karita on 2022/05/23.
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

protocol DidSelectTableViewCellDelegate {
    func didSelectRow1()

}

class PostListTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var information: UILabel!
    @IBOutlet weak var summury: UILabel!
    @IBOutlet weak var targetLevel: UILabel!
    @IBOutlet weak var youtubeID: UILabel!
    @IBOutlet weak var date_yyyyMMddHHmm: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var playVideoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class MyAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var registerInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
