//
//  MemberAuthViewController.swift
//  clubsupApp
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseEmailAuthUI

class MemberAuthViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    let Ref = Database.database().reference()

    let providers: [FUIAuthProvider] = [
        FUIEmailAuth()
    ]
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    var ActivityIndicator: UIActivityIndicatorView!
    var initilizedView: UIView = UIView()
    
    override func viewDidLoad() {
        //        loadData()
        self.authUI.delegate = self
        self.authUI.providers = providers
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func authButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        if emailTextField.text == "" || passTextField.text == ""{
            let alert: UIAlertController = UIAlertController(title: "確認", message: "空欄の項目があります。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }else{
            let pageProperty = PageProperty()
            pageProperty.initilize1(view: view)
            Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passTextField.text ?? "") { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }

                if authResult?.user != nil {
                    self?.performSegue(withIdentifier: "toRootHomeView0", sender: nil)
                    self?.initilizedView.removeFromSuperview()

//                    ログイン成功
                } else {
                    let alert: UIAlertController = UIAlertController(title: "確認", message: "認証情報に誤りがあります。再度入力してください。", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        (action: UIAlertAction!) -> Void in

                        pageProperty.removeinitilizedViewForActivityIndicator(view: (self?.view!)!)

                    })
                    alert.addAction(defaultAction)
                    self?.present(alert, animated: true, completion: nil)

                    self?.initilizedView.removeFromSuperview()
//                    ログイン失敗
                }
                // ...
            }
        }
    }
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
