//
//  SignupViewController.swift
//  FoodTracker
//
//  Created by Luiz on 6/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit



class SignupViewController: UIViewController {
    
    @IBOutlet weak var user: UITextField!

    @IBOutlet weak var password: UITextField!

    lazy var keychainManager = KeychainManager()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        view.endEditing(true)
        guard let usertxt = user.text  , usertxt.count > 0 else {
            return
        }

        guard let passwordtxt = password.text, passwordtxt.count > 0 else {
            return
        }

        do {
            try keychainManager.set(string: usertxt, forKey: "user")
            try keychainManager.set(string: passwordtxt, forKey: "password")
        } catch let keychainError as KeychainManagerError {
            print("Could not store credentials in the keychain. \(keychainError)")
        } catch {
            print(error)
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
