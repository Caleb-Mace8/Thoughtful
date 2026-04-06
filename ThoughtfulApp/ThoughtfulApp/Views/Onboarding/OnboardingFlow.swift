import SwiftUI
import UserNotifications

public struct OnboardingFlow: View {
    @Binding var isPresented: Bool
    @State private var page = 0
    @Environment(NotificationManager.self) var notificationManager
    
    private func advancePage() {
        withAnimation {
            if page < 4 {
                page += 1
            }
        }
    }
    
    private func finish() {
        withAnimation {
            isPresented = false
        }
    }
    
    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    public var body: some View {
        ZStack {
            // Dimmed background behind the onboarding card
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .transition(.opacity)

            // Centered card container
            VStack {
                TabView(selection: $page) {
                    // Page 1
                    OnboardingPageView(
                        imageName: "sparkles",
                        title: "Thanks for downloading Thoughtful",
                        subtitle: "This quick tutorial will help you get up to speed.",
                        buttons: AnyView(
                            Button("Start") {
                                advancePage()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        )
                    )
                    .tag(0)

                    // Page 2
                    OnboardingPageView(
                        imageName: "person.crop.circle.badge.plus",
                        title: "People Tab",
                        subtitle: "At the bottom of the screen there is two tabs: People and Lists. Add a person by going to the People tab and tapping the + in the top right.",
                        buttons: AnyView(
                            Button("Next") {
                                advancePage()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        )
                    )
                    .tag(1)

                    // Page 3
                    OnboardingPageView(
                        imageName: "list.bullet.rectangle.portrait",
                        title: "Creating Lists",
                        subtitle: "Tap a person, then tap + on the list header to add a gift. Pressing the + button in the top right will allow for a new list to be added to the person.",
                        buttons: AnyView(
                            Button("Next") {
                                advancePage()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        )
                    )
                    .tag(2)

                    // Page 4
                    OnboardingPageView(
                        imageName: "gift",
                        title: "Wishlists Tab",
                        subtitle: "Create wishlists for yourself by hitting + in the top right on the Lists tab.",
                        buttons: AnyView(
                            Button("Next") {
                                advancePage()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        )
                    )
                    .tag(3)

                    // Page 5
                    OnboardingPageView(
                        imageName: "bell.badge",
                        title: "Notifications",
                        subtitle: "Get notified of upcoming birthdays through notifications you set up! You can always turn this On or Off from the app settings.",
                        buttons: AnyView(
                            VStack(spacing: 16) {
                                Button("Enable Notifications") {
                                    notificationManager.requestAuthorization()
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)

                                Button("Done") {
                                    finish()
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(.horizontal, 40)
                        )
                    )
                    .tag(4)
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(maxWidth: 700, maxHeight: 650)
                .padding()
            }
        }
    }
}

struct OnboardingFlow_Previews: PreviewProvider {
    @State static var presented = true
    
    static var previews: some View {
        OnboardingFlow(isPresented: $presented)
    }
}
