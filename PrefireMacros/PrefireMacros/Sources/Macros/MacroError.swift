import Foundation

enum MacroError: Error {
    case macroAppliedToUnsupportedDeclaration
    case macroArgumentCannotBeEmpty
}

extension MacroError: CustomStringConvertible {
    var description: String {
        switch self {
        case .macroAppliedToUnsupportedDeclaration:
            return "Invalid usage: macro applied to unsupported declaration"
        case .macroArgumentCannotBeEmpty:
            return "Invalid usage: macro argument cannot be empty"
        }
    }
}
