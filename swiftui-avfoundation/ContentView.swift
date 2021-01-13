//
//  ContentView.swift
//  swiftui-avfoundation
//
//  Created by yorifuji on 2021/01/13.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    let videoCapture = VideoCapture()
    @State var image: UIImage? = nil
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            else {
                Spacer()
            }
            HStack {
                Button("run") {
                    videoCapture.run { sampleBuffer in
                        if let convertImage = UIImageFromSampleBuffer(sampleBuffer) {
                            DispatchQueue.main.async {
                                self.image = convertImage
                            }
                        }
                    }
                }
                Button("stop") {
                    videoCapture.stop()
                }
            }
            .font(.largeTitle)
        }
    }

    func UIImageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        guard let image = CIContext().createCGImage(ciImage, from: imageRect) else { return nil }
        return UIImage(cgImage: image)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
