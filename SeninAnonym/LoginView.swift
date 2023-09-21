//
//  LoginView.swift
//  SeninAnonym
//
//  Created by Ardahan Kul on 3.09.2023.
//

import Foundation
import SwiftUI

struct LoginView : View {
    
    @Binding var isLoggedIn: Bool
    
    @State private var userName = ""
    @State private var password = ""
    @State private var showAlert = false
    
    var body: some View {
        
        Form{
            Section{
                Text("Login")
                    .font(.title)
                    .padding()
            }
            Section{
                VStack {
                    TextField("Username", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .padding(.horizontal)
                    
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .padding(.horizontal)
                    
                }
            }
            
           
                Button(action: {
                    
                    let credentials: [String: String] = ["username": userName, "password": password]
                    
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
                        //let isAuthorized = SeninAnonymAPI.auth(endpoint: .login, jsonReq: jsonData)
                        SeninAnonymAPI.auth(endpoint: .login, jsonReq: jsonData) { isSuccess in
                            // Handle the result of the authentication here
                            if isSuccess {
                                // Authentication was successful
                                isLoggedIn = true
                                showAlert = false
                            } else {
                                // Authentication failed
                                isLoggedIn = false
                                showAlert = true
                            }
                        }
                    }catch{
                        print("Error : \(error.localizedDescription)")
                        isLoggedIn = false
                    }
                    
                    
                }, label: {
                    Text("Login")
                }).padding(.horizontal,10)
                    .frame(minWidth: 0, maxWidth: .infinity)
        }.alert(isPresented: $showAlert, content: {
            Alert(title: Text("Login Failed"),
                    message: Text("Invalid username or password. Please try again."),
                  dismissButton: .default(Text("OK")))
        })
        
 
        NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)){
            Text("Don't you have an account? Join Us").font(.caption)
        }
 
    }
}
