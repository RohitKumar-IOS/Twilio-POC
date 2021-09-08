//
//  SampleCode.swift
//  Twilio
//
//  Created by Rohit Prajapati on 08/09/21.
//

import Foundation

/**
 //Download video Directly from the server
 
 let urlString = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
 DispatchQueue.global(qos: .background).async {
     if let url = URL(string: urlString),
         let urlData = NSData(contentsOf: url) {
         let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
         let filePath="\(documentsPath)/tempFile.mp4"
         DispatchQueue.main.async {
             urlData.write(toFile: filePath, atomically: true)
             PHPhotoLibrary.shared().performChanges({
                 PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
             }) { completed, error in
                 if completed {
                     print("Video is saved!")
                 }
             }
         }
     }
 }
 */

/**
 
 https://mms.twiliocdn.com/AC5f9a8165db664c6a82325a2a550994a7/0685c8ad1b86205fa8dccd71765156c7?Expires=1631090890&Signature=KI4MPwaWp0xNJ8CezcCWEvURH9Paxw6mlp7qd-SN0KF0Pp8~KIfJshLZGyZzv8XSw1z2jBJTRjw-QYe8eTI4op47nbTKzPq-ztjtEKT6oFz2FuqnXpMuMlT56oaNfj92bYp6PbZy02~qd3wj2hYMKU3rQF63jOn01mLkdAGkRIJe7T1A9S2i3CCfmDY18-HZ6vRIlt0oUB6aY8dq7j7-AGS9OCfZfvWGs62RHCX5~T3fA76LlWqG9rHaOEsDbD5afD9W4ReO9KH6iTwIgBMu6oyg4AvFVeZUsLtxbPtPOAWBlbduiCEIN9lutfzwxJznIAlCuNdR6vibnObLS0GyPg__&Key-Pair-Id=APKAIRUDFXVKPONS3KUA
 
 
 https://mms.twiliocdn.com/AC5f9a8165db664c6a82325a2a550994a7/6bd1194b3bd501d69a5f52ca9bb753c7?Expires=1631090889&Signature=Pr0qB8l7SvPUTbXbzytPiLVChns5bvbmDBnNL1js2E1WAY4nXJxZcwXDJHMPhM-BcmMt5DoOtuEpw7KWWzGJNlVpIbiFH7mt16-ti65XO72BQ7XBJCrwDr1vvprGcr8t5reiJSHNcMzjb~A9hHZI1~uxMul9f6Nc~rvnh8eEzMKOzWfDQKSl6dyFE9nfvOCcpYc7LmuBumYXJ0EJm5o6RuqziLwZmZRzK7I-MunHTwcqKvCS-WfNkqBr3KGrFVh~Fo72kKVmLWUYMiF8EusnE5238DkVSq75mu4mWV25-I08-fVdfHm9unRrLbYsryzR7Cno4kwRrJULjHFf118TfQ__&Key-Pair-Id=APKAIRUDFXVKPONS3KUA
 
 
 */



/**
 func _getDataFor(_ item: AVPlayerItem, completion: @escaping (Data?) -> ()) {
     guard item.asset.isExportable else {
         completion(nil)
         return
     }

     let composition = AVMutableComposition()
     let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
     let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))

     let sourceVideoTrack = item.asset.tracks(withMediaType: AVMediaType.video).first!
     let sourceAudioTrack = item.asset.tracks(withMediaType: AVMediaType.audio).first!
     do {
         try compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: item.duration), of: sourceVideoTrack, at: CMTime.zero)
         try compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: item.duration), of: sourceAudioTrack, at: CMTime.zero)
     } catch(_) {
         completion(nil)
         return
     }

     let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: composition)
     var preset: String = AVAssetExportPresetPassthrough
     if compatiblePresets.contains(AVAssetExportPreset1920x1080) { preset = AVAssetExportPreset1920x1080 }

     guard
         let exportSession = AVAssetExportSession(asset: composition, presetName: preset),
         exportSession.supportedFileTypes.contains(AVFileType.mp4) else {
         completion(nil)
         return
     }

     var tempFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("temp_video_data.mp4", isDirectory: false)
     tempFileUrl = URL(fileURLWithPath: tempFileUrl.path)

     exportSession.outputURL = tempFileUrl
     exportSession.outputFileType = AVFileType.mp4
     let startTime = CMTimeMake(value: 0, timescale: 1)
     let timeRange = CMTimeRangeMake(start: startTime, duration: item.duration)
     exportSession.timeRange = timeRange

     exportSession.exportAsynchronously {
         print("\(tempFileUrl)")
         print("\(exportSession.error)")
         let data = try? Data(contentsOf: tempFileUrl)
         _ = try? FileManager.default.removeItem(at: tempFileUrl)
         completion(data)
     }
 }

 
 */

/**
 
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
 
 */




/**
 
 Download the file from url
 
 extension URL {
     func download(to directory: FileManager.SearchPathDirectory, using fileName: String? = nil, overwrite: Bool = false, completion: @escaping (URL?, Error?) -> Void) throws {
         let directory = try FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: true)
         let destination: URL
         if let fileName = fileName {
             destination = directory
                 .appendingPathComponent(fileName)
                 .appendingPathExtension(self.pathExtension)
         } else {
             destination = directory
             .appendingPathComponent(lastPathComponent)
         }
         if !overwrite, FileManager.default.fileExists(atPath: destination.path) {
             completion(destination, nil)
             return
         }
         URLSession.shared.downloadTask(with: self) { location, _, error in
             guard let location = location else {
                 completion(nil, error)
                 return
             }
             do {
                 if overwrite, FileManager.default.fileExists(atPath: destination.path) {
                     try FileManager.default.removeItem(at: destination)
                 }
                 try FileManager.default.moveItem(at: location, to: destination)
                 completion(destination, nil)
             } catch {
                 print(error)
             }
         }.resume()
     }

 
 
 
 let alarm = URL(string: "urlstring here")!
 do {
     try alarm.download(to: .documentDirectory) { url, error in
         guard let url = url else { return }
         print("final url", url)
         
     }
 } catch {
     print(error)
 }
 
 
 */


/**
 
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

 
 */

/**
 Alamofire
 
 let destination: DownloadRequest.Destination = { _, _ in
     let documentsURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
         let fileURL = documentsURL.appendingPathComponent("movie.mp4")
         return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
 }

 AF.download(url, to: destination).response { response in
     debugPrint(response)
     if response.error == nil, let path = response.fileURL?.path {
         print(path)
     }
 }
 
 */
