import UIKit

class FlickController: UIViewController {
    // バー
    var myProgressView:UIProgressView? = nil
    var gauge: Float = 0;
    var myScore:Int = 0;
    var opScore:Int = 0;
    
    // server push
    var time: Double = NSDate().timeIntervalSince1970;
    
    // for timer
    var timeCnt : Int = 0
    var timer : NSTimer!
    // for quiz app
    var buttons: [UIButton] = []
    var selector: [UIButton] = []
    var buttons_char: [String] = []
    var ans_labes: [UILabel] = []
    let cntLabel: UILabel = UILabel()
    let timeLabel: UILabel = UILabel()
    var myLabel: [UILabel] = [] // Design カウントの周りのラベル
    var dictionary = ["apple","image","phone","meat","fish","guess"]
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
        
        // 相手score変更の購読
        Server.server.reserveScore({(score:Int)->Void in
            print("相手のが届いた: \(score)")
            self.addOpScore(score);
        })
        
        
        timerSetUp()
        str = dictionary[3]
        let cnt = str.characters.count-1
        let diff = 1
        let myAppFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size
        // make wrong
        let wrong = make(str, diff:diff, cnt:cnt)
        
        // make label
        
        timeLabel.frame = CGRectMake(40,0,(myAppFrameSize.width),187)
        timeLabel.font = UIFont.systemFontOfSize(35)
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.text = "30"
        self.view.addSubview(timeLabel)
        
        
        var label: UILabel = UILabel()
        label.frame = CGRectMake(0,0,(myAppFrameSize.width),535)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Move              times"
        self.view.addSubview(label)
        myLabel.append(label)
        
        var timerLabel: UILabel = UILabel()
        timerLabel.frame = CGRectMake(0,0,(myAppFrameSize.width)-40,200)
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.text = "Limit : "
        self.view.addSubview(timerLabel)
        myLabel.append(timerLabel)
        
        
        cntLabel.frame = CGRectMake(0,0,(myAppFrameSize.width),520) // Design カウントの数字のラベル
        cntLabel.textAlignment = NSTextAlignment.Center
        cntLabel.font = UIFont.systemFontOfSize(50)
        cntLabel.text = "\(diff)"
        self.view.addSubview(cntLabel)
        
        // バー
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
        
