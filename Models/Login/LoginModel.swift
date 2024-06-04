//
//  LoginModel.swift
//  Pebble
//
//  Created by macbookPro on 20/07/2022.
//

import Foundation
import ObjectMapper

class LoginModel: Mappable {
    
    var expiresAt: Date?
    var type: String?
    var token: String?
    var primaryAssetId: Int?
    var mobile: Int?
    var phone: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        expiresAt <- map["expires_at"]
        type <- map["type"]
        token <- map["token"]
        primaryAssetId <- map["primary_asset_id"]
        mobile <- map["mobile"]
        phone = "\(mobile ?? 0)"
    }
}
