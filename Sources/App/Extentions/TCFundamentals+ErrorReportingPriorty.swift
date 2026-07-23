import TCFundamentals

extension TCFundamentals.ErrorReportingPriorty {

    var diagnosticRank: Int {
        switch self {
        case .zero:
            return 0
        case .low:
            return 1
        case .med:
            return 2
        case .high:
            return 3
        }
    }

    func raised(to other: TCFundamentals.ErrorReportingPriorty) -> TCFundamentals.ErrorReportingPriorty {
        diagnosticRank >= other.diagnosticRank ? self : other
    }
}
