//
//  ContentView.swift
//  Dyslexia Scan ios
//
//  Created by 陈佳怡 on 2025/2/22.
//

import SwiftUI

struct OCRscannerView: View {
    @State private var showScannerSheet = false
    @State private var texts:[ScanData] = []
    @State private var selectedFontStyle: String = "Times New Roman"
    @State private var fontSize: CGFloat = 40
    
    let availableFontStyles = [
        "Arial",
        "Times New Roman",
        "OpenDyslexic-Regular"
    ]
    
    var body: some View {
         NavigationStack{

             ZStack {
                 Color.color.opacity(0.5)
                     .ignoresSafeArea()
                 
                 VStack(spacing: 20) {
                     HStack{
                         Text("Font:")
                             .foregroundColor(.black)
                         Picker("Select Font", selection: $selectedFontStyle) {
                             ForEach(availableFontStyles, id: \.self) { fontName in
                                 Text(fontName)
                                     .font(getFontForName(fontName))
                             }
                         }
                         .pickerStyle(MenuPickerStyle())
                         .frame(maxWidth: 500)
                     }
                     .padding()
                     .background(Color.white)
                     .cornerRadius(10)
                     .shadow(radius: 2)
                     .padding(.horizontal)
                     
                   
                     Text("Preview Text")
                         .font(getFontForName(selectedFontStyle))
                         .padding()
                         .frame(maxWidth: .infinity)  //
                         .background(Color.color)     //
                         .cornerRadius(10)
                         .shadow(radius: 2)
                         .padding(.horizontal)
                     
                     
                     VStack(alignment: .leading, spacing: 10) {
                         Text("Font Size")
                             .foregroundColor(.gray)
                         HStack{
                             Text("\(Int(fontSize))")
                                 .frame(width: 40)
                             Slider(value: $fontSize, in: 8...72, step: 1)
                         }
                     }
                     .padding()
                     .background(Color.white)
                     .cornerRadius(10)
                     .shadow(radius: 2)
                     .padding(.horizontal)
                     
                
                     if texts.count > 0 {
                         List {
                             ForEach(texts) { text in
                                 NavigationLink(
                                     destination: ScrollView {
                                         Text(text.content)
                                             .font(getFontForName(selectedFontStyle))
                                             .padding()
                                     },
                                     label: {
                                         Text(text.content)
                                             .font(getFontForName(selectedFontStyle))
                                             .lineLimit(1)
                                     })
                             }
                         }
                         .listStyle(InsetGroupedListStyle())
                         .background(Color.clear)
                     } else {
                         Spacer()
                         Button(action: {
                             self.showScannerSheet = true
                         }) {
                             VStack {
                                 Image(systemName: "doc.text.viewfinder")
                                     .font(.system(size: 50))
                                     .foregroundColor(.brown)
                                 Text("Click here to scan 👆")
                                     .font(.title2)
                                     .foregroundColor(.gray)
                             }
                             .padding()
                         }
                         Spacer()
                     }
                 }
                 .padding(.vertical)
             }
             .navigationTitle("Scan OCR")
             .sheet(isPresented: $showScannerSheet) {
                 makeScannerView()
             }
         }
     }
     
    
    // Helper function to get the correct font
    private func getFontForName(_ name: String) -> Font {
        if name == "OpenDyslexic-Regular" {
            return .custom("OpenDyslexic-Regular", size: fontSize)
        } else {
            return .custom(name, size: fontSize)
        }
    }
    
    private func makeScannerView()-> ScannerView {
        ScannerView(completion: {
            textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
            self.showScannerSheet = false
        })
    }
}

#Preview {
    ContentView()
}
