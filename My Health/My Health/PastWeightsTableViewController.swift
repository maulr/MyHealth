//
//  PastWeightsTableViewController.swift
//  My Health
//
//  Created by Ron Mauldin on 12/9/14.
//  Copyright (c) 2014 maulr. All rights reserved.
//

import UIKit
import HealthKit


class PastWeightsTableViewController: UITableViewController {

    var myHealthStore = HKHealthStore?()
    var weightSamples = [HKQuantitySample]()


    let massFormatter = NSMassFormatter()
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
       title = "Weight History"
        self.perfromQueryForWeightSamples()
        // Prepare the formatters
        self.massFormatter.forPersonMassUse = true
        self.dateFormatter.dateStyle = .ShortStyle
 //       self.dateFormatter.timeStyle = .ShortStyle

        }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

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

        self.myHealthStore = HKHealthStore()
        var completion: ((Bool, NSError!) -> Void)! = {
        (success, error) -> Void in
        if !success {
        println(" Health Kit did not access the read/write dataTypes. ERROR is: \(error)")

        return
        }
        dispatch_async(dispatch_get_main_queue(), {
        () -> Void in
        self.perfromQueryForWeightSamples()

        })

        }


        self.myHealthStore?.requestAuthorizationToShareTypes(dataTypesToWrite(), readTypes: dataTypesToRead(), completion: completion)


        }

    func dataTypesToRead()-> NSSet {

        var weightSampleType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)

        var readDataTypes: NSSet = NSSet(objects: weightSampleType)
        return readDataTypes
    }
    
    func dataTypesToWrite() -> NSSet {


        var weightType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        // HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)

        var writeDataTypes: NSSet = NSSet(objects:weightType)
        return writeDataTypes
    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        println("Number of sections")
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        println("weightsamples count \(weightSamples.count)")
        return weightSamples.count
    }

     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        let sample = weightSamples[indexPath.row]
        let weight = sample.quantity.doubleValueForUnit(HKUnit(fromString: "lb"))


        cell.detailTextLabel?.text = "\(massFormatter.stringFromValue(weight, unit:.Pound))"
        cell.textLabel?.text = "\(dateFormatter.stringFromDate(sample.startDate))"
        return cell
    }

 /*  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "WeightsSegue"{
            let vc = segue.destinationViewController as ProfileViewController
            self.myHealthStore?
    }
    }*/


    // MARK: - HealthStore utility methods
    func perfromQueryForWeightSamples() {
        println("Getting weight samples")
        var weightResults = String()
        let weightFormatterUnit: NSMassFormatterUnit = .Pound

        let endDate = NSDate()

        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth,

            value: -6, toDate: endDate, options: nil)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
            ascending: false)


        let weightSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)

        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,

            endDate: endDate, options: .None)

        let query = HKSampleQuery(sampleType: weightSampleType, predicate: predicate,

            limit: 0, sortDescriptors: [sortDescriptor],  resultsHandler: {

                (query, results, error) in
                println("my results:   \(results.count)")
                if !(results != nil) {

                    println("Error running query: \(error)")
                }

                dispatch_async(dispatch_get_main_queue()) {
                    self.weightSamples = results as [HKQuantitySample]
                println("\(results)" + "(\(results.count)")
                println("weightSamples to date: \(self.weightSamples.count)")
                self.tableView.reloadData()
            }

        })

        self.myHealthStore?.executeQuery(query)
    }


}