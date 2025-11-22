//
//  ContentView.swift
//  Xcode Demo Dylexia
//
//  Created by 陈佳怡 on 2025/2/22.
//

import SwiftUI

struct ContentView: View {

    @State private var currentText = "Move the slider to to explore reading differences👇"
    @State private var sliderValue: Double = 0.0
    @State private var textOpacity: Double = 1.0
    @State private var isSimulating = false
    @State private var showOCRScanner = false
    

    private let simulator = DyslexiaSimulator()
    private let textTransitionDuration: Double = 0.3
    private let textUpdateDelay: Double = 0.3
    private let baseCircleSize: CGFloat = 40
    private let maxSizeChange: CGFloat = 40
    private let iconPadding: CGFloat = 8
    private let finalTextThreshold: Double = 0.95
    

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    

    private func leftCircleSize() -> CGFloat {
        baseCircleSize + (1 - sliderValue) * maxSizeChange
    }
    
    private func rightCircleSize() -> CGFloat {
        baseCircleSize + sliderValue * maxSizeChange
    }
    
    
    private func getRightSideImages() -> some View {
        ZStack {
            Image("Bad")
                .resizable()
                .scaledToFit()
                .padding(iconPadding)
            
            Group {
                if sliderValue >= 0.25 {
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .offset(x: 30, y: -30)
                }
                
                if sliderValue >= 0.5 {
                    Image("D2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .offset(x: -30, y: -30)
                }
                
                if sliderValue >= 0.75 {
                    Image("D3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .offset(x: 0, y: -40)
                }
            }
        }
    }
    

    var body: some View {
        ZStack {
            Color.color
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Circle()
                        .frame(width: leftCircleSize(), height: leftCircleSize())
                        .foregroundColor(.brown)
                        .overlay(
                            Image("Good")
                                .resizable()
                                .scaledToFit()
                                .padding(iconPadding)
                        )
                        .animation(.spring(), value: sliderValue)
                    
                    Spacer()
                    
                    Circle()
                        .frame(width: rightCircleSize(), height: rightCircleSize())
                        .foregroundColor(.brown)
                        .overlay(getRightSideImages())
                        .animation(.spring(), value: sliderValue)
                }
                .padding()
                
                Spacer()
                

                VStack {
                    if sliderValue >= finalTextThreshold {
                        VStack(spacing: 20) {
                            Text("Understanding Dyslexia")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Dyslexia affects 1 in 5 people worldwide. Supporting and understanding individuals with dyslexia is crucial for creating an inclusive society where everyone can thrive.")
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .foregroundColor(.black)
                    }
                    
                    Text(currentText)
                        .bold()
                        .font(.title)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // 
                        .multilineTextAlignment(.center)
                        .opacity(textOpacity)
                        .foregroundColor(.black)
                        .onReceive(timer) { _ in
                            if isSimulating {
                                currentText = simulator.messUpWords(intensity: sliderValue).joined(separator: " ")
                            }
                        }
                }
                
                Spacer()
                
                Slider(value: $sliderValue, in: 0...1)
                    .padding(.horizontal, 40)
                    .accentColor(.black)
                // 添加扫描按钮
                Button(action: {
                    showOCRScanner = true
                }) {
                    HStack {
                        Image(systemName: "doc.text.viewfinder")
                        Text("Tap to scan")
                    }
                    .padding()
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .onChange(of: sliderValue) { _, newValue in
                handleSliderValueChange(newValue)
            }
        }
        .sheet(isPresented: $showOCRScanner) {
            OCRscannerView()
        }
    }
    
    
    

    private func handleSliderValueChange(_ newValue: Double) {
        if newValue > 0.1 && !isSimulating {
            withAnimation(.easeOut(duration: textTransitionDuration)) {
                textOpacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + textUpdateDelay) {
                isSimulating = true
                withAnimation(.easeIn(duration: textTransitionDuration)) {
                    textOpacity = 1
                }
            }
        } else if newValue <= 0.1 && isSimulating {
            withAnimation(.easeOut(duration: textTransitionDuration)) {
                textOpacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + textUpdateDelay) {
                isSimulating = false
                currentText = "Move the slider to to explore reading differences👇"
                withAnimation(.easeIn(duration: textTransitionDuration)) {
                    textOpacity = 1
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
