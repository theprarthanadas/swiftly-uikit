//
//  ViewController.swift
//  Project1
//
//  Created by Prarthana Das on 12/05/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
        //self.tableView.backgroundColor = .systemPink
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(searchTapped))
        let fm = FileManager.default //use it to look for files
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items{
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        pictures = pictures.sorted()
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            dvc.numberOfImages = pictures.count
            dvc.selectedImageIndex = indexPath.row + 1
            dvc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(dvc, animated: true)
            
        }
    }
    
    @objc func searchTapped(){
//        let ac = UIAlertController(title: title, message: "This app is the best!", preferredStyle: .actionSheet)
//        ac.addAction(UIAlertAction(title: "Recommend", style: .destructive, handler: nil))
//        present(ac,animated: true)
        let vc = UIActivityViewController(activityItems: ["Hey! Check out the Storm Viewer App it is the best!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}

