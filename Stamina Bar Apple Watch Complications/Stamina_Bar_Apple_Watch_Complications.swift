//
//  Stamina_Bar_Apple_Watch_Complications.swift
//  Stamina Bar Apple Watch Complications
//
//  Created by Bryce Ellis on 5/8/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget")]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct Stamina_Bar_Apple_Watch_ComplicationsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
       
       
        case .accessoryCircular:
            Image("StaminaBarWidget")
                .resizable()
                .scaledToFit()
                .padding()
        case .accessoryRectangular:
            Image("StaminaBarWidget")
                .resizable()
                .scaledToFit()
                .padding()
        case .accessoryInline:
            Image("StaminaBarWidget")
                .resizable()
                .scaledToFit()
                .padding()
        case .accessoryCorner:
            Image("StaminaBarWidget")
                .resizable()
                .scaledToFit()
                .padding()
        default:
            Image("StaminaBarWidget")
                .resizable()
                .scaledToFit()
                .padding()
            
        }
//
//        VStack {
//            HStack {
//                Text("Time:")
//                Text(entry.date, style: .time)
//            }
//
//            Text("Favorite Emoji:")
//            Text(entry.configuration.favoriteEmoji)
//        }
    }
}

@main
struct Stamina_Bar_Apple_Watch_Complications: Widget {
    let kind: String = "Stamina_Bar_Apple_Watch_Complications"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Stamina_Bar_Apple_Watch_ComplicationsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    Stamina_Bar_Apple_Watch_Complications()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}    
