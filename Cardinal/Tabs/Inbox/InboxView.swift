//
//  InboxView.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import SwiftUI
import GazelleKit

struct InboxView: View {
    @EnvironmentObject var model: CardinalModel
    @State var fetchingPage: Bool = false
    @State var fetchingPageOnAppear: Bool = true
    @State var erroredOut: Bool = false
    var body: some View {
        if model.inbox != nil {
            NavigationView {
                List {
                    ForEach(model.inbox!.conversations) { conversation in
                        NavigationLink {
                            ConversationView(conversation.conversationId)
                        } label: {
                            ConversationPreview(conversation)
                        }
                    }
                }
                .navigationTitle("Inbox")
                .refreshable {
                    do {
                        let currentPage = model.inbox!.currentPage
                        model.inbox = try await model.api!.requestInbox(page: currentPage, type: .inbox)
                    } catch {
                        #if DEBUG
                        print(error)
                        #endif
                        if error is GazelleAPIError {
                            erroredOut = true
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            if fetchingPage {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else if let inbox = model.inbox {
                                if inbox.currentPage > 1 {
                                    Button {
                                        Task {
                                            do {
                                                fetchingPage = true
                                                let currentPage = inbox.currentPage
                                                model.inbox = try await model.api!.requestInbox(page: currentPage - 1, type: .inbox)
                                                fetchingPage = false
                                            } catch {
                                                #if DEBUG
                                                print(error)
                                                #endif
                                                if error is GazelleAPIError {
                                                    erroredOut = true
                                                }
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "arrowtriangle.left.fill")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                } else {
                                    Button {} label: {
                                        Image(systemName: "arrowtriangle.left.fill")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                    .disabled(true)
                                }
                                if inbox.currentPage < inbox.pages {
                                    Button {
                                        Task {
                                            do {
                                                fetchingPage = true
                                                let currentPage = inbox.currentPage
                                                model.inbox = try await model.api!.requestInbox(page: currentPage + 1, type: .inbox)
                                                fetchingPage = false
                                            } catch {
                                                #if DEBUG
                                                print(error)
                                                #endif
                                                if error is GazelleAPIError {
                                                    erroredOut = true
                                                }
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "arrowtriangle.right.fill")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                } else {
                                    Button {} label: {
                                        Image(systemName: "arrowtriangle.right.fill")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                    .disabled(true)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                if let conversation = model.inbox!.conversations.first {
                    model.unreadConversations = conversation.unread
                }
            }
        } else if erroredOut {
            RequestError {
                do {
                    model.inbox = try await model.api!.requestInbox(page: 1, type: .inbox)
                } catch {
                    #if DEBUG
                    print(error)
                    #endif
                    if error is GazelleAPIError {
                        erroredOut = true
                    }
                }
            }
        } else if model.getAPIKey() != "" && fetchingPageOnAppear {
            VStack {
                Spacer()
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.horizontal, 2)
                    Text("Loading...")
                }
                Spacer()
            }
            .onAppear { // this is dumb but for some reason when i use `.task(_:)`, it shits itself
                if model.inbox == nil {
                    fetchingPageOnAppear = true
                    Task {
                        do {
                            model.inbox = try await model.api!.requestInbox(page: 1, type: .inbox)
                        } catch {
                            #if DEBUG
                            print(error)
                            #endif
                            if error is GazelleAPIError {
                                erroredOut = true
                            }
                        }
                        fetchingPageOnAppear = false
                    }
                }
            }
        } else {
            VStack {
                Text("API Key Not Set")
                    .font(.title)
                Text("Your API key can be set in settings.")
            }
        }
    }
}
