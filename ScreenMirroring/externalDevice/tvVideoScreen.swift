//
//  tvVideoScreen.swift
//  screen
//
//  Created by Nguyễn Anh Tú on 24/05/2022.
//

import UIKit
import AVFoundation
import AVKit

class tvVideoScreen: UIViewController {
    
    var player: AVPlayer?
    
    init(player: AVPlayer) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, renamed: "init(product:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
    }

}
