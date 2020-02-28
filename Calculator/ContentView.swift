//
//  ContentView.swift
//  Calculator
//
//  Created by Ethan Humphrey on 9/16/19.
//  Copyright © 2019 Ethan Humphrey. All rights reserved.
//

/*
 Welcome to my child Mr. Princeton.
 
 This version of the app is way better than the App Inventor version. For starters, it has its own app icon that looks beautiful. It supports iOS 13 dark mode (I'd actually reccommend viewing in dark mode because it looks much prettier, if you don't know how to do that I'll show you).
 
 This is built using Apple's new SwiftUI framework, which is a declarative UI framework which differs from an imperative framework in many ways. Notice I don't create variables for each view, or ever call view.setBackgroundColor(.someBoringColor). I could discuss this for a while but I'm sure I'm going to do that in class.
 
 I had to learn these things called "Bindings" in order to use SwiftUI. You'll notice I have a few different separated views, such as CalcButton, CalcOperationButton, CalcNumberButton, etc. Most of these just create a new instance of CalcButton with their own action. This way all I had to do to make new numbers was create this and give it a number. Bindings are ways to reference the same variable through multiple levels of these views. State variables just let the framework know that these variables are going to be changing, and when they do make sure to update the UI.
 
 For the operations, I created an enum called OperationType that lets me easily set each operation type. This made adding new operations as simple as adding a new value to OperationType, handling it in performOperation, and creating the button for it (CalcOperationButton).
 
 Using inline if statements when setting certain variables like text and color, I was able to make the UI auto update when an operation is the next to be selected or if we're in AC mode instead of C. This is why this version actually has highlighted operation buttons.
 
 NumberFormatter formats the number with commas and the right number of decimal places. I wanted to have it so when the number got big it would go scientific, but couldn't figure that out. However, the calculator does stop you from inputting super large numbers and the text gets smaller as more numbers are entered, but if your result is a really large number then it still truncates.
 
 Obviously there are still things I'd love to add, like the landscape version of the regular calculator app that opens a lot more functions, but I didn't have the time. Please don't try out landscape mode in this app, it's horrible.
 
 Also, I didn't add the swipe to delete feature from the regular calc app (or copy/paste) but I did add a back button which is more intuitive in my mind (I legit forgot about the swipe to delete until someone told me).
 
 Overall I had lots of fun designing this and I'm legit going to use it as my main calculator app on my phone now. I spent way too long outside of class on this as well just for fun. SwiftUI is a really fun framework to play with and I can't wait to learn more about it (like using it with the Combine framework).
 
 Oh by the way, I'm technically uploading this before SwiftUI is even public, but it comes out tomorrow (Thursday the 19th) so you'll need to update Xcode in order to run this, sorry not sorry lol. If you have any issues just ask and I can help. Hope you like it!
 */

import SwiftUI

// MARK: - Views

var numberFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter
}

struct ContentView: View {
    @State var currentInput: String! = "0"
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(currentInput)
                    .font(.system(size: 85))
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .padding()
                    .minimumScaleFactor(0.6)
            }
            CalcButtons(currentInput: $currentInput)
        }
    }
}

