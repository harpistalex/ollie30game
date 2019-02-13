//
//  ViewController.swift
//  ollie30game
//
//  Created by Alexandra King on 10/01/2019.
//  Copyright © 2019 Alex's Amazing Apps. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase

class GameViewController: UIViewController {
    
    //MARK: - Global variables:
    
    var userData = UserDefaults.standard
    let firebaseRef = Database.database().reference()
    
    let allQuestions = QuestionBank()
    var questionNumber : Int = 0
    var score : Int = 0
    //Below, count should be set to allQuestions.count... but Xcode won't let me do that before self is available!
    var answersPicked : Array<Int> = Array(repeating: 0, count: 10)
    var finished : Bool = false
    
    // TODO: - check if we need view did load or view did appear
    //MARK: - Startup:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("<<<<<<<<<<<<<<-----------BOOBS------------>>>>>>>>>>>>>>")
        // Do any additional setup after loading the view, typically from a nib.

        //Temp for reset button:
        resetButton.isHidden = true
        ///////////////////////////
       
        questionNumber = userData.integer(forKey: "QuestionNumber")
        print("viewDidLoad question number \(questionNumber)")
        score = userData.integer(forKey: "Score")
        print("viewDidLoad score \(score)")
        answersPicked = userData.array(forKey: "AnswersPicked") as! Array<Int>
        
//        if userData.array(forKey: "AnswersPicked") != nil {
//            print("Answers picked found")
//        }
//        else {
//            answersPicked = Array(repeating: 0, count: 10)
//        }
        finished = userData.bool(forKey: "Finished")
        //calculateNextQuestion()
        displayQuestion()
        updateUI()
        
    }
    
    //MARK: - Outlets etc:
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var skipButton: UIButton!    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var adminButton: UIButton!
    //Temp outlet:
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func unwindFromAdminVC(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindToQuizVC(segue: UIStoryboardSegue) {
    }   //This is to set up the unwind segue from the instructions VC. There is no code here for the initial segue, as I did it in storyboard editor. Similarly, no code in instructions VC for unwind segue. This was also done in SE. See "Segue Practice" project for more info.
    
    //MARK: - Quiz functionality
    @IBAction func buttonPressed(_ sender: UIButton) {

        var buttonNumberPressed = sender.tag //NB should this be var or let?
        
        if buttonNumberPressed == allQuestions.list[questionNumber].correctAnswerNum + 1 {
            ProgressHUD.showSuccess()
            answersPicked[questionNumber] = buttonNumberPressed
            print("Correct")
            score += 1
            print(score)
        }
        else if buttonNumberPressed == 5 {
            print("Question skipped")
        }
        else {
            ProgressHUD.showError()
            answersPicked[questionNumber] = buttonNumberPressed
            print("Wrong")
            print(score)
        }
        
        calculateNextQuestion()
        displayQuestion()
        updateUI()
    }
    //TODO: - Final answer not being logged.
    func calculateNextQuestion() {
        
        let totalQuestions = answersPicked.count

        for _ in 1...totalQuestions {
            questionNumber += 1
            
            if questionNumber >= totalQuestions {
                questionNumber = 0
            }
            
            if answersPicked[questionNumber] == 0 {
                return
            }
            
        }
        
        finished = true
        
    }
    
    func displayQuestion() {
        
        saveData()
        saveToFirebase()
        
        if finished == false && questionNumber < allQuestions.list.count {
            questionLabel.text = allQuestions.list[questionNumber].questionText
            answerButton1.setTitle(allQuestions.list[questionNumber].answerText[0], for: .normal)
            answerButton2.setTitle(allQuestions.list[questionNumber].answerText[1], for: .normal)
            answerButton3.setTitle(allQuestions.list[questionNumber].answerText[2], for: .normal)
            answerButton4.setTitle(allQuestions.list[questionNumber].answerText[3], for: .normal)
            
        }
        else {
            
            print("Finished")
            print("Final score = \(score)")
            questionLabel.text = "Game over"
            questionNumberLabel.isHidden = true
            buttonStackView.isHidden = true
            skipButton.isHidden = true
            resetButton.isHidden = false
            
            ProgressHUD.show("Submimtting result")
            
            let uid = userData.string(forKey: "uid")
            let firebaseUserDataDictionary = [
                "QuestionNumber" : userData.integer(forKey: "QuestionNumber"),
                "Score": userData.integer(forKey: "Score"),
                "AnswerPicked": userData.array(forKey: "AnswerPicked") as Any,
                "Finished": userData.bool(forKey: "Finished")
                ] as [String : Any]
            
            firebaseRef.child(uid!).updateChildValues(firebaseUserDataDictionary) {
                (error:Error?, firebaseRef:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    ProgressHUD.dismiss()
                    //error
            
                } else {
                    print("Data saved successfully!")
                    //UI updates on completion:
                    self.questionLabel.text = "Thankyou for playing"
                    ProgressHUD.dismiss()
                    //success
                }
            }
            
        }
        
    }
    
    func updateUI() {
        //Maybe have a percentage completed instead of question number? Or both??
        questionNumberLabel.text = "\(questionNumber + 1) / 10"

    }
    
    //Log out:
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        ProgressHUD.show("Saving progress")

        saveData()
        
        //saving data to firebase:
        let uid = userData.string(forKey: "uid")
        let firebaseUserDataDictionary = [
            "QuestionNumber" : userData.integer(forKey: "QuestionNumber"),
            "Score": userData.integer(forKey: "Score"),
            "AnswersPicked" : userData.array(forKey: "AnswersPicked") as Any,
            "Finished" : userData.bool(forKey: "Finished")
            ] as [String : Any]
        
        firebaseRef.child(uid!).updateChildValues(firebaseUserDataDictionary) {
            (error:Error?, firebaseRef:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                ProgressHUD.dismiss()
                //error
                
            } else {
                print("Data saved successfully!")
                //success
               
                do {
                    try Auth.auth().signOut()
                    self.userData.set(false, forKey: "LoggedIn")
                    self.userData.set(0, forKey: "QuestionNumber")
                    self.userData.set(0, forKey: "Score")
                    self.userData.set(Array(repeating: 0, count: 10), forKey: "AnswersPicked")
                    self.userData.set(false, forKey: "Finished")
                    ProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "unwindToLoginVC", sender: self)
                }
                catch {
                    print("error, there was a problem signing out")
                }
                
            }
        }
        
    }
        
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        questionNumber = 0
        score = 0
        answersPicked = Array(repeating: 0, count: 10)
        finished = false
        
        userData.set(questionNumber, forKey: "QuestionNumber")
        userData.set(score, forKey: "Score")
        userData.set(answersPicked, forKey: "AnswersPicked")
        userData.set(finished, forKey: "Finished")
        
        self.questionNumberLabel.isHidden = false
        self.buttonStackView.isHidden = false
        self.skipButton.isHidden = false
        
        displayQuestion()
        updateUI()
        resetButton.isHidden = true
        
    }
    
    
