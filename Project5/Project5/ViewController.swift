//
//  ViewController.swift
//  Project5
//
//  Created by Prarthana Das on 16/05/23.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    var currentWord: String?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(startgame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        if let presentWord = defaults.object(forKey: "PresentWord") as? String,
            let savedWords = defaults.object(forKey: "Answers") as? [String] {
            title = presentWord
            currentWord = presentWord
            usedWords = savedWords
            print("Loaded old game!")
        } else {
            startgame()
        }
    }
    
  @objc  func startgame() {
        title = allWords.randomElement()
        currentWord = title
        usedWords.removeAll(keepingCapacity: true)
        save()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    @objc func promptForAnswer() {
        
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){ [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func isPossible(word: String) -> Bool {
        guard var motherWord = title?.lowercased() else { return false }
        
        
        for letter in word {
            if let position = motherWord.firstIndex(of: letter) {
                motherWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
        
    }

    func isOriginal(word: String) -> Bool {
        
        guard var motherWord = title?.lowercased() else { return false }
        
        if motherWord == word {
            return false
        } else {
            return !usedWords.contains(word)
        }
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if range.length < 3 {
            return false
        } else {
            return misspelledRange.location == NSNotFound
        }
    }
    
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)

                    save()

                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.beginUpdates()
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                    
                    
                    
                    return
                    
                } else {
                    
                   showErrorMessage(errorTitle:  "Word not recognised", errorMessage: "You can't just make them up, you know!")
                    
                }
            } else {
                
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
                
            }
        } else {
            
            guard let title = title?.lowercased() else { return }

            
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")

            
        }

        
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    
    func save() {
        defaults.set(currentWord, forKey: "PresentWord")
        defaults.set(usedWords, forKey: "Answers")
    }

}

