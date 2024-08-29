//
//  CustomSV.swift
//  server
//
//  Created by Alex on 02/03/2022.
//

import FCFileManager
import Foundation
import GCDWebServer
import SwiftNotificationCenter
import SwifterSwift

struct Configs {
    struct Folder {
        static let files = "files"
        static let sharefolder = "sharefolder"
    }
    
}

protocol WebServerManagerDelegate {
    func webserverDidUploadItem()
}

class WebServerUtil: NSObject, InterfaceWebServerUtil {

    // Singleton
    static let shared = WebServerUtil()
    
    // Properties
    private var webServer: GCDWebServer?
    private var webSerVer2: GCDWebUploader?
    private(set) var controller: UIViewController?
    
    private(set) var imagePickedBlock: ((String) -> Void)?
    private(set) var videoPickedBlock: ((String) -> Void)?
    
    func getImagePath(path: String) -> String {
        guard let host = webServer?.serverURL?.absoluteString else { fatalError("WebServer đang không chạy, hãy gọi hàm startServer trước") }
        let path = host + path
        print("Path: \(path)")
//        return path.urlWebSereverUtilEncoded!
        return path
    }
    
    func getVideoPath(path: String) -> String {
        guard let host = webServer?.serverURL?.absoluteString else { fatalError("WebServer đang không chạy, hãy gọi hàm startServer trước") }
        let path = host + path
        print("Path: \(path)")
//        return path.urlWebSereverUtilEncoded!
        return path
    }

    
    func stopServer() {
        webServer?.stop()
    }
    
    func pickImage(controller _: UIViewController?) {}
    
    func pickImage(controller: UIViewController?, complete: @escaping (String) -> Void) {
        self.controller = controller
        self.imagePickedBlock = complete
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false // If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        controller?.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func startCastServer() {
        do {
            let uploadDirectory = try getDocumentDir()
            print("Upload Dir: \(uploadDirectory)")
            webServer = GCDWebUploader(uploadDirectory: uploadDirectory)
            
            webServer?.delegate = self
            
            webServer?.addGETHandler(forBasePath: "/", directoryPath: uploadDirectory, indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
                        
            webServer?.start()
            
        } catch let e {
            print(e as! WebServerUtilError)
        }
    }
    
    func startRecevieServer() {
        FCFileManager.createDirectories(forPath: Configs.Folder.sharefolder)
        
        let documentsPath = FCFileManager.urlForItem(atPath: Configs.Folder.sharefolder)?.path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        // Server
        webSerVer2 = GCDWebUploader(uploadDirectory: documentsPath)
        webSerVer2?.delegate = self
        webSerVer2?.allowHiddenItems = true
        webSerVer2?.start()
    }
    
    func stopReceiveSever() {
        webSerVer2?.stop()
    }
    
    func pickVideo(controller: UIViewController?, complete: @escaping (String) -> Void) {
        self.controller = controller
        self.videoPickedBlock = complete
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = true
        controller?.present(picker, animated: true, completion: nil)
    }
}

extension WebServerUtil: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        // Kiểm tra xem info có nội dung là image không?
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            do {
                let fileName = try write(imagePicked: tempImage)
                imagePickedBlock?(getImagePath(path: fileName))
                controller?.dismiss(animated: true, completion: nil)
            } catch let e {
                print(e)
            }
        }
        
        // Kiểm tra xem info có nội dung là video không?
        if let tempVideoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            do {
                let fileName = try write(videoPicked: tempVideoURL)
                print("\(fileName)")
                videoPickedBlock?(getVideoPath(path: fileName))
                controller?.dismiss(animated: true, completion: nil)
            } catch(let e) {
                print(e)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        controller?.dismiss(animated: true, completion: nil)
    }
}

// MARK: GCDWebUploaderDelegate

extension WebServerUtil: GCDWebUploaderDelegate {
    func webServerDidStart(_ server: GCDWebServer) {
        print("[START] \(server.serverURL?.absoluteString)")
    }
    
    func webUploader(_: GCDWebUploader, didUploadFileAtPath path: String) {
        print("[UPLOAD] \(path)")
        let atPath = Configs.Folder.sharefolder + "/" + path.lastPathComponent
        let toPath = Configs.Folder.files + "/" + path.lastPathComponent
        let status = FCFileManager.moveItem(atPath: atPath, toPath: toPath)
//        log.debug("Move item: \(status)")
        Broadcaster.notify(WebServerManagerDelegate.self, block: {$0.webserverDidUploadItem()})
    }
    
    func webUploader(_: GCDWebUploader, didDownloadFileAtPath path: String) {
        print("[DOWNLOAD] \(path)")
    }
    
    func webUploader(_: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        print("[MOVE] \(fromPath) -> \(toPath)")
    }
    
    func webUploader(_: GCDWebUploader, didCreateDirectoryAtPath path: String) {
        print("[CREATE] \(path)")
    }
    
    func webUploader(_: GCDWebUploader, didDeleteItemAtPath path: String) {
        print("[DELETE] \(path)")
    }
}
