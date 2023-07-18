//
//  LoginRegisterButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/7/23.
//

import UIKit

typealias LoginRegisterBtnDidTapCallback = (LoginRegisterButtonKind) -> ()

protocol LoginRegisterButton where Self: UIButton {
    var kind: LoginRegisterButtonKind { get }
    var didTapCallback: LoginRegisterBtnDidTapCallback { get set }
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
}
