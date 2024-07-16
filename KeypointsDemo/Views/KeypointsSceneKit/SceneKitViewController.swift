//
//  SceneKitViewController.swift
//  KeypointsDemo
//
//  Created by Indra on 15/07/24.
//

import UIKit
import SceneKit
import Combine

class SceneKitViewController: UIViewController {
    
    // MARK: - private properties
    private let viewModel = SceneKitViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - private views
    private var scnView: SCNView?
    private var scnScene: SCNScene?
    private var cameraNode: SCNNode?
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: viewModel.fileNames)
        segmentedControl.frame = CGRect(origin: .init(x: 20, y: 80),
                                        size: .init(width: 200,
                                                    height: 40))
        
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupScene()
        setupCameraNode()
        
        viewModel.fetchKeypoints(fileName: viewModel.fileNames[safe: 0] ?? "")
        viewModel.$state.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .finished(let keypoints):
                self.cleanScene()
                keypoints.forEach { keypoint in
                    self.spawn(position: keypoint.point)
                }
            default:
                break
            }
        }.store(in: &cancellables)
        
        addSegmentedControl()
    }

}

// MARK: - Setup SceneKit views
extension SceneKitViewController {
    private func setupView() {
        scnView = self.view as? SCNView
        scnView?.allowsCameraControl = true
        scnView?.autoenablesDefaultLighting = true
    }
    
    private func setupScene() {
        scnScene = SCNScene()
        scnView?.scene = scnScene
    }
    
    private func setupCameraNode() {
        cameraNode = SCNNode()
        cameraNode?.camera = SCNCamera()
        cameraNode?.position = SCNVector3(x: 0, y: 0, z: 2.5)
        if let cameraNode {
            scnScene?.rootNode.addChildNode(cameraNode)
        }
    }
    
    private func spawn(position: SCNVector3) {
        let geometry: SCNGeometry = SCNSphere(radius: 0.01)
        
        let greenMaterial = SCNMaterial()
        greenMaterial.diffuse.contents = UIColor.green
        greenMaterial.locksAmbientWithDiffuse = true
        
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.position = position
        geometry.materials = [greenMaterial]
        scnScene?.rootNode.addChildNode(geometryNode)
    }
    
    func cleanScene() {
        if let childNodes = scnScene?.rootNode.childNodes {
            for node in childNodes {
                node.removeFromParentNode()
            }
            cameraNode?.position = SCNVector3(x: 0, y: 0, z: 2.5)
        }
    }
}

// MARK: - Setup SegmentedControl
extension SceneKitViewController {
    private func addSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(buttonSwitchValueChanged), for: .valueChanged)
        self.view.addSubview(segmentedControl)
    }

    @objc func buttonSwitchValueChanged(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            viewModel.fetchKeypoints(fileName: viewModel.fileNames[safe: 0] ?? "")
        } else {
            viewModel.fetchKeypoints(fileName: viewModel.fileNames[safe: 1] ?? "")
        }
        
        self.view.bringSubviewToFront(segmentedControl)
    }

}
