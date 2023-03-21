//
//  UserPersonal.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import SwiftUI

struct PersonalInfo: View {
    @EnvironmentObject var model: REDAppModel
    var body: some View {
        RectangleOverlay {
            VStack {
                HStack {
                    Text("Class")
                    Spacer()
                    Text(model.personalProfile!.userClass)
                }
                HStack {
                    Text("Paranoia level:")
                    Spacer()
                    Text(model.personalProfile!.paranoiaText)
                }
                HStack {
                    Text("Donor:")
                    Spacer()
                    Text(model.personalProfile!.donor ? "Yes" : "No")
                }
                HStack {
                    Text("Warned:")
                    Spacer()
                    Text(model.personalProfile!.warned ? "Yes" : "No")
                }
            }
        }
    }
}
