//
//  ViewController.swift
//  Twilio
//
//  Created by Rohit Prajapati on 08/09/21.
//

import UIKit
import Photos
import AVKit
import Alamofire

class ViewController: UIViewController {
    
    let url = "https://mms.twiliocdn.com/AC5f9a8165db664c6a82325a2a550994a7/6bd1194b3bd501d69a5f52ca9bb753c7?Expires=1631128455&Signature=O9DWwZTXsMKgZQkrNM3GsXog7YmEX3r9BFUBKDT2M7qlwu63ZiSg6F0kd5Vgy3x2FeMJrRYWVskbE9slbv0Iqjs7TE~HTkTQkMMBdY7e2gSLUFwCpVeCXuNSotCphzzBpGOdrRo3MV8RnnBKP7CexMLIPhSeBSDpPPPCcIxc9k6w-8PgPOASzVblxgGMsh8lT9SH1MTcgtaXN0kTfOOmwfSawCgGkZKuX1~cv~cvHHE59LnTK2hgQ0CEBE4ViEXNYSZxTwPmL3qRxGIBUMWsM1~qCzghciImL8Py9GQGzyLqeQ6Px0ogAIWNVjVtDB7cXBJi0t4Cmk7QkDDHT2MkdQ__&Key-Pair-Id=APKAIRUDFXVKPONS3KUA"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        downloadVideoLinkAndCreateAsset(url)
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

}



