//
//  ContentView.swift
//  Air BnB finder
//
//  Created by Ela Murat on 27/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var hotel = [Hotel]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(hotel) { hotel in
                NavigationLink(destination: Text(hotel.image)
                    .padding()) {
                        Text(hotel.title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
            }
            .navigationTitle("AirBNBs")
        }
        .onAppear(perform: {
            getHotels()
        })
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        }
    }
    func getHotels() {
        let apiKey = "?rapidapi-key=8ad147c7fbmsh0d49cfaaf12e1f9p1d09b2jsn0a2f01d49f01"
        let query = "https://airbnb19.p.rapidapi.com/api/v1/getCategory\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                if json["message"] == "Success" {
                    let contents = json["data"].arrayValue
                    for item in contents {
                        let Image = item["image"].stringValue
                        let iD = item["iD"].stringValue
                        let title = item["title"].stringValue
                        let hotels = Hotel(title: title, image: Image)
                        hotel.append(hotels)
                    }
                    return
                }
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Hotel: Identifiable {
    let id = UUID()
    var iD = String()
    var title = String()
    var image = String()
}
