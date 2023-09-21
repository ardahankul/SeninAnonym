//
//  LinkView.swift
//  SeninAnonym
//
//  Created by Ardahan Kul on 3.09.2023.
//

import SwiftUI

struct LinkView : View {
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack{
            Text("Create Link")
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "AuthToken")
                UserDefaults.standard.synchronize()
                isLoggedIn = false
            }, label: {
                Text("Log Out")
            })
        }
    }
}
