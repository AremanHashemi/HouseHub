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
                //let updates = ["Users": [self.username:String(count)]]
                count += 1
                ref.child("users/\(count)").setValue(self.username)
                //ref.updateChildValues(updates)
                self.username = ""
            }) {
                Text("Click to add to DB")
                    .padding(.bottom, 650.0)
            }
        }
    }
}
//
//func testDb() {
//    let ref = Database.database().reference()
//    let updates = ["1/name":"John", "2/name":"David"]
//    ref.updateChildValues(updates)
//}
//

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
