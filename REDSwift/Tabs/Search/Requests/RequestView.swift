//
//  RequestView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct RequestView: View {
    @State var request: Request
    @State var requestSize: Int
    init(_ request: Request, requestSize: Int) {
        self._request = State(initialValue: request)
        self._requestSize = State(initialValue: requestSize)
    }
    var body: some View {
        List {
            Group {
                SectionTitle("Title") {
                    HStack {
                        Text(request.title)
                        Spacer()
                    }
                }
                SectionTitle("Bounty") {
                    HStack {
                        Text(request.bounty.toRelevantDataUnit())
                        Spacer()
                    }
                }
                SectionTitle("Vote Count") {
                    HStack {
                        Text(String(request.voteCount))
                        Spacer()
                    }
                }
                SectionTitle("Requested By") {
                    HStack {
                        Text(request.requestorName)
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                SectionTitle(request.artists.count == 1 ? "Artist" : "Artists") {
                    EmptyView()
                }
                SectionTitle("Year") {
                    HStack {
                        Text(String(request.year))
                        Spacer()
                    }
                }
                SectionTitle("Request Created") {
                    HStack {
                        Text(request.timeAdded.timeAgo)
                        Spacer()
                    }
                }
                SectionTitle("Filled?") {
                    HStack {
                        Text(request.isFilled ? "Yes" : "No")
                        Spacer()
                    }
                }
                if request.isFilled {
                    SectionTitle("Fill Completed") {
                        HStack {
                            Text(request.timeFilled!.timeAgo)
                            Spacer()
                        }
                    }
                    SectionTitle("Filled By") {
                        HStack {
                            Text(request.fillerName)
                            Spacer()
                        }
                    }
                }
            }
            Group {
                SectionTitle("Allowed Bit Depths/Bitrates") {
                    VStack {
                        ForEach(request.bitrateList) { bitrate in
                            HStack {
                                Text(bitrate)
                                Spacer()
                            }
                        }
                    }
                }
                SectionTitle("Allowed Formats") {
                    VStack {
                        ForEach(request.formatList) { format in
                            HStack {
                                Text(format)
                                Spacer()
                            }
                        }
                    }
                }
                SectionTitle("Allowed Media") {
                    VStack {
                        ForEach(request.mediaList) { media in
                            HStack {
                                Text(media)
                                Spacer()
                            }
                        }
                    }
                }
                SectionTitle("Description") {
                    HStack {
                        Text(request.description)
                        Spacer()
                    }
                }
            }
        }
    }
}
