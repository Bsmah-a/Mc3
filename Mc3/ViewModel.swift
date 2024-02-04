//
//  ViewModel.swift
//  Ozzy
//
//  Created by Renad Alqarni on 04/02/2024.
//

import Foundation
import UIKit

final class ViewModel: ObservableObject{
    @Published var selectedModel: Models = Models(model:"NormalM77.usdz", pic:"Study_Mood", title: "Study Mood", desc: "Pick your book and study with Ozzy")
    @Published var sheetOffset: CGFloat = UIScreen.main.bounds.height / 1.30
    @Published var isModesSheetPresented = false
    
    let freemodel: [Models] = [
        Models(model:"EatM.usdz", pic:"Eating_Mood", title: "Eat Mood", desc: "Eat with Ozzy"),
        Models(model:"SleepM.usdz", pic:"Sleeping_Mood", title: "Sleep Mood", desc: "Nighty Night It's for Ozzy to sleep"),
        Models(model:"NormalM77.usdz", pic:"Study_Mood", title: "Study Mood", desc: "Pick your book and study with Ozzy")
    ]
}
