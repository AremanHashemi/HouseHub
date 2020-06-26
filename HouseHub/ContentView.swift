//
//  ContentView.swift
//  HouseHub
//
//  Created by Areman Hashemi on 6/24/20.
//  Copyright © 2020 Areman Hashemi. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

let ref = Database.database().reference()
var count = 0
struct ContentView: View {
    @State private var username: String = ""
    var body: some View {
        VStack {
            Text("Firebase DB prototype!")
            Form {
                TextField("Username", text: $username)
            }
            Button(action: {
                count += 1
                ref.child("users/\(count)").setValue(self.username)
                self.username = ""
                
            }) {
                Text("Click to add to DB")
                    .padding(.bottom, 650.0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
