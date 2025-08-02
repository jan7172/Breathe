//
//  PromptView.swift
//  Breathe
//
//  Created by Jan Bauer on 02.08.25.
//

import SwiftUI

struct PromptView: View {
    var app: SocialApp
    var onCancel: () -> Void
    var onConfirm: () -> Void
    
    @State private var mathQuestion: String = ""
    @State private var mathAnswer: String = ""
    @State private var correctMathResult: Int = 0
    @State private var taskSolved = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Bist du sicher, dass du \(app.displayName) öffnen willst?")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
            
            VStack {
                Text("Löse diese Aufgabe:")
                    .font(.headline)
                
                Text(mathQuestion)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Antwort eingeben", text: $mathAnswer)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 150)
                    .onChange(of: mathAnswer) {
                        checkMathAnswer()
                    }
            }
            .padding()
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: {
                    onCancel()
                }) {
                    Text("\(app.displayName) nicht öffnen")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    onConfirm()
                }) {
                    Text("\(app.displayName) öffnen")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(taskSolved ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!taskSolved)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .onAppear {
            generateMathTask()
        }
    }
    
    private func generateMathTask() {
        let a = Int.random(in: 2...9)
        let b = Int.random(in: 2...9)
        correctMathResult = a * b
        mathQuestion = "\(a) × \(b) = ?"
    }
    
    private func checkMathAnswer() {
        taskSolved = Int(mathAnswer) == correctMathResult
    }
}
