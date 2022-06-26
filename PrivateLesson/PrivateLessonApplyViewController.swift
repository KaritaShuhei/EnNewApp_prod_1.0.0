//
//  PrivateLessonApplyViewController.swift
//  EnNewApp
//
//  Created by Shuhei Karita on 2022/06/26.
//

import UIKit

class PrivateLessonApplyViewController: UIViewController, PurchaseInfomationPuchaseStatusReloadedDelegate {
    

    let PickerCompo1 = setPickerCompo1()
    let userInfomation = UserInformation()
    let firebaseMethod = FirebaseMethod()
    let pageProperty = PageProperty()
    let youtubePlay = YoutubePlay()
    let movieInfomation = MovieInfomation()
    let purchaseInfomation = PurchaseInfomation()

    override func viewDidLoad() {
        purchaseInfomation.purchaseInfomationPuchaseStatusReloadedDelegate = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        
        pageProperty.initilize3(view: view)
        purchaseInfomation.fetchPurchaseStatus()

    }
    
    func puchaseStatusReloaded() {
                

        switch purchaseInfomation.purchaseStatus {
        case "0":

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in

                pageProperty.removeinitilizedViewForActivityIndicator(view: view)

                let alert: UIAlertController = UIAlertController(title: "確認", message: "個別レッスンに申し込むためには入会が必要です。", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "入会へ", style: UIAlertAction.Style.default, handler:{ [self]
                    (action: UIAlertAction!) -> Void in
                    
                    performSegue(withIdentifier: "toPurchasePlan1ViewFromPVL", sender: nil)


                })
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    print("Cancel")
                })
                
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)

                return
            }

        case "1":
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                pageProperty.removeinitilizedViewForActivityIndicator(view: view)

                let url = URL(string: "https://lin.ee/DzQBRj3")!

                if UIApplication.shared.canOpenURL(url) {
                
                    UIApplication.shared.open(url)

                }
                return
            }

        default:

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in

                pageProperty.removeinitilizedViewForActivityIndicator(view: view)

                let alert: UIAlertController = UIAlertController(title: "確認", message: "予期せぬエラーが発生しました。時間をおいてから再度お試しください。", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ [self]
                    (action: UIAlertAction!) -> Void in

                })
                
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)

                return
            }
            break
        }

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
