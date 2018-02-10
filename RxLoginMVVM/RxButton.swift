//
//  RxButton.swift
//  LoginMVVM
//
//  Created by sairam kotha on 10/02/18.
//  Copyright © 2018 MVVMTest. All rights reserved.
//

import UIKit

final class RxButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
