//
//  ibudgetedWidget.swift
//  ibudgetedWidget
//
//  Created by Chris-Brien Glaze on 21/02/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), CurrentBudget: "3,000",
        TotalExpense: "100")
    }

    
    
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//
//        UserDefaults(suiteName:"com.group8.iBudget.ibudgetedWidget")!.set(totalIncome.text, forKey: "totalExpense")
//        UserDefaults(suiteName:"com.group8.iBudget.ibudgetedWidget")!.set(totalBudget.text, forKey: "Budget")
//
        
        
        let expense = UserDefaults(suiteName: "com.group8.iBudget.ibudgetedWidget")!.string(forKey: "totalExpense") ?? "0"
        
        let budget = UserDefaults(suiteName: "com.group8.iBudget.ibudgetedWidget")!.string(forKey: "totalBudget") ?? "0"
        
        
        let entry = SimpleEntry(date: Date(), configuration: configuration,CurrentBudget: budget,TotalExpense: expense)
        completion(entry)
    }

    
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
           let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            
            let expense = UserDefaults(suiteName: "com.group8.iBudget.ibudgetedWidget")!.string(forKey: "totalExpense") ?? "0"
            
            let budget = UserDefaults(suiteName: "com.group8.iBudget.ibudgetedWidget")!.string(forKey: "totalBudget") ?? "0"
            
            
            let entry = SimpleEntry(date: Date(), configuration: configuration,CurrentBudget: budget,TotalExpense: expense)
            
            
            
            let entry2 = SimpleEntry(date: entryDate, configuration: configuration,CurrentBudget: "3,000",TotalExpense: "230.00")
            entries.append(entry)
            entries.append(entry2)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let CurrentBudget : String
    let TotalExpense : String
}

struct ibudgetedWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            
            HStack {
               
                Image("logo").resizable()
                    .frame(width: 40.0, height: 40.0)
                 
                Text("iBudget").font(.headline)
                Spacer()
            }.frame(maxWidth: .infinity )
            
            //        Text(entry.date, style: .time)
            HStack {
                
                VStack {
                    Text("Budget").font(.subheadline).fontWeight(.medium)
                        .frame(maxWidth: .infinity ,alignment: .leading)
                    Text("$\(entry.CurrentBudget)").font(.headline).frame(maxWidth: .infinity ,alignment: .leading).foregroundColor(.purple)
                }
               
                
            }.frame(maxWidth: .infinity ).padding(.bottom,5)
            
           
            
            HStack {
                VStack {
                    Text("Total Expense").font(.subheadline).fontWeight(.medium).frame(maxWidth: .infinity ,alignment: .leading)
                    
                    Text("$\(entry.TotalExpense)").font(.headline).frame(maxWidth: .infinity ,alignment: .leading).foregroundColor(.pink)
                }
            }.frame(maxWidth: .infinity ).padding(.bottom,5)
            
        }.padding(.leading,10)
    }
}

struct ibudgetedWidget: Widget {
    let kind: String = "ibudgetedWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ibudgetedWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("iBudget")
        .description("Summary of expenses for iBudget app")
    }
}



struct ibudgetedWidget_Previews: PreviewProvider {
    static var previews: some View {
        ibudgetedWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), CurrentBudget: "3,000.00", TotalExpense: "1,200.00"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
