//
//  MatchTeamView.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation
import UIKit
import Kingfisher

class MatchTeamView: UIView {
    var viewModel: MatchTeamViewModel! {
        didSet {
            refresh()
        }
    }
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var teamImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

private extension MatchTeamView {
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(teamImageView)
        contentStackView.addArrangedSubview(teamNameLabel)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        teamImageView.snp.makeConstraints { make in
            make.height.equalTo(teamImageView.snp.width).multipliedBy(0.8)
        }
    }
}

// MARK: - Refresh

private extension MatchTeamView {
    func refresh() {
        if let url = viewModel.teamImageUrl {
            teamImageView.kf.setImage(with: url)
        }
        teamNameLabel.text = viewModel.teamName
    }
}
