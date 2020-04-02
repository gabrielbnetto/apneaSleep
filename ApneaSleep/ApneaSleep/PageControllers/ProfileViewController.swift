//
//  ProfileViewController.swift
//  ApneaSleep
//
//  Created by Banco Santander Brasil on 10/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage(from: "https://media.gettyimages.com/photos/colorful-powder-explosion-in-all-directions-in-a-nice-composition-picture-id890147976?s=612x612")
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
}
