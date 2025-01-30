//
//  ContentView.swift
//  Timex
//
//  Created by JoeyHammoth on 1/30/25.
//

import SwiftUI

/// A struct representing a time value with hour, minute, second, and day type.
/// The struct provides computed properties for formatted time display and
/// adjusts minutes and seconds when their values exceed 59.
struct Time {
    
    /// The hour component of the time (0-23).
    var hour: Int
    
    /// The minute component of the time (0-59).
    ///
    /// When set, if the minute value exceeds 59, the minute is reset to 0
    /// and the hour is incremented by 1.
    var min: Int {
        didSet {
            if min > 59 {
                min = 0
                hour += 1
            }
        }
    }
    
    /// The second component of the time (0-59).
    ///
    /// When set, if the second value exceeds 59, the second is reset to 0
    /// and the minute is incremented by 1.
    var sec: Int {
        didSet {
            if sec > 59 {
                sec = 0
                min += 1
            }
        }
    }
    
    /// A string representing the type of day (e.g., "AM" or "PM").
    var dayType: String
    
    /// A computed property that returns the formatted time as a string.
    ///
    /// The formatted time string is in the format:
    /// "HH:MM:SS AM/PM" or "HH:MM:SS" depending on the day type.
    /// - If hour, minute, or second is less than 10, it will be prefixed with a zero.
    ///
    /// Example:
    /// - "05:09:03 PM"
    /// - "10:05:02 AM"
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

/// A custom view that represents a hand (like an analog clock hand) with a specified length, thickness, and color.
///
/// The `HandView` is a simple rectangle that can be customized to represent a hand's appearance, such as for clock or gauge elements.
/// It uses a `Rectangle` shape, with the ability to adjust its length, thickness, and color.
struct HandView: View {
    
    /// The length of the hand (the vertical size of the rectangle).
    let length: CGFloat
    
    /// The thickness of the hand (the horizontal size of the rectangle).
    let thickness: CGFloat
    
    /// The color of the hand. Default is white.
    let color: Color
    
    /// Creates a new `HandView` instance with the specified length, thickness, and optional color.
    ///
    /// - Parameters:
    ///   - length: The vertical length of the hand (in points).
    ///   - thickness: The horizontal thickness of the hand (in points).
    ///   - color: The color of the hand. Defaults to `.white` if not specified.
    init(length: CGFloat, thickness: CGFloat, color: Color = .white) {
        self.length = length
        self.thickness = thickness
        self.color = color
    }
    
    /// The view's content and layout.
    ///
    /// The body of the view creates a rectangle with the specified color and frame size. The rectangle is then offset vertically to align the bottom edge to the center.
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: thickness, height: length)
            .offset(y: -length / 2)  // Align bottom at center
    }
}

/// The main view of the application which allows the user to set and start/stop a clock.
struct ContentView: View {
    
    /// Array containing the options for AM and PM.
    let day = ["AM", "PM"]
    
    /// A computed property that returns the appropriate start/stop text based on whether the clock is running or not.
    var startText: String {
        if !start {
            return "Start the Clock!"
        } else {
            return "Stop the Clock!"
        }
    }
    
    /// A computed property that returns true if the current day type is "PM", used to toggle between light and dark mode.
    var darkMode: Bool {
        if timex.dayType == "AM" {
            return false
        } else {
            return true
        }
    }
    
    /// A state variable that tracks whether the clock has been started (running) or not.
    @State var start: Bool = false
    
    /// A state variable that holds the timer instance for updating the clock.
    @State var timer: Timer? = nil
    
    /// A state variable that holds the user input as a string (currently not used in this implementation).
    @State var input: String = ""
    
    /// A state variable that represents the time object, including hour, minute, second, and day type (AM/PM).
    @State var timex = Time(hour: 0, min: 0, sec: 0, dayType: "AM")
    
    /// The body of the view, which describes the user interface of the application.
    var body: some View {
        NavigationStack {
            Form {
                
                /// Section displaying an introductory description of the app.
                Section("About") {
                    Text("This is a simple application that involves setting up your time and having it start and stop at your own leisure.")
                }
                
                /// Section that allows the user to select between AM and PM.
                Section("Day/Night") {
                    Picker("Day/Night", selection: $timex.dayType) {
                        ForEach(day, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                /// Section for selecting the hour, minute, and second of the time.
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
                
                /// Section that displays the current time and a button to start or stop the timer.
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
                
                /// Section containing the visual clock with rotating hands based on the time.
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
        
        // Apply dark or light mode based on the selected time of day
        .preferredColorScheme(darkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
