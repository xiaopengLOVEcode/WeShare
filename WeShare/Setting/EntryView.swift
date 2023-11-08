

import Foundation
import UIKit
import RxSwift
import RxGesture

typealias EntryTitle = String
typealias EntryImage = String
typealias EntryArrowBlock = (() -> Void)

enum EntryData {
    case arrow(EntryTitle, EntryImage, EntryArrowBlock)
    case none
}

class EntryView: UIView {
    private var bag = DisposeBag()

    private let lStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    private let titleLabel = UILabel().then {
        $0.font = .font(14)
        $0.textColor = .pl_title
    }
    
    private let imageView = UIImageView()
    
    private let arrowView = UIImageView().then {
        $0.image = UIImage(named: "arrow")
        $0.isHidden = true
    }
    
    var data: EntryData {
        didSet {
            bindData()
        }
    }
    
    init(with data: EntryData) {
        self.data = data
        super.init(frame: .zero)
        setupSubviews()
        bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EntryView {
    func setupSubviews() {
        addSubview(lStackView)
        lStackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        lStackView.addArrangedSubview(titleLabel)
        lStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        addSubview(arrowView)
        arrowView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func bindData() {
        bag = DisposeBag()
        switch data {
        case .arrow(let title, let imageStr, let handler):
            titleLabel.text = title
            imageView.image = UIImage(named: imageStr)
            arrowView.isHidden = false
            rx.tapGesture().when(.recognized)
                .subscribeNext { _ in
                    handler()
                }
                .disposed(by: bag)
        default:
            break
        }
    }
    
}
