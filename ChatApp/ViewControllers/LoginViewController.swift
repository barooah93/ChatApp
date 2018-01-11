//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Brandon Barooah on 1/10/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func loginPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "chatRoom", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatRoom" {
            if let des = segue.destination as? ViewController {
                des.userName = nameTextField.text
            }
        }
    }
    

}
