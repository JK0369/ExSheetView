//
//  ViewController.swift
//  ExOpenSheet
//
//  Created by Jake.K on 2022/03/28.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  private lazy var openButton: UIButton = {
    let button = UIButton()
    button.setTitle("open", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    button.addTarget(self, action: #selector(didTapOpenButton), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(button)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.openButton)
    
    self.openButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  @objc private func didTapOpenButton() {
    let sheetView = SheetView()
    self.view.addSubview(sheetView)
    sheetView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    self.view.layoutIfNeeded()
    sheetView.show()
  }
}
