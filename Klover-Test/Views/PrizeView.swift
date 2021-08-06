//
//  PrizeView.swift
//  Klover-Test
//
//  Created by Lawson Kelly on 8/5/21.
//

import UIKit

class PrizeView: UIView {
    struct ViewModel {
        let displayText: String
    }

    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        button.backgroundColor = Constants.Colors.pinkColor
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    let prizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(doneButton, prizeLabel)
        backgroundColor = Constants.Colors.gameBackgroundColor
        layer.borderWidth = 4
        layer.borderColor = CGColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        prizeLabel.sizeToFit()
        doneButton.sizeToFit()
        prizeLabel.frame = CGRect(x: width/2 - ((width - 40)/2), y: height/2 - prizeLabel.height - 40, width: width - 40, height: prizeLabel.height + 40)
        doneButton.frame = CGRect(x: width/2 - (doneButton.width + 80)/2, y: height/2 + 14, width: doneButton.width + 80, height: doneButton.height)
    }
}
