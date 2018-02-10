//
//  Validations.swift
//  LoginMVVM
//
//  Created by sairam kotha on 10/02/18.
//  Copyright © 2018 MVVMTest. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

enum ValidationResult {
    case ok
    case failed
    case empty
}

struct ValidationColors {
    static let okColor = UIColor.black.withAlphaComponent(0.6)
    static let errorColor = UIColor.red.withAlphaComponent(0.7)
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .ok: fallthrough
        case .empty:
            return ValidationColors.okColor
        case .failed:
            return ValidationColors.errorColor
        }
    }

    var borderColor: UIColor {
        switch self {
        case .ok: fallthrough
        case .empty:
            return UIColor.black.withAlphaComponent(0.1)
        case .failed:
            return ValidationColors.errorColor
        }
    }
}

extension String {
    func validatePassword(focused: Bool) -> ValidationResult {
        if self.count >= 6 {
            return .ok
        } else if self.isEmpty {
            return .empty
        } else {
            return .failed
        }
    }

    func validateMobile(focused: Bool) -> ValidationResult {
        let mobileNumberRegEx = "^[1-9]{1}\\d{9}$"
        let mobileNumberPredicate = NSPredicate(format: "SELF MATCHES %@",
                                                mobileNumberRegEx)
        if mobileNumberPredicate.evaluate(with: self) {
            return .ok
        } else if self.isEmpty {
            return .empty
        } else {
            return .failed
        }
    }
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
        }
    }
}

