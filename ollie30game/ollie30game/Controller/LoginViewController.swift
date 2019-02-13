//
//  LoginViewController.swift
//  ollie30game
//
//  Created by Alexandra King on 10/01/2019.
//  Copyright © 2019 Alex's Amazing Apps. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class LoginViewController: UIViewController {

    let userData = UserDefaults.standard
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTestButton.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        //The following sets the view controller depending on whether or not the user is logged in or out.
        let logInStatus = userData.bool(forKey: "LoggedIn")
        
        if logInStatus == true {
            print("logged in")
            //MARK: Firebase automatic log in
            //I think we need some kind of automatic sign into Firebase... don't we? Or does Firebase leave the user logged in when the app is closed?
            performSegue(withIdentifier: "goToGameVCLoggedIn", sender: Any?.self)
        }
        else {
            print("not logged in")
        }
        
    }
    
    //This is to set up the unwind segue from the instructions VC. There is no code here for the initial segue, as I did it in storyboard editor. Similarly, no code in instructions VC for unwind segue. This was also done in SE. See "Segue Practice" project for more info.
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
    }
    
    ////////////////////////////////////////////////////////////
    //MARK: Login test button pressed:
    @IBAction func loginPressed(_ sender: Any) {
        
        //To save the status in the userData:
        userData.set(true, forKey: "LoggedIn")
        userData.set(0, forKey: "QuestionNumber")
        userData.set(0, forKey: "Score")
        
        //... and then segue to game.
        performSegue(withIdentifier: "goToGameVC", sender: Any?.self)
    //////////////////////////////////////////////////////////////////
        
    }
    
    //MARK: Login
    @IBAction func logInButtonPressed(_ sender: Any) {
        
        ProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print("The login error is \(error!)")
            }
            else {
                //success
                print("Log in successful!")
                self.userData.set(true, forKey: "LoggedIn")
                self.userData.set(Auth.auth().currentUser?.email, forKey: "email")
                self.userData.set(Auth.auth().currentUser?.uid, forKey: "uid")

                //TODO: Get score and progress from Firebase and save to userData.
                
                if let uid = Auth.auth().currentUser?.uid
                {
                    Database.database().reference().child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user data:
                        let userDataFromFirebase = snapshot.value as? NSDictionary
                       
                        if let firebaseQuestionNumber = userDataFromFirebase?["QuestionNumber"] as? Int
                        {
                            self.userData.set(firebaseQuestionNumber, forKey: "QuestionNumber")
                            print("Question number from firebase = \(self.userData.integer(forKey: "QuestionNumber"))")
                        }
                        else {
                            print("No question number found")
                        }
                        
                        if let firebaseScore = userDataFromFirebase?["Score"] as? Int
                        {
                            self.userData.set(firebaseScore, forKey: "Score")
                            print("Score from firebase = \(self.userData.integer(forKey: "Score"))")
                        }
                        else {
                            print("No score found")
                        }
                        
                        if let firebaseAnswersPicked = userDataFromFirebase?["AnswersPicked"] as? NSArray
                        {
                            self.userData.set(firebaseAnswersPicked, forKey: "AnswersPicked")
                            print("Got answers picked from firebase")
                        }
                        else {
                            print("No answers picked found")
                        }
                        
                        if let firebaseFinished = userDataFromFirebase?["Finished"] as? Bool
                        {
                            self.userData.set(firebaseFinished, forKey: "Finished")
                            print("Finished from firebase = \(self.userData.bool(forKey: "Finished"))")
                        }
                        else {
                            print("No finished found")
                        }
                        //TODO: - Get the answersPicked array from Firebase and set userData.
                        
                        ProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "goToGameVC", sender: self)
                        
                    }) { (error) in
                        print(error.localizedDescription)
                        ProgressHUD.dismiss()
                    }
                    
                } else {
                    print("No user found, login unsuccessful")
                    ProgressHUD.dismiss()
                }

            }
            
        }
        
        
    }
    
    //MARK: Register
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        ProgressHUD.show()
    
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            if error != nil {
                print(error!)
                ProgressHUD.dismiss()
            }
            else {
                print("Registration successful!")
                let uid = Auth.auth().currentUser?.uid
                let firebaseUserData = Database.database().reference().child(uid!) //instead of child by autoID, create a new child with the UID
                let firebaseUserDataDictionary = [
                    "email": Auth.auth().currentUser?.email
                ]
                
                firebaseUserData.setValue(firebaseUserDataDictionary) {
                    (error, reference) in
                    
                    if error != nil {
                        print(error!)
                        ProgressHUD.dismiss()
                    }
                    else {
                        print("User data saved sucessfully")
                        self.userData.set(true, forKey: "LoggedIn")
                        self.userData.set(false, forKey: "Finished")
                        self.userData.set(Auth.auth().currentUser?.email, forKey: "email")
                        self.userData.set(Auth.auth().currentUser?.uid, forKey: "uid")
                        self.userData.set(0, forKey: "QuestionNumber")
                        self.userData.set(0, forKey: "Score")
                        self.userData.set(Array(repeating: 0, count: 10), forKey: "AnswersPicked")
                        ProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "goToGameVC", sender: self)
                    }
                }

            }
            
        }
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
    
