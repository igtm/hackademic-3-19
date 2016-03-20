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
                //　遷移
                self.move()
            }else{
                Server.server.nextGame_gest({(id:Int,startTime:Int) -> Void in
                    print("次のゲーム: id: \(id) startTime: \(startTime)");
                    // 遷移
                    self.move();
                });
            }
        });
    }
    func move (){
        // 遷移するViewを定義する.
        let flickController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("flick") as UIViewController
        
        // アニメーションを設定する.
        flickController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        // Viewの移動する.
        self.presentViewController(flickController, animated: true, completion: nil)
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

