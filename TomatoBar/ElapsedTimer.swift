import KeyboardShortcuts
import SwiftState
import SwiftUI

class TBElapsedTimer: ObservableObject {
    @Published var timer: Timer?
    @Published var elapsedTime: TimeInterval = 0 // Track elapsed time

    private var startTime: Date? // Track when the timer starts
    private var pauseTime: Date? // Track when the timer is paused

    func startStop() {
        if timer == nil { // Start the timer
            startTime = Date()
            elapsedTime = 0 // Reset elapsed time
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.updateElapsedTime()
            }
        } else { // Stop the timer
            timer?.invalidate()
            timer = nil
            elapsedTime = 0 // Reset elapsed time
        }
    }

    func pauseResume() {
        if let timer = timer {
            // Pause
            pauseTime = Date()
            timer.invalidate()
            self.timer = nil
        } else {
            // Resume
            if let pauseTime = pauseTime {
                startTime = startTime?.addingTimeInterval(Date().timeIntervalSince(pauseTime))
            }
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.updateElapsedTime()
            }
        }
    }

    private func updateElapsedTime() {
        if let startTime = startTime {
            elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    func formattedElapsedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // 0:00:00 format
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad] // Ensures two-digit formatting where necessary
        return formatter.string(from: elapsedTime) ?? "0:00:00"
    }
}
