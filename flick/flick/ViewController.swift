import UIKit

class ViewController: UIViewController {
    
    var buttons: [UIButton] = []
    var buttons_char: [String] = []
    let cntLabel: UILabel = UILabel()
    
    var str = ""
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
        str = "apple"
        let cnt = str.characters.count-1
        let diff = 1
        // make wrong
        let wrong = make(str, diff:diff, cnt:cnt)
        
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
                let charactor = String(wrong[wrong.startIndex.advancedBy(x)])
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
        
        // make label
        let myLabel: UILabel = UILabel()
        myLabel.frame = CGRectMake(0,0,(myAppFrameSize.width),535)
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.text = "Move              times"
        self.view.addSubview(myLabel)
        
        cntLabel.frame = CGRectMake(0,0,(myAppFrameSize.width),520)
        cntLabel.textAlignment = NSTextAlignment.Center
        cntLabel.font = UIFont.systemFontOfSize(40)
        cntLabel.text = "\(diff)"
        self.view.addSubview(cntLabel)
    }
    
    func make(original:String, diff:Int, cnt:Int)->String{
        let alf = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        var ary:[Int] = []
        for _ in 0...cnt{
            ary.append(0)
        }
        var words:[Int] = []
        for codeUnit in original.utf8 {
            words.append(Int(codeUnit - 97))
        }
        
        for _ in 1...diff{
            let index = (Int)(arc4random_uniform(UInt32(cnt*2+1)))
            if(ary[index/2] != 0){
                ary[index/2] += (ary[index/2] > 0 ? 1 : -1)
            }else{
                ary[index/2] = (index>cnt ? -1 : 1)
            }

        }
        var ret = ""
        for i in 0...cnt{
            words[i] = (26 + ary[i] + words[i]) % 26
            ret += alf[words[i]]
        }
        return ret
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
        }
        print(index)
        
        if y == 1 {
            buttons_char[x] = alf[(index+1)%26]
        }else if y == 2{
            buttons_char[x] = alf[(index+25)%26]
        }
        
        buttons[x].setTitle(buttons_char[x], forState: UIControlState.Normal)
        print("button at (\(mybtn.x),\(mybtn.y)) is pushed")
        
        // check state
        check()
    }
    
    func check()->Int{
        let alf = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        var ret = 0
        for i in 0...buttons.count-1{
            let substrStartIndex = str.startIndex.advancedBy(i)
            let substrEndIndex = substrStartIndex.advancedBy(1)
            let substr = str.substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
            print(buttons_char[i],substr)
            if(buttons_char[i] != substr){
                var b = -1, s = -1
                for j in 0...alf.count{
                    print(i,j,b,s,ret)
                    if buttons_char[i] == alf[j] {b = j}
                    if substr == alf[j] {s = j}
                    if s >= 0 && b >= 0 {break}
                }
                ret += min((26-s+b)%26,(26+s-b)%26)
                
            }
            print(ret)
        }
        print(ret)
        cntLabel.text = "\(ret)"
        self.view.addSubview(cntLabel)
        return ret
    }
}