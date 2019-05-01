//
//  RegisterDoctorViewController.swift
//  Asthma Manager
//  Created by Catalin Mares on 26/04/2019.
//

import Foundation
import Firebase
import UIKit
import CareKit
import SVProgressHUD
import FirebaseAuth

class RegisterDoctorViewController: UIViewController{
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerDoctor(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                print(error!)
            }else{
                 let userlevelDB = Database.database().reference().child("UserLevel")
                let userlevelDictionary = ["Email" : self.emailTextfield.text!, "UserLevel" : "doctor"]
                userlevelDB.childByAutoId().setValue(userlevelDictionary){
                    (error, reference) in
                    if error != nil {
                        print(error!)
                    }
                    else{
                        print("UserLevel was saved succesfully!")
                    }
                }
                SVProgressHUD.dismiss()
                print("User created succesfully")
                let alert = UIAlertController(title: "Account created", message: "New doctor account for the user with email \( self.emailTextfield.text!) has been created succesfully!", preferredStyle: UIAlertController.Style.alert)
                let returnToMenu = UIAlertAction(title: "Return to menu", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                    
                }
                // add the actions (buttons)
                alert.addAction(returnToMenu)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                self.emailTextfield.text = ""
                self.passwordTextfield.text = ""
                // create the alert
                
            }
            
        }
        
    }
    
}
