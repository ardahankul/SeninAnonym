//
//  RegisterView.swift
//  SeninAnonym
//
//  Created by Ardahan Kul on 3.09.2023.
//

import Foundation
import SwiftUI

struct RegisterView : View {
    
    @Binding var isLoggedIn: Bool
    
    @State private var fullName = ""
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        Form{
            Section{
                Text("Register and Join Us")
                    .font(.title)
                    .padding()
            }
            Section{
                VStack{
                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .padding(.horizontal)
                    
                    TextField("Username", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .padding(.horizontal)
                    
                    
                    TextField("E-Mail", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .padding(.horizontal)
                    
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .padding(.horizontal)
                }.padding(.vertical)
                
            }
            Section{
                Button(action: {
                    
                    let credentials: [String: String] = ["fullName":fullName, "username": userName, "password": password, "email": email]
                    
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: credentials)
                        SeninAnonymAPI.auth(endpoint: .register, jsonReq: jsonData) { isSuccess in
                            // Handle the result of the authentication here
                            if isSuccess {
                                // Authentication was successful
                                isLoggedIn = true
                            } else {
                                // Authentication failed
                                isLoggedIn = false
                            }
                        }
                        
                    }catch{
                        print("Error : \(error.localizedDescription)")
                    }
                    
                    
                }, label: {
                    Text("Submit")
                }).padding(.horizontal,10)
                    .frame(minWidth: 0, maxWidth: .infinity)
                
            }
        }
        
        NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)){
            Text("Do you have an account? Login").font(.caption)
        }
    }
}

