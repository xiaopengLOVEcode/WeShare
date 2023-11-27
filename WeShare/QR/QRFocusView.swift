//
//  QRFocusView.swift
//  WeShare
//
//  Created by XP on 2023/11/26.
//

import Foundation
import UIKit

final class QRFocusView: UIView {
    
    static let recLineWidth: Int = 20
    
    let focusWrapper = UIView()
    
    override func draw(_ rect: CGRect) {
        let minX: Int = 2
        let minY: Int = 2
        let maxX = Int(rect.width - 2)
        let maxY = Int(rect.height - 2)
        contentMode = .redraw
        
        UIColor.white.set()
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: minX, y: Self.recLineWidth + minY))
        path1.addLine(to: CGPoint(x: minX, y: minY))
        path1.addLine(to: CGPoint(x: Self.recLineWidth + minX, y: minY))
        path1.lineWidth = 4
        path1.lineCapStyle = .round
        path1.lineJoinStyle = .round
        path1.stroke()

        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: (Int(maxX) - Self.recLineWidth), y: minY))
        path2.addLine(to: CGPoint(x: maxX, y: minY))
        path2.addLine(to: CGPoint(x: maxX, y: minY + Self.recLineWidth))
        path2.lineWidth = 4.0
        path2.lineCapStyle = .round
        path2.lineJoinStyle = .round
        path2.stroke()

        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: maxX, y: (maxY - Self.recLineWidth)))
        path3.addLine(to: CGPoint(x: maxX, y: maxY))
        path3.addLine(to: CGPoint(x: (maxX - Self.recLineWidth), y: maxY))
        path3.lineWidth = 4.0
        path3.lineCapStyle = .round
        path3.lineJoinStyle = .round
        path3.stroke()

        let path4 = UIBezierPath()
        path4.move(to: CGPoint(x: Self.recLineWidth + minX, y: maxY))
        path4.addLine(to: CGPoint(x: minX, y: maxY))
        path4.addLine(to: CGPoint(x: minX, y: (maxY - Self.recLineWidth)))
        path4.lineWidth = 4.0
        path4.lineCapStyle = .round
        path4.lineJoinStyle = .round
        path4.stroke()
    }
    
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        addSubview(focusWrapper)
        focusWrapper.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
    }
}
