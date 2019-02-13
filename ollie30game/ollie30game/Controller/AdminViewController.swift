//
//  AdminViewController.swift
//  ollie30game
//
//  Created by Alexandra King on 23/01/2019.
//  Copyright © 2019 Alex's Amazing Apps. All rights reserved.
//

import UIKit
import Firebase

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let firebaseRef = Database.database().reference()
    var firebaseDataRecieved : Dictionary <String, Any> = [:]
    var scoresRecieved = [Int]()
    var emailsRecieved = [String]()
    var finalResults = [String]()

    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var dataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataButton.isHidden = true
        
/////////////////////////////////////////////////////////////////////
        //MARK: - RETRIEVE AND SORT ALL DATA FOR TABLEVIEW:
        
        //Set this view controller as the delegate and the datasource.
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        // SEARCHES FOR SHARING CODE IN DATABASE (ONLINE)
        
        firebaseRef.observeSingleEvent(of: .value, with: { snapshot in
            
            // SHOWING WHATEVER WAS RECEIVED FROM THE SERVER JUST AS A CONFIRMATION. FEEL FREE TO DELETE THIS LINE.
            //print(snapshot)
            
            // PROCESSES VALUES RECEIVED FROM SERVER
            if ( snapshot.value is NSNull ) {
                
                // DATA WAS NOT FOUND
                print("– – – Data was not found – – –")
                
            } else {
                
                // DATA WAS FOUND
                for user_child in (snapshot.children) {
                    
                    let user_snap = user_child as! DataSnapshot
                    let dict = user_snap.value as! [String: Any]
                    
                    // DEFINE VARIABLES FOR LABELS
                    let email = dict["email"]
                    let score = dict["Score"]
                    //print("Email: \(email ?? "not found"), Score: \(score ?? 0)")
                    self.firebaseDataRecieved["\(email ?? "no email found")"] = score ?? 0
                    //print(self.firebaseDataRecieved)
                    
                    self.emailsRecieved.append(dict["email"] as! String)
                    self.scoresRecieved.append(dict["Score"] as! Int)
                    //print(self.emailsRecieved)
                    //print(self.scoresRecieved)
                    
                }
            }
            
            self.sortResults()
            self.createFinalResults()
            
        })
        
    }
    
    //MARK: - Tableview properties
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = finalResults[indexPath.row]
        return(cell)
    }
    
    
    //MARK: - Sorting functions:
    func sortResults() {

        for i in stride(from: scoresRecieved.count-1, to: 0, by: -1) {
            for j in 1...i {
                if scoresRecieved[j-1] < scoresRecieved[j] {
                    let tmp = scoresRecieved[j-1]
                    let tmp2 = emailsRecieved[j-1]
                    scoresRecieved[j-1] = scoresRecieved[j]
                    emailsRecieved[j-1] = emailsRecieved[j]
                    scoresRecieved[j] = tmp
                    emailsRecieved[j] = tmp2
                }
            }
        }
        
        print(scoresRecieved)
        print(emailsRecieved)
        //resultsTableView.reloadData()
        
    }
    
    func createFinalResults(){
        for index in 0...emailsRecieved.count - 1 {
            finalResults.append("\(emailsRecieved[index]): \(scoresRecieved[index])")
        }
        print(finalResults)
        resultsTableView.reloadData()
    }

}
