//
//  ViewController.swift
//  KeypointsDemo
//
//  Created by Indra on 03/07/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private let viewModel = CoreGraphicsViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchKeypoints()
        viewModel.$state.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .finished(let keypoints):
                let coreGraphicsView = CoreGraphicsView(keypoints: keypoints)
                self.view.addSubview(coreGraphicsView)
                coreGraphicsView.frame = self.view.safeAreaLayoutGuide.layoutFrame
                coreGraphicsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                coreGraphicsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            default:
                break
            }
        }.store(in: &cancellables)
    }

}

