//
//  ActivityIndicator.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 22/5/22.
//

import Foundation
import UIKit

@objc open class ActivityIndicator: NSObject {
    var container: UIView = UIView()
    let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.color = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func showLoading(view: UIView?) {
        if let view = view {
            container.frame = view.frame
            container.center = view.center
            container.backgroundColor =  .clear
            view.addSubview(container)
            container.addSubview(loadingIndicator)
            NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor
                    .constraint(equalTo: container.centerXAnchor),
                loadingIndicator.centerYAnchor
                    .constraint(equalTo: container.centerYAnchor),
                loadingIndicator.widthAnchor
                    .constraint(equalToConstant: 50),
                loadingIndicator.heightAnchor
                    .constraint(equalTo: loadingIndicator.widthAnchor)
            ])
            loadingIndicator.startAnimating()
        }
        
    }
    
    @objc func hideLoading() {
        DispatchQueue.main.async { [self] in
            self.loadingIndicator.stopAnimating()
            container.removeFromSuperview()
        }
    }
}
