import SwiftUI
import DatadogRUM

struct AppView: View {
    @State private var router = TRouter()
    
    var body: some View {
        VStack(alignment: .center,
               spacing: 0) {
            switch router.appCycle {
            case .launch:
                LaunchScreen()
                    .trackRUMView(name: router.dataDogScreenName())
            case .onboarding:
                OnboardingView()
                    .environment(router)
                    .trackRUMView(name: router.dataDogScreenName())
            case .register(let user, let step, let askToContinue):
                RegistrationView(user: user, step: step, askToContinue: askToContinue)
                    .environment(router)
                    .trackRUMView(name: router.dataDogScreenName())
            case .tab:
                MainView()
                    .environment(router)
                    .trackRUMView(name: router.dataDogScreenName())
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
