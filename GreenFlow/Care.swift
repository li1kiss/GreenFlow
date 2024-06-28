import SwiftUI

struct Care: View {
    @State private var selectedDate = Date()
    @State private var lightDate = Date()
    @State private var shouldRepeat = false
    @State private var selectedDaysOfWeek: [Bool] = Array(repeating: false, count: 7)
    @State private var timeWork: Int = 0
    @State private var lightWork: Int = 0
    @State private var waterTimer: Timer?
    @State private var lightTimer: Timer?
    @State private var timer: Timer?
    @State private var isActionInProgress = false
    @State private var isLightActionInProgress = false

    @Binding var isIN2: Bool
    @Binding var isIN1: Bool

    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        VStack {
            DatePicker("When do you want to water?", selection: $selectedDate, in: Date()..., displayedComponents: .hourAndMinute)
                .onChange(of: selectedDate, perform: { _ in
                    scheduleWateringAction()
                })

            Toggle("Do you want to repeat over the week?", isOn: $shouldRepeat)

            if shouldRepeat {
                Divider()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(daysOfWeek.indices, id: \.self) { index in
                            Button(action: {
                                self.selectedDaysOfWeek[index].toggle()
                                scheduleWateringAction()
                            }) {
                                Text(daysOfWeek[index])
                                    .foregroundColor(selectedDaysOfWeek[index] ? .white : Color("colorfuncletter"))
                                    .padding(8)
                                    .background(selectedDaysOfWeek[index] ? Color.colorSelectedFunc : nil)
                                    .cornerRadius(40)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                Divider()
            }

            HStack {
                Text("Watering time:")
                Spacer()
                HStack {
                    Button(action: {
                        if timeWork > 0 {
                            timeWork -= 1
                        }
                    }, label: {
                        Image(systemName: "minus")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .frame(width: 25, height: 25)
                            .background(Color("button"))
                            .clipShape(Circle())
                            .padding(5)
                    })
                    Spacer()
                    Text("\(timeWork)")
                        .font(.title2)
                    Spacer()
                    Button(action: {
                        timeWork += 1
                    }, label: {
                        Image(systemName: "plus")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .frame(width: 25, height: 25)
                            .background(Color("button"))
                            .clipShape(Circle())
                            .padding(5)
                    })
                }
                .frame(width: 120, height: 40)
                .background(Color("colorbackButton1"))
                .clipShape(.capsule)
                .frame(width: 130, height: 50)
                .background(Color("colorbackButton"))
                .clipShape(.capsule)
            }

            Divider()

            DatePicker("When do you want to turn on the light?", selection: $lightDate, in: Date()..., displayedComponents: .hourAndMinute)
                .onChange(of: lightDate, perform: { _ in
                    scheduleLightAction()
                })
                .datePickerStyle(.compact)
                .padding(.top)
            
            HStack {
                Text("Hours light on for:")
                Spacer()
                HStack {
                    Button(action: {
                        if lightWork > 0 {
                            lightWork -= 1
                        }
                    }, label: {
                        Image(systemName: "minus")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .frame(width: 25, height: 25)
                            .background(Color("button"))
                            .clipShape(Circle())
                            .padding(5)
                    })
                    Spacer()
                    Text("\(lightWork)")
                        .font(.title2)
                    Spacer()
                    Button(action: {
                        lightWork += 1
                    }, label: {
                        Image(systemName: "plus")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .frame(width: 25, height: 25)
                            .background(Color("button"))
                            .clipShape(Circle())
                            .padding(5)
                    })
                }
                .frame(width: 120, height: 40)
                .background(Color("colorbackButton1"))
                .clipShape(.capsule)
                .frame(width: 130, height: 50)
                .background(Color("colorbackButton"))
                .clipShape(.capsule)
            }
        }
        .padding()
        .onAppear {
//            scheduleLightAction()
            scheduleWateringAction()
            scheduleLightAction()

        }
        .padding()
    }
    // Функція для обрання дати поливу
    private func scheduleWateringAction() {
        let calendar = Calendar.current
        let currentDate = Date()

        var userCalendar = Calendar.current
        userCalendar.timeZone = TimeZone.current

        let selectedComponents = userCalendar.dateComponents([.hour, .minute, .weekday], from: selectedDate)
        guard let selectedHour = selectedComponents.hour, let selectedMinute = selectedComponents.minute else {
            print("Error: Failed to get hour and minute.")
            return
        }

        var scheduledDate: Date

        if let selectedWeekday = selectedComponents.weekday {
            scheduledDate = calendar.nextDate(after: currentDate, matching: DateComponents(hour: selectedHour, minute: selectedMinute, weekday: selectedWeekday), matchingPolicy: .nextTime, direction: .forward) ?? currentDate
        } else {
            scheduledDate = calendar.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: currentDate) ?? currentDate

            if scheduledDate <= currentDate {
                scheduledDate = calendar.date(byAdding: .day, value: 1, to: scheduledDate) ?? currentDate
            }
        }

        let timeInterval = scheduledDate.timeIntervalSince(currentDate)
        print("Time interval until scheduled watering date: \(timeInterval) seconds")

        waterTimer?.invalidate()

        waterTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            print("Watering action executed")

            self.isActionInProgress = true
            self.isIN2 = false
            toggleIN2()

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.timeWork)) {
                self.isIN2 = true
                toggleIN2()
                self.isActionInProgress = false
            }
        }
    }

    // Функція для обрання дати включення світла
    private func scheduleLightAction() {
        let calendar = Calendar.current
        let currentDate = Date()

        var userCalendar = Calendar.current
        userCalendar.timeZone = TimeZone.current

        let selectedComponents = userCalendar.dateComponents([.hour, .minute, .weekday], from: lightDate)
        guard let selectedHour = selectedComponents.hour, let selectedMinute = selectedComponents.minute else {
            print("Error: Failed to get hour and minute.")
            return
        }

        var scheduledDate: Date

        if let selectedWeekday = selectedComponents.weekday {
            scheduledDate = calendar.nextDate(after: currentDate, matching: DateComponents(hour: selectedHour, minute: selectedMinute, weekday: selectedWeekday), matchingPolicy: .nextTime, direction: .forward) ?? currentDate
        } else {
            scheduledDate = calendar.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: currentDate) ?? currentDate

            if scheduledDate <= currentDate {
                scheduledDate = calendar.date(byAdding: .day, value: 1, to: scheduledDate) ?? currentDate
            }
        }

        let timeInterval = scheduledDate.timeIntervalSince(currentDate)
        print("Time interval until scheduled light date: \(timeInterval) seconds")

        lightTimer?.invalidate()

        lightTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            print("Light action executed")

            self.isLightActionInProgress = true
            self.isIN1 = false
            toggleIN1()

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.lightWork) * 3600) {
                self.isIN1 = true
                toggleIN1()
                self.isLightActionInProgress = false
            }
        }
    }


