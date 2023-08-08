//
//  ViewController.swift
//  Project8
//
//  Created by Prarthana Das on 24/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var solutions = [String]()
    var activatedButtons = [UIButton]()
    var levelUpFlag = 0
    
    var level = 1
    var count = 0
    
    //property observers
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        
        answersLabel = UILabel()
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsview = UIView()
        buttonsview.translatesAutoresizingMaskIntoConstraints = false
        buttonsview.layer.borderWidth = 0.5
        buttonsview.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(buttonsview)

        NSLayoutConstraint.activate([
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsview.widthAnchor.constraint(equalToConstant: 750),
            buttonsview.heightAnchor.constraint(equalToConstant: 320),
            buttonsview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsview.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsview.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
        ])
        
        //cluesLabel.backgroundColor = .red
        //answersLabel.backgroundColor = .green
        //buttonsview.backgroundColor = .blue
        
        let height = 80
        let width = 150
        
        for row in 0...3 {
            for col in 0...4 {
                
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsview.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
        /*
         WITH CORE ANIMATION
         UIView.animate(withDuration: 1, delay:0,animations: {
             sender.alpha = 0
         }){
             finished in
             sender.isHidden = true
         }
         
         */
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            count += 1
            
            if count == solutions.count {
            if score > 5 {
                levelUpFlag = 1
                let ac = UIAlertController(title: "Well Done!", message:  "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelModerator))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Oh no!", message:  "You couldn't achieve the cut off score", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart!", style: .default, handler: levelModerator))
                present(ac, animated: true)
            }
        }
            
        } else {
            
            
            let ac = UIAlertController(title: "Oops!", message:  "That was not the correct answer!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again!", style: .default, handler: {[unowned self]_ in
                
                self.score -= 1
                
                self.currentAnswer.text = ""
                
                for btn in self.activatedButtons {
                    btn.isHidden = false
                }
                
                self.activatedButtons.removeAll()
            }))
            present(ac, animated: true)
        }
    }
    
    
    func levelModerator(action: UIAlertAction){
        if levelUpFlag == 1 {
            level += 1
        } else {
            score = 0
        }
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        for btn in letterButtons {
            btn.isHidden = false
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            btn.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        DispatchQueue.global().async{
            if let levelFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelFileURL) {
                    var lines = levelContents.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ":")
                        let answer = parts [0]
                        let clue = parts[1]
                        
                        clueString += "\(index + 1). \(clue)\n"
                        
                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        solutionString += "\(solutionWord.count) letters\n"
                        self.solutions.append(solutionWord)
                        
                        let bits = answer.components(separatedBy: "|")
                        letterBits += bits
                    }
                }
            }
            
            
            self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            letterBits.shuffle()
            
            if  letterBits.count == self.letterButtons.count {
                for i in 0 ..< self.letterButtons.count {
                    self.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
    }
}

