//
//  SceneKitViewModel.swift
//  KeypointsDemo
//
//  Created by Indra on 15/07/24.
//

import SceneKit

enum SceneKitScreenStates {
    case initial
    case loading
    case finished(data: [Keypoint3D])
    case error(Error)
}

final class SceneKitViewModel: ObservableObject {
    @Published var state: SceneKitScreenStates = .initial
    var keypoints: [Keypoint3D] = []
    var fileNames = [FileName.ca.rawValue,
                     FileName.tw.rawValue]
    
    func fetchKeypoints(fileName: String) {
        state = .loading
        guard let url = Bundle.main.url(forResource: fileName,
                                        withExtension: "json") else {
            state = .error(NSError(domain: "File Not found", 
                                   code: 404))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decodedKeypoints = try JSONDecoder().decode([Keypoint].self, from: data)
            keypoints = decodedKeypoints.map { keypoint in
                Keypoint3D(id: keypoint.id,
                           point: SCNVector3(x: Float(keypoint.keypoints[safe: 0] ?? 0),
                                             y: Float(keypoint.keypoints[safe: 1] ?? 0), 
                                             z: Float(keypoint.keypoints[safe: 2] ?? 0)))
            }
            state = .finished(data: keypoints)
        } catch {
            print(error.localizedDescription)
            state = .error(error)
        }
    }
}
