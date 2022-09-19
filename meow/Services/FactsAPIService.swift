//
//  FactsAPIService.swift
//  meow
//
//  Created by Yanin Contreras on 13/09/22.
//

import Foundation
import Alamofire
import AppCenterAnalytics
import AppCenterCrashes

struct FactsAPIService{
    func getFacts(count: Int) async throws -> [String]{
        try await withUnsafeThrowingContinuation({ continuation in
            let url = "\(K.apiURL)?count=\(count)"
            AF.request(url)
                .response { response in
                if let safeData = response.data{
                    let decoder = JSONDecoder()
                    do {
                        Analytics.trackEvent("Items fetched", withProperties: ["Count" : "\(count)"])
                        let facts = try decoder.decode(MeowFacts.self, from: safeData)
                        continuation.resume(returning: facts.data)
                        return
                    } catch {
                        Crashes.trackError(error, properties: nil, attachments: nil)
                        continuation.resume(throwing: error)
                        return
                    }
                }
                if let err = response.error {
                    Crashes.trackError(err, properties: nil, attachments: nil)
                    continuation.resume(throwing: err)
                    return
                }
                fatalError("should not get here")
            }
        })
    }
}
