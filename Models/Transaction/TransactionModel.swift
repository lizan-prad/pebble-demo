/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TransactionContainerModel : Mappable {

    var data: [TransactionModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
    }
}
struct TransactionModel : Mappable, Equatable {
	var id : Int?
	var user_id : Int?
	var network_id : Int?
	var asset_id : Int?
	var from_user_id : String?
	var to_user_id : Int?
	var type : String?
	var isInternal : Int?
	var from : String?
	var to : String?
	var tx_id : String?
	var amount : String?
	var confirmations : Int?
	var status : String?
	var convert_quote : String?
	var created_at : String?
	var updated_at : String?
	var to_user : To_user?
	var from_user : To_user?
	var asset : Asset?
	var network : Network?
    var txnDate: String?

	init?(map: Map) {

	}
    
    static func ==(lhs: TransactionModel, rhs: TransactionModel) -> Bool {
        return lhs.id == rhs.id
    }

	mutating func mapping(map: Map) {

		id <- map["id"]
		user_id <- map["user_id"]
		network_id <- map["network_id"]
		asset_id <- map["asset_id"]
		from_user_id <- map["from_user_id"]
		to_user_id <- map["to_user_id"]
		type <- map["type"]
		isInternal <- map["internal"]
		from <- map["from"]
		to <- map["to"]
		tx_id <- map["tx_id"]
		amount <- map["amount"]
		confirmations <- map["confirmations"]
		status <- map["status"]
		convert_quote <- map["convert_quote"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		to_user <- map["to_user"]
		from_user <- map["from_user"]
		asset <- map["asset"]
		network <- map["network"]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: created_at ?? "") {
            formatter.dateFormat = "yyyy-MM-dd"
            self.txnDate = formatter.string(from: date)
        }
        
	}

}
