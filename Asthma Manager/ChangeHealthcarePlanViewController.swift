//
//  ChangeHealthcarePlanViewController.swift
//  Asthma Manager
//  Created by Catalin Mares on 26/04/2019.
//

import Foundation
import Firebase
import UIKit
import CareKit
import FirebaseAuth

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ChangeHealthcarePlanViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
   
    
    
    var frequency = 1
    @IBOutlet weak var frequencyTextfield: UILabel!
    @IBOutlet weak var instructionsTextfield: UITextView!

    @IBOutlet var stepperValue: UIStepper!
    @IBOutlet weak var dosageTextfield: UITextField!
    @IBOutlet weak var activityForm: UIStackView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var titleTextfield: UITextField!
    
    var pickerData: [String] = [String]()
    var activities: [OCKCarePlanActivity] = [OCKCarePlanActivity]()
    let activityStartDate = DateComponents(year: 2019, month: 4, day: 1)
    let calendar = Calendar(identifier: .gregorian)
    lazy var monthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    var today: Date {
        return Date()
    }
    
    lazy var carePlanStore: OCKCarePlanStore = {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[0].appendingPathComponent("carePlanStore")
        
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        let store = OCKCarePlanStore(persistenceDirectoryURL: url)
        return store
    }()
    override func viewDidLoad() {
        
        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        fetchActivities()
        pickerView.isHidden = true
        activityForm.isHidden = false
       self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
       
        
        
}
    
   
    
   
    
    
    func fetchActivities(){
        self.activities = []
        self.pickerData = []
        
        carePlanStore.activities { (_, array, error) in
            DispatchQueue.global(qos: .utility).async {
                
                for activity in array {
                    if activity.title != "Peak Flow Score"{
                        self.activities.append(activity)
                        self.pickerData.append(activity.title)

                    }
                }
                DispatchQueue.main.async {
                    // now update UI on main thread
                    self.pickerView.reloadAllComponents()
                    self.pickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
           
        }

    }
    
    
    
    func removeActivity(activity: OCKCarePlanActivity) {
        carePlanStore.remove(activity) { (_, error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }
    
    
    
    func addActivity(activity: OCKCarePlanActivity) {
        carePlanStore.add(activity) { (_, error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
    }
    
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }
    
    
    
    func createActivity(title: String, text: String,instructions: String, schedule: String) -> OCKCarePlanActivity {
        let schedule = OCKCareSchedule.dailySchedule(withStartDate: activityStartDate,
                                                     occurrencesPerDay: UInt(schedule)!,
                                                     daysToSkip: 0,
                                                     endDate: nil)
        
        let activity = OCKCarePlanActivity(identifier: title,
                                           groupIdentifier: nil,
                                           type: .intervention,
                                           title: title,
                                           text: text,tintColor: UIColor.flatRed(),
                                           instructions: instructions,
                                           imageURL: nil,
                                           schedule: schedule,
                                           resultResettable: true,
                                           userInfo:nil)
        return activity
    }
    
    @IBAction func toggleView(_ sender: Any) {
        if (segmentControl.selectedSegmentIndex == 0){
            activityForm.isHidden = false
            pickerView.isHidden = true
            button.setTitle("Add", for: .normal)
            button.backgroundColor = UIColor.green
        }else{
            activityForm.isHidden = true
            pickerView.isHidden = false
            button.setTitle("Delete", for: .normal)
            button.backgroundColor = UIColor.red
        }
    }
    
    func clearTextFields(){
        stepperValue.value = 1.0
        frequency = Int(stepperValue.value)
        titleTextfield.text! = ""
        dosageTextfield.text! = ""
        frequencyTextfield.text! = "Daily frequency: \(frequency)"
        instructionsTextfield.text! = "Instructions"
        
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        frequency = Int(sender.value)
        frequencyTextfield.text = "Daily frequency: \(frequency)"
    }
    
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        let selection = pickerData[pickerView.selectedRow(inComponent: 0)]
        
        if segmentControl.selectedSegmentIndex == 0{
        let activity = createActivity(title:  titleTextfield.text!, text: dosageTextfield.text!, instructions: instructionsTextfield.text!, schedule: String(frequency))
        addActivity(activity: activity)
        let alert = UIAlertController(title: "Complete", message: "A new action has been added to your asthma action plan.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        self.fetchActivities()
        clearTextFields()
        }
        
        
        if segmentControl.selectedSegmentIndex == 1{
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete \(selection) from your asthma action plan?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
           
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak alert] (_) in
                for activity in self.activities{
                    if activity.title == selection{
                        self.removeActivity(activity: activity)
                        self.fetchActivities()
                        let alert = UIAlertController(title: "Complete", message: "The action has been deleted succesfully from your asthma action plan.", preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
}
