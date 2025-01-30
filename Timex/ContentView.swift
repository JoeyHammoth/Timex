//
//  ContentView.swift
//  WeSplit
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

struct ContentView: View {
    
    let day = ["AM", "PM"]
    
    var startText: String {
        if !start {
            return "Start the Clock!"
        } else {
            return "Stop the Clock!"
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
                
                
            }
            .navigationTitle("Welcome to Timex!")
        }
    }
}

#Preview {
    ContentView()
}
