//
//  ModesSheet.swift
//  Mc3
//
//  Created by Renad Alqarni on 29/01/2024.
//


import SwiftUI

struct ModesSheet: View {
    // change the .navigationBarTitle color
    init() {
           UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Title") ?? .black]
           UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "Title") ?? .black]
           }
    @State private var models:[Models] = []
    let model :[Models] = [
        Models(pic:"Eating_Mood",
               title: "Eating Mood",
               desc: "Eat with Ozzy"),
        Models(pic:"Sleeping_Mood",
               title: "Sleeping Mood",
               desc: "Nighty Night It's for Ozzy to sleep"),
        Models(pic:"Study_Mood",
               title: "Study Mood",
               desc: "Pick your book and study with Ozzy")]
    
        var body: some View {
                    NavigationStack {
                        VStack {
                            Form{
                                List(model) { Models in
                                    HStack {
                                        Image((Models.pic))
                                            .resizable()
                                            .frame(width: 80,height: 80)
                                            .cornerRadius(8)
                                        HStack{
                                            VStack(alignment: .leading) {
                                                Text(Models.title)
                                                    .font(.callout)
                                                    .padding(.trailing, 35)
                                                    .foregroundColor(.white)
                                                Text(Models.desc)
                                                    .font(.subheadline)
                                                .foregroundColor(.white)}
                                            Button(action: {
                                                print("the selected model is: \(Models.pic)")
                                            }) {
                                                Text("Apply!").foregroundColor(.white)
                                                
                                            }.background(Color("Button"))
                                                .buttonStyle(.bordered)
                                                .cornerRadius(10)
                                            
                                        }
                                    }
                                }
                                .listRowBackground(Color("List"))
                                .background(Color("List"))
                            }
            }.navigationBarTitle("Choose Mood")
                            .scrollContentBackground(.hidden)
                            .background(Color("Background"))
            
        }
            
    }
   
}

#Preview {
    ModesSheet()
}
