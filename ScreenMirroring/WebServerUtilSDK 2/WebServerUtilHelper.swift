//
//  WebServerUtilHelper.swift
//  server
//
//  Created by Alex on 02/03/2022.
//

import Foundation
import UIKit
import FCFileManager

extension WebServerUtil {
    func getDocumentDir() throws -> String {
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            throw WebServerUtilError.notFound
        }
        return dir
    }
    
    func write(imagePicked image: UIImage) throws -> String {
        clearCache()
        let fileName = UUID().uuidString + ".png"
        guard let imagePath = FCFileManager.urlForItem(atPath: fileName) else {
            throw WebServerUtilError.invalidPath
        }
        do {
            guard let imageData = image.pngData() else { throw WebServerUtilError.pngError }
            try imageData.write(to: imagePath)
        } catch( _) {
            throw WebServerUtilError.notWriteToFile
        }
        return fileName
    }
    
    func write(videoPicked video: URL) throws -> String {
        clearCache()
        let fileName = UUID().uuidString + ".MOV"
        let temp = FCFileManager.pathForTemporaryDirectory() + UUID().uuidString  + ".MOV"
        let tempURL = URL.init(fileURLWithPath: temp)
        
        do {
            try FileManager().copyItem(at: video.absoluteURL, to: tempURL)
        } catch {
            print("There was an error copying the video file to the temporary location.")
        }
        
        FCFileManager.copyItem(atPath: tempURL.path, toPath: fileName)
        
        return fileName
    }
    
    func clearCache() {
        FCFileManager.removeFilesInDirectory(atPath: "/")
    }
    
}

// Encode
extension String {
    var urlWebSereverUtilEncoded: String? {
        var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, .")
        return self.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
    }
}
