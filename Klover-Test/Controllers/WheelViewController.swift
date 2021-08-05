//
//  WheelViewController.swift
//  Klover-Test
//
//  Created by Lawson Kelly on 8/4/21.
//

import UIKit
import SwiftFortuneWheel

class WheelViewController: UIViewController {
    var slices: [Slice] = []
    var sliceResponse: [SliceResponse] = []
    var fortuneWheel: SwiftFortuneWheel?

    let spinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Spin!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        button.backgroundColor = Constants.Colors.pinkColor
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleSpin), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Spin the Wheel"
        view.backgroundColor = Constants.Colors.gameBackgroundColor
        view.addSubview(spinButton)
        spinButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 124, bottom: 44, right: 124))
        getSliceData()
    }

    fileprivate func getSliceData() {
        APICaller.shared.getSliceInfo { [weak self] result in
            switch result {
            case .success(let response):
                self?.sliceResponse = response
                self?.setUpSlices(response: response)
            case .failure(let error):
                print(error)
            }
        }
    }

    fileprivate func setUpSlices(response: [SliceResponse]) {
        for item in response {
            let headerContent = Slice.ContentType.text(text: "\(item.displayText)", preferences: .withoutStoryboardExampleAmountTextPreferences)
            let slice = Slice(contents: [headerContent])
            slices.append(slice)
        }
        createWheel(slices: slices)
    }

    fileprivate func createWheel(slices: [Slice]) {
        DispatchQueue.main.async {
            let frame = CGRect(x: 35, y: 100, width: 300, height: 300)
            let fortuneWheel = SwiftFortuneWheel(frame: frame, slices: slices, configuration: .withoutStoryboardExampleConfiguration)
            self.fortuneWheel = fortuneWheel
            self.layoutWheel()
        }
    }

    func layoutWheel() {
        if let fortuneWheel = fortuneWheel {
            DispatchQueue.main.async {
                self.view.addSubview(fortuneWheel)
                guard let superview = fortuneWheel.superview
                else {
                    return
                }
                fortuneWheel.translatesAutoresizingMaskIntoConstraints = false
                fortuneWheel.widthAnchor.constraint(equalToConstant: 300).isActive = true
                fortuneWheel.heightAnchor.constraint(equalToConstant: 300).isActive = true
                fortuneWheel.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
                fortuneWheel.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
                fortuneWheel.pinImage = "wheel_ticker.png"
            }
        }
    }

    @objc fileprivate func handleSpin() {
        if let fortuneWheel = fortuneWheel {
            let randomInt = Int.random(in: 0..<slices.count)
            fortuneWheel.startRotationAnimation(finishIndex: randomInt, continuousRotationTime: 3, continuousRotationSpeed: 0.75) { [weak self] finished in
                if finished {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    print("You won ", self?.sliceResponse[randomInt].displayText ?? "")
                    let prizeView = PrizeView(frame: CGRect(x: 0, y: 0, width: self?.view.width ?? 0, height: (self?.view.width ?? 0 * 0.7) + 100))

                    self?.view.addSubview(prizeView)
                    prizeView.centerInSuperview()
                }
            }
        }
    }
}
