//
//  iosVideoScreen.swift
//  screen
//
//  Created by Nguyễn Anh Tú on 24/05/2022.
//

import UIKit
import AVFoundation

class iosVideoScreen: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var skipAheadButton: UIButton!
    @IBOutlet weak var skipBackButton: UIButton!
    
    @IBOutlet weak var homeButton: UIButton!
    
    var player: AVPlayer?
    
    // MARK: Actions
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        playPauseButton.isSelected = !playPauseButton.isSelected
        playPauseButton.isSelected ? player?.play() : player?.pause()
    }
    
    @IBAction func skipBackButtonPressed(_ sender: UIButton) {
        guard let duration = player?.currentItem?.duration else { return }
        let targetTime = max(.zero, player!.currentTime() - CMTime(seconds: 10, preferredTimescale: duration.timescale))
        player?.seek(to: targetTime)
    }
    
    @IBAction func skipAheadButtonPressed(_ sender: Any) {
        guard let duration = player?.currentItem?.duration else { return }
        let targetTime = min(duration, player!.currentTime() + CMTime(seconds: 10, preferredTimescale: duration.timescale))
        player?.seek(to: targetTime)
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
    }
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playPauseButton.isSelected = (player?.rate != 0)
        playVideo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    func playVideo() {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
    }

}

