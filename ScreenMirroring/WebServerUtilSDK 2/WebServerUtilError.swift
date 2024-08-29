//
//  WebServerUtilError.swift
//  server
//
//  Created by Alex on 02/03/2022.
//

import Foundation
 

enum WebServerUtilError: Error {
    case notFound
    case notEnoughStorageSpace
    case pngError
    case notWriteToFile
    case invalidPath
}
