//
//  ARSUISwitch.swift
//  Aries
//
//  Created by XP on 2022/11/1.
//

import UIKit

public class ARSUISwitch: UISwitch {
    
    public var onCompletion: (() -> Void)?
    
    public var offCompletion: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        configStyle()
        addHandleEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configStyle() {
        self.onTintColor = UIColor.pl_main
        self.thumbTintColor = UIColor.white
    }
    
    private func addHandleEvent() {
        addTarget(self, action: #selector(switchChange(_:)), for: .valueChanged)
    }
    
    @objc private func switchChange(_ sender: UISwitch) {
        if sender.isOn {
            self.onCompletion?()
        } else {
            self.offCompletion?()
        }
    }
}
