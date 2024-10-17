//
//  ViewController.swift
//  RibeyroSnapchat
//
//  Created by Ribeyro Guzman on 16/10/24.
//

import UIKit
import FirebaseAuth

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user, error ) in
            print("Intentando Iniciar Sesion")
            if error != nil{
                print("Se presento el siguienete error \(error)")
            }else{
                print("inicio de sesion exitoso")
            }
        }
    }

}

