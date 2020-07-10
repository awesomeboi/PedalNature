//
//  TextFieldExtension.swift
//  PedalNature
//
//  Created by Volkan Sahin on 17.03.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func loadDropdownData(data: [String]) {
        self.inputView = MyPickerView(pickerData: data, dropdownField: self)
    }
}
