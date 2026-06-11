//
//  ChatBotViewModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 11/06/26.
//
import Foundation
import FoundationModels

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

@available(iOS 26.0, *)
@MainActor
final class ChatBotViewModel: ObservableObject {

    @Published var messages: [ChatMessage] = []

    private var session: LanguageModelSession?

    func setupAI() {

        guard case .available = SystemLanguageModel.default.availability else {

            messages.append(
                ChatMessage(
                    text: """
                    Apple Intelligence model is not available.
                    Please make sure:
                    • Device supports Apple Intelligence
                    • Apple Intelligence is enabled
                    • Required models are downloaded
                    """,
                    isUser: false
                )
            )

            return
        }

        let instructions = """
        You are an Employee Assistant.

        Employee Profile:

        Name: \(UserDefaultsManager.getName())
        Employee Code: \(UserDefaultsManager.getEmpCode())
        Department: \(UserDefaultsManager.getDepartment())
        Designation: \(UserDefaultsManager.getDesignation())
        Manager: \(UserDefaultsManager.getReportTo())
        Email: \(UserDefaultsManager.getEmailID())
        Joining Date: \(UserDefaultsManager.getJoinDate())
        Birthday: \(UserDefaultsManager.getBirthday())
        Blood Group: \(UserDefaultsManager.getBloodGroup())
        Leave Balance: \(UserDefaultsManager.getPlBalance())
        Today's In Time: \(UserDefaultsManager.getTodayInTime())
        Policy Number: \(UserDefaultsManager.getPolicyNumber())
        Policy Amount: \(UserDefaultsManager.getPolicyAmount())
        Policy Validity: \(UserDefaultsManager.getPolicyValidity())

        Rules:
        1. Answer only using the above information.
        2. Do not make assumptions.
        3. If information is unavailable say:
           "I don't have that information in my current employee profile."
        """

        session = LanguageModelSession(
            instructions: instructions
        )

        messages.append(
            ChatMessage(
                text: """
                👋 Hello \(UserDefaultsManager.getName())

                I can help you with:
                • Employee Profile
                • Leave Balance
                • Joining Date
                • Department
                • Reporting Manager

                Ask me anything.
                """,
                isUser: false
            )
        )
    }

    func sendMessage(_ text: String) async {

        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        guard let session else {

            messages.append(
                ChatMessage(
                    text: "AI session is not available.",
                    isUser: false
                )
            )

            return
        }

        messages.append(
            ChatMessage(
                text: text,
                isUser: true
            )
        )

        do {

            let response = try await session.respond(
                to: text
            )

            messages.append(
                ChatMessage(
                    text: response.content,
                    isUser: false
                )
            )

        } catch {

            messages.append(
                ChatMessage(
                    text: "Error: \(error.localizedDescription)",
                    isUser: false
                )
            )

            print("FoundationModels Error:", error)
        }
    }
}
