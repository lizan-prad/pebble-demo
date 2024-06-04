//
//  NotificationModel.swift
//  Pebble
//
//  Created by macbookPro on 12/08/2022.
//

import Foundation
import ObjectMapper

class NotificationContainerModel: Mappable {
    
    var data: [NotificationModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}

class NotificationModel: Mappable {
    
    var id: Int?
    var data: NotificationDataModel?
    var notifiableId: Int?
    var readAt: String?
    var createdAt: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        data <- map["data"]
        notifiableId <- map["notifiable_id"]
        readAt <- map["read_at"]
        createdAt <- map["created_at"]
    }
}

class NotificationDataModel: Mappable {
    
    var type: String?
    var title: String?
    var message: String?
    var metadata: NotificationTxnData?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        title <- map["title"]
        message <- map["message"]
        metadata <- map["metadata"]
    }
}

class NotificationTxnData: Mappable {
    
    var asset: String?
    var amount: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        asset <- map["asset"]
        amount <- map["amount"]
    }
}
