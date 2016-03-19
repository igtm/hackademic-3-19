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
        Server.server.pushScore(10);
    }
    @IBAction func retrive(sender: UIButton) {
        Server.server.findOpponent({(roomId:NSString,opponentId:Int,isHost:Bool) -> Void in
         print("マッチング成功: roomId: \(roomId) opponentId: \(opponentId)");
            if isHost {
                var startTime = Server.server.nextGame_host(1);
                print("次のゲーム: id: 1 startTime: \(startTime)");
                // 相手score変更の購読
                Server.server.reserveScore({(score:Int)->Void in
                    let a: Int? = Int(self.textfield1.text!);
                    self.textfield1.text = String(score + a!);
                })
            }else{
                Server.server.nextGame_gest({(id:Int,startTime:Int) -> Void in
                    print("次のゲーム: id: \(id) startTime: \(startTime)");
                    // 相手score変更の購読
                    Server.server.reserveScore({(score:Int)->Void in
                        let a: Int? = Int(self.textfield1.text!);
                        self.textfield1.text = String(score + a!);
                    })
                });
            }
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

