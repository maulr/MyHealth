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



func delay(#seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))

    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class AddWeightViewController: UIViewController, UITextFieldDelegate{


    var runOnce = 0
    var myWeight: HKQuantitySample?
    @IBOutlet weak var addWeightTxt: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    let addWeightRightLbl = UILabel(frame:CGRectZero)
     var healthStore = HKHealthStore()

    let statusView = UIImageView(image: UIImage(named: "banner"))
    let messages = ["Saved to health...", "Nothing to save..."]
    let label = UILabel()


    /// Save weith to health
    @IBAction func saveWeight(sender: AnyObject) {
        self.runOnce = 0


        if addWeightTxt.text != "" {
        UIView.animateWithDuration(0.33, delay: 0.0, options: .CurveEaseOut, animations: {
            self.saveButton.center.y += 80
            self.showMessages(index: 0)

        }, completion: nil)

        var bloodSugarType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)
        var weightQuantityType = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierBodyMass)
//        let bloodUnit : HKUnit = HKUnit
        let weightUnit: HKUnit = HKUnit.poundUnit()
        let weightQuantity = HKQuantity(unit: weightUnit,
            doubleValue: (addWeightTxt.text as NSString).doubleValue)
        let now = NSDate()
        let sample = HKQuantitySample(type: weightQuantityType,
            quantity: weightQuantity,
            startDate: now,
            endDate: now)

            println("What is in textbox \(self.addWeightTxt.text)")
        healthStore.saveObject(sample, withCompletion: {
            (succeeded: Bool, error: NSError!) in
            
             if error == nil{
               println("No errors")

             }
        })

            self.addWeightTxt.resignFirstResponder()
            //self.addWeightTxt.text = ""
        }else if self.addWeightTxt.text == "" {
            //self.statusView.hidden = false
            self.saveButton.center.y += 80
            self.showMessages(index: 1)
            println("No weight to save")
        }

    }

    func showMessages(#index: Int) {

        while runOnce < 1 {
        UIView.animateWithDuration(0.33, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {

            self.statusView.center.x += self.view.frame.size.width

            }, completion: {_ in
            if self.addWeightTxt.text != "" {
                self.statusView.hidden = true
                self.statusView.center.x -= self.view.frame.size.width
                self.label.text = self.messages[0]
                }else if self.addWeightTxt.text == "" {
                    self.statusView.hidden = true
                    self.statusView.center.x -= self.view.frame.size.width
                    self.label.text = self.messages[1]
                }

                UIView.transitionWithView(self.statusView, duration: 0.5, options: .CurveEaseOut | .TransitionCurlDown , animations: {
                    self.statusView.hidden = false
                    }, completion: {_ in

                        delay(seconds: 2.0, {
                        //    if index < self.messages.count-1 {
                             //   self.showMessages(index: index+1)
                                if self.addWeightTxt != "" {
                                    self.showMessages(index: 0)
                                    self.addWeightTxt.text = ""
                                   // self.statusView.hidden = true
                                }
                            if self.addWeightTxt.text == "" {
                                    self.showMessages(index: 1)
                                    self.statusView.hidden = true
                                self.saveButton.center.y -= 80
                                }
                           // }
                            
                        })
                        
                })

        })
            self.runOnce++

        }


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.title = "Add Weight"
        
        //// Adding Status Banner
        self.saveButton.center = CGPointMake(165, 198)
  //      self.statusView.center = CGPointMake(130, 198)//saveButton.center
        self.statusView.hidden = true
        self.statusView.center = CGPointMake(165, 198) //self.saveButton.center
        view.addSubview(statusView)



        /// Adding Status label
        label.frame = CGRect(x: 0, y: 0, width: self.statusView.frame.size.width, height: self.statusView.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        self.statusView.addSubview(label)

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

    override func viewWillAppear(animated: Bool) {
        self.saveButton.center = CGPointMake(165, 198)
//        self.statusView.center = CGPointMake(130, 198)//saveButton.center
        self.statusView.hidden = true
        self.statusView.center = CGPointMake(165, 198) //self.saveButton.center
    }


    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, delay: 0.33, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: nil, animations: {
            self.saveButton.center.y -= 30
            self.saveButton.alpha = 1.0
        }, completion: nil)

        self.rtSideTxt()

    }

   override func viewWillDisappear(animated: Bool) {
    self.saveButton.center = CGPointMake(165, 198)
  //  self.statusView.center = CGPointMake(130, 198)//saveButton.center
    self.saveButton.center = CGPointMake(165, 198)
    self.statusView.hidden = true
    self.statusView.center = CGPointMake(165, 198) //self.saveButton.center
    self.saveButton.alpha = 1.0

    }

    override func viewDidDisappear(animated: Bool) {
        self.saveButton.center = CGPointMake(165, 250)
        self.saveButton.center.y -= 30
        self.saveButton.alpha = 0.0
    }





}