//    private func scheduleAction() {
//        let calendar = Calendar.current
//        let currentDate = Date()
//
//        let selectedComponents = calendar.dateComponents([.hour, .minute, .weekday], from: selectedDate)
//        guard let selectedHour = selectedComponents.hour, let selectedMinute = selectedComponents.minute else {
//            print("Error: Failed to get hour and minute.")
//            return
//        }
//
//        var scheduledDate: Date
//
//        if let selectedWeekday = selectedComponents.weekday {
//            scheduledDate = calendar.nextDate(after: currentDate, matching: DateComponents(hour: selectedHour, minute: selectedMinute, weekday: selectedWeekday), matchingPolicy: .nextTime, direction: .forward) ?? currentDate
//        } else {
//            scheduledDate = calendar.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: currentDate) ?? currentDate
//
//            if scheduledDate <= currentDate {
//                scheduledDate = calendar.date(byAdding: .day, value: 1, to: scheduledDate) ?? currentDate
//            }
//        }
//
//        let timeInterval = scheduledDate.timeIntervalSince(currentDate)
//
//        waterTimer?.invalidate()
//
//        waterTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
//            print("Watering action executed")
//
//            self.isActionInProgress = true
//            self.isIN2 = false
//            toggleIN2()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.timeWork)) {
//                self.isIN2 = true
//                toggleIN2()
//                self.isActionInProgress = false
//            }
//        }
//    }
//    
//    
//    
//    private func scheduleLightAction() {
//        let calendar = Calendar.current
//        let currentDate = Date()
//
//        let selectedComponents = calendar.dateComponents([.hour, .minute, .weekday], from: lightDate)
//        guard let selectedHour = selectedComponents.hour, let selectedMinute = selectedComponents.minute else {
//            print("Error: Failed to get hour and minute.")
//            return
//        }
//
//        var scheduledDate: Date
//
//        if let selectedWeekday = selectedComponents.weekday {
//            scheduledDate = calendar.nextDate(after: currentDate, matching: DateComponents(hour: selectedHour, minute: selectedMinute, weekday: selectedWeekday), matchingPolicy: .nextTime, direction: .forward) ?? currentDate
//        } else {
//            scheduledDate = calendar.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: currentDate) ?? currentDate
//
//            if scheduledDate <= currentDate {
//                scheduledDate = calendar.date(byAdding: .day, value: 1, to: scheduledDate) ?? currentDate
//            }
//        }
//
//        let timeInterval = scheduledDate.timeIntervalSince(currentDate)
//
//        lightTimer?.invalidate()
//
//        lightTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
//            print("Watering action executed")
//
//            self.isActionInProgress = true
//            self.isIN1 = false
//            toggleIN1()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.timeWork)) {
//                self.isIN1 = true
//                toggleIN1()
//                self.isActionInProgress = false
//            }
//        }
//    }
//    private func scheduleLightAction() {
//            let calendar = Calendar.current
//            let currentDate = Date()
//
//            let selectedComponents = calendar.dateComponents([.hour, .minute, .weekday], from: lightDate)
//            guard let selectedHour = selectedComponents.hour, let selectedMinute = selectedComponents.minute else {
//                print("Error: Failed to get hour and minute.")
//                return
//            }
//
//            var scheduledDate: Date
//
//            if let selectedWeekday = selectedComponents.weekday {
//                scheduledDate = calendar.nextDate(after: currentDate, matching: DateComponents(hour: selectedHour, minute: selectedMinute, weekday: selectedWeekday), matchingPolicy: .nextTime, direction: .forward) ?? currentDate
//            } else {
//                scheduledDate = calendar.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: currentDate) ?? currentDate
//
//                if scheduledDate <= currentDate {
//                    scheduledDate = calendar.date(byAdding: .day, value: 1, to: scheduledDate) ?? currentDate
//                }
//            }
//
//            let timeInterval = scheduledDate.timeIntervalSince(currentDate)
//            print("Time interval until scheduled date: \(timeInterval) seconds")
//
//            timer?.invalidate()
//
//            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
//                print("Light action executed")
//
//                // Update state to indicate light action is in progress
//                self.isLightActionInProgress = true
//
//                // Toggle isIN1 state to true
//                self.isIN1 = true
//                toggleIN1()
//
//                // Dispatch after work time to toggle isIN1 back to false
//                DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.lightWork) * 3600) {
//                    self.isIN1 = false
//                    toggleIN1()
//
//                    // Update state to indicate light action is completed
//                    self.isLightActionInProgress = false
//                }
//            }
//        }

