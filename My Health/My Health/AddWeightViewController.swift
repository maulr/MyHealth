//
//  AddWeightViewController.swift
//  My Health
//
//  Created by Ron Mauldin on 11/23/14.
//  Copyright (c) 2014 maulr. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class AddWeightViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addWeightTxt: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    let addWeightRightLbl = UILabel(frame:CGRectZero)
    lazy var healthStore = HKHealthStore()



    @IBAction func saveWeight(sender: AnyObject) {
         let weightQuantityType = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierBodyMass)



        let weightUnit: HKUnit = HKUnit.poundUnit()
        let weightQuantity = HKQuantity(unit: weightUnit,
            doubleValue: (addWeightTxt.text as NSString).doubleValue)
        let now = NSDate()
        let sample = HKQuantitySample(type: weightQuantityType,
            quantity: weightQuantity,
            startDate: now,
            endDate: now)

        healthStore.saveObject(sample, withCompletion: {
            (succeeded: Bool, error: NSError!) in
            if error == nil{
                println("Successfully saved the user's weight")
            } else {
                println("Failed to save the user's weight")
            }

        })
           self.addWeightTxt.resignFirstResponder()
           self.addWeightTxt.text = ""

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     }

/////////////// Setting up right side of textbox to show lbs for weight///////////

    func rtSideTxt(){
        self.addWeightTxt.rightView = addWeightRightLbl
        self.addWeightTxt.rightViewMode = .Always
        self.addWeightRightLbl.text = "lbs"
        self.addWeightRightLbl.font = UIFont.boldSystemFontOfSize(20)
        self.addWeightRightLbl.sizeToFit()

    }


    override func viewDidAppear(animated: Bool) {
        self.rtSideTxt()
    }


}







