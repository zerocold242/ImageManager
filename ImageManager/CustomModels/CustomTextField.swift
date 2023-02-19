//
//  CustomTextField.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

import UIKit

class CustomTextField: UITextField {
    
    init(font: UIFont?, textColor: UIColor?, backgroundColor: UIColor?, placeholder: String?) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.placeholder = placeholder
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
        self.autocapitalizationType = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.clipsToBounds = true
        self.returnKeyType = UIReturnKeyType.done
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

