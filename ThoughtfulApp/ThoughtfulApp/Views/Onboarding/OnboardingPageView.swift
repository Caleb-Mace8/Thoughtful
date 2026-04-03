import SwiftUI

public struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let subtitle: String
    let buttons: AnyView?

    public init(imageName: String, title: String, subtitle: String, buttons: AnyView? = nil) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.buttons = buttons
    }

    public var body: some View {
        VStack {
            VStack(spacing: 24) {
                Spacer(minLength: 24)

                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.accent)
                    .accessibilityHidden(true)

                VStack(spacing: 12) {
                    Text(title)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)

                Spacer(minLength: 8)

                if let buttons {
                    buttons
                        .tint(.accentColor)
                }
            }
            .frame(maxWidth: 600)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.card)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingPageView(
        imageName: "sparkles",
        title: "Thanks for downloading Thoughtful",
        subtitle: "This quick tutorial will help you get up to speed.",
        buttons: AnyView(
            Button("Continue") {}
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        )
    )
}

