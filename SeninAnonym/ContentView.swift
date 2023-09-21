//
//  ContentView.swift
//  SeninAnonym
//
//  Created by Ardahan Kul on 3.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var isLoggedIn = false
    
    init() {
            // Check if the token exists in UserDefaults
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                _isLoggedIn = State(initialValue: true) // Set initial value of @State
            }
        }
        
    
    var body: some View {
        
        NavigationView {
            
            if isLoggedIn {
                TabView{
                    AskView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Ask")
                        }
                    LinkView(isLoggedIn: $isLoggedIn)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    InboxView()
                        .tabItem {
                            Image(systemName: "envelope")
                            Text("Inbox")
                        }
                }
            }else{
                VStack {
                    
                    LoginView(isLoggedIn: $isLoggedIn)
                    /*
                     NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)){
                     Text("Login")
                     }
                     NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)){
                     Text("Register")
                     } */
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
