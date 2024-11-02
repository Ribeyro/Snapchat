import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaUsuarios: UITableView!
    
    // Arreglo de usuarios
    var usuarios: [Usuario] = []
    
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
            if let usuarioData = snapshot.value as? [String: AnyObject] {
                if let email = usuarioData["email"] as? String {
                    // Crear el objeto Usuario
                    let usuario = Usuario(email: email, uid: snapshot.key)
                    
                    // Agregar el usuario al arreglo
                    self.usuarios.append(usuario)
                    
                    // Recargar los datos del TableView
                    self.listaUsuarios.reloadData()
                }
            }
        })
    }

    // Retorna el número de filas en la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    // Configura cada celda con el nombre de usuario
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "userCell")
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
}

