//
//  ViewController.swift
//  RibeyroSnapchat
//
//  Created by Ribeyro Guzman on 16/10/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseDatabase

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
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion:    {(user, error) in
                    print("Intentado crear un usuario")
                    if error != nil{
                        print("Se presento el siguienete error al crear el usuario: \(error)")
                    }else{
                        print("El usurio fue creado exitosamente")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        let alerta  = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.emailTextField.text!) se creo corectamente ", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in
                            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                        })
                        
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                    }
                })
            }else{
                print("inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    @IBAction func iniciarSesionAnonimaTapped(_ sender: Any) {
        // Intentar autenticación anónima
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("Error al iniciar sesión anónima: \(error.localizedDescription)")
                return
            }
            
            // El inicio de sesión fue exitoso
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            print("Usuario anónimo autenticado con UID: \(uid)")
        }
    }
    
    
    @IBAction func signInWithGoogleTapped(_ sender: UIButton) {
        print("Botón de Google Sign-In pulsado")
            
            // Obtén la configuración del cliente
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // Configura el objeto de configuración de Google Sign-In
            let config = GIDConfiguration(clientID: clientID)
            
            // Inicia el proceso de autenticación de Google
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    print("No se pudo obtener el token de ID de Google")
                    return
                }
                
                let accessToken = user.accessToken.tokenString
                
                // Crea credenciales de Firebase con el token de Google
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                // Autenticar con Firebase usando las credenciales de Google
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Error al autenticar con Firebase: \(error.localizedDescription)")
                        return
                    }
                    
                    // Usuario autenticado correctamente
                    print("Inicio de sesión con Google exitoso")
                    // Aquí puedes realizar la transición a otra pantalla o manejar el inicio de sesión exitoso.
                }
            }
    }
}
