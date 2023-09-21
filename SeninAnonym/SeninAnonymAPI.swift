//
//  SeninAnonymAPI.swift
//  SeninAnonym
//
//  Created by Ardahan Kul on 3.09.2023.
//

import Foundation

struct UserListModel : Codable{
    let username : String
    let fullName : String
    let email : String
    let guid : String
}

struct SearchUserResponse : Codable{
    let userList : [UserListModel]
}


class UserListViewModel: ObservableObject{
    @Published var items = [UserListModel]()
    
    func loadData(searchParam : String) {
        let url = URL(string: "http://127.0.0.1:8080/api/v1/searchUser")
        let credentials: [String: String] = ["searchParameter": searchParam]
        let jsonReq = try? JSONSerialization.data(withJSONObject: credentials)
        print("url is : \(String(describing: url))")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
            // Add the Bearer token to the Authorization header
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            print(authToken)
        }
        request.httpBody = jsonReq
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do{
                if let data = data{
                    
                    //print data content
                    if let dataString = String(data: data, encoding: .utf8) {
                                    print("Data received: \(dataString)")
                                } else {
                                    print("Unable to convert data to string.")
                                }
                    
                    let result = try JSONDecoder().decode(SearchUserResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.items = result.userList
                    }
                }else{
                    print("no data")
                }
            }catch{
                print("error is  \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    
}

struct SeninAnonymAPI {
    static let baseURL = "http://127.0.0.1:8080/api/v1/"

    enum Auth: String {
        case login = "auth/authenticate"
        case register = "auth/register"
    }

    static func auth(endpoint: Auth, jsonReq: Data, completion: @escaping (Bool) -> Void) {
        let defaults = UserDefaults.standard
        var isSuccess = false
        let url = URL(string: "\(baseURL)\(endpoint.rawValue)")
        print("url is : \(String(describing: url))")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonReq

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonData = data {
                print(jsonData)
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                        if let token = jsonObj["token"] as? String {
                            print(token)
                            defaults.set(token, forKey: "AuthToken")
                            isSuccess = true
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else if let requestError = error {
                print("error occurred while sending request \(requestError.localizedDescription)")
                isSuccess = false
            } else {
                print("unexpected error occurred")
                isSuccess = false
            }

            // Call the completion handler with the result
            completion(isSuccess)
        }
        task.resume()
    }
    
    static func askQuestion(jsonReq: Data, guid: String, completion: @escaping (Bool) -> Void) {
        var isSuccess = false
        let url = URL(string: "\(baseURL)ask/\(guid)")
        print("url is : \(String(describing: url))")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
            // Add the Bearer token to the Authorization header
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonReq
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonData = data {
                isSuccess = true
            } else if let requestError = error {
                print("error occurred while sending request \(requestError.localizedDescription)")
                isSuccess = false
            } else {
                print("unexpected error occurred")
                isSuccess = false
            }

            // Call the completion handler with the result
            completion(isSuccess)
        }
        task.resume()
    }
    
    static func searchUser(jsonReq: Data, completion: @escaping (Result<Data,Error>) -> Void) {
        let url = URL(string: "\(baseURL)searchUser")
        print("url is : \(String(describing: url))")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
            // Add the Bearer token to the Authorization header
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonReq
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonData = data {
                completion(.success(jsonData))
            } else if let requestError = error {
                print("error occurred while sending request \(requestError.localizedDescription)")
                completion(.failure(requestError))
            } else {
                print("unexpected error occurred")
                let unexpectedError = NSError(domain: "SeninAnonymApp", code: -1, userInfo: nil) // Create a custom error
                completion(.failure(unexpectedError))
            }
        }
        task.resume()
    }
}
