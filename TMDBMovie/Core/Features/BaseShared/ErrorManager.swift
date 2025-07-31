//
//  ErrorManager.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 25.05.2025.
//

import Foundation

class ErrorManager: ObservableObject {
    
    var currentError: String? = nil
    var showError: Bool = false
    
    private var hideTimer: Timer?
    
    func showError(_ message: String, autohide: Bool = true) {
        currentError = message
        showError = true
        
        if autohide {
            hideTimer?.invalidate()
            
            hideTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                self.hideError()
            }
        }
    }
    
    func hideError() {
        hideTimer?.invalidate()
        currentError = nil
        showError = false
    }
}
