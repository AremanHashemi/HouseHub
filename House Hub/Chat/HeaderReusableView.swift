//
//  HeaderReusableView.swift
//  House Hub
//
//  Created by Rowen Banton on 7/20/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import MessageKit

class HeaderReusableView: MessageReusableView {
    // MARK: - Private Properties
    static private let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.white
    ]
    
    static private let insets = UIEdgeInsets(top: 12, left: 130, bottom: 12, right: 130)

    private var label: UILabel!

    // MARK: - Public Methods
    static var height: CGFloat {
        return insets.top + insets.bottom + 27
    }

    // Initialize header object itself
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createUI()
    }

    /// Setup the receiver with text.
    ///
    /// - Parameter text: The text to be displayed.
    func setup(with text: String) {
        label.attributedText = NSAttributedString(string: text)// , attributes: ChatHeaderReusableView.attributes)
    }


    // MARK: - Private Methods
    private func createUI() {
        let insets = HeaderReusableView.insets
        let frame = bounds.inset(by: insets)
        label = UILabel(frame: frame)
        label.preferredMaxLayoutWidth = frame.width
        label.numberOfLines = 1
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = .opaqueSeparator
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        addSubview(label)
    }
}
