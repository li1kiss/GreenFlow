import SwiftUI

struct ButtonRow: View {
    @Binding var isIN2: Bool
    @Binding var isIN1: Bool
    @Binding var error: String
    @Binding var plantName: String
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    ToggleButton(title: "pencil", action: edit)
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
                VStack {
                    ZStack {
                        Color.black
                            .blur(radius: 60)
                            .frame(width: 50, height: 130)
                            .cornerRadius(10)
                        VStack {
                            ToggleButton(title: isIN1 ? "lightbulb.fill" : "lightbulb", action: toggleIN1)
                                .rotationEffect(.radians(3.14))
                                .contentTransition(.symbolEffect(.replace))
                                .foregroundColor(.white)
                            
                            ToggleButton(title: "cloud.rainbow.half", action: toggleIN2)
                                .symbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing, isActive: isIN2)
                                .symbolRenderingMode(.multicolor)
                        }
                    }
                    Spacer()
                }
            }
            .padding(9)
            Spacer()
        }
    }
    
    func edit() {
        isEditing.toggle()
        if !isEditing {
            // Save the plant name when editing is finished
            UserDefaults.standard.set(plantName, forKey: "plantName")
        }
    }
    
    func toggleIN1() {
        if isIN2 == false {
            error = ""
            guard let url = URL(string: isIN1 ? "http://172.20.10.10/IN1/on" : "http://172.20.10.10/IN1/off") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                }
                self.isIN1.toggle()
            }.resume()
        } else {
            error = "Turn off IN2"
        }
    }
    
    func toggleIN2() {
        if isIN1 == false {
            error = ""
            guard let url = URL(string: isIN2 ? "http://172.20.10.10/IN2/on" : "http://172.20.10.10/IN2/off") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                }
                self.isIN2.toggle()
            }.resume()
        } else {
            error = "Turn off IN1"
        }
    }
}

struct ButtonRow_Previews: PreviewProvider {
    static var previews: some View {
        ButtonRow(isIN2: .constant(false), isIN1: .constant(false), error: .constant("error"), plantName: .constant("My plant"), isEditing: .constant(false))
    }
}
