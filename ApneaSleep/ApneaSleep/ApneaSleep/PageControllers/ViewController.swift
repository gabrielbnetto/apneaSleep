//
//  ViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 03/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import SwiftKeychainWrapper
import Lottie

class ViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var mainImage: AnimationView!
    @IBOutlet weak var loginButton: UIButton!
    var firstName: String = ""
    var name: String = ""
    var email: String = ""
    var pictureUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.imageEdgeInsets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 20)
        GIDSignIn.sharedInstance().delegate = self
        startAnimation()
    }
    
    func startAnimation() {
        let checkMarkAnimation =  AnimationView(name: "mainImage")
        mainImage.contentMode = .scaleAspectFit
        self.mainImage.addSubview(checkMarkAnimation)
        checkMarkAnimation.frame = self.mainImage.bounds
        checkMarkAnimation.loopMode = .loop
        checkMarkAnimation.play()
    }
    
    @IBAction func signInButtonClicked() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        mainLoaderController.start()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            mainLoaderController.stop()
            return
        }
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            
            if(error != nil){
                mainLoaderController.stop()
                return
            }else{
                print("Entrou")
                self.performSegue(withIdentifier: "userLogged", sender: nil)
                if let currentUser = Auth.auth().currentUser {
                    //Informacao vinda do Oauth
//                    print(currentUser.displayName!)
                    // Informacao vinda do Google
//                    print(user.profile.name!)

                    self.name = (currentUser.displayName)!
                    self.email = (currentUser.email)!
                    self.pictureUrl = (currentUser.photoURL!.absoluteString)
                    
                    KeychainWrapper.standard.set(self.name, forKey: Keys.USERNAME.rawValue)
                    KeychainWrapper.standard.set(self.email, forKey: Keys.EMAIL.rawValue)
                    KeychainWrapper.standard.set(self.pictureUrl, forKey: Keys.IMAGEM.rawValue)
                }
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User has disconnected")
        mainLoaderController.stop()
        let alert = UIAlertController(title: "Erro", message: "Ocorreu um erro ao tentar entrar! Por favor, tentar novamente em alguns segundos.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
