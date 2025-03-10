//
//  ProfileNavigationRowView.swift
//  Sidekick
//
//  Created by Bean John on 10/11/24.
//

import SwiftUI

struct ProfileNavigationRowView: View {
	
	@EnvironmentObject private var profileManager: ProfileManager
	
	@State private var isEditing: Bool = false
	@State private var isDeleting: Bool = false
	
	@State private var isHovering: Bool = false
	
	@Binding var profile: Profile
	
	var isDefault: Bool {
		return profile.id == profileManager.default?.id
	}
	
	var body: some View {
		HStack {
			editButton
			Spacer()
			controls
		}
		.padding(.leading, 4)
		.padding(.trailing)
		.background {
			RoundedRectangle(cornerRadius: 7)
				.fill(self.profile.color)
		}
		.onHover { hovering in
			self.isHovering = hovering
		}
		.sheet(isPresented: $isEditing) {
			ProfileEditorView(
				profile: $profile, isEditing: $isEditing
			)
			.frame(minWidth: 500, maxHeight: 800)
		}
		.contextMenu {
			deleteButton
		}
		.confirmationDialog(
			"Delete",
			isPresented: $isDeleting
		) {
			Button("Confirm") {
				self.profileManager.delete(
					self.profile
				)
				self.isDeleting = false
			}
		} message: {
			Text("Are you sure you want to delete this profile?")
		}
	}
	
	var editButton: some View {
		Button {
			self.isEditing.toggle()
		} label: {
			self.profile.label
		}
		.buttonStyle(.plain)
	}
	
	var controls: some View {
		Group {
			if !isDefault && isHovering {
				Group {
					deleteButton
						.labelStyle(.iconOnly)
					Image(systemName: "line.3.horizontal")
						.foregroundStyle(.secondary)
						.foregroundStyle(
							self.profile.color.adaptedTextColor
						)
				}
			}
		}
	}
	
	var deleteButton: some View {
		Button {
			self.isDeleting.toggle()
		} label: {
			Label("Delete", systemImage: "trash")
				.foregroundStyle(.red)
				.bold()
		}
		.buttonStyle(.plain)
	}
	
}
