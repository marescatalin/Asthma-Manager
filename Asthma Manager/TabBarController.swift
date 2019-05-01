import CareKit
import Firebase
import FirebaseAuth

class TabBarController: UITabBarController {
    var normalPeakFlowScore = 582

    lazy var carePlanStore: OCKCarePlanStore = {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[0].appendingPathComponent("carePlanStore")
        
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        let store = OCKCarePlanStore(persistenceDirectoryURL: url)
        store.delegate = self
        return store
    }()
    
    
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
    
    var insights: OCKInsightsViewController!
    var insightItems = [OCKInsightItem]() {
        didSet {
            insights.items = insightItems
        }
    }
    
    var contacts = [OCKContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNormalPeakFlowScore()
        addActivities()
        addContacts()
        
        let careCard = OCKCareCardViewController(carePlanStore: carePlanStore)
        
//        careCard.title = "Asthma action plan"
        careCard.tabBarItem = UITabBarItem (title: "Asthma action plan", image: UIImage(named: "careplan"), selectedImage: UIImage(named: "careplan"))
        let button = UIBarButtonItem(title: "Menu", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goToMenu))
        
        careCard.navigationItem.leftBarButtonItem = button
       
        
        
        
        let symptomTracker = OCKSymptomTrackerViewController(carePlanStore: carePlanStore)
//        symptomTracker.title = "Peak Flow Score"
         symptomTracker.tabBarItem = UITabBarItem (title: "Peak Flow Score", image: UIImage(named: "peakflowscore"), selectedImage: UIImage(named: "peakflowscore"))
        symptomTracker.delegate = self
        symptomTracker.navigationItem.leftBarButtonItem = button
        
        insights = OCKInsightsViewController(insightItems: insightItems)
//        insights.title = "Progress"
        insights.tabBarItem = UITabBarItem (title: "Progress", image: UIImage(named: "insight"), selectedImage: UIImage(named: "insight"))
        insights.navigationItem.leftBarButtonItem = button
        updateInsights()
        
        let connect = OCKConnectViewController(contacts: contacts)
//        connect.title = "Connect"
        connect.tabBarItem = UITabBarItem (title: "Connect", image: UIImage(named: "connect"), selectedImage: UIImage(named: "connect"))
        connect.delegate = self
        connect.navigationItem.leftBarButtonItem = button
        
