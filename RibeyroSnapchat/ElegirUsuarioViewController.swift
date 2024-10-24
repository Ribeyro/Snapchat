//
//  ElegirUsuarioViewController.swift
//  Snapchat
//
//  Created by Ribeyro Guzman on 23/10/24.
//

import UIKit

class ElegirUsuarioViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var listaUsuarios: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
