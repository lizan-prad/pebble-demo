//
//  ErrorModel.swift
//  Pebble
//
//  Created by macbookPro on 02/08/2022.
//

import Foundation
import ObjectMapper

class ErrorModel: Mappable {
    
    var field: String?
    var message: String?
    var rule: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        field <- map["field"]
        message <- map["message"]
        rule <- map["rule"]
    }
}
