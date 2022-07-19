//
//  MemberRegist2ViewController.swift
//  clubsupApp
//
//  Created by 原井川　千夏 on 2022/01/02.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseEmailAuthUI

class MemberRegistViewController: UIViewController,FUIAuthDelegate ,DidSelectRowDelegate{
    
    let pageProperty = PageProperty()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var prefectureTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var selectedTeamID:String?
    
    let Ref = Database.database().reference()
    
    let providers: [FUIAuthProvider] = [
        FUIEmailAuth()
    ]
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    var ActivityIndicator: UIActivityIndicatorView!
    var initilizedView: UIView = UIView()
    
    var pickerview0: UIPickerView?
    var pickerview1: UIPickerView?
    var yyyyArray = [String]()
    var mmArray = [String]()
    var ddArray = [String]()
    var prefectureArray = [String]()

    let PickerCompo0 = setPickerCompo0()
    let PickerCompo1 = setPickerCompo1()

    override func viewDidLoad() {

        pickerViewData()
        PickerCompo0.delegate = self
        PickerCompo1.delegate = self
        self.authUI.delegate = self
        self.authUI.providers = providers
        
        super.viewDidLoad()
    }
    func instanceClass(){

    }
    func pickerViewData(){
//        生年月日のPickerView設定
        let dateProperty = DateProperty()
        yyyyArray = dateProperty.getData1()
        mmArray = dateProperty.getData2()
        ddArray = dateProperty.getData3()
        PickerCompo0.selectedArray0 = yyyyArray
        PickerCompo0.selectedArray1 = mmArray
        PickerCompo0.selectedArray2 = ddArray
        pickerview0 = UIPickerView()
        pickerview0?.delegate = PickerCompo0
        pickerview0?.dataSource = PickerCompo0
        pickerview0?.tag = 0
        pickerview0?.selectRow(0, inComponent: 0, animated: false)
        pickerview0?.selectRow(0, inComponent: 1, animated: false)
        pickerview0?.selectRow(0, inComponent: 2, animated: false)
        birthdayTextField.inputView = pickerview0

//        都道府県のPickerView設定
        let areaProperty = AreaProperty()
        prefectureArray = areaProperty.getData1()
        PickerCompo1.selectedArray0 = prefectureArray
        pickerview1 = UIPickerView()
        pickerview1?.delegate = PickerCompo1
        pickerview1?.dataSource = PickerCompo1
        pickerview1?.tag = 0
        pickerview1?.selectRow(0, inComponent: 0, animated: false)
        prefectureTextField.inputView = pickerview1

    }
    func didSelectRow0() {
        birthdayTextField.text = "\(PickerCompo0.row0)/" + "\(PickerCompo0.row1)/" + "\(PickerCompo0.row2)"
    }
    func didSelectRow1() {
        prefectureTextField.text = "\(PickerCompo1.row0 ?? "")"
    }

    func keyboardDismiss(){
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func registButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
//        birthdayTextField、prefectureTextField、cityTextFieldはOptional（任意項目）
        if nameTextField.text == ""  || emailTextField.text == "" || passTextField.text == ""{
            let alert: UIAlertController = UIAlertController(title: "確認", message: "空欄の項目があります。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }else{
            pageProperty.initilize1(view: view)
            Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passTextField.text ?? "") { authResult, error in
                
                if authResult?.user == nil {
                    let alert: UIAlertController = UIAlertController(title: "確認", message: "会員情報に不備があります。再度入力してください。", preferredStyle:  UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        (action: UIAlertAction!) -> Void in

                        self.pageProperty.removeinitilizedViewForActivityIndicator(view: self.view)

                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }else{
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.nameTextField.text ?? ""
                    changeRequest?.commitChanges { error in
                        let currentUid:AnyObject = Auth.auth().currentUser!.uid as AnyObject
                        let currentName:AnyObject = Auth.auth().currentUser!.displayName! as AnyObject
                        let currentEmail:AnyObject = Auth.auth().currentUser!.email! as AnyObject
                        let data0:[String:AnyObject]=["uid":"\(currentUid)","email":"\(currentEmail)","userName":"\(currentName)","myName":"\(currentName)","adminStatus":"0","birthday":"\(self.birthdayTextField.text!)","prefecture":"\(self.prefectureTextField.text!)","city":"\(self.cityTextField.text!)","purchasePlan":"","purchaseStatus":"課金なし","purchaseExpiresDate":0,"purchaseExpiresDate_ms":0,"purchaseExpiresDate_yyyyMMdd":"","userRuleChecked":"0"] as [String : AnyObject]
                        
                        self.Ref.child("user").child(currentUid as! String).child("profile").updateChildValues(data0)
                        self.performSegue(withIdentifier: "toAppRule", sender: nil)
                        self.pageProperty.removeAllSubviews(parentView: self.view)

                    }
                }
            }
        }
    }
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
