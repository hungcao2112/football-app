//
//  MatchListHeader.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation
import UIKit

class MatchListHeader: UICollectionReusableView {
    static let reuseIdentifier = "MatchListHeader"
    
    var viewModel: MatchListHeaderViewModel! {
        didSet {
            refresh()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
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

private extension MatchListHeader {
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}

// MARK: - Refresh

private extension MatchListHeader {
    func refresh() {
        titleLabel.text = viewModel.dateString
    }
}
