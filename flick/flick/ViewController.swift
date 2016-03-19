import UIKit

class ViewController: UIViewController {
    
    var buttons: [UIButton] = []
    var buttons_char: [String] = []
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
        let str = "melon"
        let cnt = str.characters.count-1
        // 画面サイズ
        let myAppFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size
        // 箱を置く位置の開始位置
        let begin = Int(myAppFrameSize.width)/2 - (50 + (cnt)*60)/2
        print(begin)
        for x in 0...cnt{
            for y in 0...2{
                //位置を変えながらボタンを作る
                let btn : UIButton = MyButton(
                    x:x,
                    y:y,
                    frame:CGRectMake(CGFloat(x)*60 + CGFloat(begin),CGFloat(y)*60 + 50,50,50))
                //ボタンを押したときの動作
                btn.addTarget(self, action: "pushed:", forControlEvents: .TouchUpInside)
                //見える用に赤くした
                btn.backgroundColor = UIColor.redColor()
                let charactor = String(str[str.startIndex.advancedBy(x)])
                if y == 0 {
                    btn.setTitle(charactor, forState: UIControlState.Normal)
                } else if y == 1 {
                    btn.setTitle("▲", forState: UIControlState.Normal)
                } else {
                    btn.setTitle("▼", forState: UIControlState.Normal)
                }
                //画面に追加
                view.addSubview(btn)
                if y == 0{
                    buttons.append(btn)
                    buttons_char.append(charactor)
               }
            }
        }
    }
    
    //ボタンが押されたときの動作
    func pushed(mybtn : MyButton){
        let alf = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        let x = mybtn.x
        let y = mybtn.y
        let str = buttons_char[x]
        print(str)
        var index = 0
        //押されたボタンごとに結果が異なる    
        for i in 0...alf.count-1{
            if alf[i] == str{
                index = i
            }
            print(alf[i])
        }
        print(index)
        
        if y == 1 {
            buttons_char[x] = alf[(index+1)%26]
        }else if y == 2{
            buttons_char[x] = alf[(index+25)%26]
        }

        buttons[x].setTitle(buttons_char[x], forState: UIControlState.Normal)
        print("button at (\(mybtn.x),\(mybtn.y)) is pushed")
        
    }
}