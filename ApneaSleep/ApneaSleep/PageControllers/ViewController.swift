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
import Pastel
import Loaf

class ViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var mainImage: AnimationView!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.imageEdgeInsets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 20)
        GIDSignIn.sharedInstance().delegate = self
        startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        startPastelColors()
    }
    
    func startPastelColors(){
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])

        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
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
//        let user = User(name: "Gabriel Netto", username: "gabrielbnettto@gmail.com", pictureUrl: "12345", uid: "2")
//        self.performSegue(withIdentifier: "userLogged", sender: nil)
//        self.authenticateUser(user: user)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        mainLoaderController.start()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            DispatchQueue.main.async {
                self.displayAlert()
                return
            }
        }

        if(user == nil){
            self.displayAlert()
            return
        }
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            
            if(error != nil){
                DispatchQueue.main.async {
                    self.displayAlert()
                    return
                }
            }else{
                if let currentUser = Auth.auth().currentUser {

                    let user = User(name: currentUser.displayName!, username: currentUser.email!, pictureUrl: currentUser.photoURL!.absoluteString, uid: currentUser.uid)
                    
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
        DispatchQueue.main.async {
            self.displayAlert()
        }
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
        Loaf("Ocorreu um erro ao tentar entrar! Por favor, tente novamente em alguns segundos.", state: .error, sender: self).show()
    }
}
