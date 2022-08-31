//
//  ViewController.swift
//  CombineLogin
//
//  Created by Anna Sibirtseva on 31/08/2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var securityCode: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @Published private var nameText: String = ""
    @Published private var securityCodeText: Int = 0
    @Published private var passwordText: String = ""
    @Published private var confirmPasswordText: String = ""

    private var stream: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        stream = validToSubmit
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
    }

    @IBAction private func nameChanged(_ sender: UITextField) {
        nameText = sender.text ?? ""
    }

    @IBAction private func securityCodeChanged(_ sender: UITextField) {
        securityCodeText = Int(sender.text ?? "0") ?? 0
    }

    @IBAction private func passwordChanged(_ sender: UITextField) {
        passwordText = sender.text ?? ""
    }

    @IBAction private func confirmPasswordChanged(_ sender: UITextField) {
        confirmPasswordText = sender.text ?? ""
    }

    private var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4( $nameText, $securityCodeText, $passwordText, $confirmPasswordText)
            .map { name, code, password, confirmPassword in
                !name.isEmpty &&
                code % 3 == 0 &&
                !password.isEmpty &&
                !confirmPassword.isEmpty &&
                password.count >= 6 &&
                password == confirmPassword

            }.eraseToAnyPublisher()
    }
}

