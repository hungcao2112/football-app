//
//  MatchListCell.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import UIKit
import Combine

class MatchListCell: UICollectionViewCell {
    static let reuseIdentifier = "MatchListCell"
    
    var viewModel: MatchListCellViewModel! {
        didSet {
            refresh()
        }
    }
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var matchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var timeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var homeTeamView: MatchTeamView = MatchTeamView()
    
    lazy var awayTeamView: MatchTeamView = MatchTeamView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

private extension MatchListCell {
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(borderView)
        
        borderView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(matchStackView)
        matchStackView.addArrangedSubview(homeTeamView)
        matchStackView.addArrangedSubview(timeView)
        matchStackView.addArrangedSubview(awayTeamView)
        
        timeView.addSubview(timeLabel)
        
        borderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        matchStackView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        homeTeamView.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        
        awayTeamView.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}

// MARK: - Refresh

private extension MatchListCell {
    func refresh() {
        descriptionLabel.text = viewModel.descriptionText
        timeLabel.text = viewModel.timeText
        
        if let homeTeamVM = viewModel.getHomeTeamViewModel() {
            homeTeamView.viewModel = homeTeamVM
        }
        if let awayTeamVM = viewModel.getAwayTeamViewModel() {
            awayTeamView.viewModel = awayTeamVM
        }
    }
}
