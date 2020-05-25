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
        
        list.append(Question(question: "What band was Ollie in?", answers: ["Opeth", "The String Theorists", "Axiom", "Limbic System"], correctAnswer: 3))
        list.append(Question(question: "What is the name of the Onion King's dog?", answers: ["Kevin", "Archibald", "Gromit", "Colin"], correctAnswer: 0))
        list.append(Question(question: "Give Amy the secret handshake.", answers: ["Pokemon", "Roboteers, standby", "Power Rangers", "To infinity and beyond"], correctAnswer: 2))
        list.append(Question(question: "Carousel horses, wagon wheel, pink parasol. What's the speed?", answers: ["2.5", "3.5", "4", "2"], correctAnswer: 1))
        list.append(Question(question: "When did Ollie cut his hair?", answers: ["10/12/11 ", "03/01/12", "08/09/12", "11/11/11"], correctAnswer: 3))
        list.append(Question(question: "Thunderbird costume.", answers: ["Ketchup", "Sriracha", "Hendo's", "Encona"], correctAnswer: 0))
        list.append(Question(question: "What did Ollie regularly bring to Maths Club?", answers: ["Whiskey", "Cake", "Calculator", "Cats"], correctAnswer: 1))
        list.append(Question(question: "What time does Ollie get up to watch the Formula 1?", answers: ["6am", "9am", "5am", "4am"], correctAnswer: 3))
        list.append(Question(question: "What is Ollie's favourite whiskey?", answers: ["Bells", "Laphroaig", "Lagavulin", "Jack Daniels"], correctAnswer: 2))
        list.append(Question(question: "What is Ollie's numberplate?", answers: ["GY09 VAV", "FP14 UPF", "YS04 BKV", "GY06 GZP"], correctAnswer: 1))
        list.append(Question(question: "Find the item which he hides discreetly.", answers: ["1.825", "112358", "1.618", "c"], correctAnswer: 2))
        list.append(Question(question: "With what does Ollie share his middle name?", answers: ["IKEA table", "Tank Engine", "Helicopter", "Hoover"], correctAnswer: 3))
        list.append(Question(question: "00000111 x 00001111 =", answers: ["01101001", "01101000", "01001101", "01000101"], correctAnswer: 0))
        list.append(Question(question: "Cats give iron punishments at school. Tell Barney the answer.", answers: ["Wintermute", "Anagram", "Mnemonic", "Decker"], correctAnswer: 2))
        list.append(Question(question: "D&D campaign: what are you searching for?", answers: ["Ollie's lost abacus", "Ollie's lost calculator", "Ollie's lost gold", "Ollie's lost cribbage board"], correctAnswer: 1))
        list.append(Question(question: "You fight like a dairy farmer.", answers: ["How appropriate, you fight like a cow.", "Your hemorroids are flaring up again, eh?", "I am rubber you are glue.", "Even BEFORE they smell your breath?"], correctAnswer: 0))
        list.append(Question(question: "What is your name? What is your quest? What is your favourite colour?", answers: ["Arthur, Excalibur, red.", "Ollie, representation theory, purple.", "Merlin, staff, blue.", "Lancelot, Holy Grail, blue."], correctAnswer: 3))
        list.append(Question(question: "When is Ollie's ACTUAL birthday?", answers: ["17th June", "22nd May", "25th February", "10th March"], correctAnswer: 1))
        list.append(Question(question: "This is the END for you, you gutter crawling cur!", answers: ["First you'd better stop waving it around like a feather duster.", "You run THAT fast?", "And I've got a little TIP for you, get the POINT?", "Why, did you want to borrow one?"], correctAnswer: 2))
        list.append(Question(question: "What can you tell me about St John's Eve?", answers: ["23rd June", "22nd June", "24th June", "22nd May"], correctAnswer: 0))
        list.append(Question(question: "What is the name of Ollie's pub quiz group?", answers: ["Colourful Animals", "Fancy Giraffes", "The Cat's Pyjamas", "Stinky Hippos"], correctAnswer: 0))
        list.append(Question(question: "What was the title of Ollie's thesis?", answers: ["Iwahori-Hecke Algerbras and Schur Algebras", "Representations and Cohomology", "The Representation Theory of Diagram Algebras", "Elements of the Represetation Theory of Associative Algebras"], correctAnswer: 2))
        list.append(Question(question: "Ubi est Caecilius?", answers: ["Caecilius est in amphitheatre.", "Caecilius est in horto.", "Caecilius est in triclinium.", "Caecilius est in forum."], correctAnswer: 1))
        list.append(Question(question: "What is Ollie's primary nickname?", answers: ["Dolly", "Ollie Henry Rollo King", "Merv", "Pig Duck"], correctAnswer: 0))
        list.append(Question(question: "What common phrase did Ollie not understand until 28 years of age?", answers: ["Beat around the bush.", "Pardon my French.", "Takes one to know one.", "I'm full of beans."], correctAnswer: 3))
        list.append(Question(question: "Maths stands for: mathematical anti telharsic *blank* septonim.", answers: ["heliosos", "harpoonium", "harfatum", "harppopotamus"], correctAnswer: 2))
        list.append(Question(question: "Jaroslav Beck - Legend (ft. ???)", answers: ["Generdyn", "Backchat", "Summer Haze", "Tiny C"], correctAnswer: 1))
        list.append(Question(question: "#F4D03F Korok. Find me.", answers: ["Red, white blue, blue.", "Red, white, white, blue.", "White, white, blue, red.", "Red, blue, white, blue."], correctAnswer: 0))
        list.append(Question(question: "What flower would Sam Vimes be wearing today?", answers: ["Rose", "Iris", "Magnolia", "Lilac"], correctAnswer: 3))
        list.append(Question(question: "Only one of the following statements is true. Which one?", answers: ["A: B is true. ", "B: D is false.", "C: Statements A to D are false.", "D: A is false."], correctAnswer: 3))
    }
    
}
