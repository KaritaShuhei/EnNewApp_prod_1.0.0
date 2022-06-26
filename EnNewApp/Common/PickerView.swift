//
//  PickerViewProperty.swift
//  EnNewApp
//
//  Created by Shuhei Karita on 2022/05/23.
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

protocol DidSelectRowDelegate {
    func didSelectRow0()
    func didSelectRow1()
}

class setPickerCompo0: NSObject , UIPickerViewDataSource , UIPickerViewDelegate{
    
    var selectedArray0 = [String]()
    var selectedArray1 = [String]()
    var selectedArray2 = [String]()
    
    var row0:String = "1950"
    var row1:String = "1"
    var row2:String = "1"
    
    var delegate: DidSelectRowDelegate?
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                           forComponent component: Int, reusing view: UIView?) -> UIView{
        let label = (view as? UILabel) ?? UILabel()
        switch component {
        case 0:
            label.text = self.selectedArray0[row]
        case 1:
            label.text = self.selectedArray1[row]
        case 2:
            label.text = self.selectedArray2[row]
        default: break
        }

        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 3
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return selectedArray0.count
        case 1:
            return selectedArray1.count
        case 2:
            return selectedArray2.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return selectedArray0[row]
        case 1:
            return selectedArray1[row]
        case 2:
            return selectedArray2[row]
        default:
            return "error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            row0 = selectedArray0[row]
            delegate?.didSelectRow0()
        case 1:
            row1 = selectedArray1[row]
            delegate?.didSelectRow0()
        case 2:
            row2 = selectedArray2[row]
            delegate?.didSelectRow0()
        default:
            break
        }
    }
}
class setPickerCompo1: NSObject,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var selectedArray0 = [String]()
    var row0:String?
    var delegate: DidSelectRowDelegate?
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                           forComponent component: Int, reusing view: UIView?) -> UIView{
        
        let label = (view as? UILabel) ?? UILabel()
        label.text = self.selectedArray0[row]
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return selectedArray0.count
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return selectedArray0[row]
        
    }
    
    
    public func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        
        row0 = selectedArray0[row]
        if row0 == "選択してください"{
            row0 = ""
        }
        delegate?.didSelectRow1()
        
    }
}
