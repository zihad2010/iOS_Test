//
//  NativeNavigator.swift
//  Maya
//
//  Created by Md. Asraful Alam on 23/11/21.
//

import Foundation

public protocol NativeNavigator: AnyObject {}

private enum ContextAssociatedKeys {
    fileprivate static var deallocObserver: UInt8 = 0
}

extension NativeNavigator where Self: NSObject {

    private var deallocObserver: DeallocObserver? {
        get {
            return objc_getAssociatedObject(
                self,
                &(ContextAssociatedKeys.deallocObserver)
            ) as? DeallocObserver
        }
        set {
            guard deallocObserver == nil || newValue == nil else {
                preconditionFailure("DeallocObserver is already set")
            }
            objc_setAssociatedObject(
                self,
                &(ContextAssociatedKeys.deallocObserver),
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /**
     * Associates an observer to the deallocation of self
     * - parameter callback: The callback triggered when self is deallocated
     */
    func registerCallbackForDealloc(_ callback: @escaping () -> Void) {
        deallocObserver = DeallocObserver(callback: callback)
    }

    /**
    * Removes the current deallocation observer
    */
    func removeCallbackForDealloc() {
        deallocObserver?.invalidate()
        deallocObserver = nil
    }
}

