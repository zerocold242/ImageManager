//
//  CustomButton.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

import UIKit

class CustomButton: UIButton {
    
    //замыкание принимающее действие для func buttonTaped
    var actionTap: () -> Void
    
    //инициализатор с основными параметрами кнопки
    init (title: String?, titleColor: UIColor, actionTap: @escaping () -> Void) {
        self.actionTap = actionTap
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .highlighted)
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        self.alpha = 0.7
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //функция передающая действия из замыкания
    @objc private func buttonTaped(_: UIButton) {
        actionTap()
        print("buttonTaped")
    }
}

