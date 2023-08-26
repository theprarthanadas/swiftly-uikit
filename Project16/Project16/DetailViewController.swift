//
//  DetailViewController.swift
//  Project16
//
//  Created by Prarthana Das on 26/08/23.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webContent: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = URLRequest(url: URL(string: "https://facebook.com")!)
        webContent.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
