//
//  LoginViewModel.swift
//  LoginMVVM
//
//  Created by sairam kotha on 10/02/18.
//  Copyright © 2018 MVVMTest. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum LoginStatusType: Equatable {
    case loggedin
    case failed(message: String)
    case signup

    static func == (lhs: LoginStatusType, rhs: LoginStatusType) -> Bool {
        switch (lhs, rhs) {
        case (.loggedin,.loggedin),
             (.failed, .failed),
             (.signup,.signup):
            return true
        default:
            return false
        }
    }
}

struct LoginViewModel {
    let validatedMobile: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let loginEnabled: Driver<Bool>
    var loginStatus: Driver<LoginStatusType>!

    init(mobile: (text: Driver<String>, focused: Driver<Bool>),
         password: (text: Driver<String>, focused: Driver<Bool>),
         loginTaps: Driver<Void>) {

        validatedMobile = Driver.combineLatest(mobile.text, mobile.focused)
            { ($0, $1) }
            .map {
                $0.validateMobile(focused: $1)
        }

        validatedPassword = Driver.combineLatest(password.text, password.focused)
            { ($0, $1) }
        .map {
            $0.validatePassword(focused: $1)
        }

        loginEnabled = Driver.combineLatest(
            validatedMobile,
            validatedPassword
        ) { mobile, password in
            mobile.isValid && password.isValid
          }
            .distinctUntilChanged()

        let mobilePasswordObservable = Driver.combineLatest(mobile.text, password.text) {
            ["mobile": $0, "password": $1]
         }.asObservable()

        loginStatus = loginTaps.asObservable()
            .withLatestFrom(mobilePasswordObservable)
            .scan(0, accumulator: { lastCount, _ in
                return lastCount + 1
            })
            .map { count in
                switch count % 3 {
                case 0:
                    return LoginStatusType.failed(message: "exceeded login attempt")
                case 1:
                    return LoginStatusType.signup
                case 2:
                    return LoginStatusType.loggedin
                default:
                    return LoginStatusType.failed(message: "")
                }
            }.asDriver(onErrorJustReturn: LoginStatusType.failed(message: ""))

    }
}

