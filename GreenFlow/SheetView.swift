import SwiftUI

struct SheetView: View {
    
    @Binding var error: String
    @Binding var picTypeOfSetting: Int
    @Binding var isIN2: Bool
    @Binding var isIN1: Bool
    @Binding var isEditing: Bool
    @Binding var plantName: String
    
    let items = ["Care", "Water", "Light", "Detail"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    if isEditing {
                        TextField("Enter plant name", text: $plantName)
                            .foregroundColor(.white)
                            .font(.custom("AbrilFatface-Regular", size: 40))
                            .multilineTextAlignment(.center)
                            .onAppear {
                                self.plantName = UserDefaults.standard.string(forKey: "plantName") ?? "My plant"
                            }
                    } else {
                        Text(plantName)
                            .foregroundColor(.white)
                            .font(.custom("AbrilFatface-Regular", size: 40))
                    }
                    Spacer()
                }
//                Button(action: {
//                    if isEditing {
//                        UserDefaults.standard.set(self.plantName, forKey: "plantName")
//                    }
//                    isEditing.toggle()
//                }) {
//                    Text(isEditing ? "Save" : "Edit")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
                ZStack {
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                        .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                        .frame(width: 430, height: 500)
                    
                    VStack {
                        CustomPicker(selectedIndex: $picTypeOfSetting, items: items)
                            .padding()
                        Care(isIN2: $isIN2, isIN1: $isIN1)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    SheetView(
        error: .constant(""),
        picTypeOfSetting: .constant(0),
        isIN2: .constant(false),
        isIN1: .constant(false),
        isEditing: .constant(false),
        plantName: .constant("My plant")
    )
}
