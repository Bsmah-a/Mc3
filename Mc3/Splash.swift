//
//  SplashScreen.swift
//  Ozzy
//
//  Created by Shahad Alzowaid on 10/07/1445 AH.
//

import SwiftUI
struct Splash: View {
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height
    
    @State private var size: CGFloat = 0.4
    @State private var opacity: Double = 0.0
    @State private var isActive = false
    
    var body: some View {
        if isActive{
            ContentView()
        }
        else{
            ZStack {
                Image("splash").resizable().ignoresSafeArea()
                
                Image("ozzytext")
                    .scaleEffect(size)
                    .padding(.bottom, 110)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1)) {
                            size = 0.5
                            opacity = 1.0
                        }
                    }
                
                Image("Ozzy")
                    .scaleEffect(0.75)
                    .offset(x: 20, y: offsetY)
                    .rotationEffect(.degrees(20))
                    .animation(.easeInOut(duration: 1.8))
               
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){self.isActive = true}
                withAnimation {
                    offsetY = 290
                }
            }
        }
    }
}
struct Splash_Previews: PreviewProvider {
static var previews: some View {
Splash()
}
}