//    func reset() {
//
//        userData.set(0, forKey: "QuestionNumber")
//        userData.set(0, forKey: "Score")
//        sendToFirebase()
//        displayQuestion()
//
//    }

    ////////////////////////////////////////////////////////////
    
    //MARK: - Firebase interfacing:
  
    func saveToFirebase() {
        
        let uid = userData.string(forKey: "uid")
        let firebaseUserDataDictionary = [
            "QuestionNumber" : userData.integer(forKey: "QuestionNumber"),
            "Score": userData.integer(forKey: "Score"),
            "AnswersPicked": userData.array(forKey: "AnswersPicked") as Any,
            "Finished": userData.bool(forKey: "Finished")
            ] as [String : Any]
        
        firebaseRef.child(uid!).updateChildValues(firebaseUserDataDictionary)
        
    }
    
    func saveData() {
       
        userData.set(questionNumber, forKey: "QuestionNumber")
        userData.set(score, forKey: "Score")
        userData.set(answersPicked, forKey: "AnswersPicked")
        userData.set(finished, forKey: "Finished")
        
        
        
        
//        Database.database().reference().child(uid!).updateChildValues(firebaseUserDataDictionary)
//        Database.database().reference().child(uid!).updateChildValues(firebaseUserDataDictionary)
        
    }
    
    
    ///////////////////////////////////////////////////////////
//    The following is only used on the Login page and not needed here!
    
//    func retrieveFromFirebase() {
//
//        //let userID = Auth.auth().currentUser?.uid
//        //let uid = userData.string(forKey: "uid") // maybe make global
//        if let uid = Auth.auth().currentUser?.uid
//        {
//            Database.database().reference().child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                // Get user data:
//                let userDataFromFirebase = snapshot.value as? NSDictionary
//                //print(userDataFromFirebase!)
//
//                if let firebaseScore = userDataFromFirebase?["Score"] as? Int
//                    {
//                        //print(firebaseScore)
//                        self.userData.set(firebaseScore, forKey: "Score")
//                        print(self.userData.integer(forKey: "Score"))
//                    }
//                    else {
//                        print("No score found")
//                    }
//                if let firebaseQuestionNumber = userDataFromFirebase?["QuestionNumber"] as? Int
//                {
//                    //print(firebaseQuestionNumber)
//                    self.userData.set(firebaseQuestionNumber, forKey: "QuestionNumber")
//                    print(self.userData.integer(forKey: "QuestionNumber"))
//                }
//                else {
//                    print("No question number found")
//                }
//
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//        } else {
//            print("No user found")
//            }

    ////////////////////////////////////////////////////////////////////////////////////
    
    //Below is a load of bollocks from trying different things:
    
//        let uid = userData.string(forKey: "uid")
//
//        let firebaseUserData = Database.database().reference().child(uid)
//        firebaseUserData.observe(.childAdded) { (snapshot) in
//            let snapshotValue = snapshot.value as! Dictionary<String, String>
//
//            print("Firebase:", snapshotValue["User"]!)
//            print("Firebase:", snapshotValue["QuestionNumber"]!)
//            print("Firebase:", snapshotValue["Score"]!)
//
//        }
//
//    }
    
}




