import Foundation
import Observation

@Observable
final class QuotaManager {
    static let shared = QuotaManager()

    // MARK: - Constants
    let dailyLimit: Int = 10

    // MARK: - AppStorage Persistence Keys
    private let lastResetKey = "quota_last_reset_date"
    private let scannerCountKey = "quota_scanner_count"
    private let manualCountKey = "quota_manual_count"

    // MARK: - State Properties
    private(set) var scannerCount: Int = 0
    private(set) var manualCount: Int = 0
    private(set) var lastResetDate: Date = Date()

    init() {
        loadQuota()
        checkAndResetIfNewDay()
    }

    // MARK: - Public Quota Checks
    var canScan: Bool {
        checkAndResetIfNewDay()
        return scannerCount < dailyLimit
    }

    var canManualSearch: Bool {
        checkAndResetIfNewDay()
        return manualCount < dailyLimit
    }

    var remainingScans: Int {
        max(0, dailyLimit - scannerCount)
    }

    var remainingManualSearches: Int {
        max(0, dailyLimit - manualCount)
    }

    // MARK: - Quota Increments
    @discardableResult
    func incrementScannerCount() -> Bool {
        checkAndResetIfNewDay()
        guard scannerCount < dailyLimit else { return false }
        
        scannerCount += 1
        UserDefaults.standard.set(scannerCount, forKey: scannerCountKey)
        return true
    }

    @discardableResult
    func incrementManualCount() -> Bool {
        checkAndResetIfNewDay()
        guard manualCount < dailyLimit else { return false }
        
        manualCount += 1
        UserDefaults.standard.set(manualCount, forKey: manualCountKey)
        return true
    }

    // MARK: - Reset Logic
    func checkAndResetIfNewDay() {
        let calendar = Calendar.current
        if !calendar.isDateInToday(lastResetDate) {
            resetQuota()
        }
    }

    private func resetQuota() {
        scannerCount = 0
        manualCount = 0
        lastResetDate = Date()

        UserDefaults.standard.set(0, forKey: scannerCountKey)
        UserDefaults.standard.set(0, forKey: manualCountKey)
        UserDefaults.standard.set(lastResetDate.timeIntervalSince1970, forKey: lastResetKey)
    }

    private func loadQuota() {
        scannerCount = UserDefaults.standard.integer(forKey: scannerCountKey)
        manualCount = UserDefaults.standard.integer(forKey: manualCountKey)

        let timestamp = UserDefaults.standard.double(forKey: lastResetKey)
        if timestamp > 0 {
            lastResetDate = Date(timeIntervalSince1970: timestamp)
        } else {
            lastResetDate = Date()
            UserDefaults.standard.set(lastResetDate.timeIntervalSince1970, forKey: lastResetKey)
        }
    }
}
