import UIKit
import FirebaseStorage
import FirebaseAuth

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePiker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var descripcionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePiker.delegate = self
        elegirContactoBoton.isEnabled = false
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePiker.sourceType = .savedPhotosAlbum
        imagePiker.allowsEditing = false
        present(imagePiker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        guard let imagenData = imageView.image?.jpegData(compressionQuality: 0.50) else {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo procesar la imagen seleccionada.", accion: "Aceptar")
            return
        }
        
        let cargarImagen = imagenesFolder.child("\(NSUUID().uuidString).jpg")
        cargarImagen.putData(imagenData, metadata: nil) { (metadata, error) in
            if let error = error {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen: \(error.localizedDescription)", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                return
            }
            
            cargarImagen.downloadURL { (url, error) in
                guard let enlaceURL = url else {
                    self.mostrarAlerta(titulo: "Error", mensaje: "Error al obtener la URL de la imagen", accion: "Aceptar")
                    self.elegirContactoBoton.isEnabled = true
                    return
                }
                
                // Realizar el segue con la URL de la imagen
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: enlaceURL.absoluteString)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePiker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seleccionarContactoSegue",
           let siguienteVC = segue.destination as? ElegirUsuarioViewController,
           let imagenURL = sender as? String {
            
            siguienteVC.imagenURL = imagenURL
            siguienteVC.descrip = descripcionTextField.text ?? "Sin descripción"
            
            // Capturar el email del usuario actual para enviarlo junto con el snap
            if let emailRemitente = Auth.auth().currentUser?.email {
                siguienteVC.fromEmail = emailRemitente
            }
        }
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
}

