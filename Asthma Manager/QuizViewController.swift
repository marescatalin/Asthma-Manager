//
//  ViewController.swift

//


import UIKit
import Firebase
import FirebaseAuth


class QuizViewController: UIViewController {
    
    //Place your instance variables here
    let allQuestions = QuestionBank()
    var pickedAnswer : Bool = false
    var questionNumber : Int = 0
    var score : Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        resetToFirstQuestion()

        
    }
    
    func resetToFirstQuestion() {
        questionNumber = 0
        score = 0
        questionLabel.text = allQuestions.firstQuestion().questionText
        scoreLabel.text = "Your score is "+String(score)
        progressLabel.text = "\(questionNumber+1)/13"
        updateUI()
    }


    @IBAction func answerPressed(_ sender: AnyObject) {
        if sender.tag == 1 {
            pickedAnswer = true
        }
        else if sender.tag == 2 {
            pickedAnswer = false
        }

        checkAnswer()
        updateUI()
    }
    
    
    func updateUI() {
        if questionNumber < 1{
        self.progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(1)
        }
        else{
        self.progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(questionNumber)
        }
    }
    

    func nextQuestion() {
        questionNumber += 1
        
        if questionNumber <= 12 {
        questionLabel.text = allQuestions.list[questionNumber].questionText
        progressLabel.text = "\(questionNumber+1)/13"
        
       
        }
        else {
            let alert = UIAlertController(title: "Congratulations", message: "You have finished all the questions. Your score was \(score)/13.", preferredStyle: .alert)

            let restartAction = UIAlertAction(title: "Return to menu", style: .default) { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
                 let scoresDB = Database.database().reference().child("Scores")
                let scoreDictionary = ["Patient" : Auth.auth().currentUser?.email, "Score" : String(self.score)]
                scoresDB.childByAutoId().setValue(scoreDictionary){
                    (error, reference) in
                    if error != nil {
                        print(error)
                    }
                    else{
                        print("Message was saved succesfully!")
                    }
                }
            }
            alert.addAction(restartAction)
           
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func checkAnswer() {
        let correctAnswer = allQuestions.list[questionNumber].answer
        
        if correctAnswer == pickedAnswer {
            print("This answer is correct!")
            score += 1
            scoreLabel.text = "Your score is "+String(score)
            nextQuestion()
        }
        else {
            print("Your answer was wrong!")
            let alert = UIAlertController(title: "Wrong answer", message: allQuestions.list[questionNumber].reason, preferredStyle: .alert)
            let nextQuestion = UIAlertAction(title: "Next question", style: .default) { (UIAlertAction) in
                self.nextQuestion()
            }
            alert.addAction(nextQuestion)
            present(alert, animated: true, completion: nil)
        }
       
    }

    
}
