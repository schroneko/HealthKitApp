//
//  ContentView.swift
//  HeartRateForiPhone
//
//  Created by Yuta Hayashi
//  Copyright Determinant, inc.
//


import SwiftUI

struct ContentView: View {

    @ObservedObject var contentVM: ContentViewModel
    let dateformatter = DateFormatter()
    init(){

        contentVM = ContentViewModel()

        dateformatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateformatter.locale = Locale(identifier: "ja_JP")
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        // Until the term is fixed, let me decide to 1 month.
        let stardDate = "2022/02/01 00:00:00"
        let endDate = "2022/02/28 23:59:59"

        contentVM.get(
            fromDate: dateformatter.date(from: stardDate)!,
            toDate: dateformatter.date(from: endDate)!
        )
    }

    var body: some View {
        NavigationView {
            List {
                // If any error occurs to access Health Data
                if contentVM.dataSource.count == 0 {
                    Text("No Data Found.")
                } else {
                    ForEach( contentVM.dataSource ){ item in
                        HStack{
                            Text(dateformatter.string(from: item.datetime))
                            Text(" \(item.count)")
                        }
                    }
                }
            }
            .navigationTitle("Stress Level")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

