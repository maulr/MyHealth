//
//  My_HealthTests.swift
//  My HealthTests
//
//  Created by Ron Mauldin on 11/3/14.
//  Copyright (c) 2014 maulr. All rights reserved.
//
import Foundation
import UIKit
import XCTest
import My_Health
import HealthKit

class My_HealthTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testFalse() {
        XCTAssertFalse(false, "false shoulb be false")
    }



    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.


            
        }
    }

       func testViewDidLoad()
    {
        // we only have access to this if we import our project above
        let v = TabBarViewController()
        

        // assert that the ViewController.view is not nil
    //    XCTAssertNotNil(v.view, "View Did Not load")
    }
    
}
