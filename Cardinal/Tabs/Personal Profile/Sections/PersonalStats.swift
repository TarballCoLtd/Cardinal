//
//  UserStats.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import SwiftUI
import GazelleKit

struct PersonalStats: View {
    @AppStorage("tracker") var tracker: GazelleTracker = .redacted
    @EnvironmentObject var model: CardinalModel
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
                    if let ratio = model.personalProfile?.calcRatio {
                        if ratio < model.personalProfile!.requiredRatio! {
                            Text(String(format: "%.2f", ratio))
                                .foregroundColor(.red)
                                .bold()
                        } else {
                            Text(String(format: "%.2f", ratio))
                        }
                    }
                }
                if let requiredRatio = model.personalProfile!.requiredRatio, tracker != .orpheus {
                    HStack {
                        Text("Required Ratio:")
                        Spacer()
                        Text(String(format: "%.2f", requiredRatio))
                    }
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

func pow(_ x: Int, _ y: Int) -> Int {
    return Int(pow(Double(x), Double(y)))
}

extension UserProfile {
    public var calcRatio: Float? {
        guard let uploaded = uploaded else { return nil }
        guard let downloaded = downloaded else { return nil }
        let ret = Float(uploaded) / Float(downloaded)
        return floorf(ret * 100.0) / 100.0
    }
}