struct CalcButtons: View {
    @Binding var currentInput: String!
    @State var firstNumber: Double?
    @State var secondNumber: Double?
    @State var lastOperation: OperationType! = .noOperation
    @State var nextOperation: OperationType! = .noOperation
    @State var shouldClearOnNextInput: Bool! = true
    @State var didJustClear: Bool! = true
    @State var timesPressed = 0
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ColorCalcButton(buttonText: didJustClear ? "AC" : "C", textColor: UIColor(named: "oppositeLabel"), backgroundColor: UIColor(named: "otherButtonBackground")!) {
                    self.currentInput = "0"
                    self.shouldClearOnNextInput = true
                    if self.didJustClear {
                        self.firstNumber = nil
                        self.secondNumber = nil
                        self.lastOperation = .noOperation
                        self.nextOperation = .noOperation
                    }
                    self.didJustClear = true
                }
                Spacer()
                ColorCalcButton(buttonText: "+/-", textColor: UIColor(named: "oppositeLabel"), backgroundColor: UIColor(named: "otherButtonBackground")!) {
                    if !self.shouldClearOnNextInput {
                        if self.currentInput.contains("-") {
                            self.currentInput.remove(at: self.currentInput.firstIndex(of: "-")!)
                        }
                        else {
                            self.currentInput = "-" + self.currentInput
                        }
                    }
                }
                Spacer()
                ColorCalcButton(buttonText: "%", textColor: UIColor(named: "oppositeLabel"), backgroundColor: UIColor(named: "otherButtonBackground")!) {
                    if let num1 = self.firstNumber {
                        self.firstNumber = 0.01*num1
                        self.currentInput = numberFormatter.string(from: NSNumber(value: self.firstNumber!))
                    }
                    else if let num1 = Double(self.currentInput) {
                        self.firstNumber = 0.01*num1
                        self.currentInput = numberFormatter.string(from: NSNumber(value: self.firstNumber!))
                    }
                    self.shouldClearOnNextInput = true
                }
                Spacer()
                ColorCalcButton(buttonText: "←", textColor: UIColor(named: "oppositeLabel"), backgroundColor: UIColor(named: "otherButtonBackground")!) {
                    if !self.shouldClearOnNextInput {
                        if (self.currentInput.contains("-") && self.currentInput.count == 2) || self.currentInput.count == 1 {
                            self.currentInput = "0"
                            self.shouldClearOnNextInput = true
                        }
                        else {
                            self.currentInput.removeLast()
                        }
                    }
                }
                Spacer()
            }
                .padding(.vertical, 8)
            HStack {
                Spacer()
                CalcOperationButton(buttonText: "Tip", operation: .tip, nextOperation: $nextOperation, firstNumber: $firstNumber, secondNumber: $secondNumber, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput)
                Spacer()
                CalcOperationButton(buttonText: "ⁿ√x", operation: .root, nextOperation: $nextOperation, firstNumber: $firstNumber, secondNumber: $secondNumber, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput)
                Spacer()
                CalcOperationButton(buttonText: "xⁿ", operation: .exponent, nextOperation: $nextOperation, firstNumber: $firstNumber, secondNumber: $secondNumber, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput)
                Spacer()
                CalcOperationButton(buttonText: "÷", operation: .divide, nextOperation: $nextOperation, firstNumber: $firstNumber, secondNumber: $secondNumber, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput)
                Spacer()
            }
                .padding(.vertical, 8)
            HStack {
                Spacer()
                CalcNumButton(number: 7, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcNumButton(number: 8, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcNumButton(number: 9, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcOperationButton(buttonText: "×", operation: .multiply, nextOperation: $nextOperation, firstNumber: $firstNumber, secondNumber: $secondNumber, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput)
                Spacer()
            }
                .padding(.vertical, 8)
            HStack {
                Spacer()
                CalcNumButton(number: 4, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcNumButton(number: 5, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcNumButton(number: 6, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcOperationButton(buttonText: "-", operation: .subtract, nextOperation: $nextOperation, firstNumber: $firstNumber, secondNumber: $secondNumber, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput)
                Spacer()
            }
                .padding(.vertical, 8)
            HStack {
                Spacer()
                CalcNumButton(number: 1, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcNumButton(number: 2, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcNumButton(number: 3, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcOperationButton(buttonText: "+", operation: .add, nextOperation: $nextOperation, firstNumber: $firstNumber, secondNumber: $secondNumber, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput)
                Spacer()
            }
                .padding(.vertical, 8)
            HStack {
                Spacer()
                CalcButton(buttonText: (timesPressed >= 100) ? "Hi!" : "") {
                    self.timesPressed += 1
                }
                Spacer()
                CalcNumButton(number: 0, currentInput: $currentInput, shouldClearOnNextInput: $shouldClearOnNextInput, didJustClear: $didJustClear)
                Spacer()
                CalcButton(buttonText: ".") {
                    if !self.currentInput.contains(".") && !self.shouldClearOnNextInput {
                        self.currentInput += "."
                        self.shouldClearOnNextInput = false
                    }
                }
                Spacer()
                ColorCalcButton(buttonText: "=", textColor: .white, backgroundColor: .systemPurple) {
                    self.shouldClearOnNextInput = true
                    if self.nextOperation != .noOperation {
                        if let num1 = self.firstNumber {
                            if let num2 = Double(self.currentInput) {
                                // First Equals
                                self.firstNumber = performOperation(self.nextOperation, num1: num1, num2: num2)
                                self.secondNumber = num2
                                self.lastOperation = self.nextOperation
                                self.nextOperation = .noOperation
                                if let calcNum = self.firstNumber {
                                    self.currentInput = numberFormatter.string(from: NSNumber(value: calcNum))
                                }
                                else {
                                    self.currentInput = "Error"
                                    self.shouldClearOnNextInput = true
                                }
                            }
                        }
                    }
                    else if self.lastOperation != .noOperation {
                        if let num1 = self.firstNumber {
                            if let num2 = self.secondNumber {
                                // Repeated Equals
                                self.firstNumber = performOperation(self.lastOperation, num1: num1, num2: num2)
                                if let calcNum = self.firstNumber {
                                    self.currentInput = numberFormatter.string(from: NSNumber(value: calcNum))
                                }
                                else {
                                    self.currentInput = "Error"
                                    self.shouldClearOnNextInput = true
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
                .padding(.vertical, 8)
        }
    }
}

struct CalcButton: View {
    
    var buttonText: String! = ""
    var action: () -> Void = {}
    
    var body: some View {
        ColorCalcButton(buttonText: buttonText, textColor: .label, backgroundColor: .secondarySystemBackground, action: action)
    }
}

struct ColorCalcButton: View {
    
    var buttonText: String! = ""
    var textColor: UIColor! = .label
    var backgroundColor: UIColor = .secondarySystemBackground
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            self.action()
            }) {
                Text(buttonText)
                    .font(.system(size: 30))
                    .foregroundColor(Color(textColor))
                    .frame(width: 75, height: 75)
                    .padding()
                    .frame(width: 75, height: 75)
                    .background(Color(backgroundColor))
                    .cornerRadius(50)
            }
    }
}

struct CalcNumButton: View {
    var number: Int = 0
    @Binding var currentInput: String!
    @Binding var shouldClearOnNextInput: Bool!
    @Binding var didJustClear: Bool!
    var body: some View {
        CalcButton(buttonText: "\(number)", action: {
            if self.shouldClearOnNextInput {
                self.currentInput = ""
                self.shouldClearOnNextInput = false
            }
            self.didJustClear = false
            if self.currentInput.count < 10 {
                self.currentInput += "\(self.number)"
            }
        })
    }
}

struct CalcOperationButton: View {
    var buttonText: String! = ""
    var operation: OperationType = .noOperation
    @Binding var nextOperation: OperationType!
    @Binding var firstNumber: Double?
    @Binding var secondNumber: Double?
    @Binding var currentInput: String!
    @Binding var shouldClearOnNextInput: Bool!
    var body: some View {
        Button(action: {
            if self.nextOperation == .noOperation {
                if let newCalcNum = Double(self.currentInput) {
                    self.firstNumber = newCalcNum
                    self.nextOperation = self.operation
                    self.secondNumber = nil
                }
            }
            else if self.shouldClearOnNextInput {
                self.nextOperation = self.operation
            }
            else if let num1 = self.firstNumber {
                if let num2 = Double(self.currentInput) {
                    self.firstNumber = performOperation(self.nextOperation, num1: num1, num2: num2)
                    self.nextOperation = self.operation
                    if let newCalcNum = Double(self.currentInput) {
                        self.secondNumber = newCalcNum
                        if let calcNum = self.firstNumber {
                            self.currentInput = numberFormatter.string(from: NSNumber(value: calcNum))
                        }
                        else {
                            self.currentInput = "Error"
                            self.shouldClearOnNextInput = true
                        }
                    }
                    else {
                        self.currentInput = "Error"
                        self.shouldClearOnNextInput = true
                    }
                }
                else {
                    self.currentInput = "Error"
                    self.shouldClearOnNextInput = true
                }
            }
            else if let newCalcNum = Double(self.currentInput) {
                self.firstNumber = newCalcNum
                self.nextOperation = self.operation
            }
            else {
                self.currentInput = "Error"
                self.shouldClearOnNextInput = true
            }
            self.shouldClearOnNextInput = true
        }) {
            Text(buttonText)
                .font(.system(size: 30))
                .foregroundColor(Color((self.nextOperation == self.operation && self.shouldClearOnNextInput) ? .systemPurple : .white))
                .frame(width: 75, height: 75)
                .animation(.default)
            .padding()
            .frame(width: 75, height: 75)
            .background(Color((self.nextOperation == self.operation && self.shouldClearOnNextInput) ? UIColor(named: "selectedBackground")! : .systemPurple))
            .cornerRadius(50)
            .animation(.default)
        }
        
    }
}

let deviceTypes = ["iPhone SE", "iPhone 11 Pro", "iPhone 11 Pro Max"]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            ContentView()
//                .previewDevice("iPhone 8")
            ContentView()
                .previewDevice("iPhone 11 Pro Max")
//            ContentView()
//                .previewDisplayName("Light Mode")
//                .previewDevice("iPhone 11 Pro")
//            ContentView()
//                .previewDisplayName("Dark Mode")
//                .environment(\.colorScheme, .dark)
//                .previewDevice("iPhone 11 Pro")
        }
    }
}

// MARK: - Functions
func performOperation(_ operation: OperationType, num1: Double, num2: Double) -> Double? {
    switch operation {
    case .add:
        return num1 + num2
    case .subtract:
        return num1 - num2
    case .multiply:
        return num1*num2
    case .divide:
        if num2 == 0 {
            return nil
        }
        return num1/num2
    case .exponent:
        return pow(num1, num2)
    case.root:
        return pow(num1, (1/num2))
    case .tip:
        return (num2*0.01 + 1)*num1
    case .noOperation:
        return nil
    }
}
