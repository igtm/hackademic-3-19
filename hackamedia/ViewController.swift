//
//  ViewController.swift
//  hackamedia
//
//  Created by 井口 智勝 on 2016/03/19.
//  Copyright © 2016年 watnow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textfield1: UITextField!
    let ref = Firebase(url:BASE_URL)
    @IBAction func button1(sender: UIButton) {
        let a = "test1";
        textfield1.text = a;
        ref.setValue(a)
    }
    @IBAction func retrive(sender: UIButton) {
        Server.server.findOpponent({(roomId:NSString,opponentId:Int) -> Void in
         print("マッチング成功: roomId: \(roomId) opponentId: \(opponentId)");
        });
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

