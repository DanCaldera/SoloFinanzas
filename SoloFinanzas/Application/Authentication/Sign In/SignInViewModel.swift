//
//  SignInViewModel.swift
//  SoloFinanzas
//
//  Created by Daniel Caldera on 13/12/19.
//  Copyright © 2019 Platzi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit

typealias SignInHandler = ( (_ success: Bool, _ error: Error?) -> Void )

class SignInViewModel {

    static func signInWith(email: String?, password: String?, handler: SignInHandler?) {
        guard let email = email,
            validate(text: email, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") else {
                return
        }
        
        print(email)
        
        guard let password = password,
            validate(text: password, regex:
                "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$") else {
                return
        }
        
        print(password)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                handler?(false, error)
            }
            
            if result != nil {
                handler?(true, nil)
            }
        }
        
    }
    
    static private func validate(text: String, regex: String) -> Bool {
        let range = NSRange(location: 0, length: text.count)
        let regex = try? NSRegularExpression(pattern: regex)
        return regex?.firstMatch(in: text, options: [], range: range) != nil
    }
    
    static func facebookLogin(viewController: UIViewController, handler: SignInHandler?) {
        LoginManager().logIn(permissions: ["email"], from: viewController) { (result, error) in
            if let error = error {
                handler?(false, error)
                return
            }
            
            guard let token = AccessToken.current?.tokenString else { return }
            let credentials = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signIn(with: credentials, completion: { (authResult, error) in

                handler?(true, nil)
            })
            /*let credentials = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authResult, error) in

                handler?(true, nil)
            })*/
        }
    }
}
