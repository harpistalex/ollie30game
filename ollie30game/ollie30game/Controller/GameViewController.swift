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
    let connectedRef = Database.database().reference(withPath: ".info/connected")
    var connectedToFirebase : Bool = false
    
    let allQuestions = QuestionBank()
    var questionNumber : Int = 0
    var score : Int = 0
    //Below, count should be set to allQuestions.count... but Xcode won't let me do that before self is available!
    var answersPicked : Array<Int> = Array(repeating: 0, count: 30)
    var finished : Bool = false
    
    //MARK: - Startup:
    override func viewDidLoad() {
        super.viewDidLoad()

        //Temp for reset button:
        resetButton.isHidden = true
        ///////////////////////////
        
        offlineLabel.isHidden = true
       
        questionNumber = userData.integer(forKey: "QuestionNumber")
        print("viewDidLoad question number \(questionNumber)")
        score = userData.integer(forKey: "Score")
        print("viewDidLoad score \(score)")
        answersPicked = userData.array(forKey: "AnswersPicked") as! Array<Int>
        finished = userData.bool(forKey: "Finished")
        displayQuestion()
        updateUI()
        checkConnection()
        
        //Set admin button so only I can see it:
        if userData.string(forKey: "email") == "harpistalex@gmail.com" {
            adminButton.isHidden = false
        } else {
            adminButton.isHidden = true
        }
        
        //Centre button text:
        answerButton1.titleLabel?.textAlignment = NSTextAlignment.center
        answerButton2.titleLabel?.textAlignment = NSTextAlignment.center
        answerButton3.titleLabel?.textAlignment = NSTextAlignment.center
        answerButton4.titleLabel?.textAlignment = NSTextAlignment.center
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
    @IBOutlet weak var offlineLabel: UILabel!
    //Temp outlet:
    @IBOutlet weak var resetButton: UIButton!
    
    //MARK:- Unwind Segues:
    @IBAction func unwindFromAdminVC(segue: UIStoryboardSegue) {
    }
    @IBAction func unwindToQuizVC(segue: UIStoryboardSegue) {
    }   //This is to set up the unwind segue from the instructions VC. There is no code here for the initial segue, as I did it in storyboard editor. Similarly, no code in instructions VC for unwind segue. This was also done in SE. See "Segue Practice" project for more info.
    
    //For checking internet connectivity:
    func checkConnection() {
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected")
                self.connectedToFirebase = true
                self.offlineLabel.isHidden = true
                //cancel any auth logout requests.
            } else {
                print("Not connected")
                self.connectedToFirebase = false
                self.offlineLabel.isHidden = false
                ProgressHUD.dismiss()
            }
        })
    }

    
    //MARK: - Quiz functionality
    @IBAction func buttonPressed(_ sender: UIButton) {

        var buttonNumberPressed = sender.tag //NB should this be var or let?
        
        if buttonNumberPressed == allQuestions.list[questionNumber].correctAnswerNum + 1 {
            answersPicked[questionNumber] = buttonNumberPressed
            print("Correct")
            score += 1
            print(score)
        }
        else if buttonNumberPressed == 5 {
            print("Question skipped")
        }
        else {
            answersPicked[questionNumber] = buttonNumberPressed
            print("Wrong")
            print(score)
        }
        
        calculateNextQuestion()
        displayQuestion()
        updateUI()
        
    }
    
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
        saveToFirebase(completionHandler: { (success) -> Void in

            if success {
                print("data saved to Firebase")
            } else {
                print("data not saved to Firebase")
            }
        })
        
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
            //resetButton.isHidden = false
            
            ProgressHUD.show()

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
                    ProgressHUD.dismiss() //TODO: Hide logout?
                    //error
            
                } else {
                    print("Data saved successfully!")
                    //UI updates on completion:
                    self.questionLabel.text = "Thankyou for playing"
                    ProgressHUD.dismiss()
                    //success
                    //AUTOMATICALLY LOG OUT if connectionToFirebase == True?
                }
            }
            
        }
        
    }
    
    func updateUI() {

        questionNumberLabel.text = "\(questionNumber + 1) / 30"

    }
    
    //Log out:
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        if connectedToFirebase == true {
            
            ProgressHUD.show()
            saveData()
            
            saveToFirebase(completionHandler: { (success) -> Void in
                
                if success {
                    print("data saved to Firebase, now logging out.")
                    do {
                        try Auth.auth().signOut()
                        self.userData.set(false, forKey: "LoggedIn")
                        self.userData.set(0, forKey: "QuestionNumber")
                        self.userData.set(0, forKey: "Score")
                        self.userData.set(Array(repeating: 0, count: 30), forKey: "AnswersPicked")
                        self.userData.set(false, forKey: "Finished")
                        ProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "unwindToLoginVC", sender: self)
                    } catch {
                        print("error, there was a problem signing out")
                        Toast.show(message: "Error, please check internet connection and try again.", controller: self)
                        ProgressHUD.dismiss()
                            }
                } else {
                    print("data not saved to Firebase, unable to log out")
                    Toast.show(message: "Error, please check internet connection and try again.", controller: self)
                    ProgressHUD.dismiss()
                    }
            })

        } else {
            print("Could not log out, please check your internet connection and try again.")
            Toast.show(message: "Error, please check internet connection and try again.", controller: self)
        }
    }
    //TEMP FOR TESTING:
