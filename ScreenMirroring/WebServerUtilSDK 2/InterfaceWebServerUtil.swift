//
//  InterfaceWebServerUtil.swift
//  server
//
//  Created by Alex on 02/03/2022.
//

import Foundation
import UIKit

// Giao diện dung của WebServerUtil
protocol InterfaceWebServerUtil {
    
    // Hàm khởi chạy Cast Tivi GCGWebServer
    func startCastServer()
    
    // Khoi chay down load file server
    
    func startRecevieServer()
    
    // Hàm dừng Cast GCGWebServer
    func stopServer()
    
    // Hàm dùng recive GCDWebServer
    
    func stopReceiveSever()
    
    // Hàm lấy nội dung video từ UIImagePickerController
    func pickVideo(controller: UIViewController?, complete: @escaping (String) -> Void)
    
    // Hàm lấy nội dung ảnh từ UIImagePickerController
    func pickImage(controller: UIViewController?, complete: @escaping (String) -> Void)
    
    
}
