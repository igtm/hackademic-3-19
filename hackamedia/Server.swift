//
//  Server.swift
//  hackamedia
//
//  Created by 井口 智勝 on 2016/03/19.
//  Copyright © 2016年 watnow. All rights reserved.
//

import Foundation

class Server {
    static let server = Server()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _ROOM_REF = Firebase(url: "\(BASE_URL)/rooms")
    private var _RECORD_REF = Firebase(url: "\(BASE_URL)/records")
    private var _ROOM_ID = "";
    private var _GAME_ID = "";

    private var _GAMES = [1,2,3,4];
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var ROOM_REF: Firebase {
        return _ROOM_REF
    }
    
    var RECORD_REF: Firebase {
        return _RECORD_REF
    }
    
    func findOpponent(cb:(NSString,Int,Bool)->Void) {
        var key: String? = nil;
        var host: Int? = nil;
        _ROOM_REF.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                var dict = rest.value as! NSDictionary;
                host = dict["host"] as! Int;
                
                if let variableName = dict["gest"] {
                    // nol nill
                    print("相方なし");
                } else {
                    // nil
                    print("相方発見");
                    key = rest.key;
                    break;
                }
            }
            if key != nil {
                // 既に待ってる人がいたので、gest登録して終了
                self._BASE_REF.childByAppendingPath("rooms/" + key!).updateChildValues(["gest":USER_ID]);
                self._ROOM_ID = key!; // room_idを保持
                cb(key!,host!,false);
            }else{
                // いないので、hostとして新しいroomを作る
                var newRef = self._ROOM_REF.childByAutoId();
                newRef.setValue(["host":USER_ID]);
                var newId = newRef.key;
                self._ROOM_REF.childByAppendingPath(newId).observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    if snapshot.key == "gest" {
                        self._ROOM_REF.removeAllObservers();
                        self._ROOM_ID = newId; // room_idを保持
                        cb(newId,snapshot.value as! Int,true);
                    }
                })
            }
        })
    }
    
    func nextGame_host(app_id: Int) ->Double{
        let timestamp = NSDate().timeIntervalSince1970;
        let inTenSec = timestamp + 1000 * 10;
        print(timestamp);
        print(inTenSec);
        let newRef = _ROOM_REF.childByAppendingPath(_ROOM_ID).childByAppendingPath("games").childByAutoId();
        newRef.setValue(["id":app_id,"startTime":inTenSec]);
        _GAME_ID = newRef.key; // 新しいGame_id
        return inTenSec;
    }
    
    func nextGame_gest(cb:(Int,Int)->Void){
        _ROOM_REF.childByAppendingPath(_ROOM_ID).childByAppendingPath("games").observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
            let id = snapshot.value.objectForKey("id") as! Int;
            let startTime = snapshot.value.objectForKey("startTime") as! Int;
            self._GAME_ID = snapshot.key; // 新しいGame_id
            print(id)
            print(startTime)
            cb(id,startTime);
        })
    }
    
    // スコアの送信
    func pushScore(score:Int){
        let newRef = _RECORD_REF.childByAppendingPath(_GAME_ID).childByAutoId();
        newRef.setValue(["getter":USER_ID,"score":score]);
    }
    
    // スコア変動の監視: nextGameの後,pushScoreが起きる前に呼び出す。
    func reserveScore(cb:(Int)->Void){
        let newRef = _RECORD_REF.childByAppendingPath(_GAME_ID).observeEventType(.ChildAdded, withBlock: { snapshot in
            print(snapshot);
            
            if snapshot.value.objectForKey("getter") as! Int != USER_ID {
                let score = snapshot.value.objectForKey("score") as! Int;
                cb(score);
            }
        })
    }
}