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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "Ficar", style: .default) { (action) in print("didPress stay") }

        let blockAction = UIAlertAction(title: "Sair", style: .destructive) { (action) in self.userLogout() }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in print("didPress cancel") }

        actionSheet.addAction(reportAction)
        actionSheet.addAction(blockAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func userLogout(){
        GIDSignIn.sharedInstance()?.signOut()
        self.performSegue(withIdentifier: "userLoggout", sender: nil)
    }
}

