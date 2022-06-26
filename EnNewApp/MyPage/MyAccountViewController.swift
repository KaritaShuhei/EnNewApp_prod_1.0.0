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

class MyAccountViewController: UIViewController {
    
    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()

    @IBOutlet var TableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!

    
    var menuArray = ["生年月日","所在地","メールアドレス","利用規約","プライバシーポリシー"]

    
    override func viewDidLoad() {

        pageProperty.initilize2(view: view)
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
        userNameLabel.text = userInfomation.currentUserName
        userInfomation.getData1()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)
            TableView.reloadData()
            return
        }

    }
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        if indexPath.row == 0{
            cell!.registerInfoLabel.text = userInfomation.birthday
            cell!.ImageView.image = UIImage(systemName:"person.crop.square")
        }else if indexPath.row == 1{
            cell!.registerInfoLabel.text = userInfomation.prefecture + userInfomation.city
            cell!.ImageView.image = UIImage(systemName:"calendar")
        }else if indexPath.row == 2{
            cell!.registerInfoLabel.text = userInfomation.currentEmail
            cell!.ImageView.image = UIImage(systemName:"doc.plaintext")
        }else if indexPath.row == 3{
            cell!.registerInfoLabel.text = ""
            cell!.ImageView.image = UIImage(systemName:"doc.plaintext")
        }else if indexPath.row == 4{
            cell!.registerInfoLabel.text = ""
            cell!.ImageView.image = UIImage(systemName:"doc.plaintext")
        }
        return cell!
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
