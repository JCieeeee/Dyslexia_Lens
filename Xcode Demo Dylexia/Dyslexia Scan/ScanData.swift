//
//  ScanData.swift
//  Xcode Demo Dylexia
//
//  Created by 陈佳怡 on 2025/2/23.
//
import Foundation

struct ScanData:Identifiable{
    var id = UUID()
    let content:String
    
    init(content:String){
        self.content = content
    }
}

