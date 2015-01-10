//
//  WeightsToDateViewController.swift
//  My Health
//
//  Created by Ron Mauldin on 12/7/14.
//  Copyright (c) 2014 maulr. All rights reserved.
//

import UIKit
import HealthKit

class WeightsToDateViewController: UIViewController {

    // singleton HealthStore
    var healthStore:HKHealthStore? = {

        if HKHealthStore.isHealthDataAvailable() {

            return HKHealthStore()
        } else {

            return nil
        }
        }()

    // weight
    var weightSamples: HKQuantitySample?

    override func viewDidLoad() {
        super.viewDidLoad()

        // request for the type of healthkit data required
              }

    @IBAction func viewMyWeights(sender: AnyObject) {
                            self.performQueryForBodyMass()


    }


    // load the most recent body mass (weight) measurement
    func performQueryForBodyMass() {

        let endDate = NSDate()
        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth,
            value: -1, toDate: endDate, options: nil)

        let weightSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,
            endDate: endDate, options: .None)

        let query = HKSampleQuery(sampleType: weightSampleType, predicate: predicate,
            limit: 0, sortDescriptors: nil, resultsHandler: {
                (query, results, error) in
                if !(results != nil) {
                    println("There was an error running the query: \(error)")
                }

                dispatch_async(dispatch_get_main_queue()) {
                    let weightSamples = (results as [HKQuantitySample])[0]
                    println("Whats my weight: \(self.weightSamples?.quantity)")
                    }

        })
        self.healthStore?.executeQuery(query)
    }
}