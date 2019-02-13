//
//  Question.swift
//  ollie30game
//
//  Created by Alexandra King on 10/01/2019.
//  Copyright © 2019 Alex's Amazing Apps. All rights reserved.
//

import Foundation

class Question {
    
    let questionText : String
    let answerText : [String]
    let correctAnswerNum : Int
    
    init(question: String, answers: [String], correctAnswer: Int) {
        questionText = question
        answerText = answers
        correctAnswerNum = correctAnswer
        
    }
    
}
