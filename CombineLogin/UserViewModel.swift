//
//  UserViewModel.swift
//  CombineLogin
//
//  Created by Anna Sibirtseva on 31/08/2022.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {

    @Published private var username: String = ""
    @Published private var securityCode: String = ""
    @Published private var password: String = ""
    @Published private var confirmPassword: String = ""

    @Published private var usernameValidator = UsernameValidation.empty
    @Published private var passwordValidator = PasswordValidation.empty
    @Published private var securityCodeValidator = SecurityCodeValidation.empty
    @Published private var isValid: Bool = false
    @Published private var userNameError: String?
    @Published private var securityCodeError: String?
    @Published private var passwordError: String?
    @Published private var confirmPasswordError: String?

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        Publishers.CombineLatest4(self.validUserNamePublisher,
                                  self.validSecurityCodePublisher,
                                  self.passwordValidatorPublisher,
                                  self.confirmPasswordValidatorPublisher)
        .dropFirst()
        .sink { _usernameValidator, _securityCodeValidator, _passwordValidator , _confirmPasswordValidator in

            self.isValid =
            _usernameValidator.errorMessage == nil &&
            _securityCodeValidator.errorMessage == nil &&
            _passwordValidator.errorMessage == nil &&
            _confirmPasswordValidator.confirmPasswordErrorMessage == nil
        }
        .store(in: &cancellableSet)

        validUserNamePublisher
            .dropFirst()
            .sink { (_usernameValidator) in
                self.userNameError = _usernameValidator.errorMessage
            }
            .store(in: &cancellableSet)

        validSecurityCodePublisher
            .dropFirst()
            .sink { (_securityCodeValidator) in
                self.securityCodeError = _securityCodeValidator.errorMessage
            }
            .store(in: &cancellableSet)

        passwordValidatorPublisher
            .dropFirst()
            .sink { (_passwordValidator) in
                self.passwordError = _passwordValidator.errorMessage
            }
            .store(in: &cancellableSet)

        confirmPasswordValidatorPublisher
            .dropFirst()
            .sink { (_passwordValidator) in
                self.confirmPasswordError = _passwordValidator.confirmPasswordErrorMessage
            }
            .store(in: &cancellableSet)
    }

    private var validUserNamePublisher: AnyPublisher<UsernameValidation, Never> {
        $username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { username in
                if username.isEmpty {
                    return .empty
                } else {
                    return userNameChecker(forName: username)
                }
            }
            .eraseToAnyPublisher()
    }

    private var validSecurityCodePublisher: AnyPublisher<SecurityCodeValidation, Never> {
        $securityCode
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { securityCode in
                if securityCode.isEmpty {
                    return .empty
                } else {
                    return securityCodeChecker(forCode: securityCode)
                }
            }
            .eraseToAnyPublisher()
    }

    private var passwordValidatorPublisher: AnyPublisher<PasswordValidation, Never> {
        $password
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { password in
                if password.isEmpty {
                    return .empty
                } else {
                    return passwordStrengthChecker(forPassword: password)
                }
            }
            .eraseToAnyPublisher()
    }

    private var confirmPasswordValidatorPublisher: AnyPublisher<PasswordValidation, Never> {
        $confirmPassword
            .debounce(for: 0.0, scheduler: RunLoop.main)
            .map { confirmPassword in
                if confirmPassword.isEmpty {
                    return .confirmPasswordEmpty
                } else if self.password != confirmPassword {
                    return .notMatch
                } else {
                    return .valid
                }
            }
            .eraseToAnyPublisher()
    }
}


