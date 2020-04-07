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
        if let userName: String = KeychainWrapper.standard.string(forKey: Keys.USERNAME.rawValue){
            self.nameLabel.text = userName
            self.nameLabel.textAlignment = .center

        }
        if let userEmail: String = KeychainWrapper.standard.string(forKey: Keys.EMAIL.rawValue){
            self.emailLabel.text = userEmail
            self.emailLabel.textAlignment = .center
            
        }
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
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
        print("entrou")
        GIDSignIn.sharedInstance()?.signOut()
        print("Saiu")
        self.performSegue(withIdentifier: "userLoggout", sender: nil)
    }
    
    @IBAction func sendMail(_ sender: Any) {
        mailLoaderController.start()
    }
}

