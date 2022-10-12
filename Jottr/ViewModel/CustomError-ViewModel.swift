//
//  CustomError-ViewModel.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/12/22.
//

import Foundation

// MARK: Custom Errors
enum CustomError: Error {
    case failCodableResponse, dataTooLong
    
    func stringValue() -> String {
        switch self {
        case .failCodableResponse:
            return "We have trouble submitting your work. Contact client support, notify them of a parameter encoding error."
        case .dataTooLong:
            return "its too long"
        }
    }
}

