//
//  ViewController.swift
//  screen
//
//  Created by Nguyễn Anh Tú on 18/05/2022.
//

import UIKit
import AVKit
import AVFoundation
import FCFileManager

class ViewController: UIViewController {
    
    var additionalWindows = [UIWindow]()
    
    private(set) var controller: UIViewController?
    
    var airplay = UIView()
    
    private lazy var routePickerView: AVRoutePickerView = {
        let routePickerView = AVRoutePickerView(frame: .zero)
        routePickerView.isHidden = true
        view.addSubview(routePickerView)
        return routePickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebServerUtil.shared.startCastServer()
        
        setupAirplayButton()
        let airplayButton = UIBarButtonItem(customView: airplay)
        self.navigationItem.rightBarButtonItems = [airplayButton]
        
        NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) { (notification) in
            print("debug: connected")
            
            // Get the new screen information.
            let newScreen = notification.object as! UIScreen
            let screenDimensions = newScreen.bounds
                    
            // Configure a window for the screen.
            let newWindow = UIWindow(frame: screenDimensions)
            newWindow.screen = newScreen
            
            // Install a custom root view controller in the window.
            newWindow.rootViewController = UIViewController()
                    
            // You must show the window explicitly.
            newWindow.isHidden = false
            
            // Save a reference to the window in a local array.
            self.additionalWindows.append(newWindow)
        }
        
        NotificationCenter.default.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil) { (notification) in
            print("debug: disconnected")
            
            let screen = notification.object as! UIScreen

            // Remove the window associated with the screen.
            for window in self.additionalWindows {
                if window.screen == screen {
                    // Remove the window and its contents.
                    let index = self.additionalWindows.firstIndex(of: window)
                    self.additionalWindows.remove(at: index!)
                }
            }
        }
    }
    
    private func setupAirplayButton() {
        airplay.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        // Add a Picker
        let routePickerView = AVRoutePickerView(frame: buttonView.bounds)
        routePickerView.delegate = self
        routePickerView.tintColor = .black
        routePickerView.activeTintColor = .green
        // Prioritize Video Devices
        routePickerView.prioritizesVideoDevices = true
        
        buttonView.addSubview(routePickerView)
        self.airplay.addSubview(buttonView)
    }
    
    @IBAction func debugAction(_ sender: Any) {
        pickImage(controller: self)
    }
    
    @IBAction func debugAction2(_ sender: Any) {
        let imageList = [
            "https://picsum.photos/id/0/5616/3744",
            "https://picsum.photos/id/1/5616/3744",
            "https://picsum.photos/id/10/2500/1667",
            "https://picsum.photos/id/100/2500/1656",
            "https://picsum.photos/id/1000/5626/3635",
            "https://picsum.photos/id/1001/5616/3744",
            "https://picsum.photos/id/1002/4312/2868",
            "https://picsum.photos/id/1003/1181/1772",
            "https://picsum.photos/id/1004/5616/3744",
            "https://picsum.photos/id/1005/5760/3840",
            "https://picsum.photos/id/1006/3000/2000"
        ]
        let randomString = imageList.randomElement()!
        let onlineImageURL = URL(string: randomString)!
        if UIScreen.screens.count > 1 {
            let window = additionalWindows.last!
            window.rootViewController = tvImageScreen(nibName: "tvImageScreen", imageURL: onlineImageURL)
            window.makeKeyAndVisible()
            window.isHidden = false
        }
    }
    
    @IBAction func debugAction3(_ sender: Any) {
        pickVideo(controller: self)
    }
    
    @IBAction func debugAction4(_ sender: Any) {
        let videoList = [
            "https://abcnewsvod-f.akamaihd.net/i/abcnews/2022/05/220523_gma3_ukraine_109_,500,800,1200,1800,2500,3200,4500,.mp4.csmil/master.m3u8?b=500-4500",
            "https://abcnewsvod-f.akamaihd.net/i/abcnews/2022/05/220523_abcnl_update_1p_sutton_,500,800,1200,1800,2500,3200,4500,.mp4.csmil/master.m3u8?b=500-4500",
            "https://abcnewsvod-f.akamaihd.net/i/abcnews/2022/05/220523_abcnl_update_11a_clennett_shepherd_,500,800,1200,1800,2500,3200,4500,.mp4.csmil/master.m3u8?b=500-4500",
            "https://abcnewsvod-f.akamaihd.net/i/abcnews/2022/05/220523_abcnl_update_11a_thomas_,500,800,1200,1800,2500,3200,4500,.mp4.csmil/master.m3u8?b=500-4500",
            "https://abcnewsvod-f.akamaihd.net/i/abcnews/2022/05/220523_abcnl_update_11a_burridge_,500,800,1200,1800,2500,3200,4500,.mp4.csmil/master.m3u8?b=500-4500",
            "https://abcnewsvod-f.akamaihd.net/i/abcnews/2022/05/220523_abcnl_update_10a_burridge_,500,800,1200,1800,2500,3200,4500,.mp4.csmil/master.m3u8?b=500-4500"
        ]
        let randomString = videoList.randomElement()!
        let videoURL = URL(string: randomString)!
        castVideo(videoURL: videoURL)
    }
    
    @IBAction func debugAction5(_ sender: Any) {
        if UIScreen.screens.count == 1 {
            print("debug: Please turn on screen mirroring in control center following our tutorial!")
        } else {
            let window = additionalWindows.last!
            if window.isHidden == false {
                window.isHidden = true
            }
        }
    }
    @IBAction func showAirPlay(_ sender: Any) {
        let routePickerView = AVRoutePickerView()
        view.addSubview(routePickerView)
    }
}

