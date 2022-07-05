//
//  MyAccountViewController.swift
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
import YoutubePlayer_in_WKWebView

class MyAccountViewController: UIViewController, PurchaseInfomationPuchaseStatusReloadedDelegate {

    
    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()
    let purchaseInfomation = PurchaseInfomation()

    @IBOutlet var TableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!

    
    var menuArray = ["生年月日","所在地（都道府県）","所在地（市区町村）","メールアドレス","会員ID","会員共通パスワード","利用規約","プライバシーポリシー"]
    var userInfoValueArray = [String]()
    
    override func viewDidLoad() {

        purchaseInfomation.purchaseInfomationPuchaseStatusReloadedDelegate = self
        pageProperty.initilize2(view: view)
        purchaseInfomation.fetchPurchaseStatus()
        TableView.delegate = self
        TableView.dataSource = self
        loadData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
        /// 画面再表示
     override func viewWillAppear(_ animated: Bool) {

         super.viewWillAppear(animated)
     }
    
    func loadData(){
        userInfoValueArray.removeAll()
        userNameLabel.text = userInfomation.currentUserName
        userInfomation.getData1()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)
            userInfoValueArray.append(userInfomation.birthday)
            userInfoValueArray.append(userInfomation.prefecture)
            userInfoValueArray.append(userInfomation.city)
            userInfoValueArray.append(userInfomation.currentEmail)
            userInfoValueArray.append("")
            userInfoValueArray.append("")
//利用規約とプライバシーポリシーのCellには値が入らないのでnilで埋める
            userInfoValueArray.append("")
            userInfoValueArray.append("")
            TableView.reloadData()
            return
        }

    }
    
    func puchaseStatusReloaded() {
                
        switch purchaseInfomation.purchaseStatus {
        case "0":

                return

        case "1":
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in

                userInfoValueArray[4] = userInfomation.currentEmail
                userInfoValueArray[5] = "withpaypay"
                TableView.reloadData()
                
                return
            }

        default:
            break
        }

    }
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userNameEditButtonTapped(_ sender: Any) {

        var uiTextField = UITextField()
        let alert = UIAlertController(title: "入力情報を修正する", message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "完了", style: .default) { (action) in
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = uiTextField.text ?? ""
            changeRequest?.commitChanges { error in
                let currentName:AnyObject = Auth.auth().currentUser!.displayName! as AnyObject
                let data0:[String:AnyObject]=["userName":"\(currentName)"] as [String : AnyObject]
                self.firebaseMethod.Ref.child("user").child(self.userInfomation.currentUid).child("profile").updateChildValues(data0){
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        self.userNameLabel.text = uiTextField.text ?? ""
                    }
                }
                
            }
            
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addTextField { [self] (textField) in
            textField.text = userNameLabel.text
            uiTextField = textField
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }


}
extension MyAccountViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
                
       
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "myAccountCell", for: indexPath as IndexPath) as? MyAccountTableViewCell
        cell!.titleLabel.text = self.menuArray[indexPath.row]
        if userInfoValueArray != []{

            cell!.registerInfoLabel.text = self.userInfoValueArray[indexPath.row]

        }
//        if indexPath.row == 0{
//            cell!.registerInfoLabel.text = userInfomation.birthday
//            cell!.ImageView.image = UIImage(systemName:"person.crop.square")
//        }else if indexPath.row == 1{
//            cell!.registerInfoLabel.text = userInfomation.prefecture + userInfomation.city
//            cell!.ImageView.image = UIImage(systemName:"calendar")
//        }else if indexPath.row == 2{
//            cell!.registerInfoLabel.text = userInfomation.currentEmail
//            cell!.ImageView.image = UIImage(systemName:"doc.plaintext")
//        }else if indexPath.row == 3{
//            cell!.registerInfoLabel.text = ""
//            cell!.ImageView.image = UIImage(systemName:"doc.plaintext")
//        }else if indexPath.row == 4{
//            cell!.registerInfoLabel.text = ""
//            cell!.ImageView.image = UIImage(systemName:"doc.plaintext")
//        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if indexPath.row == 3{
            
            print("emailは編集不可")
            
        }else if indexPath.row == 4 || indexPath.row == 5{

            print("会員ID、共通パスワードは編集不可")

        }else if indexPath.row == 6{
            
            let url = URL(string: "https://en-new.com/wp-content/uploads/2022/06/Term_of_Service.pdf")!

            if UIApplication.shared.canOpenURL(url) {
            
                UIApplication.shared.open(url)

            }
            
        }else if indexPath.row == 7{
            
            let url = URL(string: "https://en-new.com/wp-content/uploads/2022/06/Privacy_Policy.pdf")!

            if UIApplication.shared.canOpenURL(url) {
            
                UIApplication.shared.open(url)

            }
            
        }else{
            
            var uiTextField = UITextField()
            let alert = UIAlertController(title: "入力情報を修正する", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "完了", style: .default) { (action) in
                print(uiTextField.text!)
                
                if self.menuArray[indexPath.row] == "生年月日"{
                    
                    let data0 = ["birthday":"\(uiTextField.text ?? "")"] as [String : Any]
                    self.firebaseMethod.Ref.child("user").child(self.userInfomation.currentUid).child("profile").updateChildValues(data0){
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            print("Data saved successfully!")
                            self.loadData()
                        }
                    }
                    
                }else if self.menuArray[indexPath.row] == "所在地（都道府県）"{
                    
                    let data0 = ["prefecture":"\(uiTextField.text ?? "")"] as [String : Any]
                    self.firebaseMethod.Ref.child("user").child(self.userInfomation.currentUid).child("profile").updateChildValues(data0){
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            print("Data saved successfully!")
                            self.loadData()
                        }
                    }

                }else if self.menuArray[indexPath.row] == "所在地（市区町村）"{
                    
                    let data0 = ["city":"\(uiTextField.text ?? "")"] as [String : Any]
                    self.firebaseMethod.Ref.child("user").child(self.userInfomation.currentUid).child("profile").updateChildValues(data0){
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            print("Data saved successfully!")
                            self.loadData()
                        }
                    }

                }
                
            }
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            alert.addTextField { [self] (textField) in
                textField.text = userInfoValueArray[indexPath.row]
                uiTextField = textField
            }
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)

            
        }

//        selectedPostID = dicArray[(twoDimArray_re[indexPath.row][0] as? String)!]?["postID"] as? String
//        performSegue(withIdentifier: "toSelectedPostListView", sender: nil)

    }

    @IBAction func logoutButtonTapped(_ sender: Any) {

                let alert: UIAlertController = UIAlertController(title: "確認", message: "ログアウトしていいですか？", preferredStyle:  UIAlertController.Style.alert)

                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in

                    do{
                        try Auth.auth().signOut()

                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

                    }catch let error as NSError{
                        print(error)
                    }
                    print("OK")
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
