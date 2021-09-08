//
//  ViewController.swift
//  Twilio
//
//  Created by Rohit Prajapati on 08/09/21.
//

import UIKit
import Photos
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadVideoLinkAndCreateAsset("https://mms.twiliocdn.com/AC5f9a8165db664c6a82325a2a550994a7/0685c8ad1b86205fa8dccd71765156c7?Expires=1631090890&Signature=KI4MPwaWp0xNJ8CezcCWEvURH9Paxw6mlp7qd-SN0KF0Pp8~KIfJshLZGyZzv8XSw1z2jBJTRjw-QYe8eTI4op47nbTKzPq-ztjtEKT6oFz2FuqnXpMuMlT56oaNfj92bYp6PbZy02~qd3wj2hYMKU3rQF63jOn01mLkdAGkRIJe7T1A9S2i3CCfmDY18-HZ6vRIlt0oUB6aY8dq7j7-AGS9OCfZfvWGs62RHCX5~T3fA76LlWqG9rHaOEsDbD5afD9W4ReO9KH6iTwIgBMu6oyg4AvFVeZUsLtxbPtPOAWBlbduiCEIN9lutfzwxJznIAlCuNdR6vibnObLS0GyPg__&Key-Pair-Id=APKAIRUDFXVKPONS3KUA")
    }
    
    func downloadVideoLinkAndCreateAsset(_ videoLink: String) {

        // use guard to make sure you have a valid url
        guard let videoURL = URL(string: videoLink) else { return }

        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        // check if the file already exist at the destination folder if you don't want to download it twice
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {

            // set up your download task
            URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in

                // use guard to unwrap your optional url
                guard let location = location else { return }

                // create a deatination url with the server response suggested file name
                let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)
                
                DispatchQueue.main.async {
                    self.encodeVideo(videoURL: destinationURL)
                }
                

                do {

                    try FileManager.default.moveItem(at: location, to: destinationURL)

                    PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in

                        // check if user authorized access photos for your app
                        if authorizationStatus == .authorized {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                    if completed {
                                        print("Video asset created")
                                    } else {
                                        print(error)
                                    }
                            }
                        }
                    })

                } catch { print(error) }

            }.resume()

        } else {
            print("File already exists at destination url")
        }
    }
    
    
    

    
    
    
    func encodeVideo(videoURL: URL){
        let avAsset = AVURLAsset(url: videoURL)
        let startDate = Date()
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocPath = NSURL(fileURLWithPath: docDir).appendingPathComponent("temp.mp4")?.absoluteString
        
        let docDir2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        let filePath = docDir2.appendingPathComponent("rendered-Video.mp4")
        deleteFile(filePath!)
        
        if FileManager.default.fileExists(atPath: myDocPath!){
            do{
                try FileManager.default.removeItem(atPath: myDocPath!)
            }catch let error{
                print(error)
            }
        }
        
        exportSession?.outputURL = filePath
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.shouldOptimizeForNetworkUse = true
        
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRange(start: start, duration: avAsset.duration)
        exportSession?.timeRange = range
        
        exportSession!.exportAsynchronously{() -> Void in
            switch exportSession!.status{
            case .failed:
                print("\(exportSession!.error!)")
            case .cancelled:
                print("Export cancelled")
            case .completed:
                let endDate = Date()
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful")
                print(exportSession?.outputURL ?? "")
            default:
                break
            }
            
        }
    }

    func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else{
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
}

