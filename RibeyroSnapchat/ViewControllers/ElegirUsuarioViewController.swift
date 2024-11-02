import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaUsuarios: UITableView!
    
    var usuarios: [Usuario] = []
    var imagenURL = ""
    var descrip = ""
    var fromEmail = ""  // Email del remitente que envía el snap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Asignamos los delegados y dataSource
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        
        print("Intentando cargar usuarios...")
        
        // Observa los datos de Firebase en el nodo "usuarios"
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: { (snapshot) in
            print(snapshot)
            
            // Extraer los datos del snapshot
            if let usuarioData = snapshot.value as? [String: AnyObject],
               let email = usuarioData["email"] as? String {
                // Crear el objeto Usuario
                let usuario = Usuario(email: email, uid: snapshot.key)
                
                // Agregar el usuario al arreglo
                self.usuarios.append(usuario)
                
                // Recargar los datos del TableView
                self.listaUsuarios.reloadData()
            }
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "userCell")
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        
        // Crear el snap con el email del remitente en "from"
        let snap = [
            "from": fromEmail,              // El email del remitente que envía el snap
            "descripcion": descrip,         // La descripción del snap
            "imagenURL": imagenURL          // URL de la imagen
        ]
        
        // Guardar el snap en Firebase bajo el usuario seleccionado
        Database.database().reference().child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
    }
}
