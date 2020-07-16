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
}

struct TimeProvider: TimelineProvider {

    func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
        let model = Entry(date: Date())
        completion(model)
    }
    
    func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries = [Entry]()
        var components = Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: Date())
        components.second = 0
        let roundedDate = Calendar.current.date(from: components) ?? Date()
       
        for minute in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minute, to: roundedDate) ?? Date()
            let model = Entry(date: entryDate)
            entries.append(model)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TimeZoneView: View {
    
    let sourceDate: Date
    let timeZone: String
    
    var body: some View {
        Link(destination: URL(string: timeZone)!) {
            VStack {
                Text(timeZone)
                    .font(.caption)
                
                Text(dateString(for: timeZone))
                    .font(.caption)
            }
        }
    }
    
    func dateString(for timeZone: String) -> String {
        let form = DateFormatter()
        form.timeStyle = .short
        form.timeZone = TimeZone(abbreviation: timeZone)
        
        return form.string(from: sourceDate)
    }
}

struct WidgetView: View {
    @Environment(\.widgetFamily) var family
    
    let data: Entry
    
    var body: some View {
        if family == .systemSmall {
            TimeZoneView(sourceDate: data.date, timeZone: "PST")
        } else if family == .systemMedium {
            HStack(spacing: 20) {
                TimeZoneView(sourceDate: data.date, timeZone: "PST")
                TimeZoneView(sourceDate: data.date, timeZone: "EST")
            }
        } else if family == .systemLarge {
            VStack(spacing: 40) {
                HStack(spacing: 20) {
                    TimeZoneView(sourceDate: data.date, timeZone: "PST")
                    TimeZoneView(sourceDate: data.date, timeZone: "EST")
                }
                HStack(spacing: 20) {
                    TimeZoneView(sourceDate: data.date, timeZone: "GMT")
                    TimeZoneView(sourceDate: data.date, timeZone: "JST")
                }
            }
        }
    }
}

struct PlaceholderView: View {
    
    let entry = Entry(date: Date())
    
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
