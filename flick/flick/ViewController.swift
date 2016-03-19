import UIKit

class ViewController: UIViewController {
    
    var buttons: [UIButton] = []
    var selector: [UIButton] = []
    var buttons_char: [String] = []
    let cntLabel: UILabel = UILabel()
    var dictionary = ["apple","orange","banana","meat","fish","egg"]
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
        str = dictionary[3]
        let cnt = str.characters.count-1
        let diff = 1
        let myAppFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size
        // make wrong
        let wrong = make(str, diff:diff, cnt:cnt)
        
        // make label
        let myLabel: UILabel = UILabel() // Design カウントの周りのラベル
        myLabel.frame = CGRectMake(0,0,(myAppFrameSize.width),535)
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.text = "Move              times"
        self.view.addSubview(myLabel)
        
        cntLabel.frame = CGRectMake(0,0,(myAppFrameSize.width),520) // Design カウントの数字のラベル
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
        for codeUnit in original.utf8{
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
        print(ary,words)
        for i in 0...cnt{
            
            print(ary.count,words.count,i)
            
            words[i] = (26 + ary[i] + words[i]) % 26
            ret += alf[words[i]]
        }
        
        // 画面サイズ
        let myAppFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size
        // 箱を置く位置の開始位置
        let begin = Int(myAppFrameSize.width)/2 - (50 + (cnt)*60)/2
        print(begin)
        for x in 0...cnt{ // 横の列
            for y in 0...2{ // 縦の列
                //位置を変えながらボタンを作る // Desigin Xx3 のますのボタンの設定
                let btn : UIButton = MyButton(
                    x:x,
                    y:y,
                    frame:CGRectMake(CGFloat(x)*60 + CGFloat(begin),CGFloat(y)*60 + 50,50,50))
                //ボタンを押したときの動作
                btn.addTarget(self, action: "pushed:", forControlEvents: .TouchUpInside)
                
                let charactor = String(ret[ret.startIndex.advancedBy(x)])
                if y == 0 { // Design 1段目
                    btn.setTitle(charactor, forState: UIControlState.Normal)
                    btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
                } else if y == 1 { // Design 2段目
                    btn.setTitle("▲", forState: UIControlState.Normal)
                    btn.backgroundColor = UIColor.redColor()
                    btn.layer.cornerRadius = 10
                    
                } else { // Design 3段目
                    btn.setTitle("▼", forState: UIControlState.Normal)
                    btn.backgroundColor = UIColor.redColor()
                    btn.layer.cornerRadius = 10
                }
                //画面に追加
                view.addSubview(btn)
                if y == 0{
                    buttons.append(btn)
                    buttons_char.append(charactor)
                }
                selector.append(btn)
            }
        }
        check()
        return ret
    }
    
    //ボタンが押されたときの動作
    func pushed(mybtn : MyButton){
        let alf = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        let x = mybtn.x
        let y = mybtn.y
        let str = buttons_char[x]
        var index = 0
        //押されたボタンごとに結果が異なる    
        for i in 0...alf.count-1{
            if alf[i] == str{
                index = i
            }
        }
        
        if y == 1 {
            buttons_char[x] = alf[(index+1)%26]
        }else if y == 2{
            buttons_char[x] = alf[(index+25)%26]
        }
        
        buttons[x].setTitle(buttons_char[x], forState: UIControlState.Normal)
        
        // check state
        check()
    }
    
    func check(){
        let alf = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        var ret = 0
        for i in 0...buttons.count-1{
            let substrStartIndex = str.startIndex.advancedBy(i)
            let substrEndIndex = substrStartIndex.advancedBy(1)
            let substr = str.substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
            if(buttons_char[i] != substr){
                var b = -1, s = -1
                for j in 0...alf.count{
                    if buttons_char[i] == alf[j] {b = j}
                    if substr == alf[j] {s = j}
                    if s >= 0 && b >= 0 {break}
                }
                ret += min((26-s+b)%26,(26+s-b)%26)
                
            }
        }
        cntLabel.text = "\(ret)"
        self.view.addSubview(cntLabel)
        if ret == 0{
            for i in selector{
               i.removeFromSuperview()
            }
            buttons.removeAll()
            buttons_char.removeAll()
            
            let diff = 1
            let random = Int(arc4random()) % dictionary.count
            str = dictionary[random]
            var cnt = str.characters.count-1
            let wrong = make(str, diff:diff, cnt:cnt)
            
        }
    }
}