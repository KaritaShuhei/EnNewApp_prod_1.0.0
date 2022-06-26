//
//  MethodForDatabase.swift
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

protocol FirebaseMethodDelegate : AnyObject{
    func setValue(selectedRef:DatabaseReference,data:[String : Any])
    func uploadValue(selectedRef:DatabaseReference,data:[String : Any])
    func deleteValue(selectedRef:DatabaseReference)
}

//Databaseの参照先を追加する
public class FirebaseMethod:NSObject,FirebaseMethodDelegate {
    
    let Ref = Database.database().reference()

    func setValue(selectedRef: DatabaseReference, data: [String : Any]) {
        
        
    }
    
    func uploadValue(selectedRef: DatabaseReference,data:[String : Any]) {
        selectedRef.setValue(data) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }

    }

    func deleteValue(selectedRef: DatabaseReference) {
        
        
    }

    
}
