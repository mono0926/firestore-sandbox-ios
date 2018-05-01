//
//  ViewController.swift
//  FirestoreSandbox
//
//  Created by mono on 2018/04/28.
//  Copyright © 2018 Aquatica Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func crashDidTap(_ sender: UIButton) {
        _ = [Int]()[0]
    }
}

