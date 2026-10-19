import TCFundamentals

extension BillingType {

    /// Applies the billing direction without changing the stored price or quantity.
    func signedAmount(_ amount: Int64) -> Int64 {
        self == .adjustment ? -amount : amount
    }
}
