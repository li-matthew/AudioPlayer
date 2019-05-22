//
//  ViewController.swift
//  eq
//
//  Created by Matthew Li on 5/22/19.
//  Copyright © 2019 Matthew Li. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var timer = Timer()
    var songs:[String] = []
    var currentSong = 0
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var sliderBar: UISlider!
//    @IBOutlet weak var progressBar: UIProgressView!
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func sliderBar(_ sender: UISlider) {
//        print(TimeInterval(sliderBar.value * Float(audioPlayer.duration)))
        audioPlayer.currentTime = TimeInterval(sliderBar.value * Float(audioPlayer.duration))
    }
    
    @IBAction func playButton(_ sender: UIButton) {

        audioPlayer.prepareToPlay()
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            timer.invalidate()
            sender.setTitle("Play", for: .normal)
        }
        else {
            audioPlayer.play()
            sender.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.fire), userInfo: nil, repeats: true)
        }

        
    }
    
    @IBAction func nextSong(_ sender: UIButton) {
        if currentSong + 1 < songs.capacity {
            currentSong = currentSong + 1
        }
        else {
            currentSong = 0
        }
        let sound = Bundle.main.path(forResource: songs[currentSong], ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            songTitle.text = songs[currentSong]
            playButton.setTitle("Play", for: .normal)
        }
        catch {
            print("error")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSongs()
        // Do any additional setup after loading the view.
        let sound = Bundle.main.path(forResource: songs[currentSong], ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            songTitle.text = songs[currentSong]
        }
        catch {
            print("error")
        }
        
    }
    @objc func fire()
    {
        let totaltime = audioPlayer.duration
//        print(audioPlayer.currentTime)
//        progressBar.progress = Float(audioPlayer.currentTime/totaltime)
        sliderBar.value = Float(audioPlayer.currentTime/totaltime)
    }

    func getSongs() {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for song in songPath {
                var mySong = song.absoluteString
                if mySong.contains(".mp3") {
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count - 1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)
                }
            }
        }
        catch {
            print("error")
        }
    }
}