extension ViewController: AVRoutePickerViewDelegate {
    func routePickerViewWillBeginPresentingRoutes(_: AVRoutePickerView) {
        // Tells the delegate that the route picker view will present routes to the user.
        print("the route picker view will present routes to the user")
    }
    
    func routePickerViewDidEndPresentingRoutes(_: AVRoutePickerView) {
        // Tells the delegate that the route picker view finished presenting routes to the user.
        print("the route picker view finished presenting routes to the user")
    }

}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func pickImage(controller: UIViewController) {
        self.controller = controller
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false // If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        controller.present(imagePickerController, animated: true, completion: nil)
    }
    
    func pickVideo(controller: UIViewController) {
        self.controller = controller
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        controller.present(picker, animated: true, completion: nil)
    }
    
    func clearCache() {
        FCFileManager.removeFilesInDirectory(atPath: "/")
    }
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        clearCache()
           
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if UIScreen.screens.count > 1 {
                let window = additionalWindows.last!
                window.rootViewController = tvImageScreen(nibName: "tvImageScreen", uiImage: tempImage)
                window.makeKeyAndVisible()
                window.isHidden = false
            }
        }
       
        if let tempVideoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print("video path: ", tempVideoURL)
            
            // Convert to m3u8
            let ffmpeg = FFmpeg()
            let hlsPath = ffmpeg.convertFile(tempVideoURL.absoluteString)
            print("hls output: \(hlsPath)")
            
            let streamURL = WebServerUtil.shared.getVideoPath(path: hlsPath.lastPathComponent)
            print("stream url: \(streamURL)")
            
            controller?.dismiss(animated: true, completion: nil)
            
            if hlsPath != "" {
                castVideo(videoURL: URL(string: streamURL)!)
            }
        }
   }
       
   func imagePickerControllerDidCancel(_: UIImagePickerController) {
       controller?.dismiss(animated: true, completion: nil)
   }
}

extension ViewController {
    func castVideo(videoURL: URL) {
        
        AVAudioSession.sharedInstance().prepareRouteSelectionForPlayback(completionHandler: { (shouldStartPlayback, routeSelection) in
            if shouldStartPlayback {
                switch routeSelection {
                case .local, .external:
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
                    } catch {
                        print("Error setting audio session category and mode: \(error)")
                    }
                    let player = AVPlayer(url: videoURL)
                    let remoteControlVC = iosVideoScreen(nibName: "iosVideoScreen", bundle: nil)
                    remoteControlVC.player = player
                    remoteControlVC.modalPresentationStyle = .fullScreen
                    self.present(remoteControlVC, animated: true, completion: nil)
                    player.play()
                    
                    if UIScreen.screens.count > 1 {
                        let window = self.additionalWindows.last!
                        if window.isHidden == true {
                            window.isHidden = false
                        }
                        
                        window.rootViewController = tvVideoScreen(player: player)
                        window.makeKeyAndVisible()
                    }
                    
                case .none:
                    fallthrough
                @unknown default:
                    print("Cancelling playback")
                }
            } else {
                print("Cancelling playback")
            }
        })
    }
    
    
}

