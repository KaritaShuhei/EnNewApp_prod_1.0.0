
//
//  profileViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/05/04.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class MyPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()

    @IBOutlet var TableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!

    
    var menuArray = ["利用規約","プライバシーポリシー","通知設定"]

    
    override func viewDidLoad() {

        TableView.delegate = self
        TableView.dataSource = self
        loadData()
        TableView.reloadData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
        /// 画面再表示
     override func viewWillAppear(_ animated: Bool) {

         super.viewWillAppear(animated)
     }
    
    func loadData(){
        userNameLabel.text = userInfomation.currentUserName
    }
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
                
       
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath as IndexPath) as? SettingTableViewCell
        cell!.titleLabel.text = self.menuArray[indexPath.row]
        if indexPath.row == 0{
            cell!.ImageView.image = UIImage(systemName:"person.crop.square")
        }else if indexPath.row == 1{
            cell!.ImageView.image = UIImage(systemName:"calendar")
        }else if indexPath.row == 2{
            cell!.ImageView.image = UIImage(systemName:"doc.plaintext")
        }else if indexPath.row == 3{
            cell!.ImageView.image = UIImage(systemName:"square.and.at.rectangle")
        }else{
            cell!.ImageView.image = UIImage(systemName:"envelope.badge")
        }
        return cell!
    }
    
    @IBAction func logoutView(_ sender: Any) {

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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
