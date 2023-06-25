import SwiftUI
import Networking
import FirebaseCore
import FirebaseCrashlytics

struct List: View {
    @EnvironmentObject var network: DataOfImage
    @AppStorage("CrashlyticsConsent") var crashlyticsConsent: Bool = false

    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                self.imageCollectionView
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                Button("Crash") {
                    fatalError("Crash")
                }
                Button("Mistake") {
                    let nilValue: Int? = nil
                    let crashValue = nilValue!
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
                .padding()
                Button("Crash 2") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        // Simulating a crash by accessing an index out of bounds in an array
                        let array = [1, 2, 3]
                        let crashValue = array[4]
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
                .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Crashlytics Consent"),
                message: Text("Do you consent to collect crash data?"),
                primaryButton: .default(Text("Yes")) {
                    crashlyticsConsent = true
                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(crashlyticsConsent)
                },
                secondaryButton: .default(Text("No")) {
                    crashlyticsConsent = false
                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(crashlyticsConsent)
                }
            )
        }
        .onAppear {
            if !crashlyticsConsent {
                showAlert = true
            }
        }
    }
    
    private var imageCollectionView: some View {
        ScrollView {
            LazyVStack {
                ForEach($network.cats) { $cat in
                    NavigationLink(
                        destination:
                            LazyVStack {
                                AsyncImage(url: URL(string: cat.url), scale: 2){ image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(height: 350)
                            },
                        label: {
                            AsyncImage(url: URL(string: cat.url), scale: 2){ image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 400, height: 400)
                            .padding()
                            .onTapGesture {
                                // Logging the string when the user taps on the image
                                let tappedString = "Tapped on: \(cat.url)"
                                Crashlytics.crashlytics().log(tappedString)
                            }
                        }
                    )
                }
                Color.clear
                    .frame(width: 0, height: 0, alignment: .bottom)
                    .onAppear {
                        network.loadmore()
                    }
            }
        }
    }
}
