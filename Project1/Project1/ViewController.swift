//
//  ViewController.swift
//  Project1
//
//  Created by Prarthana Das on 12/05/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var counts = [Int]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
        //self.tableView.backgroundColor = .systemPink
        navigationController?.navigationBar.prefersLargeTitles = true
        let fm = FileManager.default //use it to look for files
        let path = Bundle.main.resourcePath!
        
        //DispatchQueue.global(qos: .background).async{
            let items = try! fm.contentsOfDirectory(atPath: path)
            for item in items{
                if item.hasPrefix("nssl"){
                    self.pictures.append(item)
                    self.counts.append(0)
                }
            }
            self.pictures = self.pictures.sorted()
        
        tableView.reloadData()
      //  }
        

       
        //print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Picture")
        cell.textLabel?.text = pictures[indexPath.row]
        if let imageCounts = defaults.object(forKey: "imageCalls") as? [Int] {
            counts = imageCounts
        }
            cell.detailTextLabel?.text = String(counts[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            counts[indexPath.row] += 1
            defaults.set(counts, forKey: "imageCalls")
            dvc.numberOfImages = pictures.count
            dvc.selectedImageIndex = indexPath.row + 1
            dvc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(dvc, animated: true)
            tableView.reloadData()
        }
    }

}

