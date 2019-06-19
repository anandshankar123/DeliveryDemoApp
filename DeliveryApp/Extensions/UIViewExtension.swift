// swiftlint:disable all
import Foundation
import UIKit
extension UIView {
    func constraintAnchor(anchor: Anchor) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        if #available(iOS 11, *), anchor.enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
            print("Top: \(topInset)")
            print("bottom: \(bottomInset)")
        }
        translatesAutoresizingMaskIntoConstraints = false
        if let top = anchor.top {
            self.topAnchor.constraint(equalTo: top, constant: anchor.paddingTop+topInset).isActive = true
        }
        if let left = anchor.left {
            self.leftAnchor.constraint(equalTo: left, constant: anchor.paddingLeft).isActive = true
        }
        if let right = anchor.right {
            rightAnchor.constraint(equalTo: right, constant: -anchor.paddingRight).isActive = true
        }
        if let bottom = anchor.bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -anchor.paddingBottom-bottomInset).isActive = true
        }
        if anchor.height != 0 {
            heightAnchor.constraint(equalToConstant: anchor.height).isActive = true
        }
        if anchor.width != 0 {
            widthAnchor.constraint(equalToConstant: anchor.width).isActive = true
        }
    }
}
extension UIView {
    func trailing(toView view : UIView , constant : CGFloat = 0 , multiplier : CGFloat = 1)-> NSLayoutConstraint {
        return  NSLayoutConstraint.init(item: self
            , attribute: NSLayoutConstraint.Attribute.trailing
            , relatedBy: NSLayoutConstraint.Relation.equal
            , toItem: view
            , attribute: NSLayoutConstraint.Attribute.trailing
            , multiplier: multiplier
            , constant: constant)
    }
    func leading(toView view : UIView , constant : CGFloat = 0 , multiplier : CGFloat = 1)-> NSLayoutConstraint {
        return  NSLayoutConstraint.init(item: self
            , attribute: NSLayoutConstraint.Attribute.leading
            , relatedBy: NSLayoutConstraint.Relation.equal
            , toItem: view
            , attribute: NSLayoutConstraint.Attribute.leading
            , multiplier: multiplier
            , constant: constant)
    }
    func top(toView view : UIView , constant : CGFloat = 0 , multiplier : CGFloat = 1)-> NSLayoutConstraint {
        return  NSLayoutConstraint.init(item: self
            , attribute: NSLayoutConstraint.Attribute.top
            , relatedBy: NSLayoutConstraint.Relation.equal
            , toItem: view
            , attribute: NSLayoutConstraint.Attribute.top
            , multiplier: multiplier
            , constant: constant)
    }
    func relativeTop(toView view : UIView , constant : CGFloat = 0 , multiplier : CGFloat = 1)-> NSLayoutConstraint {
        return  NSLayoutConstraint.init(item: self
            , attribute: NSLayoutConstraint.Attribute.top
            , relatedBy: NSLayoutConstraint.Relation.equal
            , toItem: view
            , attribute: NSLayoutConstraint.Attribute.bottom
            , multiplier: multiplier
            , constant: constant)
    }
    func bottom(toView view : UIView , constant : CGFloat = 0 , multiplier : CGFloat = 1)-> NSLayoutConstraint {
        return  NSLayoutConstraint.init(item: self
            , attribute: NSLayoutConstraint.Attribute.bottom
            , relatedBy: NSLayoutConstraint.Relation.equal
            , toItem: view
            , attribute: NSLayoutConstraint.Attribute.bottom
            , multiplier: multiplier
            , constant: constant)
    }
    func height(toView view : UIView? = nil , constant : CGFloat = 0 , multiplier : CGFloat = 1)-> NSLayoutConstraint {
        return  NSLayoutConstraint.init(item: self
            , attribute: NSLayoutConstraint.Attribute.height
            , relatedBy: NSLayoutConstraint.Relation.equal
            , toItem: view
            , attribute: view != nil ? NSLayoutConstraint.Attribute.height : NSLayoutConstraint.Attribute.notAnAttribute
            , multiplier: multiplier
            , constant: constant)
    }
    func relativeBottom(toView view : UIView , constant : CGFloat = 0 , multiplier : CGFloat = 1)-> NSLayoutConstraint {
        return  NSLayoutConstraint.init(item: self
            , attribute: NSLayoutConstraint.Attribute.bottom
            , relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual
            , toItem: view
            , attribute: NSLayoutConstraint.Attribute.bottom
            , multiplier: multiplier
            , constant: constant)
    }
    func add(toSuperView view : UIView, topMargin : CGFloat, leftMargin : CGFloat, rightMargin : CGFloat , bottomMargin: CGFloat){
        view.addSubview(self)
        view.addConstraints (
            [top(toView: view,constant: topMargin)
                ,leading(toView: view, constant: leftMargin)
                ,trailing(toView: view, constant: rightMargin)
                ,bottom(toView: view, constant: bottomMargin)
            ]
        )
        view.layoutIfNeeded()
    }
    func add(toSuperView view : UIView, relatedView : UIView, topMargin : CGFloat, leftMargin : CGFloat, rightMargin : CGFloat , viewHeight: CGFloat){
        view.addSubview(self)
        view.addConstraints (
            [relativeTop(toView: relatedView,constant: topMargin)
                ,leading(toView: relatedView, constant: leftMargin)
                ,trailing(toView: relatedView, constant: rightMargin)
                ,height(constant: viewHeight)
            ]
        )
        view.layoutIfNeeded()
    }
    func add(toSuperView view : UIView, relatedView : UIView, topMargin : CGFloat, leftMargin : CGFloat, rightMargin : CGFloat){
        view.addSubview(self)
        view.addConstraints (
            [relativeTop(toView: relatedView,constant: topMargin)
                ,leading(toView: relatedView, constant: leftMargin)
                ,trailing(toView: relatedView, constant: rightMargin)
            ]
        )
        view.layoutIfNeeded()
    }
    func enableConstraints(){
        translatesAutoresizingMaskIntoConstraints = false
    }
}