        viewControllers = [
            UINavigationController(rootViewController: careCard),
            UINavigationController(rootViewController: symptomTracker),
            UINavigationController(rootViewController: insights),
            UINavigationController(rootViewController: connect)
        ]
        connect.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: Selector(("actionMethodName")))
        symptomTracker.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: Selector(("actionMethodName")))
        careCard.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: Selector(("actionMethodName")))
        insights.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: Selector(("actionMethodName")))
    }
    
    func addActivities() {
        carePlanStore.activities { [unowned self] (_, activities, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard activities.count == 0 else { return }
            
            for activity in self.interventions() + self.assessments() {
                self.carePlanStore.add(activity) { (_, error) in
                    guard let error = error else { return }
                    print(error.localizedDescription)
                }
            }
        }
    }
    
   
    
    func addNormalPeakFlowScore(){
        let messageDB = Database.database().reference().child("PeakFlowScores")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            if snapshotValue["Email"] == Auth.auth().currentUser?.email{
                self.normalPeakFlowScore = Int((snapshotValue["PeakFlowScore"]! as NSString).intValue)
            }
    }
    }
    
    @objc func goToMenu(){
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        print(self.normalPeakFlowScore)
    }
    
    func interventions() -> [OCKCarePlanActivity] {
        let exerciseSchedule = OCKCareSchedule.dailySchedule(withStartDate: activityStartDate, occurrencesPerDay: 1, daysToSkip: 1, endDate: nil)
        let eightADay = OCKCareSchedule.dailySchedule(withStartDate: activityStartDate as DateComponents, occurrencesPerDay: 8)
        let fiveADay = OCKCareSchedule.dailySchedule(withStartDate: activityStartDate as DateComponents, occurrencesPerDay: 5)
        

        let firstActivity = OCKCarePlanActivity(identifier: "Exercise", groupIdentifier: nil, type: .intervention, title: "Exercise", text: "30 min/session",tintColor: UIColor.flatRed(), instructions: "Swimming is one of the best exercises for asthma because it builds up the muscles you use for breathing. It also exposes the lungs to lots of warm, moist air, which is less likely to trigger asthma symptoms.", imageURL: nil,schedule: exerciseSchedule, resultResettable: true, userInfo:nil)
        
        let secondActivity = OCKCarePlanActivity(identifier: "FiveADay", groupIdentifier: nil, type: .intervention, title: "5 a day", text: "80g/portion",tintColor: UIColor.flatGreen(), instructions: "You should be getting at least 5 portions of a variety of fruit and vegetables every day. That's 5 portions of fruit and veg in total, not 5 portions of each. A portion of fruit or vegetables is 80g.", imageURL: nil,schedule: fiveADay, resultResettable: true, userInfo:nil)
        
        let thirdActivity = OCKCarePlanActivity(identifier: "Water", groupIdentifier: nil, type: .intervention, title: "Drink water", text: "250ml/glass",tintColor: UIColor.flatSkyBlue(), instructions: "Studies have shown that dehydration could play a significant role in asthma and allergies. The lack of water vapor in the lungs causes the airways to constrict and for the asthmatic's lungs to produce mucus, the two factors that cause an asthma attack.", imageURL: nil,schedule: eightADay, resultResettable: true, userInfo:nil)
        
        return [firstActivity, secondActivity,thirdActivity]
    }
    
    
    
    func assessments() -> [OCKCarePlanActivity] {
        let oncePerDaySchedule = OCKCareSchedule.dailySchedule(withStartDate: activityStartDate,
                                                               occurrencesPerDay: 1)
        
        let peakFlowAssessment = OCKCarePlanActivity.assessment(withIdentifier: "peakFlow",
                                                                groupIdentifier: nil,
                                                                title: "Peak Flow Score",
                                                                text: "What was your peak flow score today?",
                                                                tintColor: .purple,
                                                                resultResettable: true,
                                                                schedule: oncePerDaySchedule,
                                                                userInfo: nil,
                                                                optional: false)
        
        return [peakFlowAssessment]
    }
    
    func updateInsights() {
        self.insightItems = []
        
        var peakFlow = [DateComponents: Int]()
        var interventionCompletion = [DateComponents: Int]()
        
        let activitiesDispatchGroup = DispatchGroup()
        
        activitiesDispatchGroup.enter()
        fetchpeakFlow { peakFlowDict in
            peakFlow = peakFlowDict
            activitiesDispatchGroup.leave()
        }
        
        activitiesDispatchGroup.enter()
        fetchInterventionCompletion { interventionCompletionDict in
            interventionCompletion = interventionCompletionDict
            activitiesDispatchGroup.leave()
        }
        
        activitiesDispatchGroup.notify(queue: .main) {
            if let peakFlowMessage = self.peakFlowMessage(peakFlow: peakFlow) {
                self.insightItems.append(peakFlowMessage)
            }
            self.insightItems.append(self.interventionBarChart(interventionCompletion: interventionCompletion, peakFlow: peakFlow))
        }
    }
    
    func fetchpeakFlow(completion: @escaping ([DateComponents: Int]) -> ()) {
        var peakFlow = [DateComponents: Int]()
        
        let peakFlowStartDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: DateComponents(day: -7), to: today)!)
        let peakFlowEndDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: DateComponents(day: -1), to: today)!)
        
        carePlanStore.activity(forIdentifier: "peakFlow") { [unowned self] (_, activity, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let peakFlowAssessment = activity else { return }
            self.carePlanStore.enumerateEvents(of: peakFlowAssessment, startDate: peakFlowStartDate, endDate: peakFlowEndDate, handler: { (event, _) in
                guard let event = event else { return }
                if let result = event.result {
                    peakFlow[event.date] = Int(result.valueString)!
                } else {
                    peakFlow[event.date] = 0
                }
            }, completion: { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                completion(peakFlow)
            })
        }
    }
    
    func fetchInterventionCompletion(completion: @escaping ([DateComponents: Int]) -> ()) {
        var interventionCompletion = [DateComponents: Int]()
        
        let interventionStartDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: DateComponents(day: -7), to: today)!)
        let interventionEndDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: DateComponents(day: -1), to: today)!)
        
        carePlanStore.dailyCompletionStatus(with: .intervention, startDate: interventionStartDate, endDate: interventionEndDate, handler: { (date, completed, total) in
            interventionCompletion[date] = lround((Double(completed) / Double(total)) * 100)
        }, completion: { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(interventionCompletion)
        })
    }
    
    func peakFlowMessage(peakFlow: [DateComponents: Int]) -> OCKMessageItem? {
        //extracting the peak flow scores for the week and computing the average
        let peakFlowAverage = Double(peakFlow.values.reduce(0) { $0 + $1 }) / Double(peakFlow.count)
        let peakFlowAverageInt = lround(peakFlowAverage)
        //computing the target zones for the peak flow score
        let greenZoneMinimum = Double(normalPeakFlowScore)*0.8
        let yellowZoneMinimum = Double(normalPeakFlowScore)*0.5
       
        
        if peakFlowAverage >= greenZoneMinimum {
            let averageAlert = OCKMessageItem(title: "Green zone", text: "You had an average peak flow score of \(peakFlowAverageInt) L/min this week. You are between 80 to 100 percent of the usual or normal peak flow readings which indicates clear. A peak flow reading in the green zone indicates that the lung function management is under good control.", tintColor: .green, messageType: .tip)
            return averageAlert
        } else if peakFlowAverage >= yellowZoneMinimum {
            let consistentAlert = OCKMessageItem(title: "Yellow zone", text: "You had an average peak flow score of \(peakFlowAverageInt) L/min this week.You are between 50 to 79 percent of the usual or normal peak flow readings which indicates caution. It may mean respiratory airways are narrowing and additional medication may be required.", tintColor: .yellow, messageType: .alert)
            return consistentAlert
        } else{
            let averageTip = OCKMessageItem(title: "Red zone", text: "You had an average peak flow score of \(peakFlowAverageInt) L/min this week. Less than 50 percent of the usual or normal peak flow readings. Indicates a medical emergency. Severe airway narrowing may be occurring and immediate action needs to be taken. This would usually involve contacting a doctor or hospital.", tintColor: .red, messageType: .alert)
            return averageTip
        }
       
    }
    
    func interventionBarChart(interventionCompletion: [DateComponents: Int], peakFlow: [DateComponents: Int]) -> OCKBarChart {
        let sortedDates = interventionCompletion.keys.sorted() {
            calendar.dateComponents([.second], from: $0, to: $1).second! > 0
        }
        let formattedDates = sortedDates.map {
            monthDayFormatter.string(from: calendar.date(from: $0)!)
        }
        
        let interventionValues = sortedDates.map { interventionCompletion[$0]! }
        let interventionSeries = OCKBarSeries(title: "Asthma action plan", values: interventionValues as [NSNumber], valueLabels: interventionValues.map { "\($0)%" }, tintColor: .red)
        
        let peakFlowNumbers = sortedDates.map { peakFlow[$0]! }
        let peakFlowValues: [Double]
        if peakFlow.values.max()! > 0 {
            let singleHourWidth = 100.0 / Double(peakFlow.values.max()!)
            peakFlowValues = peakFlowNumbers.map { singleHourWidth * Double($0) }
        } else {
            peakFlowValues = peakFlowNumbers.map { _ in 0 }
        }
        let peakFlowSeries = OCKBarSeries(title: "Peak flow score", values: peakFlowValues as [NSNumber], valueLabels: peakFlowNumbers.map { "\($0)" }, tintColor: .purple)
        
        let interventionBarChart = OCKBarChart(title: "Asthma action plan to Peak flow score", text: "See how completing your asthma action plan affects your average peak flow score.", tintColor: nil, axisTitles: formattedDates, axisSubtitles: nil, dataSeries: [interventionSeries, peakFlowSeries], minimumScaleRangeValue: 0, maximumScaleRangeValue: 100)
        return interventionBarChart
    }
    
    func addContacts() {
        contacts = [OCKContact(contactType: .personal,
                    name: "Catalin Mares",
                    relation: "Work",
                    tintColor: nil,
                    phoneNumber: CNPhoneNumber(stringValue: "07594537485"),
                    messageNumber: CNPhoneNumber(stringValue: "07594537485"),
                    emailAddress: "cmares1@sheffield.ac.uk",
                    monogram: "SR",
                    image: UIImage(named: "contacts")),
         OCKContact(contactType: .careTeam,
                    name: "Dr. Haider Rasool",
                    relation: "Therapist",
                    tintColor: nil,
                    phoneNumber: CNPhoneNumber(stringValue: "07454282727"),
                    messageNumber: CNPhoneNumber(stringValue: "07454282727"),
                    emailAddress: "hrasool@yahoo.com",
                    monogram: "CO",
                    image: UIImage(named: "egg")),
         OCKContact(contactType: .careTeam,
                    name: "Dr Georgica Bors",
                    relation: "Doctor",
                    tintColor: nil,
                    phoneNumber: CNPhoneNumber(stringValue: "074564371221"),
                    messageNumber: CNPhoneNumber(stringValue: "074564371221"),
                    emailAddress: "dr.bors@google.com",
                    monogram: "HG",
                    image: UIImage(named: "egg"))]
        
    }
    
}

