//
//  ProfileViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 10/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userImage: String = KeychainWrapper.standard.string(forKey: Keys.IMAGEM.rawValue){
            setImage(from: userImage)
        }
        if let userName: String = KeychainWrapper.standard.string(forKey: Keys.NAME.rawValue){
            self.nameLabel.text = userName
        }
        if let userEmail: String = KeychainWrapper.standard.string(forKey: Keys.USERNAME.rawValue){
            self.emailLabel.text = userEmail
        }
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    @IBAction func logoutButton() {
        let alert = UIAlertController(title: "Logout", message: "Tem certeza que deseja sair de sua conta?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Sair", style: UIAlertAction.Style.default, handler: { action in self.userLogout() }))
        alert.addAction(UIAlertAction(title: "Ficar", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func userLogout(){
        GIDSignIn.sharedInstance()?.signOut()
        self.performSegue(withIdentifier: "userLoggout", sender: nil)
    }
    
    @IBAction func sendMail(_ sender: Any) {
        mailLoaderController.start()
//        let getRequest = ApiResquest(endpoint: "sendAudioDataEmail")
//        getRequest.get(completion: {result in
//            switch result {
//                case .success( _):
//                    DispatchQueue.main.async{
//                        mailLoaderController.stop()
//                        self.displayAlert(title: "Sucesso", message: "Email enviado com sucesso!")
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async{
//                        mailLoaderController.stop()
//                        self.displayAlert(title: "Erro", message: "Ocorreu um erro ao enviar email! Por favor, tente novamente em alguns segundos.")
//                        print(error)
//                    }
//            }
//        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            mailLoaderController.stop()
        }
    }
    
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

