//
//  LogInViewController.swift
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD
import FirebaseAuth

class LogInViewController: UIViewController {
    var usersDictionary:Dictionary<String, String> = [:]
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let messageDB = Database.database().reference().child("UserLevel")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            self.usersDictionary[snapshotValue["Email"]!] = snapshotValue["UserLevel"]!
            print(self.usersDictionary)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let alert = UIAlertController(title: "Reset password", message: "Enter your email", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send reset link", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            Auth.auth().sendPasswordReset(withEmail: textField!.text!) { error in
                // create the alert
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
    
    func clearTextFields(){
        self.emailTextfield.text = ""
        self.passwordTextfield.text = ""
    }
   
    @IBAction func logInPressed(_ sender: AnyObject) {
        //Show loading circle
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error == nil{
                SVProgressHUD.dismiss()
                
                //go to doctor or patient screen
                if self.usersDictionary[self.emailTextfield.text!]! == "patient"{
                    self.performSegue(withIdentifier: "goToPatientMenu", sender: self)
                }else{
                    self.performSegue(withIdentifier: "goToDoctorMenu", sender: self)
                }
                
                //clear email and password fields
                self.clearTextFields()              
            }
            else{
                SVProgressHUD.dismiss()
                self.passwordTextfield.text = ""
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    


    
}  
