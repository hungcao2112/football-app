//
//  TeamListCell.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import UIKit

class TeamListCell: UICollectionViewCell {
    static let reuseIdentifier = "TeamListCell"
    
    var viewModel: TeamListCellViewModel! {
        didSet {
            refresh()
        }
    }
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
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
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGreen
        return imageView
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

private extension TeamListCell {
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(teamImageView)
        contentStackView.addArrangedSubview(teamNameLabel)
        contentStackView.addArrangedSubview(checkImageView)
        
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(50).priority(999)
        }
        
        teamImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
    }
}

// MARK: - Refresh

private extension TeamListCell {
    func refresh() {
        teamImageView.kf.setImage(with: viewModel.teamImageUrl)
        teamNameLabel.text = viewModel.teamName
        checkImageView.isHidden = !viewModel.isSelected
    }
}
