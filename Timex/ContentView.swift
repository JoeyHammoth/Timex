//
//  ContentView.swift
//  Timex
//
//  Created by James Nikolas on 1/30/25.
//

import SwiftUI

struct Time {
    var hour: Int
    var min: Int {
        didSet {
            if min > 59 {
                min = 0
                hour += 1
            }
        }
    }
    var sec: Int {
        didSet {
            if sec > 59 {
                sec = 0
                min += 1
            }
        }
    }
    var dayType: String
    var time: String {
        if (hour < 10 && min < 10 && sec < 10) {
            return "0\(hour):0\(min):0\(sec) \(dayType)"
        } else if (hour >= 10 && min < 10 && sec < 10) {
            return "\(hour):0\(min):0\(sec) \(dayType)"
        } else if (hour >= 10 && min >= 10 && sec < 10) {
            return "\(hour):\(min):0\(sec) \(dayType)"
        } else if (hour >= 10 && min < 10 && sec >= 10) {
            return "\(hour):0\(min):\(sec) \(dayType)"
        } else if (hour < 10 && min < 10 && sec >= 10) {
            return "0\(hour):0\(min):\(sec) \(dayType)"
        } else if (hour < 10 && min >= 10 && sec < 10) {
            return "0\(hour):\(min):0\(sec) \(dayType)"
        } else {
            return "\(hour):\(min):\(sec) \(dayType)"
        }
    }
}

struct HandView: View {
    let length: CGFloat
    let thickness: CGFloat
    let color: Color
    
    init(length: CGFloat, thickness: CGFloat, color: Color = .white) {
        self.length = length
        self.thickness = thickness
        self.color = color
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: thickness, height: length)
            .offset(y: -length / 2)  // Align bottom at center
    }
}

struct ContentView: View {
    
    let day = ["AM", "PM"]
    
    var startText: String {
        if !start {
            return "Start the Clock!"
        } else {
            return "Stop the Clock!"
        }
    }
    
    var darkMode: Bool {
        if timex.dayType == "AM" {
            return false
        } else {
            return true
        }
    }
    
    @State var start: Bool = false
    @State var timer: Timer? = nil
    @State var input: String = ""
    @State var timex = Time(hour: 0, min: 0, sec: 0, dayType: "AM")
    
    var body: some View {
        NavigationStack {
            Form {
                Section("About") {
                    Text("This is a simple application that involves setting up your time and having it start and stop at your own leisure.")
                }
                
                Section("Day/Night") {
                    Picker("Day/Night", selection: $timex.dayType) {
                        ForEach(day, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Details") {
                    Picker("Hour", selection: $timex.hour) {
                        ForEach(0...12, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    Picker("Minute", selection: $timex.min) {
                        ForEach(0...60, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    Picker("Second", selection: $timex.sec) {
                        ForEach(0...60, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section("Time") {
                    Text("Time is \(timex.time)")
                    Button("\(startText)") {
                        if start == true {
                            // invalidate currently running timer
                            start = false
                            timer?.invalidate()
                            timer = nil
                        } else {
                            start = true
                            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                                timex.sec += 1
                            }
                        }
                    }
                    
                }
                
                Section("Clock") {
                    ZStack {
                        Circle()
                            .stroke(lineWidth:10)
                            .padding(10)
                        
                        HandView(length: 120, thickness: 5, color: darkMode ? .white : .black)
                            .rotationEffect(.degrees(Double(timex.sec) * 6), anchor: .center)
                        
                        HandView(length: 100, thickness: 8, color: darkMode ? .white : .black)
                            .rotationEffect(.degrees(Double(timex.min) * 6), anchor: .center)
                        
                        HandView(length: 70, thickness: 10, color: darkMode ? .white : .black)
                            .rotationEffect(.degrees((Double(timex.hour) * 30) + (Double(timex.min) / 2)), anchor: .center)
                    }
                    
                    
                }
                
            }
            .navigationTitle("Welcome to Timex!")
            
        }
        .preferredColorScheme(darkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
