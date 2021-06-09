//
//  UIViewExtensions.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import UIKit

// This is experimental extension do not use it except if you know what you are doing. 
extension UIView {
    private class UIViewTapStore {
        var callback:UIViewTapGestureCallBack?
    }
    
    typealias UIViewTapGestureCallBack = () -> Void
    private static let tapStoreAssociation = ObjectAssociation<UIViewTapStore>()
    private var tapStore: UIViewTapStore! {
        get { return UIView.tapStoreAssociation[self] }
        set { UIView.tapStoreAssociation[self] = newValue }
    }
    
    ///This is a experimental class to add tap gesture to UIView using blocks instead of objc selectors
    ///
    ///Experimental extension
    ///
    ///**Issues Found**
    ///1. When adding this gesture to tableview controller, the gesture is being saved multiple times it should be because closure is being stored in static variable in UIVIew class
    ///2. When adding gesture to parent view, children's gesture won't work.
    ///
    func addTapGestureCallback(_ callback:@escaping UIViewTapGestureCallBack) {
        tapStore = UIViewTapStore()
        tapStore.callback = callback
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        tapStore.callback?()
    }
}

//MARK:- Add Subview
extension UIView {
    func addSubview (
        _ subview: UIView,
        constrainedTo anchorsView: UIView
    ) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: anchorsView.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: anchorsView.centerYAnchor),
            subview.widthAnchor.constraint(equalTo: anchorsView.widthAnchor),
            subview.heightAnchor.constraint(equalTo: anchorsView.heightAnchor)
        ])
    }
    
    func addSubviewAtCenterWithFixedDimension(_ subview:UIView,
                                              width:CGFloat,
                                              height:CGFloat) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func addSubviewAtCenter(_ subview:UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


