//
//  ProfileViewController.swift
//  My Health
//
//  Created by Ron Mauldin on 11/3/14.
//  Copyright (c) 2014 maulr. All rights reserved.
//

import Foundation
import UIKit
import HealthKit


// Sets the decimal places in the distance walked/ran.
extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}



class ProfileViewController: UIViewController {

    var healthStore: HKHealthStore? = nil
//    var passWeight = String()
    var distance = 0.0
    var steps = 0
    var totalDist = Double()
    var timerCount = 0
    var runTimer = false
    var timer = NSTimer()
    var backgroundColor = UIColor()
    var heightValue = String()


    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var refreshLbl: UIButton!
    @IBOutlet weak var stepsLbl: UILabel!
    @IBOutlet weak var distLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var myActInd: UIActivityIndicatorView!
    
    @IBOutlet weak var adviseUpdateLbl: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if !HKHealthStore.isHealthDataAvailable() {
            dispatch_async(dispatch_get_main_queue(), {
                var alert = UIAlertController(
                    title: "Alert",
                    message: "HealthKit is not supported on this device.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(
                    alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(
                    title: "OK", style: UIAlertActionStyle.Default,
                    handler: nil))
                println("HealthKit is not supported on this device.")
            })
            return
        }

        self.healthStore = HKHealthStore()
        var completion: ((Bool, NSError!) -> Void)! = {
            (success, error) -> Void in
            if !success {
                println(" Health Kit did not access the read/write dataTypes. ERROR is: \(error)")

                return
            }
            //            dispatch_async(dispatch_get_main_queue(), {
            //               () -> Void in

            //                            })

        }


        self.healthStore?.requestAuthorizationToShareTypes(dataTypesToWrite(), readTypes: dataTypesToRead(), completion: completion)


        
        self.actIndStart()
        self.startRefreshTimer()

    }



    func dataTypesToWrite() -> NSSet {
        var bodyTempType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyTemperature)
        var bodyMassType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        var stepsType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        var weightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
//        var bloodSugar: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)
        var writeDataTypes: NSSet = NSSet(objects:bodyMassType, bodyTempType,weightType,stepsType)
        return writeDataTypes
    }

    ///////// Data types to read from HealthStore ///////////////////////
    func dataTypesToRead()-> NSSet {

        var weightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        var distanceType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        var stepsType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        var hieghtType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)
        var birthDayType: HKCharacteristicType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)
        var genderType = HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)
//  var bloodSugar: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)
        var readDataTypes: NSSet = NSSet(objects: hieghtType, birthDayType, genderType,  distanceType,weightType,stepsType)
        return readDataTypes
    }

    

     override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //        profileLbl.center.x -= view.bounds.width
        genderLbl.center.x -= view.bounds.width
        weightLbl.center.x -= view.bounds.width
        heightLbl.center.x -= view.bounds.width
        ageLbl.center.x -= view.bounds.width
        dobLbl.center.x -= view.bounds.width
        distLbl.center.x -= view.bounds.width
        stepsLbl.center.x -= view.bounds.width
 //       refreshLbl.center.x -= view.bounds.width
 //       adviseUpdateLbl.center.x -= view.bounds.width


     self.adviseUpdateLbl.text = "Back ground color will change when data is updated automatically every 2min. or by tapping Refresh."
        self.retrieveDistance(){}
        self.retrieveSteps(){}
        self.retrieveUsersWeight()
        self.retrieveUsersAge()
        self.retrieveUsersHeight()
        self.myGender()

           }
