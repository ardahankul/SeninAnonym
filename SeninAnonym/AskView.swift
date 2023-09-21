//
//  AskView.swift
//  SeninAnonym
//
//  Created by Ardahan Kul on 3.09.2023.
//

import SwiftUI
import Combine

struct AskView : View {
    @ObservedObject var userListViewModel = UserListViewModel()
    
    @State private var searchText = ""
    @State private var isBottomViewVisible = false
    @State private var selectedItem = ""
    @State private var filteredUsernames: [String] = []
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Text("Ask your question anonymly").font(.title2)
                    Spacer()
                }.padding(.horizontal)
                SearchBar(text: $searchText).onTapGesture {
                    isBottomViewVisible = false
                }.onChange(of: searchText, {
                    if !searchText.isEmpty {
                        print(searchText)
                        userListViewModel.loadData(searchParam: searchText)
                    }
                })
                    .padding()
                if !isBottomViewVisible{
                    List(userListViewModel.items, id: \.username) { item in
                        Button(action: {
                            selectedItem = item.username
                            searchText = ""
                            isBottomViewVisible = true
                        }) {
                            Text(item.username)
                        }
                    }
                }
                if isBottomViewVisible {
                 // Customize the bottom view here
                 BottomView(selectedItem: $selectedItem)
                    Spacer()
                 }
            }
            }
        }
    }


struct BottomView: View {
    @Binding var selectedItem: String
    @State private var question = ""
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline){
                Image(systemName: "person")
                Text(selectedItem)
                Spacer()
            }.padding()
            MultilineTextFieldExample(question: $question)
            Button(action: {
                let guid = "fdd6e0e1-4615-30d5-912c-ee056fcde3c9"
                let credentials: [String: String] = ["question": question]
                
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: credentials)
                    //let isAuthorized = SeninAnonymAPI.auth(endpoint: .login, jsonReq: jsonData)
                    SeninAnonymAPI.askQuestion(jsonReq: jsonData, guid: guid) { isSuccess in
                        // Handle the result of the authentication here
                        if isSuccess {
                            // Authentication was successful
                            print("success")
                        } else {
                            // Authentication failed
                            print("failed")
                        }
                    }
                }catch{
                    print("Error : \(error.localizedDescription)")
                   
                }
                
                
                
            }, label: {Text("Ask Question")})
        }
        .padding()
    }
}


struct SearchBar: View {
    @Binding var text: String
    
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                
            
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
        }
    }
}



struct MultilineTextFieldExample: View {
    
    @Binding var question : String
    
    let textLimit = 10
    
    var body: some View {
        TextField("Ask your question", text:$question , axis: .vertical)
            .lineLimit(3, reservesSpace: true)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            .onReceive(Just(question), perform: { _ in
                limitText(textLimit)
            })
            .padding()
        
    }
    func limitText(_ upper: Int) {
        if question.count > upper {
            question = String(question.prefix(upper))
        }
    }
}

struct AskView_Previews : PreviewProvider{
    static var previews : some View {
        AskView()
    }
}




