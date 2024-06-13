//
//  HQWebService.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

class HQWebService: HQWebServiceProtocol {
    func getData<T: Decodable>(urlString: String, _ completion: @escaping (_ success: Bool, _ model: T?, _ error: HQWebServiceError?) -> ()) {
        
        // This can later be changed to stop specific task with this url.
        URLSession.shared.cancelAllRunningtasks()
        
        let session = URLSession.shared;
        
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            
            let loadTask = session.dataTask(with: urlRequest) { (data, response, error) in
                if let errorResponse = error {
                    completion(false, nil, HQWebServiceError.customError(message: errorResponse.localizedDescription))
                } else if let httpResponse = response as? HTTPURLResponse {
#if DEBUG
                    if let data = data {
                        let str = String(decoding: data, as: UTF8.self)
                        // This will print only in DEBUG Mode. Check file HQLogger.swift
                        print(str)
                    }
#endif
                    if httpResponse.statusCode != 200 {
                        var errorMessage: String?
                        if let data = data {
                            do {
                                let jsonResponse = try JSONSerialization.jsonObject(with:data, options: [])
                                if let jsonDict =  jsonResponse as? NSDictionary, let errorDict =  jsonDict["error"] as? NSDictionary {
                                    if let errorDescription = errorDict["description"] as? String {
                                        errorMessage = errorDescription
                                    }
                                }
                            } catch let parsingError {
                                // This will print only in DEBUG Mode. Check file HQLogger.swift
                                print("Error", parsingError)
                            }
                        }
                        let errorResponse = NSError(domain: "Domain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : "Http error occured"])
                        completion(false, nil, HQWebServiceError.customError(message:errorMessage ?? errorResponse.localizedDescription))
                    } else {
//                        let model = self.parseResponse(data: data)
                        var model: T?
                        
                        if let data = data {
                            do {
                                let dataModel = try JSONDecoder().decode(T.self, from: data)
                                model = dataModel
                            } catch {
                                // This will print only in DEBUG Mode. Check file HQLogger.swift
                                print("\(error)")
                            }
                        }
                        
                        completion(true, model, nil)
                    }
                }
            }
            loadTask.resume()
            return
        }
        completion(false, nil, HQWebServiceError.internalError)
    }
}
