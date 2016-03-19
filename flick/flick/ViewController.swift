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
    
    //メイン
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = "apple"
        for x in 0...4{
            for y in 0...2{
                //位置を変えながらボタンを作る
                let btn : UIButton = MyButton(
                    x:x,
                    y:y,
                    frame:CGRectMake(CGFloat(x)*60 + 10,CGFloat(y)*60 + 50,50,50))
                //ボタンを押したときの動作
                btn.addTarget(self, action: "pushed:", forControlEvents: .TouchUpInside)
                //見える用に赤くした
                btn.backgroundColor = UIColor.redColor()
                if y == 0 {
                    if x < str.characters.count {
                        print(str[str.startIndex.advancedBy(x)])
                    }
                    btn.setTitle(String(str[str.startIndex.advancedBy(x)]), forState: UIControlState.Normal)
                    print("btn" + String(x))
                } else if y == 1 {
                    btn.setTitle("▲", forState: UIControlState.Normal)
                } else {
                    btn.setTitle("▼", forState: UIControlState.Normal)
                }
                //画面に追加
                view.addSubview(btn)
                if x == 0 && y == 0{
                    buttons.append(btn)
               }
            }
        }
    }
    
    //ボタンが押されたときの動作
    func pushed(mybtn : MyButton){
        print("asa".characters.count )
        //押されたボタンごとに結果が異なる
        let str = "asa"
        let index = str.startIndex.advancedBy(0)
        print(str[str.startIndex.advancedBy(0)])
        
        
        print("button at (\(mybtn.x),\(mybtn.y)) is pushed")
        
    }
}