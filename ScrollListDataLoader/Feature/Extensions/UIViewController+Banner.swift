//
//  UIViewController+Banner.swift
//
//  Created by Radim Langer on 20/09/2018.
//

import UIKit

extension UIViewController {

    private enum AnimationType {
        case presentation
        case dismissal
    }

    public func showNotification(with text: String, topInset: CGFloat) {

        guard view.subviews.first(where: { ($0 as? UILabel)?.text == text }) == nil else {
            return
        }

        let label = self.label(with: text)
        view.addSubview(label)

        springAnimate(.presentation, view: label, topInset: topInset) {
            self.springAnimate(.dismissal, delay: 5, view: label, topInset: topInset) {
                label.removeFromSuperview()
            }
        }
    }

    private func label(with text: String) -> UILabel {

        let maxWidth = view.frame.width

        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        let labelHeight = label.sizeThatFits(CGSize(width: maxWidth - 16, height: .greatestFiniteMagnitude)).height + 16

        label.frame.size.width = view.frame.width - 16
        label.frame.size.height = labelHeight
        label.frame.origin.x = 8
        label.frame.origin.y = -label.frame.height

        label.layer.backgroundColor = UIColor.red.cgColor
        label.layer.cornerRadius = labelHeight / 4

        return label
    }

    private func springAnimate(
        _ type: AnimationType,
        delay: TimeInterval = 0,
        view: UIView,
        topInset: CGFloat,
        completion: (() -> Void)? = nil
    ) {

        let slidingDuration: TimeInterval = 0.5

        let yCoord = type == .presentation ? topInset : -(topInset + view.frame.maxY)

        UIView.animate(
            withDuration: slidingDuration,
            delay: delay,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: { view.frame.origin.y = yCoord },
            completion: { _ in completion?() }
        )
    }

}
