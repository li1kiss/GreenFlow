import SwiftUI

struct ContentView: View {
    
    @State public var isIN1 = false
    @State private var isIN2 = false
    @State private var isEditing = false
    @State private var error = ""
    @State private var picTypeOfSetting = 0
    @State private var plantName = UserDefaults.standard.string(forKey: "plantName") ?? "My plant"
    
    var body: some View {
        ZStack{
            ScrollView {
                VStack(spacing: -150) {
                    PhotoFlower()
                    SheetView(
                        error: $error,
                        picTypeOfSetting: $picTypeOfSetting,
                        isIN2: $isIN2,
                        isIN1: $isIN1,
                        isEditing: $isEditing,
                        plantName: $plantName
                    )
                }
            }
            .ignoresSafeArea()
            ButtonRow(
                isIN2: $isIN2,
                isIN1: $isIN1,
                error: $error,
                plantName: $plantName,
                isEditing: $isEditing
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
