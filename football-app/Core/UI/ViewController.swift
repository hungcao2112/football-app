//
//  ViewController.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import UIKit

class ViewController: UIViewController {
    var isPresentedModally: Bool {
      return presentingViewController != nil ||
        navigationController?.presentingViewController?.presentedViewController === navigationController ||
        tabBarController?.presentingViewController is UITabBarController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        setupNavBarItems()
    }
    
    func setupNavBarItems() {
      if navigationController?.viewControllers.first != self {
        let backButton = UIBarButtonItem(
          image: UIImage(systemName: "arrow.backward"),
          style: .plain,
          target: self,
          action: #selector(backButtonTapped)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton

        navigationController?.interactivePopGestureRecognizer?.delegate = self
      }
    }
    
    func setTitle(_ title: String) {
        navigationItem.title = title
    }
    
    @objc
    func backButtonTapped() {
      if navigationController?.viewControllers.first != self {
        navigationController?.popViewController(animated: true)
      } else if isPresentedModally {
        dismiss(animated: true, completion: nil)
      }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return true
  }
}
