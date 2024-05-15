import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UserStoryMacro: MemberMacro, ExtensionMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.macroAppliedToUnsupportedDeclaration
        }

        let userStory = getUserStoryValue(structDeclaration)

        guard !userStory.isEmpty else {
            throw MacroError.macroArgumentCannotBeEmpty
        }

        let variable = try VariableDeclSyntax("static let userStory: String = \(raw: userStory)")

        return [DeclSyntax(variable)]
    }

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.macroAppliedToUnsupportedDeclaration
        }

        let userStory = getUserStoryValue(structDeclaration)

        guard !userStory.isEmpty else {
            throw MacroError.macroArgumentCannotBeEmpty
        }

        let filteredAttributes = structDeclaration
            .attributes
            .filter {
                $0
                    .as(AttributeSyntax.self)?.attributeName
                    .as(IdentifierTypeSyntax.self)?.name.text != "UserStory"
            }

        let modifiers = structDeclaration.modifiers

        let applyUserStoryFunction =
                """
                static func applyUserStory() -> some View {
                    previews
                        .previewUserStory(Self.userStory)
                }
                """

        let extensionSyntax = ExtensionDeclSyntax(
            attributes: filteredAttributes,
            modifiers: modifiers,
            extensionKeyword: .keyword(.extension),
            extendedType: TypeSyntax(stringLiteral: structDeclaration.name.text),
            inheritanceClause: nil,
            genericWhereClause: nil,
            memberBlock: MemberBlockSyntax(members: MemberBlockItemListSyntax(stringLiteral: applyUserStoryFunction))
        )

        return [extensionSyntax]
    }

    private static func getUserStoryValue(_ structDeclaration: StructDeclSyntax) -> String {
        let labeledExprListSyntax = structDeclaration.attributes.first?
            .as(AttributeSyntax.self)?.arguments?
            .as(LabeledExprListSyntax.self)?.first?.expression

        let userStoryStringLiteral = labeledExprListSyntax?
            .as(StringLiteralExprSyntax.self)?.segments.first?
            .as(StringSegmentSyntax.self)?.content.text

        let memberAccessExprSyntax = labeledExprListSyntax?
            .as(MemberAccessExprSyntax.self)

        let propertyBase = memberAccessExprSyntax?.base?
            .as(DeclReferenceExprSyntax.self)?.baseName.text

        let propertySign = memberAccessExprSyntax?.period.text

        let propertyName = memberAccessExprSyntax?.declName
            .as(DeclReferenceExprSyntax.self)?.baseName.text

        let userStoryStaticProperty = [propertyBase, propertySign, propertyName].compactMap { $0 }.joined()

        let userStory: String

        if let userStoryStringLiteral, !userStoryStringLiteral.isEmpty {
            userStory = "\"\(userStoryStringLiteral)\""
        } else {
            userStory = userStoryStaticProperty
        }

        return userStory
    }
}
