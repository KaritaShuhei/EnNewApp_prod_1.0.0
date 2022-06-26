//
//  ViewController.swift
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

//現在時刻を取得
public class TimeProperty {
    
    var now = NSDate()
    var formatter = DateFormatter()
    var date_yyyyMMddHHmmSS = String()
    var date_yyyyMMddHHmm = String()
    var date_yyyy = String()
    var date_mm = String()
    var date_dd = String()

    func getData1()-> String{
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        date_yyyyMMddHHmmSS = formatter.string(from: now as Date)
        return date_yyyyMMddHHmmSS
    }
    func getData2()-> String{
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        date_yyyyMMddHHmm = formatter.string(from: Date())
        return date_yyyyMMddHHmm
    }
    func getData3()-> String{
        formatter.dateFormat = "yyyy"
        date_yyyy = formatter.string(from: now as Date)
        return date_yyyy
    }
    func getData4()-> String{
        formatter.dateFormat = "MM"
        date_mm = formatter.string(from: now as Date)
        return date_mm
    }
    func getData5()-> String{
        formatter.dateFormat = "dd"
        date_dd = formatter.string(from: now as Date)
        return date_dd
    }

}
//Date関連情報を取得
public class DateProperty {
    var yyyyArray = [String]()
    var mmArray = [String]()
    var ddArray = [String]()

    func getData1() -> Array<String> {
        for i in 1950..<2022{
            yyyyArray.append(String(i))
        }
        return yyyyArray
    }
    func getData2() -> Array<String> {
        for i in 1..<12{
            mmArray.append(String(i))
        }
        return mmArray
    }
    func getData3() -> Array<String> {
        for i in 1..<31{
            ddArray.append(String(i))
        }
        return ddArray
    }
}
//Area関連情報を取得
public class AreaProperty {
    var area1Array = [String]()

    func getData1() -> Array<String> {
        area1Array = ["選択してください","北海道","青森","岩手","宮城","秋田","山形","福島","茨城","栃木","群馬","埼玉","千葉","東京","神奈川","新潟","富山","石川","福井","山梨","長野","岐阜","静岡","愛知","三重","滋賀","京都","大阪","兵庫","奈良","和歌山","鳥取","島根","岡山","広島","山口","徳島","香川","愛媛","高知","福岡","佐賀","長崎","熊本","大分","宮崎","鹿児島","沖縄"]

        return area1Array
    }
}