//Add animation to labels ////////////
     override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.22, delay: 0.0, options: .CurveEaseOut, animations: {

            self.genderLbl.center.x += self.view.bounds.width

            }, completion: nil)
        UIView.animateWithDuration(0.22, delay: 0.3, options: .CurveEaseIn, animations: {
            self.dobLbl.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.22, delay: 0.4, options: .CurveEaseIn, animations: {
            self.ageLbl.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.22, delay: 0.5, options: .CurveEaseIn, animations: {
            self.weightLbl.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.22, delay: 0.6, options: .CurveEaseIn, animations: {
            self.heightLbl.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.22, delay: 0.7, options: .CurveEaseIn, animations: {
            self.distLbl.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.22, delay: 0.8, options: .CurveEaseIn, animations: {
            self.stepsLbl.center.x += self.view.bounds.width
            }, completion: nil)
/*        UIView.animateWithDuration(0.33, delay: 0.9, options: .CurveEaseIn, animations: {
            self.refreshLbl.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.33, delay: 1.0, options: .CurveEaseIn, animations: {
            self.adviseUpdateLbl.center.x += self.view.bounds.width
            }, completion: nil)*/

    }



////////// View background color with change when data is updated.//////////
    func changeColor(){

        UIView.animateWithDuration(1.5, animations: {


        if self.view.backgroundColor == UIColor.blueColor() {
            self.view.backgroundColor = UIColor.brownColor()
        }else {
            self.view.backgroundColor = UIColor.blueColor()
        }
        })
    }
//////////// Updates Distance and Steps, resets timer to 0//////////
    func refreshTimer() {

        timerCount += 1
         println("true or false: \(runTimer)")

        if timerCount == 1 {
            timerCount = 0
            self.retrieveDistance(){}
            self.retrieveSteps(){}
            self.changeColor()
        }

    }

///////////// Sets timer to update every 2 minutes///////////////////
    func startRefreshTimer() {

            timer = NSTimer.scheduledTimerWithTimeInterval(60 * 2, target: self, selector: Selector("refreshTimer"), userInfo: nil, repeats: true)
            //runTimer = true
            }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 


///////// Activity Indicator /////////////////////////////
    func actIndStart() {
        self.myActInd.center = self.view.center
        self.myActInd.hidesWhenStopped = true
        self.myActInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    }

/////////Retrieve user's gender//////////////////////////////////
    func myGender() {

        let genderType = self.healthStore?.biologicalSexWithError(nil)


     if (genderType != nil) {
      switch genderType!.biologicalSex{
      case .Female:
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
      self.genderLbl.text = "Female"
      })
      case .Male:
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
      self.genderLbl.text = "Male"
      })
      default:
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
      self.genderLbl.text = "No gender added"
      })
            }
         }
     }





///////// Retrieving Users Age///////////////////////////////

    func retrieveUsersAge()
    {
        var error: NSError?
        let dob = self.healthStore?.dateOfBirthWithError(&error)
        if dob == nil {
            println("Does not seem to be a birthdate entered to retrieve")
            return
        }
//////////// Fromatting the DOB/////////////////////////////

        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let now = NSDate()
        let myBDate = dateFormatter.stringFromDate(dob!)
        var ageComponents: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.YearCalendarUnit, fromDate: dob!, toDate: now, options: NSCalendarOptions.WrapComponents)
///////////// Getting Users Age from DOB/////////////////////
        var usersAge: Int = ageComponents.year
        var ageValue: String = NSNumberFormatter.localizedStringFromNumber(usersAge, numberStyle: NSNumberFormatterStyle.NoStyle)
        self.dobLbl.text = ("\(myBDate)")
        self.ageLbl.text = ("\(ageValue)")
        println("I am \(ageValue) years of age.")
        println("I was born on: \(myBDate)")
    }


///////////// Retrieve user's default height unit in inches.///////////////////

    func retrieveUsersHeight()
    {
        let setHeightInformationHandle: ((String) -> Void) = {
            (heightValue) -> Void in

            let lengthFormatter: NSLengthFormatter = NSLengthFormatter()
            lengthFormatter.unitStyle = NSFormattingUnitStyle.Long

            let heightFormatterUnit: NSLengthFormatterUnit = .Inch
            let heightUniString: String = lengthFormatter.unitStringFromValue(50, unit: heightFormatterUnit)

        }

        let heightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)

        // Query to get the user's latest height, if it exists.
        let completion: HKCompletionHandle = {
            (mostRecentQuantity, error) -> Void in

            if mostRecentQuantity == nil {
                println("Either an error occured getting the user's height information or none has been stored yet in the health app.")

                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                   self.heightValue = NSLocalizedString("Not available", comment: "")

                    setHeightInformationHandle(self.heightValue)
                })

                return
            }

//////////////// Determine the height in the required unit.////////////////////
            let heightUnit: HKUnit = HKUnit.inchUnit()
            let usersHeight: Double = mostRecentQuantity.doubleValueForUnit(heightUnit)

/////////////////// Update the hieght label.////////////////////////////////////
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                self.heightValue = NSNumberFormatter.localizedStringFromNumber(NSNumber(double: usersHeight), numberStyle: NSNumberFormatterStyle.NoStyle)

                self.heightLbl.text = ("\(self.heightValue)")
                println("\(self.heightValue)")
            })

        }

        self.healthStore!.mostRecentQuantitySampleOfType(heightType, predicate: nil, completion: completion)
        }
