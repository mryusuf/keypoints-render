//
//  Keypoint.swift
//  KeypointsDemo
//
//  Created by Indra on 08/07/24.
//

import SceneKit

struct Keypoint: Decodable {
    let id: Int
    let keypoints: [Double]
}

struct Keypoint2D: Decodable {
    let id: Int
    let point: CGPoint
}

struct Keypoint3D {
    let id: Int
    let point: SCNVector3
}

enum FileName: String {
    case ca = "CA_Keypoints"
    case tw = "TW_Keypoints"
}
