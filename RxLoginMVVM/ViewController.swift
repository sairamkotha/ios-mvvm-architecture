//
//  ViewController.swift
//  RxLoginMVVM
//
//  Created by sairam kotha on 10/02/18.
//  Copyright © 2018 MVVMTest. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    @IBOutlet private weak var mobileNumberLabel: UILabel!
    @IBOutlet private weak var mobileNumberTextfield: RxTextfield!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var passwordTextfield: RxTextfield!
    @IBOutlet private weak var loginButton: RxButton!
    private var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel(mobile: (text: mobileNumberTextfield.rx.text.orEmpty.asDriver(),
                                            focused: mobileNumberTextfield.rx.beingEdited.asDriver()),
                                   password: (text: passwordTextfield.rx.text.orEmpty.asDriver(),
                                              focused: passwordTextfield.rx.beingEdited.asDriver()),
                                   loginTaps: loginButton.rx.tap.asDriver())
        bindToRx()
        loginButton.layer.cornerRadius = 4.0
    }

    private func bindToRx() {
        viewModel.loginEnabled
            .asObservable()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.validatedMobile
            .asObservable()
            .skip(1)
            .bind(to: mobileNumberLabel.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.validatedPassword
            .asObservable()
            .bind(to: passwordLabel.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.loginStatus
            .asObservable()
            .subscribe(onNext: { [weak self] (status) in
                let alertmessage: String
                switch status {
                case let .failed(message):
                    alertmessage = message
                    break
                case .loggedin:
                    alertmessage = "User loggedin"
                    break
                case .signup:
                    alertmessage = "User need to signup"
                    break
                }
                self?.showAlert(alertmessage)
            })
            .disposed(by: disposeBag)
    }

    private func showAlert(_ message: String) {
        guard message.isEmpty == false else {
            return
        }
        let controller = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        controller.addAction(defaultAction)
        self.present(controller, animated: true, completion: nil)
    }
}