        //
    }
    // バーを変える
    func changeBar(num: Float){
        print("バーを変える: \(num)")
        gauge = num
        myProgressView!.setProgress(gauge, animated: true)
        
    }
    // 自分のスコア
    func addScore(){
        // パラメータ
        var timeOnClear: Double = NSDate().timeIntervalSince1970;
        var kiso:Double = 100.0;
        var gotScore:Int = Int(kiso * (1.0/(timeOnClear - self.time) + 1.0));
        // サーバー
        Server.server.pushScore(gotScore);
        self.time = timeOnClear
        // バー
        self.myScore += gotScore
        var proportion = caluBar();
        changeBar(proportion);
    }
    // 相手のスコア
    func addOpScore(num:Int){
        // バー
        self.opScore += num
        var proportion = caluBar();
        changeBar(proportion);
    }

    // バーの割合を計算 float
    func caluBar()-> Float{
        print("caluBar: self.myScore\(self.myScore), self.opScore\(self.opScore)")

        var total: Float = Float(self.myScore + self.opScore)
        var result: Float = 0;
        if total == 0{
            result = 0.5
        }else if self.myScore == 0{
            result = 0
        }else{
            result = Float(self.myScore) / total
        }
        return result;
    }
    func onUpdate(timer : NSTimer){
        if(timeCnt < 3000000000){
            timeCnt += 1
            timeLabel.text = "\(30-timeCnt)"
            print(timeCnt) // println()は、Swift2よりDeprecatedになりました。
        } else {
            for i in selector{
                i.removeFromSuperview()
            }
            for i in ans_labes{
                i.removeFromSuperview()
            }
            ans_labes.removeAll()
            buttons_char.removeAll()
            timeLabel.removeFromSuperview()
            cntLabel.removeFromSuperview()
            for i in myLabel{
                i.removeFromSuperview()
            }
            
        }
    }
    
    func timerSetUp(){
        let myDate: NSDate = NSDate()
        let myCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponetns = myCalendar.components(NSCalendarUnit(rawValue: NSCalendarUnit.Year.rawValue   |
            NSCalendarUnit.Hour.rawValue   |
            NSCalendarUnit.Minute.rawValue |
            NSCalendarUnit.Second.rawValue) ,
            fromDate: myDate) // 注
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
        timer.fire()
        var myStr: String = "\(myComponetns.hour)"
        myStr += "\(myComponetns.minute)"
        myStr += "\(myComponetns.second)"
        
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
        let begin = Int(myAppFrameSize.width)/2 - (70 + (cnt)*80)/2
        print(begin)
        
        for i in 0...cnt{
            let charactor = String(ret[ret.startIndex.advancedBy(i)])
            
            let ansLabel: UILabel = UILabel() // Design カウントの周りのラベル
            ansLabel.frame = CGRectMake(CGFloat(i)*80 + CGFloat(begin),350,80,80) // Design カウントの数字のラベル
            ansLabel.textAlignment = NSTextAlignment.Center
            ansLabel.font = UIFont.systemFontOfSize(40)
            ansLabel.text = charactor
            self.view.addSubview(ansLabel)
            ans_labes.append(ansLabel)
            buttons_char.append(charactor)
            
        }
        for x in 0...cnt{ // 横の列
            for y in 0...1{ // 縦の列
                //位置を変えながらボタンを作る // Desigin Xx3 のますのボタンの設定
                let btn : UIButton = MyButton(
                    x:x,
                    y:y,
                    frame:CGRectMake(CGFloat(x)*80 + CGFloat(begin),CGFloat(y)*80 + 438,70,70))
                //ボタンを押したときの動作
                btn.addTarget(self, action: "pushed:", forControlEvents: .TouchUpInside)
                
                // タイトルを設定する(ボタンがハイライトされた時).
                btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
                // ボタンの影
                btn.layer.shadowOffset = CGSizeMake(5.0, 5.0)
                btn.layer.shadowOpacity = 0.5
                btn.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.9)
                btn.layer.cornerRadius = 20
                
                if y == 0 { // Design 1段目
                    btn.setTitle("▲", forState: UIControlState.Normal)
                } else if y == 1 { // Design 2段目
                    btn.setTitle("▼", forState: UIControlState.Normal)
                }
                //画面に追加
                view.addSubview(btn)
                if y == 0{
                    buttons.append(btn)
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
        
        if y == 0 {
            buttons_char[x] = alf[(index+25)%26]
        }else if y == 1{
            buttons_char[x] = alf[(index+1)%26]
        }
        
        ans_labes[x].text = buttons_char[x]
        
        // check state
        check()
    }
    
    func check(){
        let alf = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        var ret = 0
        for i in 0...ans_labes.count-1{
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
        // 正解
        if ret == 0{
            
            // サーバーとバーを更新
            print("自分が正解！！！！");
            addScore();
            
            for i in selector{
                i.removeFromSuperview()
            }
            for i in ans_labes{
                i.removeFromSuperview()
            }
            ans_labes.removeAll()
            buttons_char.removeAll()
            let diff = 1
            let random = Int(arc4random()) % dictionary.count
            str = dictionary[random]
            let cnt = str.characters.count-1
            make(str, diff:diff, cnt:cnt)
        }
    }
    
    static func colorWithHexString (hex:String) -> UIColor {
        
        let cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if ((cString as String).characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringWithRange(NSRange(location: 0, length: 2))
        let gString = (cString as NSString).substringWithRange(NSRange(location: 2, length: 2))
        let bString = (cString as NSString).substringWithRange(NSRange(location: 4, length: 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(
            red: CGFloat(Float(r) / 255.0),
            green: CGFloat(Float(g) / 255.0),
            blue: CGFloat(Float(b) / 255.0),
            alpha: CGFloat(Float(1.0))
        )
    }
}