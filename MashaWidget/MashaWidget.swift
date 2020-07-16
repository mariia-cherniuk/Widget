//
//  MashaWidget.swift
//  MashaWidget
//
//  Created by Mariia Cherniuk on 16/07/2020.
//

import WidgetKit
import SwiftUI
import Intents

struct Entry: TimelineEntry {
    let date: Date
    let targetDate: Date
}

struct TimeProvider: TimelineProvider {

    func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
        let date = Date()
        let model = Entry(date: Date(), targetDate: Date().addingTimeInterval(6000))
        completion(model)
    }
    
    func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries = [Entry]()
        let entryDate = Calendar.current.date(byAdding: .minute, value: 0, to: Date())!
        let targetDate = Date().addingTimeInterval(3600)
        let model = Entry(date: entryDate, targetDate: targetDate)
        
        entries.append(model)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetView: View {
    @Environment(\.widgetFamily) var family
    
    let data: Entry
    
    var font: Font {
        if family == .systemSmall {
            return .title
        } else {
            return .largeTitle
        }
    }
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .inset(by: 5)
                .fill(family == .systemSmall ? Color.red : Color.pink)
            
            Text(data.targetDate, style: .timer)
                .multilineTextAlignment(.center)
                .font(font)
                .padding()
        }
        .background(Color(white: 0.1))
        .foregroundColor(.white)
    }
}

struct PlaceholderView: View {
    
    let entry = Entry(date: Date(), targetDate: Date().addingTimeInterval(3600))
    
    var body: some View {
        WidgetView(data: entry)
    }
}

@main
struct Config: Widget {
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.hackingwithswift.timer",
                            provider: TimeProvider(),
                            placeholder: PlaceholderView()) { data in
            WidgetView(data: data)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .description(Text(""))
    }
}
