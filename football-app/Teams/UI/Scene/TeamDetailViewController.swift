//
//  TeamDetailViewController.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import UIKit
import Combine

class TeamDetailViewController: ViewController {
    var viewModel: TeamDetailViewModel!
    
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
    
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Life-cycle

extension TeamDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
}

// MARK: - Setup

extension TeamDetailViewController {
    func setup() {
        setTitle(viewModel.title)
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(teamImageView)
        view.addSubview(teamNameLabel)
        
        teamImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        teamNameLabel.snp.makeConstraints { make in
            make.top.equalTo(teamImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Bindings

private extension TeamDetailViewController {
    func bind() {
        viewModel.$imageUrl
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                guard let self = self else { return }
                self.teamImageView.kf.setImage(with: url)
            }
            .store(in: &cancellables)
        
        viewModel.$teamName
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: teamNameLabel)
            .store(in: &cancellables)
    }
}
