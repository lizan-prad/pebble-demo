//
//  CountryManager.swift
//  Pebble
//
//  Created by macbookPro on 02/08/2022.
//

import UIKit

class CountryManager {
    
    static let shared = CountryManager()
    
    var countries: [CountryModel] = {
        var countries: [CountryModel] = []
        
        countries.append(CountryModel(countryCode: "AF", phoneExtension: "93"))
        countries.append(CountryModel(countryCode: "AL", phoneExtension: "355"))
        countries.append(CountryModel(countryCode: "DZ", phoneExtension: "213"))
        countries.append(CountryModel(countryCode: "AS", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "AD", phoneExtension: "376"))
        countries.append(CountryModel(countryCode: "AO", phoneExtension: "244"))
        countries.append(CountryModel(countryCode: "AI", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "AQ", phoneExtension: "672"))
        countries.append(CountryModel(countryCode: "AG", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "AR", phoneExtension: "54"))
        countries.append(CountryModel(countryCode: "AM", phoneExtension: "374"))
        countries.append(CountryModel(countryCode: "AW", phoneExtension: "297"))
        countries.append(CountryModel(countryCode: "AU", phoneExtension: "61"))
        countries.append(CountryModel(countryCode: "AT", phoneExtension: "43"))
        countries.append(CountryModel(countryCode: "AZ", phoneExtension: "994"))
        
        
        countries.append(CountryModel(countryCode: "BS", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "BH", phoneExtension: "973"))
        countries.append(CountryModel(countryCode: "BD", phoneExtension: "880"))
        countries.append(CountryModel(countryCode: "BB", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "BY", phoneExtension: "375"))
        countries.append(CountryModel(countryCode: "BE", phoneExtension: "32"))
        countries.append(CountryModel(countryCode: "BZ", phoneExtension: "501"))
        countries.append(CountryModel(countryCode: "BJ", phoneExtension: "229"))
        countries.append(CountryModel(countryCode: "BM", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "BT", phoneExtension: "975"))
        countries.append(CountryModel(countryCode: "BO", phoneExtension: "591"))
        countries.append(CountryModel(countryCode: "BA", phoneExtension: "387"))
        countries.append(CountryModel(countryCode: "BW", phoneExtension: "267"))
        countries.append(CountryModel(countryCode: "BR", phoneExtension: "55"))
        countries.append(CountryModel(countryCode: "IO", phoneExtension: "246"))
        countries.append(CountryModel(countryCode: "VG", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "BN", phoneExtension: "673"))
        countries.append(CountryModel(countryCode: "BG", phoneExtension: "359"))
        countries.append(CountryModel(countryCode: "BF", phoneExtension: "226"))
        countries.append(CountryModel(countryCode: "BI", phoneExtension: "257"))
        countries.append(CountryModel(countryCode: "KH", phoneExtension: "855"))
        countries.append(CountryModel(countryCode: "CM", phoneExtension: "237"))
        countries.append(CountryModel(countryCode: "CA", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "CV", phoneExtension: "238"))
        
        countries.append(CountryModel(countryCode: "KY", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "CF", phoneExtension: "236"))
        countries.append(CountryModel(countryCode: "TD", phoneExtension: "235"))
        countries.append(CountryModel(countryCode: "CL", phoneExtension: "56"))
        countries.append(CountryModel(countryCode: "CN", phoneExtension: "86"))
        countries.append(CountryModel(countryCode: "CX", phoneExtension: "61"))
        countries.append(CountryModel(countryCode: "CC", phoneExtension: "61"))
        countries.append(CountryModel(countryCode: "CO", phoneExtension: "57"))
        countries.append(CountryModel(countryCode: "KM", phoneExtension: "269"))
        countries.append(CountryModel(countryCode: "CK", phoneExtension: "682"))
        countries.append(CountryModel(countryCode: "CR", phoneExtension: "506"))
        countries.append(CountryModel(countryCode: "HR", phoneExtension: "385"))
        countries.append(CountryModel(countryCode: "CU", phoneExtension: "53"))
        countries.append(CountryModel(countryCode: "CW", phoneExtension: "599"))
        countries.append(CountryModel(countryCode: "CY", phoneExtension: "357"))
        countries.append(CountryModel(countryCode: "CZ", phoneExtension: "420"))
        countries.append(CountryModel(countryCode: "CD", phoneExtension: "243"))
        
        countries.append(CountryModel(countryCode: "DK", phoneExtension: "45"))
        countries.append(CountryModel(countryCode: "DJ", phoneExtension: "253"))
        countries.append(CountryModel(countryCode: "DM", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "DO", phoneExtension: "1"))
        
        countries.append(CountryModel(countryCode: "TL", phoneExtension: "670"))
        countries.append(CountryModel(countryCode: "EC", phoneExtension: "593"))
        countries.append(CountryModel(countryCode: "EG", phoneExtension: "20"))
        countries.append(CountryModel(countryCode: "SV", phoneExtension: "503"))
        countries.append(CountryModel(countryCode: "GQ", phoneExtension: "240"))
        countries.append(CountryModel(countryCode: "ER", phoneExtension: "291"))
        countries.append(CountryModel(countryCode: "EE", phoneExtension: "372"))
        countries.append(CountryModel(countryCode: "ET", phoneExtension: "251"))
        
        countries.append(CountryModel(countryCode: "FK", phoneExtension: "500"))
        countries.append(CountryModel(countryCode: "FO", phoneExtension: "298"))
        countries.append(CountryModel(countryCode: "FJ", phoneExtension: "679"))
        countries.append(CountryModel(countryCode: "FI", phoneExtension: "358"))
        countries.append(CountryModel(countryCode: "FR", phoneExtension: "33"))
        countries.append(CountryModel(countryCode: "PF", phoneExtension: "689"))
        
        countries.append(CountryModel(countryCode: "GA", phoneExtension: "241"))
        countries.append(CountryModel(countryCode: "GM", phoneExtension: "220"))
        countries.append(CountryModel(countryCode: "GE", phoneExtension: "995"))
        countries.append(CountryModel(countryCode: "DE", phoneExtension: "49"))
        countries.append(CountryModel(countryCode: "GH", phoneExtension: "233"))
        countries.append(CountryModel(countryCode: "GI", phoneExtension: "350"))
        countries.append(CountryModel(countryCode: "GR", phoneExtension: "30"))
        countries.append(CountryModel(countryCode: "GL", phoneExtension: "299"))
        countries.append(CountryModel(countryCode: "GD", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "GU", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "GT", phoneExtension: "502"))
        countries.append(CountryModel(countryCode: "GG", phoneExtension: "44"))
        countries.append(CountryModel(countryCode: "GN", phoneExtension: "224"))
        countries.append(CountryModel(countryCode: "GW", phoneExtension: "245"))
        countries.append(CountryModel(countryCode: "GY", phoneExtension: "592"))
        
        countries.append(CountryModel(countryCode: "HT", phoneExtension: "509"))
        countries.append(CountryModel(countryCode: "HN", phoneExtension: "504"))
        countries.append(CountryModel(countryCode: "HK", phoneExtension: "852"))
        countries.append(CountryModel(countryCode: "HU", phoneExtension: "36"))
        
        countries.append(CountryModel(countryCode: "IS", phoneExtension: "354"))
        countries.append(CountryModel(countryCode: "IN", phoneExtension: "91"))
        countries.append(CountryModel(countryCode: "ID", phoneExtension: "62"))
        countries.append(CountryModel(countryCode: "IR", phoneExtension: "98"))
        countries.append(CountryModel(countryCode: "IQ", phoneExtension: "964"))
        countries.append(CountryModel(countryCode: "IE", phoneExtension: "353"))
        countries.append(CountryModel(countryCode: "IM", phoneExtension: "44"))
        countries.append(CountryModel(countryCode: "IL", phoneExtension: "972"))
        countries.append(CountryModel(countryCode: "IT", phoneExtension: "39"))
        countries.append(CountryModel(countryCode: "CI", phoneExtension: "225"))
        
        countries.append(CountryModel(countryCode: "JM", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "JP", phoneExtension: "81"))
        countries.append(CountryModel(countryCode: "JE", phoneExtension: "44"))
        countries.append(CountryModel(countryCode: "JO", phoneExtension: "962"))
        
        countries.append(CountryModel(countryCode: "KZ", phoneExtension: "7"))
        countries.append(CountryModel(countryCode: "KE", phoneExtension: "254"))
        countries.append(CountryModel(countryCode: "KI", phoneExtension: "686"))
        countries.append(CountryModel(countryCode: "XK", phoneExtension: "383"))
        countries.append(CountryModel(countryCode: "KW", phoneExtension: "965"))
        countries.append(CountryModel(countryCode: "KG", phoneExtension: "996"))
        
        countries.append(CountryModel(countryCode: "LA", phoneExtension: "856"))
        countries.append(CountryModel(countryCode: "LV", phoneExtension: "371"))
        countries.append(CountryModel(countryCode: "LB", phoneExtension: "961"))
        countries.append(CountryModel(countryCode: "LS", phoneExtension: "266"))
        countries.append(CountryModel(countryCode: "LR", phoneExtension: "231"))
        countries.append(CountryModel(countryCode: "LY", phoneExtension: "218"))
        countries.append(CountryModel(countryCode: "LI", phoneExtension: "423"))
        countries.append(CountryModel(countryCode: "LT", phoneExtension: "370"))
        countries.append(CountryModel(countryCode: "LU", phoneExtension: "352"))
        
        countries.append(CountryModel(countryCode: "MO", phoneExtension: "853"))
        countries.append(CountryModel(countryCode: "MK", phoneExtension: "389"))
        countries.append(CountryModel(countryCode: "MG", phoneExtension: "261"))
        countries.append(CountryModel(countryCode: "MW", phoneExtension: "265"))
        countries.append(CountryModel(countryCode: "MY", phoneExtension: "60"))
        countries.append(CountryModel(countryCode: "MV", phoneExtension: "960"))
        countries.append(CountryModel(countryCode: "ML", phoneExtension: "223"))
        countries.append(CountryModel(countryCode: "MT", phoneExtension: "356"))
        countries.append(CountryModel(countryCode: "MH", phoneExtension: "692"))
        countries.append(CountryModel(countryCode: "MR", phoneExtension: "222"))
        countries.append(CountryModel(countryCode: "MU", phoneExtension: "230"))
        countries.append(CountryModel(countryCode: "YT", phoneExtension: "262"))
        countries.append(CountryModel(countryCode: "MX", phoneExtension: "52"))
        countries.append(CountryModel(countryCode: "FM", phoneExtension: "691"))
        countries.append(CountryModel(countryCode: "MD", phoneExtension: "373"))
        countries.append(CountryModel(countryCode: "MC", phoneExtension: "377"))
        countries.append(CountryModel(countryCode: "MN", phoneExtension: "976"))
        countries.append(CountryModel(countryCode: "ME", phoneExtension: "382"))
        countries.append(CountryModel(countryCode: "MS", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "MA", phoneExtension: "212"))
        countries.append(CountryModel(countryCode: "MZ", phoneExtension: "258"))
        countries.append(CountryModel(countryCode: "MM", phoneExtension: "95"))
        
        countries.append(CountryModel(countryCode: "NA", phoneExtension: "264"))
        countries.append(CountryModel(countryCode: "NR", phoneExtension: "674"))
        countries.append(CountryModel(countryCode: "NP", phoneExtension: "977"))
        countries.append(CountryModel(countryCode: "NL", phoneExtension: "31"))
        countries.append(CountryModel(countryCode: "AN", phoneExtension: "599"))
        countries.append(CountryModel(countryCode: "NC", phoneExtension: "687"))
        countries.append(CountryModel(countryCode: "NZ", phoneExtension: "64"))
        countries.append(CountryModel(countryCode: "NI", phoneExtension: "505"))
        countries.append(CountryModel(countryCode: "NE", phoneExtension: "227"))
        countries.append(CountryModel(countryCode: "NG", phoneExtension: "234"))
        countries.append(CountryModel(countryCode: "NU", phoneExtension: "683"))
        countries.append(CountryModel(countryCode: "KP", phoneExtension: "850"))
        countries.append(CountryModel(countryCode: "MP", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "NO", phoneExtension: "47"))
        
        countries.append(CountryModel(countryCode: "OM", phoneExtension: "968"))
        
        countries.append(CountryModel(countryCode: "PK", phoneExtension: "92"))
        countries.append(CountryModel(countryCode: "PW", phoneExtension: "680"))
        countries.append(CountryModel(countryCode: "PS", phoneExtension: "970"))
        countries.append(CountryModel(countryCode: "PA", phoneExtension: "507"))
        countries.append(CountryModel(countryCode: "PG", phoneExtension: "675"))
        countries.append(CountryModel(countryCode: "PY", phoneExtension: "595"))
        countries.append(CountryModel(countryCode: "PE", phoneExtension: "51"))
        countries.append(CountryModel(countryCode: "PH", phoneExtension: "63"))
        countries.append(CountryModel(countryCode: "PN", phoneExtension: "64"))
        countries.append(CountryModel(countryCode: "PL", phoneExtension: "48"))
        countries.append(CountryModel(countryCode: "PT", phoneExtension: "351"))
        countries.append(CountryModel(countryCode: "PR", phoneExtension: "1"))
        
        countries.append(CountryModel(countryCode: "QA", phoneExtension: "974"))
        
        countries.append(CountryModel(countryCode: "CG", phoneExtension: "242"))
        countries.append(CountryModel(countryCode: "RE", phoneExtension: "262"))
        countries.append(CountryModel(countryCode: "RO", phoneExtension: "40"))
        countries.append(CountryModel(countryCode: "RU", phoneExtension: "7"))
        countries.append(CountryModel(countryCode: "RW", phoneExtension: "250"))
        
        countries.append(CountryModel(countryCode: "BL", phoneExtension: "590"))
        countries.append(CountryModel(countryCode: "SH", phoneExtension: "290"))
        countries.append(CountryModel(countryCode: "KN", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "LC", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "MF", phoneExtension: "590"))
        countries.append(CountryModel(countryCode: "PM", phoneExtension: "508"))
        
        countries.append(CountryModel(countryCode: "VC", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "WS", phoneExtension: "685"))
        countries.append(CountryModel(countryCode: "SM", phoneExtension: "378"))
        countries.append(CountryModel(countryCode: "ST", phoneExtension: "239"))
        countries.append(CountryModel(countryCode: "SA", phoneExtension: "966"))
        countries.append(CountryModel(countryCode: "SN", phoneExtension: "221"))
        countries.append(CountryModel(countryCode: "RS", phoneExtension: "381"))
        countries.append(CountryModel(countryCode: "SC", phoneExtension: "248"))
        countries.append(CountryModel(countryCode: "SL", phoneExtension: "232"))
        countries.append(CountryModel(countryCode: "SG", phoneExtension: "65"))
        countries.append(CountryModel(countryCode: "SX", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "SK", phoneExtension: "421"))
        countries.append(CountryModel(countryCode: "SI", phoneExtension: "386"))
        countries.append(CountryModel(countryCode: "SB", phoneExtension: "677"))
        countries.append(CountryModel(countryCode: "SO", phoneExtension: "252"))
        countries.append(CountryModel(countryCode: "ZA", phoneExtension: "27"))
        countries.append(CountryModel(countryCode: "KR", phoneExtension: "82"))
        countries.append(CountryModel(countryCode: "SS", phoneExtension: "211"))
        countries.append(CountryModel(countryCode: "ES", phoneExtension: "34"))
        countries.append(CountryModel(countryCode: "LK", phoneExtension: "94"))
        countries.append(CountryModel(countryCode: "SD", phoneExtension: "249"))
        countries.append(CountryModel(countryCode: "SR", phoneExtension: "597"))
        countries.append(CountryModel(countryCode: "SJ", phoneExtension: "47"))
        countries.append(CountryModel(countryCode: "SZ", phoneExtension: "268"))
        countries.append(CountryModel(countryCode: "SE", phoneExtension: "46"))
        countries.append(CountryModel(countryCode: "CH", phoneExtension: "41"))
        countries.append(CountryModel(countryCode: "SY", phoneExtension: "963"))
        
        countries.append(CountryModel(countryCode: "TW", phoneExtension: "886"))
        countries.append(CountryModel(countryCode: "TJ", phoneExtension: "992"))
        countries.append(CountryModel(countryCode: "TZ", phoneExtension: "255"))
        countries.append(CountryModel(countryCode: "TH", phoneExtension: "66"))
        countries.append(CountryModel(countryCode: "TG", phoneExtension: "228"))
        countries.append(CountryModel(countryCode: "TK", phoneExtension: "690"))
        countries.append(CountryModel(countryCode: "TO", phoneExtension: "676"))
        countries.append(CountryModel(countryCode: "TT", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "TN", phoneExtension: "216"))
        countries.append(CountryModel(countryCode: "TR", phoneExtension: "90"))
        countries.append(CountryModel(countryCode: "TM", phoneExtension: "993"))
        countries.append(CountryModel(countryCode: "TC", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "TV", phoneExtension: "688"))
        
        countries.append(CountryModel(countryCode: "VI", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "UG", phoneExtension: "256"))
        countries.append(CountryModel(countryCode: "UA", phoneExtension: "380"))
        countries.append(CountryModel(countryCode: "AE", phoneExtension: "971"))
        countries.append(CountryModel(countryCode: "GB", phoneExtension: "44"))
        countries.append(CountryModel(countryCode: "US", phoneExtension: "1"))
        countries.append(CountryModel(countryCode: "UY", phoneExtension: "598"))
        countries.append(CountryModel(countryCode: "UZ", phoneExtension: "998"))
        
        countries.append(CountryModel(countryCode: "VU", phoneExtension: "678"))
        countries.append(CountryModel(countryCode: "VA", phoneExtension: "379"))
        countries.append(CountryModel(countryCode: "VE", phoneExtension: "58"))
        countries.append(CountryModel(countryCode: "VN", phoneExtension: "84"))
        
        countries.append(CountryModel(countryCode: "WF", phoneExtension: "681"))
        countries.append(CountryModel(countryCode: "EH", phoneExtension: "212"))
        
        countries.append(CountryModel(countryCode: "YE", phoneExtension: "967"))
        
        countries.append(CountryModel(countryCode: "ZM", phoneExtension: "260"))
        countries.append(CountryModel(countryCode: "ZW", phoneExtension: "263"))
        
        return countries
        }()
}

class CountryModel: NSObject {
    
    public var countryCode: String
    public var phoneExtension: String
    
    public var name: String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode) ?? nil
    }
    
    public var flag: String? {
        return flag(country: countryCode)
    }
    
    init(countryCode: String, phoneExtension: String) {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
    }
    
    private func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
