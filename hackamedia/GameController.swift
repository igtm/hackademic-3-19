//
//  GameController.swift
//  hackamedia
//
//  Created by 井口 智勝 on 2016/03/20.
//  Copyright © 2016年 watnow. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    var myProgressView:UIProgressView? = nil
    var gauge: Float = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // ProgressViewを作成する.
        myProgressView = UIProgressView(frame: CGRectMake(0, 0, self.view.frame.width, 500))
        myProgressView!.progressTintColor = UIColor(red:0.11, green:0.82, blue:0.69, alpha:1.0)
        myProgressView!.trackTintColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
        
        // 座標を設定する.
        myProgressView!.layer.position = CGPoint(x: self.view.frame.width/2, y: 100)
        
        // バーの高さを設定する(横に1.0倍,縦に2.0倍).
        myProgressView!.transform = CGAffineTransformMakeScale(1.0, 10.0)
        
        // アニメーションを付ける.
        gauge = 0.5
        myProgressView!.setProgress(gauge, animated: true)
        
        // Viewに追加する.
        self.view.addSubview(myProgressView!)
    }
    
    @IBAction func move(sender: UIButton) {
        changeBar(gauge + 0.01)
    }
    // バーを変える
    func changeBar(num: Float){
        gauge = num
        myProgressView!.setProgress(gauge, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
