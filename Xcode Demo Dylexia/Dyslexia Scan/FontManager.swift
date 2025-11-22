//
//  FontManager.swift
//  Xcode Demo Dylexia
//
//  Created by 陈佳怡 on 2025/2/23.
//

import Foundation
import SwiftUI


class FontManager {
    static let shared = FontManager()
    
    var customFonts: [String] = []
    
    init() {
        registerFonts()
    }
    
    private func registerFonts() {
        guard let bundlePath = Bundle.main.path(forResource: ".", ofType: "bundle"),
              let bundle = Bundle(path: bundlePath) else { return }
        
        if let fontURLs = bundle.urls(forResourcesWithExtension: "otf", subdirectory: nil) {
            for url in fontURLs {
                var errorRef: Unmanaged<CFError>?
                if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, &errorRef) {
                    print("Failed to register font: \(url.lastPathComponent)")
                    if let error = errorRef?.takeUnretainedValue() {
                        print("Error: \(error)")
                    }
                } else {
                    customFonts.append(url.lastPathComponent)
                    print("Successfully registered font: \(url.lastPathComponent)")
                }
            }
        }
    }
    
    func getAvailableFonts() -> [String] {
        let familyNames = UIFont.familyNames.sorted()
        var fontList: [String] = []
        
        for family in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: family)
            fontList.append(contentsOf: fontNames)
        }
        return fontList
    }
}
