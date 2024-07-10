//
//  CoreGraphicsView.swift
//  KeypointsDemo
//
//  Created by Indra on 08/07/24.
//

import UIKit

final class CoreGraphicsView: UIView {
    private var keypoints: [Keypoint2D]
    
    init(keypoints: [Keypoint2D]) {
        self.keypoints = keypoints
        super.init(frame: .zero)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for keypoint in keypoints {
            context.beginPath()
            // MARK: - Improvement: modify Transformation value on the fly (e.g. for pinch gesture, screen rotate)
            let tranform = CGAffineTransform(rect.size.height - 20,
                                             0,
                                             0,
                                             rect.size.height - 20,
                                             rect.size.width / 2,
                                             rect.size.height / 2)
            let scaleTransform = CGAffineTransformScale(tranform,
                                                        rect.size.height,
                                                        rect.size.height)
            let point = CGPointApplyAffineTransform(keypoint.point, tranform)
//            context.setStrokeColor(UIColor.blue.cgColor)
//            context.setLineWidth(2.0)
//            context.setLineCap(.round)
//            context.move(to: point)
//            context.addLine(to: CGPoint(x: point.x + 2, y: point.y - 2))
//            context.strokePath()
            context.setFillColor(UIColor.systemBrown.cgColor)
            context.fill(CGRect(x: point.x, y: point.y, width: 2, height: 2))
        }
    }
}
