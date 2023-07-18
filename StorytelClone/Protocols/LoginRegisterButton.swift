//
//  LoginRegisterButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/7/23.
//

import UIKit

protocol LoginRegisterButton where Self: UIButton {
    var kind: LoginRegisterButtonKind { get }
}

enum LoginRegisterButtonKind: String {
    // Raw value is button text
    case appleLogin = "Sign in with Apple"
    case appleRegister = "Continue with Apple"
    
    case emailLogin = "Log in with E-mail"
    case emailRegister = "Create with E-mail"
    
    case googleLogin = "Log in with Google"
    case googleRegister = "Continue with Google"
    
    case facebookLogin = "Log in with Facebook"
    case facebookRegister = "Create with Facebook"
    
    // MARK: Instance properties
    var buttonImage: UIImage? {
        var systemImageName: String = ""
        var customImageName: String = ""
        
        switch self {
        case .appleLogin, .appleRegister: systemImageName = "apple.logo"
        case .emailLogin, .emailRegister: systemImageName = "envelope.circle.fill"
        case .googleLogin, .googleRegister: customImageName = "googleLogo"
        case .facebookLogin, .facebookRegister: customImageName = "facebookLogo"
        }
        
        let image = !systemImageName.isEmpty ? UIImage(systemName: systemImageName) : UIImage(named: customImageName)
        return image
    }
    
    // MARK: Instance methods
    func handleButtonDidTap() {
        switch self {
        case .appleLogin, .emailLogin, .googleLogin, .facebookLogin:
            print("log in to user account")
        case .appleRegister, .emailRegister, .googleRegister, .facebookRegister:
            print("creating user account")
        }
    }
}
