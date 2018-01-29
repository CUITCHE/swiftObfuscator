import SwiftSyntax

class Renamer: SyntaxRewriter {
    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        if node.identifier.text == "foo" {
            return super.visit(node.withIdentifier(SyntaxFactory.makeIdentifier("bar")))
        } else {
            return super.visit(node)
        }
    }
}
