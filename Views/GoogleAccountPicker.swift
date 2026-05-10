//
//  GoogleAccountPicker.swift
//  SmartPark
//

import SwiftUI

struct GoogleAccountPicker: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    Image(systemName: "g.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.blue)
                        .padding(.top, 24)

                    Text("Choose an account")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("to continue to SmartPark")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 20)

                Divider()

                ForEach(AuthManager.availableAccounts, id: \.email) { account in
                    Button {
                        dismiss()
                        authManager.signIn(with: account)
                    } label: {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: account.initial == "T" ? [.blue, .cyan] : [.green, .mint],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Text(account.initial)
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                )

                            VStack(alignment: .leading, spacing: 3) {
                                Text(account.name)
                                    .foregroundStyle(.primary)
                                    .fontWeight(.medium)
                                Text(account.email)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                    }

                    Divider().padding(.leading, 80)
                }

                Button {
                    dismiss()
                    authManager.signIn(with: AuthManager.availableAccounts[0])
                } label: {
                    HStack(spacing: 16) {
                        Circle()
                            .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1.5)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundStyle(.secondary)
                            )

                        Text("Use another account")
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                }

                Spacer()

                Text("To continue, Google will share your name, email address, and profile picture with SmartPark.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 20)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
