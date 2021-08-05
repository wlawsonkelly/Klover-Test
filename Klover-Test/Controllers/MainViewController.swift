//
//  ViewController.swift
//  Klover-Test
//
//  Created by Lawson Kelly on 8/4/21.
//

import UIKit

class MainViewController: UIViewController {

    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Spin the Wheel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Constants.Colors.pinkColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(handlePressStart), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(startButton)
        startButton.sizeToFit()
        startButton.centerInSuperview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Wheel Game"
    }

    @objc private func handlePressStart() {
        let wheelVC = WheelViewController()
        navigationItem.title = ""
        self.navigationController?.pushViewController(wheelVC, animated: true)
    }

}
