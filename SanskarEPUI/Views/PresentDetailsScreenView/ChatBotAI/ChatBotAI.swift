//
//  ChatBotAI.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 11/06/26.
//

import SwiftUI

@available(iOS 26.0, *)
struct ChatBotAI: View {

    @StateObject private var vm = ChatBotViewModel()
    @State private var text = ""

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color.blue.opacity(0.08),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                headerView

                ScrollViewReader { proxy in

                    ScrollView {

                        LazyVStack(spacing: 12) {

                            ForEach(vm.messages) { msg in

                                ChatBubble(
                                    message: msg
                                )
                                .id(msg.id)
                            }
                        }
                        .padding(.top)
                    }
                    .onChange(of: vm.messages.count) { _, _ in

                        if let last = vm.messages.last {
                            withAnimation {
                                proxy.scrollTo(
                                    last.id,
                                    anchor: .bottom
                                )
                            }
                        }
                    }
                }

                inputView
            }
        }
        .task {
            vm.setupAI()
        }
    }
}
struct ChatBubble: View {

    let message: ChatMessage

    var body: some View {

        HStack {

            if message.isUser {
                Spacer()
            }

            Text(message.text)
                .font(.system(size: 15))
                .foregroundStyle(
                    message.isUser ? .white : .primary
                )
                .padding()
                .background {
                    if message.isUser {
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color(.systemGray6)
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )
                .frame(maxWidth: 280, alignment: .leading)

            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
@available(iOS 26.0, *)
//MARK: HeaderView
extension ChatBotAI {

    var headerView: some View {

        HStack {

            Image(systemName: "brain.head.profile")
                .font(.title2)
                .foregroundStyle(.white)

            VStack(alignment: .leading) {

                Text("AI Assistant")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Employee Support")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.blue, .cyan],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}
@available(iOS 26.0, *)
extension ChatBotAI {

    var inputView: some View {

        HStack(spacing: 12) {

            TextField(
                "Ask anything...",
                text: $text,
                axis: .vertical
            )
            .padding(12)
            .background(
                Color(.systemGray6)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
            )

            Button {

                let message = text.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

                guard !message.isEmpty else {
                    return
                }

                text = ""

                Task {
                    await vm.sendMessage(message)
                }

            } label: {

                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(.blue)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}