extension TabBarController: OCKSymptomTrackerViewControllerDelegate {
    
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        let alert: UIAlertController
        
        if assessmentEvent.activity.identifier == "peakFlow" {
            alert = peakFlowAlert(event: assessmentEvent)
        }else {
            return
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func peakFlowAlert(event: OCKCarePlanEvent) -> UIAlertController {
        let alert = UIAlertController(title: "Peak Flow Score", message: "What is the maximum peak flow score value for today?", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { [unowned self] _ in
            let peakFlowField = alert.textFields![0]
            let result = OCKCarePlanEventResult(valueString: peakFlowField.text!, unitString: "L/min", userInfo: nil)
            self.carePlanStore.update(event, with: result, state: .completed) { (_, _, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        alert.addAction(doneAction)
        
        return alert
    }
    
    func weightAlert(event: OCKCarePlanEvent) -> UIAlertController {
        let alert = UIAlertController(title: "Weight", message: "How much do you weigh (in kilograms)?", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { [unowned self] _ in
            let weightField = alert.textFields![0]
            let result = OCKCarePlanEventResult(valueString: weightField.text!, unitString: "kg", userInfo: nil)
            self.carePlanStore.update(event, with: result, state: .completed) { (_, _, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        alert.addAction(doneAction)
        
        return alert
    }
    
}

extension TabBarController: OCKCarePlanStoreDelegate {
    
    func carePlanStore(_ store: OCKCarePlanStore, didReceiveUpdateOf event: OCKCarePlanEvent) {
        updateInsights()
    }
    
}

extension TabBarController: OCKConnectViewControllerDelegate {
    
    func connectViewController(_ connectViewController: OCKConnectViewController, didSelectShareButtonFor contact: OCKContact, presentationSourceView sourceView: UIView?) {
        var peakFlow = [DateComponents: Int]()
        
        let peakFlowDispatchGroup = DispatchGroup()
        
        peakFlowDispatchGroup.enter()
        fetchpeakFlow { peakFlowDict in
            peakFlow = peakFlowDict
            peakFlowDispatchGroup.leave()
        }
        
        peakFlowDispatchGroup.notify(queue: .main) {
            let paragraph = OCKDocumentElementParagraph(content: "Peak flow readings are often classified into 3 zones of measurement according to the American Lung Association; green, yellow, and red. Doctors and health practitioners develop management plans based on the green-yellow-red zones.\nGreen Zone: 80 to 100 percent of the usual or normal peak flow readings are clear. A peak flow reading in the green zone indicates that the lung function management is under good control.\nYellow Zone: 50 to 79 percent of the usual or normal peak flow readings indicates caution. It may mean respiratory airways are narrowing and additional medication may be required.\nRed Zone: Less than 50 percent of the usual or normal peak flow readings. Indicates a medical emergency. Severe airway narrowing may be occurring and immediate action needs to be taken. This would usually involve contacting a doctor or hospital.")
            
            
            let subtitle = OCKDocumentElementSubtitle(subtitle: "This Week's peak flow scores")
            
            let formattedDates = peakFlow.keys.sorted(by: {
                self.calendar.dateComponents([.second], from: $0, to: $1).second! > 0
            }).map { self.monthDayFormatter.string(from: self.calendar.date(from: $0)!) }
            let table = OCKDocumentElementTable(headers: formattedDates, rows: [peakFlow.values.map { "\($0) L/min" }])
            
            let careDocument = OCKDocument(title: "Weekly peak flow scores overview", elements: [paragraph, subtitle, table])
            careDocument.createPDFData { (pdfData, error) in
                let activityVC = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = sourceView
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    func connectViewController(_ connectViewController: OCKConnectViewController, titleForSharingCellFor contact: OCKContact) -> String? {
        return "Share weekly peak flow scores with \(contact.name)"
    }
}
