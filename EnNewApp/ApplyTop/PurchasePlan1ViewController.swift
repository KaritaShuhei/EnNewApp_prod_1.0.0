//
//  inviteViewController.swift
//  coachingApp1
//
//  Created by 刈田修平 on 2021/02/28.
//

import UIKit
import Firebase
import FirebaseStorage
import StoreKit

class PurchasePlan1ViewController: UIViewController,PurchaseInfomationCancelButtonTappedDelegate {
    
    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()
    let purchaseInfomation = PurchaseInfomation()
        
    @IBOutlet weak var purchaseButton: UIButton!
    
    
    override func viewDidLoad() {
        purchaseInfomation.purchaseInfomationCancelButtonTappedDelegate = self
        purchaseInfomation.fetchPurchaseStatus()
        purchaseInfomation.fetchProducts()
        purchaseStatusChanged()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func purchaseStatusChanged(){
        let profileRef = firebaseMethod.Ref.child("user").child("\(self.userInfomation.currentUid)").child("profile")
        profileRef.observe(.childChanged, with: { (snapshot) in
            print("purchaseExpiresDate_1")

            profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let key = value?["purchaseExpiresDate"] as? Int
                let timeInterval = NSDate().timeIntervalSince1970
                if key ?? 0 > Int(timeInterval){
                    if self.purchaseInfomation.childChangedStatus == "1"{
//                        2回目以降の検知（読み込み）は無効化したい、"2"に繰り上げ
                        self.purchaseInfomation.childChangedStatus = "2"
                        print("childChangedStatus=1")
                        self.pageProperty.removeAllSubviews(parentView: self.view)
                        self.performSegue(withIdentifier: "toMainView1", sender: nil)
                    }
                }
            })
            
        })

    }
    
    @IBAction func tappedButton(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "確認", message: "ベーシックプランに加入しますか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ [self]
            (action: UIAlertAction!) -> Void in
            self.pageProperty.initilize3(view: view)
            self.purchaseButton.isEnabled = false
            self.purchaseButton.setTitle("支払処理中", for: .normal)
            purchaseButton.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            purchaseButton.backgroundColor = .systemRed
            self.purchaseInfomation.fetchSKPaymentQueue()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            self.purchaseButton.isEnabled = true
            self.purchaseButton.setTitle("申し込む", for: .normal)
            self.purchaseButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.purchaseButton.backgroundColor = .systemRed
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)

        
    }

    @IBAction func restore(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "確認", message: "以前購入した情報を復元しますか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ [self]
            (action: UIAlertAction!) -> Void in
            self.pageProperty.initilize1(view: view)
            let timeInterval = NSDate().timeIntervalSince1970
            if Int(timeInterval) < self.purchaseInfomation.purchaseExpiresDate ?? 0{
                
                self.performSegue(withIdentifier: "toMainView1", sender: nil)
                
            }else{
                let alert: UIAlertController = UIAlertController(title: "確認", message: "有効な購入履歴はありません。", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    
                    self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)

                })
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
            }
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    func cancelButtonTapped() {

        self.purchaseButton.isEnabled = true
        self.purchaseButton.setTitle("申し込む", for: .normal)
        self.purchaseButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.purchaseButton.backgroundColor = .systemRed

        self.pageProperty.removeinitilizedViewForActivityIndicator(view: view)
        
    }

}
