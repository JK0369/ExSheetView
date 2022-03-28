//
//  SheetView.swift
//  ExOpenSheet
//
//  Created by Jake.K on 2022/03/28.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift
import RxCocoa

class SheetView: UIView {
  private enum Metric {
    static let cornerRadius = 14.0
    static let contentViewInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
    static let sampleLabelTopSpacing = 120.0
    static let bottomLeftBottomRightCornerMask: CACornerMask = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
  }
  private enum Color {
    static let white = UIColor.white
    static let dimmedBlack = UIColor.black.withAlphaComponent(0.25)
    static let clear = UIColor.clear
  }
  
  private lazy var backgroundView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    return view
  }()
  private lazy var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = Color.white
    view.layer.cornerRadius = Metric.cornerRadius
    view.layer.maskedCorners =  Metric.bottomLeftBottomRightCornerMask
    view.clipsToBounds = true
    return view
  }()
  private lazy var someButton: UIButton = {
    let button = UIButton()
    button.setTitle("예시 버튼", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    return button
  }()
  private lazy var sampleLabel: UILabel = {
    let label = UILabel()
    label.text = "sample top sheet"
    label.textAlignment = .center
    return label
  }()
  
  private let disposeBag = DisposeBag()

  required init?(coder: NSCoder) {
    fatalError("init?(coder:) has not been implemented")
  }
  init() {
    super.init(frame: .zero)
    
    // Add
    self.addSubview(self.backgroundView)
    self.addSubview(self.contentView)
    self.contentView.addSubview(self.sampleLabel)
    self.contentView.addSubview(self.someButton)

    // Layout
    self.backgroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    self.contentView.snp.makeConstraints {
      $0.bottom.equalTo(self.snp.top)
      $0.width.equalToSuperview()
    }
    self.someButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    self.sampleLabel.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.top.equalToSuperview().offset(Metric.sampleLabelTopSpacing)
    }
    
    // Bind
    self.backgroundView.rx.tapGesture()
      .skip(1)
      .bind { [weak self] _ in self?.hide() }
      .disposed(by: self.disposeBag)
    self.someButton.rx.tap
      .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
      .bind { _ in print("버튼 Tap!") }
      .disposed(by: self.disposeBag)
  }
  
  func show(completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      self.contentView.snp.remakeConstraints {
        $0.top.left.right.equalToSuperview()
        $0.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide).inset(Metric.contentViewInset).priority(999)
      }
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        options: .curveEaseInOut,
        animations: {
          self.backgroundView.backgroundColor = Color.dimmedBlack
          self.layoutIfNeeded()
        },
        completion: { _ in completion?() }
      )
    }
  }
  
  func hide(completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      self.contentView.snp.remakeConstraints {
        $0.bottom.equalTo(self.snp.top)
        $0.left.right.equalToSuperview()
      }
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        options: .curveEaseInOut,
        animations: {
          self.backgroundView.backgroundColor = Color.clear
          self.layoutIfNeeded()
        },
        completion: { _ in
          completion?()
          self.removeFromSuperview()
        }
      )
    }
  }
}
