//
//  TextPicker.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

//Синглтон с методом создания универсального алерта с текстфилдом. Текст получаем из комплишн.

import UIKit

class TextPicker {
    
    static let defaultPicker = TextPicker()
    
    func getText(showTextPickerIn viewController: UIViewController,
                 title: String,
                 message: String,
                 completion: (( _ text: String) ->())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        
        let alertOK = UIAlertAction(title: "OK", style: .default) { alert in
            if let text = alertController.textFields?[0].text, text != "" {
                completion?(text)
            }
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        viewController.present(alertController, animated: true)
    }
}

