//
//  ViewModel.swift
//  Ozzy
//
//  Created by Renad Alqarni on 04/02/2024.
//

import Foundation

final class ViewModel: ObservableObject{
    @Published var selectedModel: Models = Models(model:"Normal.usdz",pic:"Study_Mood",
                                              title: "Study Mood",
                                              desc: "Pick your book and study with Ozzy")
    let freemodel :[Models] = [
        Models(model:"eat57.usdz",pic:"Eating_Mood",
               title: "Eat Mood     ",
               desc: "Eat with Ozzy"),
        Models(model:"Sleep2.usdz",pic:"Sleeping_Mood",
               title: "Sleep Mood",
               desc: "Nighty Night It's for Ozzy to sleep"),
        Models(model:"Normal.usdz",pic:"Study_Mood",
               title: "Study Mood",
               desc: "Pick your book and study with Ozzy")]
}
