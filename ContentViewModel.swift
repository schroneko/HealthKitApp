//
//  ContentViewModel.swift
//  ListRowItem.swift
//  HeartRateForiPhone
//
//  Created by Yuta Hayashi
//  Copyright Determinant, inc.
//


import SwiftUI
import HealthKit

class ContentViewModel: ObservableObject, Identifiable {

    @Published var dataSource:[ListRowItem] = []

    func get( fromDate: Date, toDate: Date)  {

        let healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: [], read: Set([HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]), completion: { success, error in

            if success == false {
                print("Not Available to access Data")
                return
            }

            let query = HKSampleQuery(sampleType: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                                      predicate: HKQuery.predicateForSamples(withStart: fromDate, end: toDate, options: []),
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]){ (query, results, error) in

                guard error == nil else { print("error"); return }

                if let tmpResults = results as? [HKQuantitySample] {

                    for item in tmpResults {

                        let listItem = ListRowItem(
                            id: item.uuid.uuidString,
                            datetime: item.endDate,
                            count: String(item.quantity.doubleValue(for: HKUnit(from: "count/min")))
                        )

                        self.dataSource.append(listItem)
                    }
                }
            }
            healthStore.execute(query)
        })
    }
}

