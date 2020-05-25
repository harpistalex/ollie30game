//
//  InstructionsViewController.swift
//  ollie30game
//
//  Created by Alexandra King on 10/01/2019.
//  Copyright © 2019 Alex's Amazing Apps. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        instructionsLabel.text = "Welcome to ollie_is_30 the game! Answers can be found all around you. If you haven’t yet found the answer, press skip - you can come back to it later. You only get one shot at each question! Once you’ve answered, you can’t go back and change it.\n\nUse Google and ask those around you. Please leave clues where you found them.\n\nYour answers are synched with an online database, the winner will be announced at the end of the day. If you lose your internet connection, answers are stored locally and uploaded when the connection is resumed. For further info or if you’re really stuck, speak with Alex."

    
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
