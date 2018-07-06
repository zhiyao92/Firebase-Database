//
//  ToDo.swift
//  JSON-Firebase
//
//  Created by Kelvin Tan on 7/6/18.
//  Copyright © 2018 Kelvin Tan. All rights reserved.
//

import Foundation
import Firebase

struct ToDo{
    let ref: DatabaseReference?
    var id: String
    let item: String
    
    init(id: String, item: String){
        self.ref = nil
        self.id = id
        self.item = item
    }
    
    init?(snapshot: DataSnapshot){
        guard
        let value = snapshot.value as? [String:AnyObject],
        let id = value["id"] as? String,
        let item = value["item"] as? String
        else {
            return nil
        }
        self.ref = snapshot.ref
        self.id = id
        self.item = item
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "item":item
        ]
    }
}
