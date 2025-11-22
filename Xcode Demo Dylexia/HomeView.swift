//
//  HomeViwq.swift
//  Xcode Demo Dylexia
//
//  Created by 陈佳怡 on 2025/2/23.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @State private var showContentView: Bool = false
    
    var body: some View {
        if showContentView {
            ContentView()
        } else {
        ZStack { 
            Color(.color) //
                .ignoresSafeArea()
            

            VStack(spacing: 20) {

                Spacer()
                
                ZStack {
                    

                    Image("Topic")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .offset(y: -30)
                        .frame(height: 400)
                    

                    Image("Characters")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .offset(y: 60)
                }
                

                Text("Welcome to Dyslexia Lens")
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding()
                    .tint(.brown)
                Text("An interactive app designed to help you read the text through the eyes of someone with dyslexia. Click 'start'to begin")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                


                Spacer()
                
                Button(action: {
                    showContentView = true
                }) {
                    Image(systemName: "restart")
                        .imageScale(.large)
                    
                    Text("Start")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .tint(.brown)
            }
        }
    }
}
}


#Preview {
    HomeView()
}
