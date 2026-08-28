import Web
import TCFundamentals

/// Shared empty-state presentation for catalog, list, and detail views.
func emptyState(
    _ title: String,
    _ subtitle: String? = nil
) -> Div {
    Div {
        
        if let subtitle, !subtitle.isEmpty {
            
            USubTitle(title)
                .custom("align-content", "end")

            UMinorTitle(subtitle)
                .custom("line-height", "1.4")
                .marginTop(4.px)
        }
        else {
            USubTitle(title)
                .custom("align-content", "center")    
        }
    }
    .custom("border", "1px dashed rgba(66, 183, 245, 0.3)")
    .id(.init("emptyState_\(callKey(7))"))
    .custom("border-radius", "10px")
    .padding(all: 18.px)
    .textAlign(.center)
    .height(100.percent)
    .display(.grid)

}
