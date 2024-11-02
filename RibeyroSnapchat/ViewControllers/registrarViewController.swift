import UIKit
import Firebase

class registrarViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuración adicional, si es necesaria
    }
    
    @IBAction func iniciarSesion(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func crearUsuarioTapped(_ sender: UIButton) {
        // Validar campos
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            mostrarAlerta(titulo: "Error", mensaje: "Por favor, completa todos los campos.")
            return
        }
        
        // Crear un nuevo usuario en Firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error al crear usuario: \(error.localizedDescription)")
                // Mostrar un mensaje de error
                self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo crear el usuario: \(error.localizedDescription)")
            } else {
                print("Usuario creado exitosamente")
                // Almacenar información adicional del usuario en la base de datos
                if let user = authResult?.user {
                    Database.database().reference().child("usuarios").child(user.uid).child("email").setValue(user.email)
                }
                // Regresar a la pantalla de login o continuar en la app
                self.performSegue(withIdentifier: "crearUsuarioSuccessSegue", sender: self)
            }
        }
    }
    
    // Función para mostrar alertas
    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
}

