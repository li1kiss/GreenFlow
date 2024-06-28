import SwiftUI

// Кастомний вид для кожного елементу Picker
struct CustomPickerItem: View {
    var title: String
    var isSelected: Bool

    var body: some View {
        Text(title)
            .foregroundColor(isSelected ? Color.white : Color.black)
            .padding()
            .background(isSelected ? Color.colorSelectedFunc : nil)
            .cornerRadius(40)
        // Додайте анімацію для зміни вигляду
    }
}

struct CustomPicker: View {
    @Binding var selectedIndex: Int
    var items: [String]
    
    var body: some View {
        HStack {
            ForEach(0..<items.count, id: \.self) { index in
                Button(action: {
                    if index != selectedIndex { // Перевірка, чи кнопка не є вже вибраною
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }) {
                    CustomPickerItem(title: items[index], isSelected: index == selectedIndex)
                }
                .transition(.scale) // Приклад анімації при додаванні або видаленні кнопок
                .font(.caption)
                .disabled(index == selectedIndex) // Вимкнути кнопку, якщо вона вже вибрана
            }
        }
        .background(Color.colorfuncletter)
        .cornerRadius(40)
// Анімація внутрішніх змін
    }

}

struct CustomPicker_Preview: PreviewProvider {
    static var previews: some View {
        CustomPicker(selectedIndex: .constant(0), items: ["Care", "Water", "Light", "Detail"])
    }
}
