//
//  LoginInspector.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

import Foundation
import KeychainAccess

class LoginInspector {
    
    let keychain = Keychain(service: "netology.SandBoxDemo")
    static let shared = LoginInspector()
    
    //вход с сохраненным паролем
    func logIn(password: String, completion: @escaping (Bool) -> Void ) {
        if keychain[password] != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    //сохранение нового пароля
    func signUp(password: String, completion: @escaping () -> Void ) {
        keychain[password] = password
        completion()
    }
    
    //удаление сохраненного пароля
    func removePassword() {
        try! keychain.removeAll()
    }
}

