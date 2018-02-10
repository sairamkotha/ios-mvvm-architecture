//
//  RxTextfield.swift
//  LoginMVVM
//
//  Created by sairam kotha on 10/02/18.
//  Copyright © 2018 MVVMTest. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RxTextfield: UITextField {
    private let disposeBag = DisposeBag()
    var beingEdited: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    func commonInit() {
        rx.controlEvent(.editingDidBegin)
            .subscribe { [weak self] _ in
                self?.beingEdited = true
            }.disposed(by: disposeBag)

        rx.controlEvent(.editingDidEnd)
            .subscribe { [weak self] _ in
                self?.beingEdited = false
            }.disposed(by: disposeBag)
    }
}

extension Reactive where Base: RxTextfield {
    var beingEdited: ControlProperty<Bool> {
        return value
    }

    var value: ControlProperty<Bool> {
        return UIControl.valuePublic(
            base,
            getter: { textField in
                textField.beingEdited
        }, setter: { textField, value in
            textField.beingEdited = value
        }
        )
    }
}

extension UIControl {
    static func valuePublic<T, ControlType: UIControl>(_ control: ControlType, getter: @escaping (ControlType) -> T, setter: @escaping (ControlType, T) -> Void) -> ControlProperty<T> {
        let values: Observable<T> = Observable.deferred { [weak control] in
            guard let existingSelf = control else {
                return Observable.empty()
            }

            return (existingSelf as UIControl).rx.controlEvent([.allEditingEvents, .valueChanged, .editingDidEnd, .editingDidBegin])
                .flatMap { _ in
                    control.map { Observable.just(getter($0)) } ?? Observable.empty()
                }
                .startWith(getter(existingSelf))
        }
        return ControlProperty(values: values, valueSink: Binder(control) { control, value in
            setter(control, value)
        })
    }
}

