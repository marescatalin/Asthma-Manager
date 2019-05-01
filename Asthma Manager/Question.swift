//
//  Question.swift
//


import Foundation

class Question {
    
    let questionText : String
    let answer : Bool
    let reason : String
    
    init(text: String, correctAnswer: Bool,answerReason: String){
        questionText = text
        answer = correctAnswer
        reason = answerReason
    }
}
