//
//  ViewController.swift
//  Project10
//
//  Created by Prarthana Das on 03/06/23.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            picker.sourceType = .camera
//        }
        present(picker, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to get dequeue PersonCell")
        }
        let person = people[indexPath.item]
        cell.name.text = person.name

        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var person = people[indexPath.item]
        
        let ac = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .alert)
      //  ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive){[weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
            
        })
        ac.addAction(UIAlertAction(title: "Rename", style: .default){[weak self] _  in
            let rac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
            rac.addTextField()
            rac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            rac.addAction(UIAlertAction(title: "Rename", style: .default){[weak self] _  in
                guard let newName = rac.textFields?[0].text else { return }
                person.name = newName
                
                self?.collectionView.reloadData()
            })
            self?.present(rac, animated: true)
        })
        
       
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

