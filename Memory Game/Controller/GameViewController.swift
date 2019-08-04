//
//  GameViewController.swift
//  Memory Game
//
//  Created by Nguyen Dang Hau on 7/31/19.
//  Copyright © 2019 Nguyen Dang Hau. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var question: Int!
    var level_main: Int!
    var level_sub: Int!
    var wrong: Int!
    
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var wrongLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var numberTxt: InputTextField!
    @IBOutlet weak var failLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonCheck()
        initGame(digit: 2,level_main: 1, level_sub: 1, wrong: 0)
    }
    
    func addButtonCheck(){
        let calcBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        calcBtn.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        calcBtn.setTitle("Check", for: .normal)
        calcBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        calcBtn.addTarget(self, action: #selector(compareUserInput), for: .touchUpInside)
        numberTxt.inputAccessoryView = calcBtn
    }
    
    @objc func compareUserInput(){
        if numberTxt.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Ohh!", message: "You must type a number", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let userNumber = Int(numberTxt.text!)
            let currQuestion = question!
            var mainLevel = level_main!
            var subLevel = level_sub!
            var wrongNumber = wrong!
            var digit: Int = 0;
            
            if(userNumber == currQuestion) {
                if(subLevel < 3) {
                    subLevel+=1;
                } else
                    if(subLevel == 3) {
                        mainLevel+=1;
                        subLevel = 1;
                }
            } else {
                wrongNumber+=1;
            }
            if wrongNumber == 3 {
                questionLbl.text = "????"
                wrongLbl.text = "Wrong: " + String(wrongNumber) + "/3"
                numberTxt.isHidden = true
                failLbl.isHidden = false
            }else{
                digit = mainLevel + 2;
                initGame(digit: digit, level_main: mainLevel, level_sub: subLevel, wrong: wrongNumber)
            }
        }
        
        
    }
    
    func initGame(digit: Int, level_main: Int, level_sub: Int, wrong: Int){
        self.question = self.randomGenerate(forNumberLength: digit)
        self.level_main = level_main
        self.level_sub = level_sub
        self.wrong = wrong
        GenNumber(level_main: level_main, level_sub: level_sub, digit: digit, question: question, wrong: wrong)
    }
    
    
    func GenNumber(level_main: Int, level_sub: Int,  digit: Int, question: Int, wrong: Int){
        questionLbl.text = String(question)
        wrongLbl.text = "Wrong: " + String(wrong) + "/3"
        levelLbl.text = "Level: " + String(level_main) + " - " + String(level_sub)
        numberTxt.text = ""
        if level_main == 1 && level_sub == 1 {
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.hideNumber(myString: String(self.question))
            }
        }else{
            let digit = level_main + 2;
            let time = 0.2 * Double(min(digit, 5)) + 0.2 * Double(max(digit - 5, 0))
            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false) { timer in
                self.hideNumber(myString: String(self.question))
            }
        }
        
    }
    
    func randomGenerate(forNumberLength digit: Int) -> Int {
        let max = Int(pow(Double(10), Double(digit)) - 1)
        let min = Int(pow(Double(10), Double(digit - 1)))
        return Int.random(in: min ..< max)
    }
    
    func hideNumber(myString: String){
        let regex = try! NSRegularExpression(pattern: "[0-9]", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, myString.count)
        let modString = regex.stringByReplacingMatches(in: myString, options: [], range: range, withTemplate: ".")
        questionLbl.text = String(modString)
    }
    
    @IBAction func resetGame(_ sender: Any) {
        initGame(digit: 2,level_main: 1, level_sub: 1, wrong: 0)
        numberTxt.isHidden = false
        failLbl.isHidden = true
    }

}
