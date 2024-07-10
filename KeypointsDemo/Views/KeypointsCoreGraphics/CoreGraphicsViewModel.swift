//
//  CoreGraphicsViewModel.swift
//  KeypointsDemo
//
//  Created by Indra on 08/07/24.
//

import Foundation

enum ScreenStates {
    case initial
    case loading
    case finished(data: [Keypoint2D])
    case error(Error)
}

final class CoreGraphicsViewModel: ObservableObject {
    @Published var state: ScreenStates = .initial
    var keypoints: [Keypoint2D] = []
    
    func fetchKeypoints() {
        state = .loading
        guard let url = Bundle.main.url(forResource: "TW_Keypoints", withExtension: "json") else {
            state = .error(NSError(domain: "File Not found", code: 404))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decodedKeypoints = try JSONDecoder().decode([Keypoint].self, from: data)
            keypoints = decodedKeypoints.map { keypoint in
                Keypoint2D(id: keypoint.id,
                           point: CGPoint(x: keypoint.keypoints[safe: 0] ?? 0,
                                          y: keypoint.keypoints[safe: 1] ?? 0))
            }
            state = .finished(data: keypoints)
        } catch {
            print(error.localizedDescription)
            state = .error(error)
        }
    }
}
