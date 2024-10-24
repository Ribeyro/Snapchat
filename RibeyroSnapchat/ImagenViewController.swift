//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Ribeyro Guzman on 23/10/24.
//

import UIKit
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(NSUUID().uuidString).jpg").putData(imagenData!, metadata: nil){
            (metadata, error ) in
            if error != nil{
                self.mostrarAlerta(titulo: "error", mensaje: "se produjo un eerror al subir la imagen", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                
                print("ocurrio un error al subir la imagen \(error)")
            }else{
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
            }
        }
        // Crea una alerta para mostrar el progreso de la carga
        let alertaCarga = UIAlertController(title: "Cargando imagen ...", message: "0%", preferredStyle: .alert)
        let progresoCarga: UIProgressView = UIProgressView(progressViewStyle: .default)
        progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
        alertaCarga.view.addSubview(progresoCarga)
        
        // Observa el progreso de la carga
        cargarImagen.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress else { return }
            let porcentaje = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            print(porcentaje)
            
            // Actualiza la barra de progreso y el mensaje de la alerta
            progresoCarga.setProgress(Float(porcentaje), animated: true)
            alertaCarga.message = "\(Int(round(porcentaje * 100)))%"
            
            // Si la carga está completa, cierra la alerta
            if porcentaje >= 1.0 {
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        
        // Añade el botón "Aceptar" a la alerta
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        
        // Presenta la alerta al usuario
        present(alertaCarga, animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePiker.dismiss(animated: true, completion: nil)
    }
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //  let imagenesFolder = Storage.storage().reference().child("imagenes")
    //   let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
    //  imagenesFolder.child("imagenes.jpg").putData(imagenData!, metadata: nil){
    //       (metadata, error ) in
    //     if error != nil{
    //          print("ocurrio un error al subir la imagen \(error)")
    //      }
    //   }
    //}
    
    
    // Función para mostrar una alerta con un mensaje personalizado
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        
        
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    
}


