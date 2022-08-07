//
//  Created by Suman Ghosh on 06/08/22.
//

import Foundation

struct APOD: Codable {
    let date: String
    let title: String
    let explanation: String
    let mediaType: String
    let url: String
    let hdurl: String
}

extension APOD {
    
    init(from response: APODResponse) {
        self.init(date: response.date,
                  title: response.title,
                  explanation: response.explanation,
                  mediaType: response.mediaType,
                  url: response.url,
                  hdurl: response.hdurl)
    }
}

extension APOD {
    
   static func mockAPOD() -> APOD {
        return APOD(date: "2022-08-06",
             title: "Stereo Phobos",
             explanation: "Get out your red/blue glasses and float next to Phobos, grooved moon of Mars! Captured in 2004 by the High Resolution Stereo Camera on board ESA's Mars Express spacecraft, the image data was recorded at a distance of about 200 kilometers from the martian moon. This tantalizing stereo anaglyph view shows the Mars-facing side of Phobos. It highlights the asteroid-like moon's cratered and grooved surface. Up to hundreds of meters wide, the mysterious grooves may be related to the impact that created Stickney crater, the large crater at the left. Stickney crater is about 10 kilometers across, while Phobos itself is only around 27 kilometers across at its widest point.",
             mediaType: "image",
             url: "https://apod.nasa.gov/apod/image/2208/Phobos_stereoME_1024c.jpg",
             hdurl: "https://apod.nasa.gov/apod/image/2208/Phobos_stereoME_full.jpg")
    }
}

