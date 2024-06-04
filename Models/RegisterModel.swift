//
//  RegisterModel.swift
//  Pebble
//
//  Created by macbookPro on 17/07/2022.
//

import Foundation
import ObjectMapper

class RegisterModel: Mappable {
 
    var verificationId: String?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
    
        verificationId <- map["verification_id"]
    }
}
