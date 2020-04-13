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
    var nome: String = ""
    var email: String = ""
    var pictureUrl: String = ""

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
                if let currentUser = Auth.auth().currentUser {
                    //Informacao vinda do Oauth
//                    print(currentUser.displayName!)
                    // Informacao vinda do Google
//                    print(user.profile.name!)

                    let user = User(nome: currentUser.displayName!, email: currentUser.email!, pictureUrl: currentUser.photoURL!.absoluteString)
                    
                    if KeychainWrapper.standard.string(forKey: Keys.USERID.rawValue) == nil{
                        self.nome = user.nome
                        self.email = user.email
                        self.pictureUrl = user.pictureUrl
                        print("USERRR \(user)")
                        KeychainWrapper.standard.set(user.nome, forKey: Keys.USERNAME.rawValue)
                        KeychainWrapper.standard.set(user.email, forKey: Keys.EMAIL.rawValue)
                        KeychainWrapper.standard.set(user.pictureUrl, forKey: Keys.IMAGEM.rawValue)
                        
                        self.registerUser(user: user)
                        
                    } else {
                        
                        user.userId = KeychainWrapper.standard.string(forKey: Keys.USERID.rawValue)
                        self.updateUser(user: user)
                        
                    }
                }
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User has disconnected")
        mainLoaderController.stop()
        self.displayAlert()
    }
    
    func registerUser(user: User) {
        let postRequest = ApiResquest(endpoint: "registerUser")
        postRequest.postUser(user, completion: {result in
            switch result {
            case .success(let userResp):
                print("User: \(userResp)")
                let userId = userResp["userId"].stringValue
                KeychainWrapper.standard.set(userId, forKey: Keys.USERID.rawValue)
                self.updateUser(user: user)
            case .failure(let error):
                self.displayAlert()
                print("Error: \(error)")
            }
        })
    }
        
    func updateUser(user: User) {
        let postRequest = ApiResquest(endpoint: "updateUser")
        postRequest.postUser(user, completion: {result in
            switch result {
            case .success(let userResp):
                print("User Updated: \(userResp)")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "userLogged", sender: nil)
                }
            case .failure(let error):
                self.displayAlert()
                print("Erro: \(error)")
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
