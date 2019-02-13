//
//  QuestionBank.swift
//  ollie30game
//
//  Created by Alexandra King on 10/01/2019.
//  Copyright © 2019 Alex's Amazing Apps. All rights reserved.
//

import Foundation

class QuestionBank {
    
    var list = [Question]()
    
    init() {
        
        list.append(Question(question: "This is the first question...", answers: ["Answer 1", "Answer 2", "Answer 3", "Correct answer"], correctAnswer: 3))
        list.append(Question(question: "This is the second question...", answers: ["Correct answer", "Answer 2", "Answer 3", "Answer 4"], correctAnswer: 0))
        list.append(Question(question: "This is the third question...", answers: ["Answer 1", "Answer 2", "Correct answer", "Answer 4"], correctAnswer: 2))
        list.append(Question(question: "This is the fourth question...", answers: ["Answer 1", "Correct answer", "Answer 3", "Answer 4"], correctAnswer: 1))
        list.append(Question(question: "This is the fifth question...", answers: ["Answer 1", "Answer 2", "Answer 3", "Correct Answer"], correctAnswer: 3))
        list.append(Question(question: "This is the sixth question...", answers: ["Correct Answer", "Answer 2", "Answer 3", "Answer 4"], correctAnswer: 0))
        list.append(Question(question: "This is the seventh question...", answers: ["Answer 1", "Correct answer", "Answer 3", "Answer 4"], correctAnswer: 1))
        list.append(Question(question: "This is the eigth question...", answers: ["Answer 1", "Answer 2", "Answer 3", "Correct Answer"], correctAnswer: 3))
        list.append(Question(question: "This is the ninth question...", answers: ["Answer 1", "Answer 2", "Correct Answer", "Answer 4"], correctAnswer: 2))
        list.append(Question(question: "This is the tenth question...", answers: ["Answer 1", "Correct Answer", "Answer 3", "Answer 4"], correctAnswer: 1))
    }
    
}
