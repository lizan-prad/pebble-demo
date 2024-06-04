//
//  NetworkManager.swift
//  Sharemil
//
//  Created by macbookPro on 13/06/2022.
//

import UIKit
import ObjectMapper
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static let shared = NetworkManager()
    
    typealias CompletionHandler<T: Mappable> = (Result<T, Error>) -> ()
    
    func request<T: Mappable>(_ value: T.Type ,urlExt: String, method: HTTPMethod, param: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping CompletionHandler<T>){
        
        let header = headers == nil ? [.authorization(bearerToken: UserDefaults.standard.string(forKey: "AUTH") ?? "")]  : headers
        print(header)
        if (NetworkReachabilityManager.default?.isReachable != true) {
            let vc = UIStoryboard.init(name: "NoInternet", bundle: nil).instantiateViewController(withIdentifier: "NoInternetViewController") as! NoInternetViewController
            appdelegate.window?.rootViewController?.present(vc, animated: true)
            return
        }
        AF.request(URLConfig.baseUrl + urlExt, method: method, parameters: param, encoding: encoding, headers: header).responseJSON { (response) in
            print(response.response)
            switch response.result {
            case .success(let data):
               
                if let data = data as? [String:Any], let model = Mapper<T>().map(JSON: data) {
                    print(data)
                    if response.response?.statusCode == 401 {
                        let coordinator = WelcomeCoordinator.init(navigationController: UINavigationController.init())
                        appdelegate.window?.rootViewController = UINavigationController.init(rootViewController: coordinator.getMainView())
                    }
                    if (400 ... 450).contains(response.response?.statusCode ?? 0) {
                        if let errors = (data["errors"] as? [[String:Any]]) , let error = Mapper<ErrorModel>().map(JSON: errors.first ?? [String:Any]()) {
                            completion(.failure(NSError.init(domain: error.field ?? "", code: 0, userInfo:   [NSLocalizedDescriptionKey: error.message ?? ""]  )))
                        } else {
                        completion(.failure(NSError.init(domain: "login", code: 0, userInfo:   [NSLocalizedDescriptionKey: (data["errorMessage"] as? String) ?? ""]  )))
                        }
                    } else if !(200...210).contains(response.response?.statusCode ?? 0) {
                        completion(.failure(NSError.init(domain: "login", code: 0, userInfo:   [NSLocalizedDescriptionKey: ((data["errors"] as? [[String:Any]])?.first?["message"] as? String) ?? ""]  )))
                    } else {
                        completion(.success(model))
                    }
                } else if (200...210).contains(response.response?.statusCode ?? 0) {
                    if let data = data as? [[String:Any]], let model = Mapper<T>().map(JSONObject: ["data": data]) {
                        print(JSON.init(data))
                        completion(.success(model))
                    } else {
                        guard let model = Mapper<T>().map(JSON: [String:Any]()) else {return}
                        completion(.success(model))
                    }
                    
                } else {
                    if let data = data as? [[String:Any]], let errors = data.first?["errors"] as? [[String:Any]], let error = Mapper<ErrorModel>().map(JSON: errors.first ?? [String:Any]()) {
                        completion(.failure(NSError.init(domain: error.field ?? "", code: 0, userInfo:   [NSLocalizedDescriptionKey: error.message ?? ""]  )))
                    }
                }
            case .failure(let error):
                if (200...210).contains(response.response?.statusCode ?? 0) {
                    guard let model = Mapper<T>().map(JSON: [String:Any]()) else {return}
                    completion(.success(model))
                } else {
                    print(String(describing: error))
                    completion(.failure(error))
                }
            }
        }
    }
    
    func requestArray<T: Mappable>(_ value: T.Type ,urlExt: String, method: HTTPMethod, param: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping (Result<[T], Error>) -> ()){
        
        let header = headers == nil ? [.authorization(bearerToken: UserDefaults.standard.string(forKey: "AUTH") ?? "")]  : headers
        print(header)
        AF.request(URLConfig.baseUrl + urlExt, method: method, parameters: param, encoding: encoding, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if (200...210).contains(response.response?.statusCode ?? 0) {
                    if let data = data as? [[String:Any]] {
                        print(data)
                        let model = Mapper<T>().mapArray(JSONArray: data)
                        completion(.success(model))
                        
                    }
                }
            case .failure(let error):
                print(String(describing: error))
                completion(.failure(error))
            }
        }
    }
    
   
    
    func requestData(urlExt: String, method: HTTPMethod, param: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping (Data) -> ()){
        
        let header = headers == nil ? ["Accept" : "application/json", "Authorization":  "Bearer \(UserDefaults.standard.string(forKey: "AT") ?? "")"] : headers

        AF.request(urlExt, method: method, parameters: param, encoding: encoding, headers: header).responseData { data in
            if let data = data.data {
                completion(data)
            }
        }
    }
    
    func requestMultipart<T: Mappable>(_value: T.Type, param:[String: Any],arrImage:[UIImage],imageKey:String,URlName:String,controller:UIViewController, withblock:@escaping (_ response: Result<Data?, AFError>)->Void){

        let header: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: "AUTH") ?? "")]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for img in arrImage {
                guard let imgData = img.jpegData(compressionQuality: 0.1) else { return }
                multipartFormData.append(imgData, withName: imageKey, fileName: "\(Date().timeIntervalSince1970)" + ".jpg", mimeType: "image/jpg")
            }
            
            
        },to: URL.init(string: URLConfig.baseUrl + URlName)!, usingThreshold: UInt64.init(),
          method: .put,
          headers: header).response{ response in
            
            if (200...210).contains(response.response?.statusCode ?? 0) {
                withblock(response.result)
            } else {
            if((response.error != nil)){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        
                        let status = parsedData["responseStatus"] as? NSInteger ?? 0
                        
                        if (status == 1){
                            if let model = Mapper<T>().map(JSONObject: parsedData) {
                                print(model)
                            }
                            
                        }else if (status == 2){
                            print("error message")
                        }else{
                            print("error message")
                        }
                    }
                }catch{
                    print("error message")
                }
                
            }else{
                 print(response.error!.localizedDescription)
            }
        }
        }
    }
       
}