//    private func scheduleLightAction() {
//        let calendar = Calendar.current
//        let currentDate = Date()
//
//        let selectedComponents = calendar.dateComponents([.hour, .minute], from: selectedDate)
//        guard let selectedHour = selectedComponents.hour, let selectedMinute = selectedComponents.minute else {
//            print("Error: Failed to get hour and minute.")
//            return
//        }
//
//        var scheduledDate = calendar.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: currentDate) ?? currentDate
//
//        if scheduledDate <= currentDate {
//            scheduledDate = calendar.date(byAdding: .day, value: 1, to: scheduledDate) ?? currentDate
//        }
//
//        let timeInterval = scheduledDate.timeIntervalSince(currentDate)
//
//        lightTimer?.invalidate()
//
//        lightTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
//            print("Light action executed at \(Date())")
//
//            self.isLightActionInProgress = true
//            self.isIN1 = true
//            toggleIN1()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.lightWork) * 3600) {
//                print("Turning off light at \(Date())")
//                self.isIN1 = false
//                toggleIN1()
//                self.isLightActionInProgress = false
//            }
//        }
//    }
    func toggleIN1() {
        print("toggleIN1 called, isIN1: \(isIN1)")
        guard let url = URL(string: isIN1 ? "http://172.20.10.10/IN1/on" : "http://172.20.10.10/IN1/off") else {
            print("Invalid URL for toggleIN1")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            print("Response: \(String(describing: response))")
            self.isIN1.toggle()
        }.resume()
    }

    func toggleIN2() {
        print("toggleIN2 called, isIN2: \(isIN2)")
        guard let url = URL(string: isIN2 ? "http://172.20.10.10/IN2/on" : "http://172.20.10.10/IN2/off") else {
            print("Invalid URL for toggleIN2")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            print("Response: \(String(describing: response))")
            self.isIN2.toggle()
        }.resume()
    }
}

struct Care_Previews: PreviewProvider {
    static var previews: some View {
        Care(isIN2: .constant(false), isIN1: .constant(false))
    }
}
