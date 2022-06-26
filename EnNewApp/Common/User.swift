//
//  UserProperty.swift
//  EnNewApp
//
//  Created by Shuhei Karita on 2022/05/20.
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

protocol PurchaseInfomationCancelButtonTappedDelegate{
    
    func cancelButtonTapped()
    
}

protocol PurchaseInfomationPuchaseStatusReloadedDelegate{
    
    func puchaseStatusReloaded()
    
}
//ユーザープロフィールを取得
public class UserInformation {
    let Ref = Database.database().reference()
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    let currentEmail:String = Auth.auth().currentUser!.email!
    var handler: UInt = 0
    
    var myName = String()
    var adminStatus = String()
    var birthday = String()
    var prefecture = String()
    var city = String()
    var purchasePlan = String()
    var purchaseStatus = String()
    var purchaseExpiresDate = Int()
    var purchaseExpiresDate_ms = Int()
    var purchaseExpiresDate_yyyyMMdd = String()
    var userRuleChecked = String()
    
    var fcmStatus = String()
    var fcmToken = String()
    
    //    ユーザープロフィール情報一式を取得
    func getData1(){
        let ref0 = self.Ref.child("user").child("\(self.currentUid)").child("profile")
        handler = ref0.observe(.value, with: { [self] (snapshot) in
            ref0.removeObserver(withHandle: handler)
            let value = snapshot.value as? NSDictionary
            self.myName = value?["myName"] as? String ?? ""
            self.adminStatus = value?["adminStatus"] as? String ?? ""
            self.birthday = value?["birthday"] as? String ?? ""
            self.prefecture = value?["prefecture"] as? String ?? ""
            self.city = value?["city"] as? String ?? ""
            self.purchasePlan = value?["purchasePlan"] as? String ?? ""
            self.purchaseStatus = value?["purchaseStatus"] as? String ?? ""
            self.purchaseExpiresDate = value?["purchaseExpiresDate"] as? Int ?? 0
            self.purchaseExpiresDate_ms = value?["purchaseExpiresDate_ms"] as? Int ?? 0
            self.purchaseExpiresDate_yyyyMMdd = value?["purchaseExpiresDate_yyyyMMdd"] as? String ?? ""
            self.userRuleChecked = value?["userRuleChecked"] as? String ?? ""
        })
    }
    //FCMトークンを取得
    func getData2(){
        let ref0 = self.Ref.child("user").child("\(self.currentUid)").child("notification")
        handler = ref0.observe(.value, with: { [self] (snapshot) in
            ref0.removeObserver(withHandle: handler)
            let value = snapshot.value as? NSDictionary
            self.fcmStatus = value?["fcmStatus"] as? String ?? ""
            self.fcmToken = value?["fcmToken"] as? String ?? ""
        })
    }
    
}
//課金状況を取得
class PurchaseInfomation: NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    let Ref = Database.database().reference()
    
    var myProduct:SKProduct?
    var purchaseExpiresDate: Int?
    var purchaseStatus:String?
    var childChangedStatus:String = "0"
    var purchaseInfomationCancelButtonTappedDelegate: PurchaseInfomationCancelButtonTappedDelegate?
    var purchaseInfomationPuchaseStatusReloadedDelegate: PurchaseInfomationPuchaseStatusReloadedDelegate?
    
    func fetchProducts(){
        let productIdentifier:Set = ["com.FreJave.AutoRenewingSubscription_Basic"]
        // 製品ID
        let productsRequest: SKProductsRequest = SKProductsRequest.init(productIdentifiers: productIdentifier)
        productsRequest.delegate = self
        productsRequest.start()
        print("productIdentifier:\(productIdentifier)")
    }
    func fetchPurchaseStatus(){
        print("fetchPurchaseStatus")
        let ref = Ref.child("user").child("\(self.currentUid)").child("profile")
        ref.observeSingleEvent(of: .value, with: { [self] (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                let key = value["purchaseExpiresDate"] as? Int
                self.purchaseExpiresDate = key
                if key != nil{
                    print("期限切れ")
                    self.purchaseExpiresDate = key
                    let timeInterval = NSDate().timeIntervalSince1970
                    if Int(timeInterval) > self.purchaseExpiresDate ?? 0{
                        self.receiptValidation(url: "https://buy.itunes.apple.com/verifyReceipt")
                    }else{
                        print("期限内")

                        self.purchaseStatus = "1"
                        purchaseInfomationPuchaseStatusReloadedDelegate?.puchaseStatusReloaded()
                        
                    }
                }else{
                    print("課金なし")

                    self.purchaseStatus = "0"
                    purchaseInfomationPuchaseStatusReloadedDelegate?.puchaseStatusReloaded()
                    
                }
                
            }else{
                
                self.purchaseStatus = "0"
                purchaseInfomationPuchaseStatusReloadedDelegate?.puchaseStatusReloaded()

            }
        })
        
        
    }
    func fetchSKPaymentQueue(){
        guard  let myProduct = self.myProduct else {
            print("SKPaymentQueue")
            return
        }
        if SKPaymentQueue.canMakePayments(){
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            print("SKPaymentQueue")
        }
        
    }
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first{
            myProduct = product
            print(myProduct)
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                purchaseInfomationCancelButtonTappedDelegate?.cancelButtonTapped()
                queue.finishTransaction(transaction)
                print("Transaction Failed \(transaction)")
            case .purchased:
                receiptValidation(url: "https://buy.itunes.apple.com/verifyReceipt")
                queue.finishTransaction(transaction)
                print("Transaction purchased: \(transaction)")
                
            case .restored:
                receiptValidation(url: "https://buy.itunes.apple.com/verifyReceipt")
                queue.finishTransaction(transaction)
                print("Transaction restored: \(transaction)")
                //                self.performSegue(withIdentifier: "applyFormNavigationSegue", sender: nil)
            case .deferred, .purchasing:
                print("Transaction in progress: \(transaction)")
            @unknown default:
                break
            }
        }
    }
    
    
    func receiptValidation(url: String) {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        print(receiptUrl)
        guard let receiptData = try? Data(contentsOf: receiptUrl!) else {
            self.purchaseStatus = "0"
            purchaseInfomationPuchaseStatusReloadedDelegate?.puchaseStatusReloaded()
            print("hoho")
            print("error")
            return
        }
        let requestContents = [
            "receipt-data": receiptData.base64EncodedString(options: .endLineWithCarriageReturn),
            "password": "39daf859768049a49b739db858bf09d1" // appstoreconnectからApp 用共有シークレットを取得しておきます
        ]
        //        print(requestContents)
        
        let requestData = try! JSONSerialization.data(withJSONObject: requestContents, options: .init(rawValue: 0))
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"content-type")
        request.timeoutInterval = 5.0
        request.httpMethod = "POST"
        request.httpBody = requestData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let json:Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: jsonData, options: .init(rawValue: 0)) as! Dictionary<String, AnyObject>
                
                let status:Int = json["status"] as! Int
                if status == receiptErrorStatus.invalidReceiptForProduction.rawValue {
                    self.receiptValidation(url: "https://sandbox.itunes.apple.com/verifyReceipt")
                }
                
                guard let receipts:Array<Dictionary<String, AnyObject>> = json["latest_receipt_info"] as? Array<Dictionary<String, AnyObject>> else {
                    return
                }
                
                // 機能開放
                self.provideFunctions(receipts: receipts)
            } catch let error {
                print("SKPaymentManager : Failure to validate receipt: \(error)")
            }
        })
        task.resume()
    }
    enum receiptErrorStatus: Int {
        case invalidJson = 21000
        case invalidReceiptDataProperty = 21002
        case authenticationError = 21003
        case commonSecretKeyMisMatch = 21004
        case receiptServerNotWorking = 21005
        case invalidReceiptForProduction = 21007
        case invalidReceiptForSandbox = 21008
        case unknownError = 21010
    }
    func provideFunctions(receipts:Array<Dictionary<String, AnyObject>>) {
        //        let in_apps = receipts["latest_receipt_info"] as! Array<Dictionary<String, AnyObject>>
        
        var latestExpireDate:Int = 0
        for receipt in receipts {
            let receiptExpireDateMs = Int(receipt["expires_date_ms"] as? String ?? "") ?? 0
            let receiptExpireDateS = receiptExpireDateMs / 1000
            if receiptExpireDateS > latestExpireDate {
                latestExpireDate = receiptExpireDateS
                print(latestExpireDate)
            }
            let demodata = receipt["expires_date"] as? String ?? ""
            print("demodata:\(demodata)")
        }
        UserDefaults.standard.set(latestExpireDate, forKey: "expireDate")
        let timeInterval = NSDate().timeIntervalSince1970
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let purchaseExpiresDate_yyyyMMdd = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(latestExpireDate)))
        
        self.purchaseExpiresDate = latestExpireDate
        //画面遷移用childChangeのトリガーとして”１”をセット
        self.childChangedStatus = "1"
        if Int(timeInterval) < latestExpireDate {

            let data = ["purchaseExpiresDate":latestExpireDate,"purchaseStatus":"課金中","purchasePlan":"ベーシックプラン","purchaseExpiresDate_yyyyMMdd":"\(purchaseExpiresDate_yyyyMMdd)"] as [String : Any]
            let ref = self.Ref.child("user").child("\(self.currentUid)").child("profile")
            ref.updateChildValues(data)
            
            self.purchaseStatus = "1"
            purchaseInfomationPuchaseStatusReloadedDelegate?.puchaseStatusReloaded()

        }else{

            print(purchaseExpiresDate_yyyyMMdd)
            let data = ["purchaseExpiresDate":latestExpireDate,"purchaseStatus":"課金なし","purchaseExpiresDate_yyyyMMdd":"\(purchaseExpiresDate_yyyyMMdd)"] as [String : Any]
            let ref = self.Ref.child("user").child("\(self.currentUid)").child("profile")
            ref.updateChildValues(data)

            self.purchaseStatus = "0"
            purchaseInfomationPuchaseStatusReloadedDelegate?.puchaseStatusReloaded()

        }
        //        self.dismiss(animated: true, completion: nil)
    }
}
