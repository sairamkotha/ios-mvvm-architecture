//
//  RxLoginMVVMTests.swift
//  RxLoginMVVMTests
//
//  Created by sairam kotha on 10/02/18.
//  Copyright © 2018 MVVMTest. All rights reserved.
//

import XCTest
@testable import RxLoginMVVM

class ValidationTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMobileNumber() {
        var mobileNumber = ""
        XCTAssertTrue(mobileNumber.validateMobile(focused: true) == .empty)

        mobileNumber = "767910"
        XCTAssertTrue(mobileNumber.validateMobile(focused: true) == ValidationResult.failed)

        mobileNumber = "7679106369"
        XCTAssertTrue(mobileNumber.validateMobile(focused: true) == ValidationResult.ok)

        mobileNumber = "767910asdasd"
        XCTAssertTrue(mobileNumber.validateMobile(focused: true) == ValidationResult.failed)

        mobileNumber = "asdasde"
        XCTAssertTrue(mobileNumber.validateMobile(focused: true) == ValidationResult.failed)

        let validation = mobileNumber.validatePassword(focused: true)
        XCTAssertTrue(validation.isValid)
    }

    func testPassword() {
        var mobileNumber = ""
        XCTAssertTrue(mobileNumber.validatePassword(focused: true) == .empty)

        mobileNumber = "asds"
        XCTAssertTrue(mobileNumber.validatePassword(focused: true) == ValidationResult.failed)

        mobileNumber = "ahsahdh"
        XCTAssertTrue(mobileNumber.validatePassword(focused: true) == ValidationResult.ok)

        mobileNumber = "712732nasj"
        XCTAssertTrue(mobileNumber.validatePassword(focused: true) == ValidationResult.ok)

        mobileNumber = "asdasde!as@ 92"
        XCTAssertTrue(mobileNumber.validatePassword(focused: true) == ValidationResult.ok)
    }

}

