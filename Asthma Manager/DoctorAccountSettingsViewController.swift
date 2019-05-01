//
//  DoctorAccountSettingsViewController.swift
//  Asthma Manager
//  Created by Catalin Mares on 14/04/2019.
//

import Foundation
import Firebase
import UIKit
import CareKit
import FirebaseAuth

class DoctorAccountSettingsViewController: UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func resetPassword(_ sender: Any) {
        let alert = UIAlertController(title: "Reset password", message: "Are you sure you want to reset your password?", preferredStyle: .alert)
        
        
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send reset link", style: .default, handler: { [weak alert] (_) in
            Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { error in
                let alert = UIAlertController(title: "Password link sent", message: "Your reset link has been sent to you to the email address provided.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func deleteAccount(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertController.Style.alert)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let user = Auth.auth().currentUser
            user?.delete { error in
                if error != nil {
                    print("An error occured")
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                    print("Account deleted")
                    
                }
            }
            
        }
        // add the actions (buttons)
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
