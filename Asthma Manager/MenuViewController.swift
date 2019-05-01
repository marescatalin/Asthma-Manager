//
//  MenuViewController.swift
//  Asthma Manager
//
//  Created by Catalin Mares on 14/04/2019.
//

import Foundation
import Firebase
import UIKit
import CareKit
import FirebaseAuth

class MenuViewController: UIViewController{

    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } catch let err {
            print(err)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.hidesBackButton = true;        
    }
}