//    @IBAction func resetButtonPressed(_ sender: Any) {
//
//        questionNumber = 0
//        score = 0
//        answersPicked = Array(repeating: 0, count: 30)
//        finished = false
//
//        self.questionNumberLabel.isHidden = false
//        self.buttonStackView.isHidden = false
//        self.skipButton.isHidden = false
//
//        displayQuestion()
//        updateUI()
//        resetButton.isHidden = true
//
//    }
    ////////////////////////////////////////////////////////////
    
    //MARK: - Firebase interfacing:
  
    func saveToFirebase(completionHandler: @escaping (_ success:Bool) -> Void) {
        //This should probably get uid from Firebase, NOT userData.
        let uid = userData.string(forKey: "uid")
        let firebaseUserDataDictionary = [
            "QuestionNumber" : userData.integer(forKey: "QuestionNumber"),
            "Score": userData.integer(forKey: "Score"),
            "AnswersPicked": userData.array(forKey: "AnswersPicked") as Any,
            "Finished": userData.bool(forKey: "Finished")
            ] as [String : Any]
        
        var complete : Bool = false
        
        firebaseRef.child(uid!).updateChildValues(firebaseUserDataDictionary) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                complete = false
                print(error)
            } else {
                complete = true
                print("-----------Data has been saved")
            }
            
            completionHandler(complete)

        }
        
        
    }
        
    
    func saveData() {
       
        userData.set(questionNumber, forKey: "QuestionNumber")
        userData.set(score, forKey: "Score")
        userData.set(answersPicked, forKey: "AnswersPicked")
        userData.set(finished, forKey: "Finished")
        
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
        
        
        //saving data to firebase:
        //NB: THIS IS WITHOUT A COMPLETION HANDLER:
        //        let uid = userData.string(forKey: "uid")
        //        let firebaseUserDataDictionary = [
        //            "QuestionNumber" : userData.integer(forKey: "QuestionNumber"),
        //            "Score": userData.integer(forKey: "Score"),
        //            "AnswersPicked" : userData.array(forKey: "AnswersPicked") as Any,
        //            "Finished" : userData.bool(forKey: "Finished")
        //            ] as [String : Any]
        //
        //        firebaseRef.child(uid!).updateChildValues(firebaseUserDataDictionary) {
        //            (error:Error?, firebaseRef:DatabaseReference) in
        //            if let error = error {
        //                print("Data could not be saved: \(error).")
        //                ProgressHUD.dismiss()
        //                //error
        //
        //            } else {
        //                print("Data saved successfully!")
        //                //success
        //
        //                do {
        //                    try Auth.auth().signOut()
        //                    self.userData.set(false, forKey: "LoggedIn")
        //                    self.userData.set(0, forKey: "QuestionNumber")
        //                    self.userData.set(0, forKey: "Score")
        //                    self.userData.set(Array(repeating: 0, count: 10), forKey: "AnswersPicked")
        //                    self.userData.set(false, forKey: "Finished")
        //                    ProgressHUD.dismiss()
        //                    self.performSegue(withIdentifier: "unwindToLoginVC", sender: self)
        //                }
        //                catch {
        //                    print("error, there was a problem signing out")
        //                }
        //
        //            }
        //        }
        
    
}




