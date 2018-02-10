//
//  LoginViewModelTest.swift
//  RxLoginMVVMTests
//
//  Created by sairam kotha on 10/02/18.
//  Copyright © 2018 MVVMTest. All rights reserved.
//

import XCTest
@testable import RxLoginMVVM
import RxTest
import RxSwift

final class LoginViewModelTest: XCTestCase {
    var viewModel: LoginViewModel!
    var mobile = Variable<String>("")
    var password = Variable<String>("")
    var mobileFocused = Variable<Bool>(true)
    var passwordFocused = Variable<Bool>(true)
    var loginTap = PublishSubject<Void>()
    var loginStatus = PublishSubject<LoginStatusType>()
    var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel(mobile: (text: mobile.asDriver(),
                                            focused: mobileFocused.asDriver()),
                                   password: (text: password.asDriver(),
                                              focused: passwordFocused.asDriver()),
                                   loginTaps: loginTap.asDriver(onErrorJustReturn: ()))
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLogin() {
        let testSchduler = TestScheduler(initialClock: 0)
        let loginEnabledTestObs = testSchduler.createObserver(Bool.self)
        let mobileValidation = testSchduler.createObserver(ValidationResult.self)
        let passwordValidation = testSchduler.createObserver(ValidationResult.self)
        let loginStatus = testSchduler.createObserver(LoginStatusType.self)

        viewModel.validatedMobile.asObservable()
            .subscribe(mobileValidation)
            .disposed(by: disposeBag)
        viewModel.validatedPassword.asObservable()
            .subscribe(passwordValidation)
            .disposed(by: disposeBag)

        viewModel.loginStatus.asObservable()
            .subscribe(loginStatus)
            .disposed(by: disposeBag)

        mobile.value = "76688"
        XCTAssertTrue(mobileValidation.events.last?.value.element == ValidationResult.failed)

        mobile.value = ""
        XCTAssertTrue(mobileValidation.events.last?.value.element == ValidationResult.empty)

        mobile.value = "7679106369"
        XCTAssertTrue(mobileValidation.events.last?.value.element == ValidationResult.ok)


        password.value = "21y"
        XCTAssertTrue(passwordValidation.events.last?.value.element == ValidationResult.failed)

        password.value = "2hbh1j3b"
        XCTAssertTrue(passwordValidation.events.last?.value.element == ValidationResult.ok)

        loginTap.onNext(())
        XCTAssertTrue(loginStatus.events.last?.value.element! == .signup)
    }
}
