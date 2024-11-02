import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tablaSnaps: UITableView!
    
    var snaps: [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self

        guard let uid = Auth.auth().currentUser?.uid else {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener el UID del usuario", accion: "Aceptar")
            return
        }

        // Observar los snaps del usuario actual en la base de datos
        Database.database().reference().child("usuarios").child(uid).child("snaps").observe(.childAdded, with: { snapshot in
            // Aseguramos que los datos estén en el formato correcto
            if let snapData = snapshot.value as? [String: Any] {
                // Creamos un objeto Snap con los valores recuperados
                let snap = Snap()
                snap.imagenURL = snapData["imagenURL"] as? String ?? ""
                snap.from = snapData["from"] as? String ?? "Desconocido"
                snap.descrip = snapData["descripcion"] as? String ?? ""
                
                // Agregar el snap al arreglo y recargar la tabla
                self.snaps.append(snap)
                self.tablaSnaps.reloadData()
            } else {
                print("Error al convertir datos de snap")
            }
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Usar una celda reutilizable con un identificador
        let cell = tableView.dequeueReusableCell(withIdentifier: "SnapCell") ?? UITableViewCell(style: .default, reuseIdentifier: "SnapCell")
        let snap = snaps[indexPath.row]
        
        // Configurar el texto de la celda con el nombre del remitente
        cell.textLabel?.text = snap.from
        return cell
    }

    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        }
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
