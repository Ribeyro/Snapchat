//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Ribeyro Guzman on 2/11/24.
//

import UIKit
import SDWebImage



class VerSnapViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMensaje: UITextField!
    var snap = Snap()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMensaje.text = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
    }
}
