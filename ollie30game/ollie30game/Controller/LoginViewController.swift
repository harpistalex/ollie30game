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

    //MARK:- Global Variables and IBOutlets:
    let userData = UserDefaults.standard
    var loginUIBool : Bool = false //False means registerUI is showing. True means loginUI is showing.
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var loginTestButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var loginOrRegister: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TESTING:
        loginTestButton.isHidden = true
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        ///////////////////////////////
        
        //To dissmiss the keyboard when the user taps outside:
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        loginOrRegister.titleLabel?.textAlignment = NSTextAlignment.center

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        //The following sets the view controller depending on whether or not the user is logged in or out.
        let logInStatus = userData.bool(forKey: "LoggedIn")
        if logInStatus == true {
            print("logged in")
            performSegue(withIdentifier: "goToGameVCLoggedIn", sender: Any?.self)
        } else {
            print("not logged in")
        }
        
        let alreadyRegistered = userData.bool(forKey: "AlreadyRegistered")
        if alreadyRegistered == true {
            loginUI()
        } else {
            registerUI()
        }
        
        
    }
    
    //This is to set up the unwind segue from the instructions VC. There is no code here for the initial segue, as I did it in Storyboard Editor. Similarly, no code in instructions VC for unwind segue. This was also done in SE. See "Segue Practice" project for more info.
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
    
    
    @IBAction func loginOrRegisterPressed(_ sender: Any) {
        if loginUIBool == false {
            loginUI()
        } else {
            registerUI()
        }
    }
    
    
    //MARK: Login
    @IBAction func logInButtonPressed(_ sender: Any) {
        
        self.view.endEditing(true) //this hides the keyboard
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            Toast.show(message: "Please enter both fields.", controller: self)
            return
        }
        
        ProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print("The login error is \(error!)")
                Toast.show(message: "\(error!.localizedDescription)", controller: self)
                ProgressHUD.dismiss()
            }
            else {
                //success
                print("Log in successful!")
                self.userData.set(true, forKey: "LoggedIn")
                self.userData.set(Auth.auth().currentUser?.email, forKey: "email")
                self.userData.set(Auth.auth().currentUser?.uid, forKey: "uid")

                //Get score and progress from Firebase and save to userData:
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
                        
                        ProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "goToGameVC", sender: self)
                        
                    }) { (error) in
                        print(error.localizedDescription)
                        Toast.show(message: "Login error, please check internet connection.", controller: self)
                        ProgressHUD.dismiss()
                    }
                    
                } else {
                    print("No user found, login unsuccessful")
                    Toast.show(message: "No user found. Please create account.", controller: self)
                    ProgressHUD.dismiss()
                }

            }
            
        }
        
        
    }
    
    //MARK: Register
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        self.view.endEditing(true) //this hides the keyboard
        
        if usernameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" || usernameTextField.text == "" {
            Toast.show(message: "Please enter all fields.", controller: self)
            return
        }
        
        if passwordTextField.text != retypePasswordTextField.text {
            Toast.show(message: "Passwords do not match", controller: self)
            return
        }
        
        let code = codeTextField.text!
        
        if code == "3.14159" {
            
            ProgressHUD.show()
        
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {
                (user, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    Toast.show(message: "\(error!.localizedDescription)", controller: self)
                    ProgressHUD.dismiss()
                }
                else {
                    print("Registration successful!")
                    let uid = Auth.auth().currentUser?.uid
                    let firebaseUserData = Database.database().reference().child(uid!) //instead of child by autoID, create a new child with the UID
                    let firebaseUserDataDictionary = [
                        "email": Auth.auth().currentUser?.email,
                        "username": self.usernameTextField.text
                    ]
                    
                    firebaseUserData.setValue(firebaseUserDataDictionary) {
                        (error, reference) in
                        
                        if error != nil {
                            print(error!)
                            //TODO:- Make some kind of Toast to display the error.
                            ProgressHUD.dismiss()
                            //I guess I need to expand on this...? If it doesn't work, do you just try again?
                        }
                        else {
                            print("User data saved sucessfully")
                            self.userData.set(true, forKey: "LoggedIn")
                            self.userData.set(false, forKey: "Finished")
                            self.userData.set(Auth.auth().currentUser?.email, forKey: "email")
                            self.userData.set(Auth.auth().currentUser?.uid, forKey: "uid")
                            self.userData.set(0, forKey: "QuestionNumber")
                            self.userData.set(0, forKey: "Score")
                            self.userData.set(Array(repeating: 0, count: 30), forKey: "AnswersPicked")
                            self.userData.set(true, forKey: "AlreadyRegistered")
                            self.userData.set(self.usernameTextField.text, forKey: "Username")
                            ProgressHUD.dismiss()
                            self.performSegue(withIdentifier: "goToGameVC", sender: self)
                        }
                    }

                }
                
            }
            
        } else {
           Toast.show(message: "Incorrect code", controller: self)
        }
    }
    
    //MARK: Reset password
    @IBAction func resetPasswordPressed (_ sender: Any) {
        
        let userEmail = emailTextField.text!
        Auth.auth().sendPasswordReset(withEmail: userEmail) { error in
            Toast.show(message: "Please enter your email address.", controller: self)
            return
        }

    }
    
    
    //MARK: UI updates
    func loginUI() {
        usernameTextField.isHidden = true
        codeTextField.isHidden = true
        registerButton.isHidden = true
        retypePasswordTextField.isHidden = true
        resetPasswordButton.isHidden = false
        loginButton.isHidden = false
        loginOrRegister.setTitle("Need to register? Create account.", for: .normal)
        loginUIBool = true
        
    }
    
    func registerUI() {
        usernameTextField.isHidden = false
        codeTextField.isHidden = false
        registerButton.isHidden = false
        retypePasswordTextField.isHidden = false
        loginButton.isHidden = true
        resetPasswordButton.isHidden = true
        loginOrRegister.setTitle("Already have an account? Log in.", for: .normal)
        loginUIBool = false
        
    }
    
}
    
