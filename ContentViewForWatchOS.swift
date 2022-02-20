//
//  ContentView.swift
//  HeartRate WatchKit Extension
//
//  Created by Yuta Hayashi
//  Copyright 2022 Determinant, inc.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")

    @State private var value = 0

    var body: some View {
        VStack{
            HStack{
                Text("Stress Level")
                    .font(.system(size: 20))
            }

            HStack{
                Spacer()
                Text("\(value)")
                    .fontWeight(.regular)
                    .font(.system(size: 70))

                Text("/ 100")
                    .fontWeight(.bold)
                    .padding(.top, 40.0)
            }

        }
        .padding()
        .onAppear(perform: start)
    }


    func start() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }

    // Authorization to access to Health Data
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }

    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {

        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in

        guard let samples = samples as? [HKQuantitySample] else {
            return
        }

        self.process(samples, type: quantityTypeIdentifier)

        }

        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)

        query.updateHandler = updateHandler

        healthStore.execute(query)
    }

    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0

        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }

            self.value = Int(lastHeartRate)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

