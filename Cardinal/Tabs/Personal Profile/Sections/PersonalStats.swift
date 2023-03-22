//
//  UserStats.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import SwiftUI
import GazelleKit

struct PersonalStats: View {
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
                    if model.personalProfile!.calcRatio < model.personalProfile!.requiredRatio! {
                        Text(String(format: "%.2f", model.personalProfile!.calcRatio))
                            .foregroundColor(.red)
                            .bold()
                    } else {
                        Text(String(format: "%.2f", model.personalProfile!.calcRatio))
                    }
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

func pow(_ x: Int, _ y: Int) -> Int {
    return Int(pow(Double(x), Double(y)))
}

extension UserProfile {
    public var calcRatio: Float {
        let ret = Float(uploaded ?? 0) / Float(downloaded ?? 0)
        return floorf(ret * 100.0) / 100.0
    }
}
