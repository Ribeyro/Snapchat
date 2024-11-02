import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseDatabase
import Firebase

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        // Validar campos de entrada
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            mostrarAlerta(titulo: "Campos vacíos", mensaje: "Por favor, completa ambos campos.")
            return
        }

        // Intentar iniciar sesión con Firebase
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            print("Intentando iniciar sesión...")
            
            if let error = error {
                print("Error al intentar iniciar sesión: \(error.localizedDescription)")
                
                // Mostrar alerta de opciones, incluso si hay un error
                self.mostrarAlertaUsuarioNoExiste()
                return
            }
            
            // Inicio de sesión exitoso
            print("Inicio de sesión exitoso")
            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
        }
    }

    // Función para mostrar la alerta cuando hay un error
    func mostrarAlertaUsuarioNoExiste() {
        let alerta = UIAlertController(title: "Error", message: "Ha ocurrido un error. ¿Deseas crear un nuevo usuario o iniciar sesión con Google?", preferredStyle: .alert)
        
        // Botón "Crear"
        let crearAction = UIAlertAction(title: "Crear", style: .default) { action in
            self.performSegue(withIdentifier: "crearUsuarioSegue", sender: self)
        }
        alerta.addAction(crearAction)
        
        // Botón "Iniciar sesión con Google"
        let googleAction = UIAlertAction(title: "Iniciar sesión con Google", style: .default) { action in
            self.signInWithGoogleTapped(UIButton())
        }
        alerta.addAction(googleAction)
        
        // Botón "Cancelar"
        let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerta.addAction(cancelarAction)
        
        // Mostrar la alerta
        self.present(alerta, animated: true, completion: nil)
    }



    // Función para mostrar alertas genéricas
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alerta.addAction(btnOK)
        self.present(alerta, animated: true, completion: nil)
    }
    
    // Otras acciones de inicio de sesión (anónima y Google Sign-In)
    @IBAction func iniciarSesionAnonimaTapped(_ sender: Any) {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("Error al iniciar sesión anónima: \(error.localizedDescription)")
                return
            }
            guard let user = authResult?.user else { return }
            print("Usuario anónimo autenticado con UID: \(user.uid)")
        }
    }
    
    @IBAction func signInWithGoogleTapped(_ sender: UIButton) {
        print("Botón de Google Sign-In pulsado")
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
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
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error al autenticar con Firebase: \(error.localizedDescription)")
                    return
                }
                print("Inicio de sesión con Google exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
}

