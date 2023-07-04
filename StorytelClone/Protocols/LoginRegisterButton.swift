//
//  LoginRegisterButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/7/23.
//

import UIKit

protocol LoginRegisterButton: UIButton {
    var kind: LoginRegisterButtonKind { get }
}

enum LoginRegisterButtonKind: String {
    // Raw value is button text
    case appleLogin = "Sign in with Apple"
    case appleRegister = "Continue with Apple"
    
    case emailLogin = "Log in with E-mail"
    case emailRegister = "Create with E-mail"
            
    // MARK: Instance properties
    var buttonImage: UIImage? {
        var imageName: String
        switch self {
        case .appleLogin, .appleRegister: imageName = "apple.logo"
        case .emailLogin, .emailRegister: imageName = "envelope.circle.fill"
        }
        let image = UIImage(systemName: imageName)
        return image
    }
    
    // MARK: Instance methods
    func handleButtonDidTap() {
        switch self {
        case .appleLogin, .emailLogin: print("log in to user account")
        case .appleRegister, .emailRegister: print("creating user account")
        }
    }

}
