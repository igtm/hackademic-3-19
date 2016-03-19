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
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var ROOM_REF: Firebase {
        return _ROOM_REF
    }
    
    func findOpponent(cb:(NSString,Int)->Void) {
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
                cb(key!,host!);
            }else{
                // いないので、hostとして新しいroomを作る
                var newRef = self._BASE_REF.childByAppendingPath("rooms").childByAutoId();
                newRef.setValue(["host":USER_ID]);
                var newId = newRef.key;
                self._ROOM_REF.childByAppendingPath(newId).observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    if snapshot.key == "gest" {
                        self._ROOM_REF.removeAllObservers();
                        cb(newId,snapshot.value as! Int);
                    }
                })
            }
        })
    }
}