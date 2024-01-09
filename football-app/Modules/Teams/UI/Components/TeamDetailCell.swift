//
//  TeamDetailCell.swift
//  football-app
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation
import UIKit

class TeamDetailCell: UICollectionViewCell {
    static let reuseIdentifier = "TeamListCell"
    
    var viewModel: TeamDetailCellViewModel! {
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
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var vsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "vs."
        label.textColor = .black
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy var teamImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
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

private extension TeamDetailCell {
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(dateLabel)
        addSubview(borderView)

        borderView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(vsLabel)
        contentStackView.addArrangedSubview(teamImageView)
        contentStackView.addArrangedSubview(teamNameLabel)
        contentStackView.addArrangedSubview(resultLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8).priority(999)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(16)
        }
        
        teamImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(60)
        }
    }
}

// MARK: - Refresh

private extension TeamDetailCell {
    func refresh() {
        dateLabel.text = viewModel.dateText
        teamImageView.kf.setImage(with: viewModel.teamImageUrl)
        teamNameLabel.text = viewModel.teamName
        resultLabel.backgroundColor = viewModel.isWinner ? .systemGreen : .systemRed
        resultLabel.text = viewModel.resultText
    }
}
