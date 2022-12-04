//
//  UserStats.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import SwiftUI

struct UserStats: View {
    @EnvironmentObject var model: REDAppModel
    let formatter = DateFormatter()
    init() {
        formatter.dateStyle = .short
    }
    var body: some View {
        RectangleOverlay {
            VStack {
                HStack {
                    Text("Joined:")
                    Spacer()
                    Text(formatter.string(from: model.personalProfile!.joinedDate))
                }
                HStack {
                    Text("Last seen:")
                    Spacer()
                    Text(formatter.string(from: model.personalProfile!.lastSeen!))
                }
                HStack {
                    Text("Uploaded:")
                    Spacer()
                    Text(model.personalProfile!.uploaded!.toRelevantDataUnit())
                }
                HStack {
                    Text("Downloaded:")
                    Spacer()
                    Text(model.personalProfile!.downloaded!.toRelevantDataUnit())
                }
                HStack {
                    Text("Ratio:")
                    Spacer()
                    Text(String(format: "%.2f", model.personalProfile!.ratio! - 0.01)) // for some reason the API rounds up, and the RED UI rounds down
                }
                HStack {
                    Text("Required Ratio:")
                    Spacer()
                    Text(String(format: "%.2f", model.personalProfile!.requiredRatio!))
                }
            }
        }
    }
}

extension Int {
    func toRelevantDataUnit() -> String {
        if self < 1024 {
            return "\(self) B"
        } else if self < pow(1024, 2) {
            return "\(String(format: "%.2f", Float(self) / 1024)) KiB"
        } else if self < pow(1024, 3) {
            return "\(String(format: "%.2f", Float(self) / pow(1024, 2))) MiB"
        } else if self < pow(1024, 4) {
            return "\(String(format: "%.2f", Float(self) / pow(1024, 3))) GiB"
        } else if self < pow(1024, 5) {
            return "\(String(format: "%.2f", Float(self) / pow(1024, 4))) TiB"
        } else {
            return "\(String(format: "%.2f", Float(self) / pow(1024, 5))) PiB"
        }
    }
}

extension Float {
    
}

func pow(_ x: Int, _ y: Int) -> Int {
    return Int(pow(Double(x), Double(y)))
}
