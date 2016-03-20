//
//  ViewController.swift
//  select_screen
//
//  Created by 内西 功一 on 2016/03/20.
//  Copyright © 2016年 Koichi. All rights reserved.
//

import UIKit

class SelectGameController: UIViewController {
    
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
    
    // タイマー終了後
    func afterTimer(){
        // ハードコード:　次のページをランダム
        let apps = ["flick"]
        let rand = Int(arc4random_uniform(1))
        print("rand : \(rand)")
        
        move(apps[rand])
    }
    func move (place:String){
        // 遷移するViewを定義する.
        let flickController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(place) as UIViewController
        
        // アニメーションを設定する.
        flickController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        // Viewの移動する.
        self.presentViewController(flickController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0);

        
        // ハードコード:　次のページをランダム
        let apps = ["flick"]
        let rand = Int(arc4random_uniform(1))
        print("rand : \(rand)")
        
        
        // 次のページ読込
        let timestamp = NSDate().timeIntervalSince1970;
        var diff: Double = Server.server.START_TIME - timestamp;
        
        if diff <= 0{
            move(apps[rand]);
        }else{
            var timer = NSTimer.scheduledTimerWithTimeInterval(diff/1000, target: self, selector: Selector("afterTimer"), userInfo: nil, repeats: false)
        
        }
    
        
        
        let cnt: Int = 2
        // 画面サイズ
        let myAppFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size
        // 箱を置く位置の開始位置
        let begin = Int(myAppFrameSize.width)/2 - (100 + (cnt)*110)/2
        // img_path
        let img_path = ["1.png","2.png","3.png","4.png","5.png"]
        // img_rand
        var answer: [Int] = []
        
        var i = 1
        while(i < 4){
            let rand = arc4random_uniform(5)
            if !answer.contains(Int(rand)){
                answer.append(Int(rand))
                i += 1
                
            }
        }
        print(answer)
        
        for x in 0...cnt{ // 横の列
            //位置を変えながらボタンを作る // Desigin Xx3 のますのボタンの設定
            let btn : UIButton = MyButton(
                x:x,
                y:0,
                frame:CGRectMake(CGFloat(x)*110 + CGFloat(begin),380,100,100))
            //ボタンを押したときの動作
            btn.addTarget(self, action: "pushed:", forControlEvents: .TouchUpInside)
            
            // タイトルを設定する(ボタンがハイライトされた時).
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            // ボタンの影
            btn.layer.shadowOffset = CGSizeMake(5.0, 5.0)
            btn.layer.shadowOpacity = 0.5
            //            btn.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.9)
            
            btn.layer.cornerRadius = 20
            btn.setImage(UIImage(named:"/Users/Tomokatsu/Desktop/hackamedia/test3/hackamedia/hackamedia/"+img_path[answer[x]]), forState: UIControlState.Normal)
            view.addSubview(btn)
            buttons.append(btn)
            
        }
        // center label
        let ansLabel: UILabel = UILabel() // Design カウントの周りのラベル
        ansLabel.frame = CGRectMake(0,250,myAppFrameSize.width,80) // Design カウントの数字のラベル
        ansLabel.textAlignment = NSTextAlignment.Center
        ansLabel.font = UIFont.systemFontOfSize(35)
        ansLabel.text = "You'll play the games below. please wait..."
        self.view.addSubview(ansLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //ボタンが押されたときの動作
    func pushed(mybtn : MyButton){
        print(mybtn.x,mybtn.y)
    }
    
}

