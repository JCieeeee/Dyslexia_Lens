//
//  DyslexiaSimulator.swift
//  Xcode Demo Dylexia
//
//  Created by 陈佳怡 on 2025/2/22.
//

import UIKit


class DyslexiaSimulator {
    
    let sampleText = """
        Dyslexia is characterized by a range of reading difficulties, including challenges with word recognition, decoding, and spelling. It is recognized as a multifactorial disorder, meaning that its causes and manifestations can vary significantly among individuals
        """
    

    struct WordMeta {
        let length: Int
        let position: Int
    }
    
    private var textNodes: [String] = []
    private var wordsInTextNodes: [[WordMeta]] = []
    

    init() {

        textNodes = sampleText.components(separatedBy: ". ").map { $0 + "." }
        processTextNodes()
    }
    

    private func processTextNodes() {
        for node in textNodes {
            var words: [WordMeta] = []
            
           
            let regex = try! NSRegularExpression(pattern: "\\w+")
            let range = NSRange(location: 0, length: node.utf16.count)
            
            
            let matches = regex.matches(in: node, range: range)
            
            for match in matches {
                words.append(WordMeta(
                    length: match.range.length,
                    position: match.range.location
                ))
            }
            
            wordsInTextNodes.append(words)
        }
    }
    
    
    private func isNumber(_ char: Character) -> Bool {
        return char.isNumber
    }
    
    
    private func getRandomInt(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }
    
    
    private func messUpMessyPart(_ messyPart: String) -> String {
        if messyPart.count < 2 {
            return messyPart
        }
        
        var a = 0
        var b = 0
        
        
        repeat {
            a = getRandomInt(min: 0, max: messyPart.count - 1)
            b = getRandomInt(min: 0, max: messyPart.count - 1)
        } while a >= b
        
        
        var messyArray = Array(messyPart)
        
        let temp = messyArray[a]
        messyArray[a] = messyArray[b]
        messyArray[b] = temp
        
        return String(messyArray)
    }
    
    
    private func messUpWord(_ word: String) -> String {
        if word.count < 3 {
            return word
        }
        
        let first = word.first!
        let last = word.last!
        let middle = String(word.dropFirst().dropLast())
        
        return String(first) + messUpMessyPart(middle) + String(last)
    }
    
    
    func messUpWords(intensity: Double) -> [String] {
        var newTextNodes = textNodes
        
        for (i, node) in textNodes.enumerated() {
            var newNode = node
            
            for wordMeta in wordsInTextNodes[i] {
                
                if Double.random(in: 0...1) > intensity {
                    continue
                }
                
                let start = node.index(node.startIndex, offsetBy: wordMeta.position)
                let end = node.index(start, offsetBy: wordMeta.length)
                let word = String(node[start..<end])
                
                
                var scrambledWord = word
                for _ in 0..<Int(intensity * 3) {
                    scrambledWord = messUpWord(scrambledWord)
                }
                
               
                if intensity > 0.5 {
                    scrambledWord = String(scrambledWord.reversed())
                }
                
                newNode = newNode.replacingOccurrences(of: word, with: scrambledWord)
            }
            
            newTextNodes[i] = newNode
        }
        
        return newTextNodes
    }
}

class DyslexiaViewController: UIViewController {
    private let simulator = DyslexiaSimulator()
    private var timer: Timer?
    private let textView = UITextView()
    private var intensity: Double = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        startSimulation()
    }
    
    private func setupTextView() {
        textView.frame = view.bounds
        textView.isEditable = false
        view.addSubview(textView)
    }
    
    private func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            let scrambledText = self?.simulator.messUpWords(intensity: self?.intensity ?? 0.5).joined(separator: " ")
            self?.textView.text = scrambledText
        }
    }
}
