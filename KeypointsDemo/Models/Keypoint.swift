//
//  Keypoint.swift
//  KeypointsDemo
//
//  Created by Indra on 08/07/24.
//

import Foundation

struct Keypoint: Decodable {
    let id: Int
    let keypoints: [CGFloat]
}

struct Keypoint2D: Decodable {
    let id: Int
    let point: CGPoint
}
