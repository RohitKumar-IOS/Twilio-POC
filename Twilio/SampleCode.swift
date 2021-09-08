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
