//
//  Validation.swift
//  CombineLogin
//
//  Created by Anna Sibirtseva on 31/08/2022.
//

import Foundation

func passwordStrengthChecker(forPassword text: String) -> PasswordValidation {
    let password = text.count
    return password < 6 ? .short : .valid
}

func securityCodeChecker(forCode text: String) -> SecurityCodeValidation {
    let securityCode = text.count
    return securityCode % 3 != 0 ? .incorrectSecurityCode : .correctSecurtiyCode
}

func userNameChecker(forName text: String) -> UsernameValidation {
    let username = text.count
    if username == 0 {
        return .empty
    } else if username < 2 {
        return .short
    } else {
        return .valid
    }
}

public enum UsernameValidation {
    case empty
    case short
    case valid
    var errorMessage: String? {
        switch self {
        case .empty:
            return "Please enter username"
        case .short:
            return "Username should be at least 2 characters long"
        default:
            return nil
        }
    }
}

public enum SecurityCodeValidation {
    case incorrectSecurityCode
    case correctSecurtiyCode
    case empty
    var errorMessage: String? {
        switch self {
        case .incorrectSecurityCode:
            return "Please enter correct security code"
        case .empty:
            return "Please enter security code"
        default:
            return nil
        }
    }
}


public enum PasswordValidation {
    case empty
    case confirmPasswordEmpty
    case notMatch
    case short
    case valid

    var errorMessage: String? {
        switch self {
        case .short:
            return "Password should be longer than 6 characters"
        case .empty:
            return "Please enter password"
        default:
            return nil
        }
    }

    var confirmPasswordErrorMessage: String? {
        switch self {
        case .confirmPasswordEmpty:
            return "Please confirm password"
        case .notMatch:
            return "Passwords do not match"
        default:
            return nil
        }
    }
}
