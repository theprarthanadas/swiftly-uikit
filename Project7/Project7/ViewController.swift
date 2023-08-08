//
//  ViewController.swift
//  Project7
//
//  Created by Prarthana Das on 19/05/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController?.tabBarItem.tag == 0 {
             urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        parse(urlString!)
        
        let credits = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
        let filter = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterContent))
        let reset = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetTapped))
        
        navigationItem.rightBarButtonItems = [reset, credits, filter]
        
    }
    
    @objc func resetTapped() {
        parse(urlString!)
    }
    
    
    func parse(_ urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) {[self] data, response, error in
                guard let data = data else{
                    showError()
                    return
                }
                
                let decoder = JSONDecoder()
                
                if let jsonPetitions = try? decoder.decode(Petitions.self, from: data) {
                    petitions = jsonPetitions.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
            task.resume()

        } else {
            showError()
        }
    }

    @objc func creditsTapped() {
        let creditsVC = UIAlertController(title: "SOURCE", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        creditsVC.addAction(UIAlertAction(title: "Okay", style: .default))
        present(creditsVC, animated: true)
    }
    
    @objc func filterContent() {
        let filterVC = UIAlertController(title: "Filter", message: "Enter text to filter", preferredStyle: .alert)
        filterVC.addTextField()
        
        let submitFilter = UIAlertAction(title: "Submit", style: .default){[unowned self, weak filterVC] action in
            guard let textToFilter = filterVC?.textFields?[0] .text else { return}
            
            DispatchQueue.global(qos: .background).async{
                self.petitions = self.petitions.filter{ (title) -> Bool in
                    return title.title.contains(textToFilter)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        filterVC.addAction(submitFilter)
        present(filterVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func showError() {
        let evc = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        evc.addAction(UIAlertAction(title: "Okay", style: .default))
        present(evc, animated: true)
    }
    
   


}

