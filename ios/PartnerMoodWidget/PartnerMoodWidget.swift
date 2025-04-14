//
//  PartnerMoodWidget.swift
//  PartnerMoodWidget
//
//  Created by Jose Reyes on 03/04/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // method to retrieve data from Flutter app
    private func getDataFromFlutter() -> SimpleEntry {
        let userDefaults = UserDefaults(suiteName: "group.emotionsPartnerMood")
        let textFromFlutterApp = userDefaults?.string(forKey: "text_from_flutter_app") ?? "0"
        return SimpleEntry(date: Date(), text: textFromFlutterApp)
    }
    
    //preview in widget gallery
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "0")
    }

    // widget gallery/selection preview
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = getDataFromFlutter()
        completion(entry)
    }

    // actual widget on home screen
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getDataFromFlutter()

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

// this represents the data structure for the widget
struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
}

// view that defines how our widget looks
struct PartnerMoodWidgetEntryView : View {
    var entry: Provider.Entry
    var defaultMood : String = "defaultMood"

    var body: some View {
        VStack {
            Image(defaultMood)
            Text("Mood:")
            Text(entry.text)
        }
    }
}

// main widget configuration
struct PartnerMoodWidget: Widget {
    let kind: String = "PartnerMoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PartnerMoodWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PartnerMoodWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    PartnerMoodWidget()
} timeline: {
    SimpleEntry(date: .now, text: "0")
    SimpleEntry(date: .now, text: "0")
}
