//
//  UserInfo.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI
import GazelleKit

struct UserInfo: View {
    @State var profile: UserProfile
    init(_ profile: UserProfile) {
        self._profile = State(initialValue: profile)
    }
    var body: some View {
        RectangleOverlay {
            VStack {
                HStack {
                    Text("Class")
                    Spacer()
                    Text(profile.userClass)
                }
                HStack {
                    Text("Paranoia level:")
                    Spacer()
                    Text(profile.paranoiaText)
                }
                HStack {
                    Text("Donor:")
                    Spacer()
                    Text(profile.donor ? "Yes" : "No")
                }
                HStack {
                    Text("Warned:")
                    Spacer()
                    Text(profile.warned ? "Yes" : "No")
                }
            }
        }
    }
}
