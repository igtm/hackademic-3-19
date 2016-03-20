//
//  ViewController.swift
//  guess
//
//  Created by Miyakura Souhei on 2016/03/19.
//  Copyright © 2016年 Miyakura Souhei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timeCnt : Int = 0
    var timer : NSTimer!
    
    let cntLabel: UILabel = UILabel()
    let timeLabel: UILabel = UILabel()
    let myLabel: UILabel = UILabel()
    var selector: [UIButton] = []
    var ans_labes: [UILabel] = []
    var buttons_char: [String] = []
    
    var buttons: [UIButton] = []
    var answer_string: String = ""
    var anser_strings: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...3{
            anser_strings.append("a")
            
        
        }
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
            myLabel.removeFromSuperview()
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
        
        var rand = arc4random_uniform(4) + 0
        for i in 0...3{
            anser_strings[i] = alphabet[answer[(i+Int(rand))%4]]
            if(i == 0){
                kota1.setTitle(alphabet[answer[(i+Int(rand))%4]], forState: UIControlState.Normal)
                
                //                kota1.text = alphabet[answer[(i+Int(rand))%4]]
            }else if(i == 1){
                kota2.setTitle(alphabet[answer[(i+Int(rand))%4]], forState: UIControlState.Normal)

            }else if(i == 2){
                kota3.setTitle(alphabet[answer[(i+Int(rand))%4]], forState: UIControlState.Normal)
                
            }else{
                kota4.setTitle(alphabet[answer[(i+Int(rand))%4]], forState: UIControlState.Normal)
                
            }
        }
        
        
        
    }
    
        @IBAction func function1(sender: AnyObject) {
            print(answer_string)
            print(anser_strings[0])
            if(answer_string == anser_strings[0]){
                print("miyakura")
                nextProblem()
            }
        }
    
        @IBAction func function2(sender: AnyObject) {
        print(answer_string)
        print(anser_strings[1])
        if(answer_string == anser_strings[1]){
            print("miyakura")
            nextProblem()
            }
        }
    
        @IBAction func function3(sender: AnyObject) {
        print(answer_string)
        print(anser_strings[2])
        if(answer_string == anser_strings[2]){
            print("miyakura")
            nextProblem()
            }
        }
    
        @IBAction func function4(sender: AnyObject) {
        print(answer_string)
        print(anser_strings[3])
        if(answer_string == anser_strings[3]){
            print("miyakura")
            nextProblem()
            }
        }
    
    func nextProblem(){
        library()
        quiz()

    }

    

    
}



