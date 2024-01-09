//
//  TeamDetailHeaderView.swift
//  football-app
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation
import UIKit

class TeamDetailHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "TeamDetailHeaderView"
    
    var viewModel: TeamDetailHeaderViewModel! {
        didSet {
            refresh()
        }
    }
    
    lazy var teamImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    lazy var teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var recentMatchesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Recent matches"
        label.textAlignment = .center
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

private extension TeamDetailHeaderView {
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(teamImageView)
        addSubview(teamNameLabel)
        addSubview(recentMatchesLabel)
        
        teamImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        teamNameLabel.snp.makeConstraints { make in
            make.top.equalTo(teamImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        recentMatchesLabel.snp.makeConstraints { make in
            make.top.equalTo(teamNameLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().priority(999)
        }
    }
}

// MARK: - Refresh

private extension TeamDetailHeaderView {
    func refresh() {
        teamImageView.kf.setImage(with: viewModel.imageUrl)
        teamNameLabel.text = viewModel.teamName
    }
}
