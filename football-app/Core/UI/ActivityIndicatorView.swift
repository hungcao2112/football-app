//
//  ActivityIndicatorView.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation
import UIKit

final class ActivityIndicatorView: UIActivityIndicatorView {
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        color = .white
        backgroundColor = .darkGray
        layer.cornerRadius = 5.0
        hidesWhenStopped = true
    }
}

