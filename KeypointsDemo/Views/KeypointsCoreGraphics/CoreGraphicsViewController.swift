//
//  CoreGraphicsViewController.swift
//  KeypointsDemo
//
//  Created by Indra on 03/07/24.
//

import UIKit
import Combine

final class CoreGraphicsViewController: UIViewController {
    
    // MARK: - private properties
    private let viewModel = CoreGraphicsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - private views
    private var coreGraphicsView: UIView?
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
        viewModel.fetchKeypoints(fileName: viewModel.fileNames[safe: 0] ?? "")
        viewModel.$state.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .finished(let keypoints):
                if let coreGraphicsView = self.coreGraphicsView {
                    coreGraphicsView.removeFromSuperview()
                }
                
                let coreGraphicsView = CoreGraphicsView(keypoints: keypoints)
                self.view.addSubview(coreGraphicsView)
                coreGraphicsView.frame = self.view.safeAreaLayoutGuide.layoutFrame
                coreGraphicsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                coreGraphicsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                
                self.coreGraphicsView = coreGraphicsView
            default:
                break
            }
        }.store(in: &cancellables)
        
        addSegmentedControl()
        
    }
}

// MARK: - Setup SegmentedControl
extension CoreGraphicsViewController {
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

