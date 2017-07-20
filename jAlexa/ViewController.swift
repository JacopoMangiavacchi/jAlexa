//
//  ViewController.swift
//  jAlexa
//
//  Created by Jacopo Mangiavacchi on 7/16/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import WatchConnectivity
import AVFoundation
import MessageUI


class ViewController: UIViewController, WCSessionDelegate, MFMailComposeViewControllerDelegate {
    var player: AVAudioPlayer?

    private let session : WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        session?.delegate = self
        session?.activate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func session(_ session: WCSession, didReceive file: WCSessionFile) {

        print("File received : \(file.fileURL)")
        //sendEmail(file: file.fileURL)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: file.fileURL)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }

    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sendEmail(file: URL) {
        if( MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject("watchOS captured audio")
            mailComposer.setMessageBody("This is what they sound like.", isHTML: false)
            
            do {
                let fileData = try Data(contentsOf: file)
                mailComposer.addAttachmentData(fileData, mimeType: "audio/aac", fileName: "audio")
                self.present(mailComposer, animated: true, completion: nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