/////////// Get the users weight info.//////////////////////////////////////



     func retrieveUsersWeight() -> Void
    {
        var setWeightInformationHandle: ((String) -> Void) = {
            (weightValue) -> Void in

            let massFormatter: NSMassFormatter = NSMassFormatter()
            massFormatter.unitStyle = NSFormattingUnitStyle.Long

            let weightFormatterUnit: NSMassFormatterUnit = .Pound
            let weightUniString: String = massFormatter.unitStringFromValue(10, unit: weightFormatterUnit)
            let localizedHeightUnitDescriptionFormat: String = NSLocalizedString("Weight (%@)", comment: "");

            let weightUnitDescription: NSString = NSString(format: localizedHeightUnitDescriptionFormat, weightUniString);


        }

        let weightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)

/////////// Query to get the user's latest weight, if in database.//////////////
        let completion: HKCompletionHandle = {
            (mostRecentQuantity, error) -> Void in

            if mostRecentQuantity == nil {
                println("Either an error occured fetching the user's weight information or none has been stored yet. In your app, try to handle this gracefully.")

                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    let weightValue: String = NSLocalizedString("Not available", comment: "")

                    setWeightInformationHandle(weightValue)
                    self.weightLbl.text =  ("\(weightValue)")
                    println("\(weightValue)")

                })
                

                return
            }



//////////// Determine the weight in the required unit.///////////////////////////
            let weightUnit: HKUnit = HKUnit.poundUnit()
            let usersWeight: Double = mostRecentQuantity.doubleValueForUnit(weightUnit)

///////////// Update the weight label.///////////////////////////////////////////
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                let weightValue: String = NSNumberFormatter.localizedStringFromNumber(NSNumber(double: usersWeight), numberStyle: NSNumberFormatterStyle.NoStyle)
                   println("MY Weight is: \(weightValue) lbs")
                   self.weightLbl.text =  ("\(weightValue)")


                })
        }

        self.healthStore!.mostRecentQuantitySampleOfType(weightType, predicate: nil, completion: completion)


               
    }



//////////////// Get distance walked or ran ////////////////////////////
    func retrieveDistance(completion: () -> ()) {

       let distanceType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        self.retrieveTotalDataOfQuantityType(distanceType, completion: { (quantity, error) -> () in
            if let quantity = quantity {
  //              let distance = quantity.doubleValueForUnit(HKUnit.mileUnit())
                self.distance = Double(quantity.doubleValueForUnit(HKUnit.mileUnit()))
                self.distLbl.text = "\(self.distance)"





//              let miles = self.distance
 //              println(lengthFormatter.stringFromMeters(miles))

                println("did the miles round off?  \(self.totalDist)")
                println("how far did I walk? \(self.totalDist)")
            }
            completion()

            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in

                 let myDistance = self.distance
                 println(myDistance.format(".1"))
                 var totalDist = myDistance.format(".2")

                self.distLbl.text = ("\(totalDist)")
                println(self.totalDist)

                if self.distLbl.text != nil && self.stepsLbl.text != nil {
                self.myActInd.stopAnimating()

            }

            })
        })






    }

//////////// Gets the steps taken for the day ///////////////////////////////
     func retrieveSteps(completion: () -> ()) {

        println("whats in this label right now? \(distLbl.text)")

        let stepsType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        self.retrieveTotalDataOfQuantityType(stepsType, completion: { (quantity, error) -> () in
            if let quantity = quantity {
                self.steps = Int(quantity.doubleValueForUnit(HKUnit.countUnit()))
                println("steps taken so far: \(self.steps)")

            }
            completion()

        dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                self.stepsLbl.text = "\(self.steps)  Steps taken"

            if self.distLbl.text != nil && self.stepsLbl.text != nil {
             self.myActInd.stopAnimating()

             }

          })

        })
     }

////////////// Gathering cumulative data for the day //////////////////////

    func retrieveTotalDataOfQuantityType(quantityType: HKQuantityType, completion:(quantity: HKQuantity?, error: NSError?) -> ()) {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let flags: NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit
        let components = calendar.components(flags, fromDate: now)
        let startDate = calendar.dateFromComponents(components)
        let endDate = calendar.dateByAddingUnit(NSCalendarUnit.DayCalendarUnit, value: 1, toDate: startDate!, options: nil)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .StrictStartDate)

        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: HKStatisticsOptions.CumulativeSum) { (query, result, error) -> Void in
            if result != nil {
                completion(quantity: result.sumQuantity(), error: error)
            }
        }
        healthStore!.executeQuery(query)

    }

   
////////////////// Refresh Data if they don't want to wait for timer./////////////////
    @IBAction func refreshButton(sender: AnyObject) {
        self.actIndStart()
        self.retrieveDistance(){}
        self.retrieveSteps(){}
        self.retrieveUsersWeight()
        self.retrieveUsersAge()
        self.retrieveUsersHeight()
        self.changeColor()

    }


}
