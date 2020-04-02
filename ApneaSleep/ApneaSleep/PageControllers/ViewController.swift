//
//  ViewController.swift
//  ApneaSleep
//
//  Created by Banco Santander Brasil on 03/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class ViewController: UIViewController, GIDSignInDelegate {

//    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        signInButton.imageEdgeInsets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 20)
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @IBAction func signInButtonClicked() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            
            if(error != nil){
                return
            }else{
                print("Entrou")
                self.performSegue(withIdentifier: "userLogged", sender: nil)
                if let currentUser = Auth.auth().currentUser {
                    //Informacao vinda do Oauth
                    print(currentUser.photoURL!)
                    print("@@@@@@@@@")
                    // Informacao vinda do Google
                    print(user.profile.givenName!)
                }
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User has disconnected")
    }
}
