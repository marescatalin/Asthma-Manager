//
//  PatientTestScoresViewController.swift
//  Asthma Manager
//
//  Created by Catalin Mares on 24/04/2019.
//

import Foundation
import Firebase
import UIKit
import CareKit
import FirebaseAuth




class PatientTestScoresViewController : UIViewController{
     var usersDictionary:Dictionary<String, String> = [:]
     var res = [String]()
    
    @IBOutlet var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        messageTableView.delegate = self as? UITableViewDelegate
        messageTableView.dataSource = self as? UITableViewDataSource
        retrieveMessages()
    }
    
}


extension PatientTestScoresViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func retrieveMessages(){
        let messageDB = Database.database().reference().child("Scores")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            self.usersDictionary[snapshotValue["Patient"]!] = snapshotValue["Score"]!
            self.res = []
            for (key, value) in self.usersDictionary {
                self.res.append("\(key) -> \(value)/13")
            }
            self.messageTableView.reloadData()
        }
        }
    
   
    
    // Define no of rows in your tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return res.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Default cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell")! as UITableViewCell
        
        cell.textLabel!.text = "\(indexPath.row+1). \(res[indexPath.row])"
        
        return cell;
    }
    
}
