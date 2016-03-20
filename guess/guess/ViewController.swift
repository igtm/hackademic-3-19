//
//  ViewController.swift
//  guess
//
//  Created by Miyakura Souhei on 2016/03/19.
//  Copyright © 2016年 Miyakura Souhei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // for timer
    var timeCnt : Int = 0
    var timer : NSTimer!
    let timeLabel: UILabel = UILabel()
    
    // selector
    var buttons: [UIButton] = []
    var buttons_char: [String] = []
    var anser_strings: [String] = []
    var ans_labes: [UILabel] = []
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    
    // answers
    var answer_string: String = ""
    
    var Label: [UILabel] = [] // Design カウントの周りのラベル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerSetUp()
        Initialize()
        for _ in 0...3{
            anser_strings.append("a")
        }
        
        let myAppFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size
        timeLabel.frame = CGRectMake(40,0,(myAppFrameSize.width),187)
        timeLabel.font = UIFont.systemFontOfSize(35)
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.text = "30"
        self.view.addSubview(timeLabel)
        Label.append(timeLabel)
        
        var timerLabel: UILabel = UILabel()
        timerLabel.frame = CGRectMake(0,0,(myAppFrameSize.width)-40,200)
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.text = "Limit : "
        self.view.addSubview(timerLabel)
        Label.append(timerLabel)
        
        library()
        quiz()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var button: UILabel!

    @IBOutlet var kota1: UIButton!
    @IBOutlet var kota2: UIButton!
    @IBOutlet var kota3: UIButton!
    @IBOutlet var kota4: UIButton!
    
    
    func onUpdate(timer : NSTimer){
        if(timeCnt < 30){
            timeCnt += 1
            timeLabel.text = "\(30-timeCnt)"
            print(timeCnt) // println()は、Swift2よりDeprecatedになりました。
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
    
    func Initialize(){
        button.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.9)
        for btn in [kota1, kota2, kota3, kota4]{
            btn.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.9)
            // ボタンの影
            btn.layer.shadowOffset = CGSizeMake(5.0, 5.0)
            btn.layer.shadowOpacity = 0.5
            btn.layer.cornerRadius = 20
        }
        for label in [label1,label2,label3,label4]{
            label.font = UIFont.systemFontOfSize(30)
            label.textColor = UIColor.whiteColor()
        }
    }
    
    
    //問題のところだよ
    func library(){
       
         var i = arc4random_uniform(15) + 0
        
        var samp = ["apple","orange","grape","machine","phone","computer","cup","english","cloth","interesting","class","brain","train","clock","question"]
       
        let ans = samp[Int(i)]  //本番はLibraryからひろう
        
        let size = UInt32(ans.characters.count)
        
        let a = arc4random() % size
        
        //print(a)
        
        let bf = ans.substringToIndex(ans.startIndex.advancedBy(Int(a)))
        let af = ans.substringFromIndex(ans.startIndex.advancedBy(Int(a)+1))
        
        //答えの単語だよ
        let substrStartIndex = ans.startIndex.advancedBy(Int(a))
        let substrEndIndex = substrStartIndex.advancedBy(1)
        let hidden = ans.substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
        print(hidden)
        
        
        let question = bf+"_"+af
        
        answer_string = hidden;
        button.text = question
        button.font = UIFont.systemFontOfSize(50);
        
        
        
    }
    
    //4択のところだよ
    func quiz(){
        let ans = answer_string
        print(ans)
        let alphabet: [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        
        var ans_num = -1
        for i in 0...alphabet.count-1{
            if(ans == alphabet[i]){
                ans_num = i
            }
        }
        print(ans_num)
        var answers = [ans_num]
        var answer: [Int] = [ans_num]
        
        var i = 1
        while(i < 4){
            let rand = arc4random_uniform(25) + 0
            if !answers.contains(Int(rand)){
                
                answer.append(Int(rand))
                i += 1
            
            }
            
        }
        print(answer)
        
        let rand = arc4random_uniform(4) + 0
        for i in 0...3{
            anser_strings[i] = alphabet[answer[(i+Int(rand))%4]]
            if(i == 0){
                label1.text = anser_strings[i]
            }else if(i == 1){
                label2.text = anser_strings[i]
            }else if(i == 2){
                label3.text = anser_strings[i]
            }else{
                label4.text = anser_strings[i]
            }
        }
        
        
        
    }
    
    // check result function
    @IBAction func function1(sender: AnyObject) {if(answer_string == anser_strings[0]){nextProblem()}}
    @IBAction func function2(sender: AnyObject) {if(answer_string == anser_strings[1]){nextProblem()}}
    @IBAction func function3(sender: AnyObject) {if(answer_string == anser_strings[2]){nextProblem()}}
    @IBAction func function4(sender: AnyObject) {if(answer_string == anser_strings[3]){nextProblem()}}
    
    // select next problem
    func nextProblem(){
        library()
        quiz()

    }

    

    
}



