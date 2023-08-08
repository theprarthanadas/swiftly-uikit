//
//  ViewController.swift
//  Project15
//
//  Created by Prarthana Das on 21/06/23.
//

import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imageView = UIImageView(image: UIImage(named: "penguin"))
//        print(self.view.bounds.height)
//        print(self.view.bounds.width)
        imageView.center = CGPoint(x:self.view.bounds.height/4, y:self.view.bounds.width)
        view.addSubview(imageView)
    }


    @IBAction func tapped(_ sender: UIButton) {
        
        sender.isHidden = true
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
            animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.clear
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }
        

        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
        
    }
    
}

