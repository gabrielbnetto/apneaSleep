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
import SwiftyJSON

class ViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var mainImage: AnimationView!
    @IBOutlet weak var loginButton: UIButton!

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
            DispatchQueue.main.async {
                self.displayAlert()
                mainLoaderController.stop()
                return
            }
        }
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            
            if(error != nil){
                DispatchQueue.main.async {
                    self.displayAlert()
                    mainLoaderController.stop()
                    return
                }
            }else{
                if let currentUser = Auth.auth().currentUser {

                    let user = User(name: "Gabriel Netto", username: "gabrielbnettto@gmail.com", pictureUrl: currentUser.photoURL!.absoluteString, uid: "2")
//                    let user = User(name: currentUser.displayName!, username: currentUser.email!, pictureUrl: currentUser.photoURL!.absoluteString, uid: currentUser.uid)
                    
                        KeychainWrapper.standard.set(user.username, forKey: Keys.USERNAME.rawValue)
                        KeychainWrapper.standard.set(user.uid, forKey: Keys.UID.rawValue)
                        KeychainWrapper.standard.set(user.name, forKey: Keys.NAME.rawValue)
                        KeychainWrapper.standard.set(user.pictureUrl, forKey: Keys.IMAGEM.rawValue)
                        
                        self.authenticateUser(user: user)
                }
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User has disconnected")
        mainLoaderController.stop()
        self.displayAlert()
    }
    
    func authenticateUser(user: User) {
        let postRequest = ApiResquest(endpoint: "authenticate")
        postRequest.authenticateUser(user, completion: {result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "userLogged", sender: nil)
                }
            case false:
                DispatchQueue.main.async {
                    self.displayAlert()
                }
            }
        })
    }
    
    func displayAlert() {
        let alert = UIAlertController(title: "Erro", message: "Ocorreu um erro ao tentar entrar! Por favor, tente novamente em alguns segundos.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        mainLoaderController.stop()
    }
}
