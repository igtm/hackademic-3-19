//
//  ViewController.swift
//  hackamedia
//
//  Created by 井口 智勝 on 2016/03/19.
//  Copyright © 2016年 watnow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var buttons: [UIButton] = []
    // UIButtonを継承した独自クラス
    class MyButton: UIButton{
        let x:Int
        let y:Int
        init(x:Int,y:Int,frame:CGRect){
            self.x = x
            self.y = y
            super.init(frame:frame)
        }
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    

    @IBOutlet weak var textfield1: UITextField!
    let ref = Firebase(url:BASE_URL)
    @IBAction func button1(sender: UIButton) {
        Server.server.pushScore(10);
    }
    func move (){
        // 遷移するViewを定義する.
        let flickController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("select_game") as UIViewController
        
        // アニメーションを設定する.
        flickController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        // Viewの移動する.
        self.presentViewController(flickController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0);
        
        
        let cnt: Int = 2
        // 画面サイズ
        let myAppFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size
        // 箱を置く位置の開始位置
        let begin = Int(myAppFrameSize.width)/2
        
        let btn : UIButton = MyButton(
            x:0,
            y:0,
            frame:CGRectMake(CGFloat(begin)-150,380,300,100))
        //ボタンを押したときの動作
        btn.addTarget(self, action: "pushed:", forControlEvents: .TouchUpInside)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        // ボタンの影
        btn.layer.shadowOffset = CGSizeMake(5.0, 5.0)
        btn.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.9)
        btn.layer.shadowOpacity = 0.5
        //           btn.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.9)
        
        btn.layer.cornerRadius = 20
        
        view.addSubview(btn)
        buttons.append(btn)
        
        // center label
        let ansLabel: UILabel = UILabel() // Design カウントの周りのラベル
        ansLabel.frame = CGRectMake(0,250,myAppFrameSize.width,80) // Design カウントの数字のラベル
        ansLabel.textAlignment = NSTextAlignment.Center
        ansLabel.font = UIFont.systemFontOfSize(35)
        ansLabel.text = "EIGO Wars"
        self.view.addSubview(ansLabel)// center label
        
        let startLabel: UILabel = UILabel() // Design カウントの周りのラベル
        startLabel.frame = CGRectMake(0,390,myAppFrameSize.width,80) // Design カウントの数字のラベル
        startLabel.textAlignment = NSTextAlignment.Center
        startLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        startLabel.font = UIFont.systemFontOfSize(35)
        startLabel.text = "<< START >>"
        self.view.addSubview(startLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ボタンが押されたときの動作
    func pushed(mybtn : MyButton){
        print(mybtn.x,mybtn.y)
        
        Server.server.findOpponent({(roomId:NSString,opponentId:Int,isHost:Bool) -> Void in
            print("マッチング成功: roomId: \(roomId) opponentId: \(opponentId)");
            if isHost {
                var startTime = Server.server.nextGame_host(1);
                print("次のゲーム: id: 1 startTime: \(startTime)");
                //　遷移
                self.move()
            }else{
                Server.server.nextGame_gest({(id:Int,startTime:Double) -> Void in
                    print("次のゲーム: id: \(id) startTime: \(startTime)");
                    // 遷移
                    self.move();
                });
            }
        });
    }



}

