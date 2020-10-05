//
//  ViewController.swift
//  AppleLogin
//
//  Created by Vivek Dharmani on 9/14/20.
//  Copyright © 2020 Vivek Dharmani. All rights reserved.
//

import UIKit
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func fbSignIn(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if error == nil{
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }else{
                print("Failed to login: \(error?.localizedDescription ?? "")")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
        }

    }
    func getFBUserData(){
        self.view.isUserInteractionEnabled = false
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    if let dict = result as? [String : AnyObject]{
                        if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                            
                            self.view.isUserInteractionEnabled = true
                            
                        }else{
                            let email = dict["email"] as? String
                            let first_name = dict["first_name"] as? String
                            let last_name = dict["last_name"] as? String
                            var image = ""
                            if let picture = dict["picture"] as? [String:Any]{
                                if let data = picture["data"] as? [String:Any]{
                                    if let url = data["url"] as? String{
                                        image = url
                                    }
                                }
                            }
                            let id = dict["id"] as? String
                        }
                    }
                    
                }else{
                    self.view.isUserInteractionEnabled = true
                    
                    
                }
            })
        }
        
    }

    
    @IBAction func googleSignIn(_ sender: Any) {
    }
    
    @available(iOS 13.0, *)
    @IBAction func appleSignIn(_ sender: Any) {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//            return
//        }
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
               // Create an account in your system.
               let userIdentifier = appleIDCredential.user
               let userFirstName = appleIDCredential.fullName?.givenName
               let userLastName = appleIDCredential.fullName?.familyName
               let userEmail = appleIDCredential.email
               let appleIDProvider = ASAuthorizationAppleIDProvider()
               appleIDProvider.getCredentialState(forUserID:userIdentifier) {  (credentialState, error) in
                    switch credentialState {
                       case .authorized:
                           // The Apple ID credential is valid.
                           debugPrint("The Apple ID credential is valid")
                           break
                       case .revoked:
                           // The Apple ID credential is revoked.
                           debugPrint("The Apple ID credential is revoked")

                           break
                    case .notFound:
                           // No credential was found, so show the sign-in UI.
                       break
                       default:
                           break
                    }
               }
               //Navigate to other view controller
           } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
               // Sign in using an existing iCloud Keychain credential.
               let username = passwordCredential.user
               let password = passwordCredential.password
               
               //Navigate to other view controller
           }
        
        
        
        
//        print("AppleID Crendential Authorization: userId: \(appleIDCredential.user), email: \(String(describing: appleIDCredential.email))")

    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Crendential failed with error: \(error.localizedDescription)")
    }
}

@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {
    func alert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
