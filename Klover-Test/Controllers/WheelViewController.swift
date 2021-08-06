//
//  WheelViewController.swift
//  Klover-Test
//
//  Created by Lawson Kelly on 8/4/21.
//

import UIKit
import SwiftFortuneWheel
import SwiftConfettiView

class WheelViewController: UIViewController {
    var slices: [Slice] = []
    var sliceResponse: [SliceResponse] = []
    var fortuneWheel: SwiftFortuneWheel?
    var confettiView: SwiftConfettiView?
    var prizeView: PrizeView?

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
        spinButton.sizeToFit()
        spinButton.frame = CGRect(x: view.width/2 - 50, y: view.height - 64, width: 100, height: spinButton.height)
        view.addSubview(spinButton)
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

    fileprivate func setupPrizeView(amount: String, currency: String) {
        let prizeView = PrizeView(frame: CGRect(x: view.width/2 - ((view.width - 80)/2), y: view.height/2 - view.height/8, width: view.width - 80, height: view.height/4))
        self.prizeView = prizeView
        prizeView.centerInSuperview()
        prizeView.prizeLabel.text = "CONGRATS YOU HAVE WON BIG. YOU WON \(amount) \(currency)"
        prizeView.doneButton.addTarget(self, action: #selector(stopAnimating), for: .touchUpInside)
        self.view.addSubview(prizeView)
        spinButton.isHidden = true
    }

    fileprivate func setupConfetiView() {
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        view.addSubview(confettiView)
        self.confettiView = confettiView
        confettiView.intensity = 0.8
        confettiView.type = .star
        confettiView.startConfetti()
    }

    @objc fileprivate func handleSpin() {
        if let fortuneWheel = fortuneWheel {
            let randomInt = Int.random(in: 0..<slices.count)
            fortuneWheel.startRotationAnimation(finishIndex: randomInt, continuousRotationTime: 3, continuousRotationSpeed: 0.75) { [weak self] finished in
                if finished {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    self?.setupConfetiView()
                    self?.setupPrizeView(amount: self?.sliceResponse[randomInt].displayText ?? "", currency: self?.sliceResponse[randomInt].currency ?? "")
                }
            }
        }
    }

    @objc fileprivate func stopAnimating() {
        self.confettiView?.stopConfetti()
        spinButton.isHidden = false
        self.prizeView?.removeFromSuperview()
        self.confettiView?.removeFromSuperview()
    }
}
