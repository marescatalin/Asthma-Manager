//
//  RegisterViewController.swift
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD
import FirebaseAuth

class RegisterViewController: UIViewController {

    
    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        //While the closure is executed, show a loading tab to improve user interaction
        SVProgressHUD.show()
        //Set up a new user in Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                print(error!)
            }
            else{
                //Dismiss loading tab as soon as the user has been created succesfully
                let userlevelDB = Database.database().reference().child("UserLevel")
                let peakFlowScoresDB = Database.database().reference().child("PeakFlowScores")
                let userlevelDictionary = ["Email" : self.emailTextfield.text!, "UserLevel" : "patient"]
                 let peakFLowScoreDictionary = ["Email" : self.emailTextfield.text!, "PeakFlowScore" : "500"]
                userlevelDB.childByAutoId().setValue(userlevelDictionary){
                    (error, reference) in
                    if error != nil {
                        print(error!)
                    }
                    else{
                        print("UserLevel was saved succesfully!")
                    }
                }
                
                peakFlowScoresDB.childByAutoId().setValue(peakFLowScoreDictionary){
                    (error, reference) in
                    if error != nil {
                        print(error!)
                    }
                    else{
                        print("PeakFlowScore was saved succesfully!")
                    }
                }
                SVProgressHUD.dismiss()
                //Debug message to be printed in console
                print("User created succesfully")
                self.emailTextfield.text = ""
                self.passwordTextfield.text = ""
                self.performSegue(withIdentifier: "goToMenu", sender: self)
                
            }
        }
    } 
    
    
}
