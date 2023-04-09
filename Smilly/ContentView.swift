//
//  ContentView.swift
//  Smilly
//
//  Created by Michael Lutz on 4/8/23.
//

import SwiftUI
import MapKit
import CoreLocation

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
struct ContentView: View {
    let lm = LocationDataManager()
    @State var isCard: Bool = true
    @State public var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    init() {
        Task{
            let ( data, _) = try await URLSession.shared.data(from: URL(string:"http://10.0.7.56:80")!)
            let decodedResponse = try? JSONDecoder()
                .decode(Reports.self, from:data)
            print(decodedResponse?.reports[0].rating ?? "")
        }
    }
    struct Report: Codable{
        var rating: String
        var age: String
        var lat: String
        var long: String
    }
    struct Reports: Codable{
        var reports: [Report]
    }
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .overlay(alignment: .bottomLeading){
                
            Image("Smilly")
                    .resizable().scaledToFit().padding(isCard ? 20 : 150)
                    .offset(x: isCard ? 0 : -(UIScreen.screenWidth / 3), y: isCard ? -(UIScreen.screenHeight / 2) : (-UIScreen.screenHeight) * 17 / 25)
                    .animation(.easeInOut, value: isCard)
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .fill(.white)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 2)
                .offset(x: 0, y: isCard ? 0 : 500)
                .animation(.easeInOut, value: isCard)
                VStack(spacing: 30){
                
                Text("How's the smell?")
                
                HStack{
                    Button{
                        isCard.toggle()
                        lm.submitRating(rating:2)
                    }label:{
                        Image("Smile").resizable().scaledToFit()
                    }.padding([.trailing,.leading ],15)
                    
                    Button{
                        isCard.toggle()
                        lm.submitRating(rating:1)
                    }label:{
                        Image("Mid").resizable().scaledToFit()
                    }.padding([.trailing,.leading ],15)
                    
                    Button{
                        isCard.toggle()
                        lm.submitRating(rating: 0)
                    }label:{
                        Image("Frown").resizable().scaledToFit()
                    }.padding([.trailing,.leading ],15)
                }
                Button("Close"){
                    isCard.toggle()
                }
                .padding([.top], UIScreen.screenHeight / 5)
            }
                .padding()
                .offset(x: 0, y: isCard ? 0 : 500)
                .animation(.easeInOut, value: isCard)
            }
            .overlay(alignment: .bottomTrailing){
                Button{
                    isCard.toggle()
                }label:{
                    Circle()
                        .fill(.white)
                        .overlay(){
                            Text("+")
                                .font(.title)
                        }
                        .frame(width: 85, height: 85)
                }
                .offset(x: 0, y: isCard ? 500 : 0)
                .animation(.easeInOut, value: isCard)
                .padding(40)
            }
        }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

