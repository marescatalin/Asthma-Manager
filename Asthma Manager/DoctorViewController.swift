//
//  DoctorViewController.swift
//  Asthma Manager
//
//  Created by Catalin Mares on 24/04/2019.
//

import Foundation
import Firebase
import UIKit
import CareKit
import FirebaseAuth

class DoctorViewController : UIViewController{

    override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.hidesBackButton = true;
}
    @IBAction func logOff(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            print("signed out")
        } catch let err {
            print(err)
        }
    }
    
}
