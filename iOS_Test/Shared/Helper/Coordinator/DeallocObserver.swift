//
//  DeallocObserver.swift
//  Maya
//
//  Created by Asraful Alam on 23/11/21.
//

import Foundation

/**
 * An instance of this class emits an event when it is deallocated
 */
final class DeallocObserver {

    private var callback: () -> Void

    /**
     * - parameter callback: The callback called when self is deallocated
     */
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    /**
    * Removes the current callback
    */
    func invalidate() {
        callback = {}
    }

    deinit {
        callback()
    }
}
