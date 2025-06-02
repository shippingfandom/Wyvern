Wyvern.BoundNodeKind = {}
// Statements
Wyvern.BoundNodeKind.BlockStatement      = Wyvern.auto()
Wyvern.BoundNodeKind.ExpressionStatement = Wyvern.auto()
Wyvern.BoundNodeKind.VariableDeclaration = Wyvern.auto()
Wyvern.BoundNodeKind.IfStatement         = Wyvern.auto()
Wyvern.BoundNodeKind.SwitchStatement     = Wyvern.auto()
Wyvern.BoundNodeKind.WhileStatement      = Wyvern.auto()
Wyvern.BoundNodeKind.DoWhileStatement    = Wyvern.auto()
Wyvern.BoundNodeKind.ForStatement        = Wyvern.auto()
Wyvern.BoundNodeKind.ForeachStatement    = Wyvern.auto()
Wyvern.BoundNodeKind.BreakStatement      = Wyvern.auto()
Wyvern.BoundNodeKind.ContinueStatement   = Wyvern.auto()
Wyvern.BoundNodeKind.ReturnStatement     = Wyvern.auto()
Wyvern.BoundNodeKind.CaseBodyStatement   = Wyvern.auto()
Wyvern.BoundNodeKind.CaseStatement       = Wyvern.auto()

// Expressions
Wyvern.BoundNodeKind.UnaryExpression             = Wyvern.auto()
Wyvern.BoundNodeKind.LiteralExpression           = Wyvern.auto()
Wyvern.BoundNodeKind.BinaryExpression            = Wyvern.auto()
Wyvern.BoundNodeKind.VariableExpression          = Wyvern.auto()
Wyvern.BoundNodeKind.AssignmentExpression        = Wyvern.auto()
Wyvern.BoundNodeKind.CallingAssignmentExpression = Wyvern.auto()
Wyvern.BoundNodeKind.CallExpression              = Wyvern.auto()
Wyvern.BoundNodeKind.ConversionExpression        = Wyvern.auto()
Wyvern.BoundNodeKind.ErrorExpression             = Wyvern.auto()
Wyvern.BoundNodeKind.ArrayExpression             = Wyvern.auto()
Wyvern.BoundNodeKind.IndexExpression             = Wyvern.auto()
Wyvern.BoundNodeKind.MapExpression               = Wyvern.auto()
Wyvern.BoundNodeKind.ParenthesizedExpression     = Wyvern.auto()
Wyvern.BoundNodeKind.NamecallExpression          = Wyvern.auto()
Wyvern.BoundNodeKind.NewExpression               = Wyvern.auto()
Wyvern.BoundNodeKind.NewStructExpression         = Wyvern.auto()

// Nodes
Wyvern.BoundNodeKind.Parameter            = Wyvern.auto()
Wyvern.BoundNodeKind.Pair                 = Wyvern.auto()
Wyvern.BoundNodeKind.FunctionDeclaration  = Wyvern.auto()
Wyvern.BoundNodeKind.ClassDeclaration     = Wyvern.auto()
Wyvern.BoundNodeKind.StructDeclaration    = Wyvern.auto()
Wyvern.BoundNodeKind.MSImport             = Wyvern.auto()
Wyvern.BoundNodeKind.Import               = Wyvern.auto()
Wyvern.BoundNodeKind.EnumDeclaration      = Wyvern.auto()
Wyvern.BoundNodeKind.EnumMember           = Wyvern.auto()
Wyvern.BoundNodeKind.StructArgument       = Wyvern.auto()

Wyvern.auto(true)

Wyvern.BoundNodeKind.ToString = function(nKind)
    for kvI in Wyvern.BoundNodeKind
        if kvI.value == nKind then
            return kvI.key
        end if
    end for

    return "Unkown"
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundNode = {"Kind":-1}

Wyvern.BoundNode.GetChildren = function()
    children = []
    for k in self
        if k.key == "__isa" then continue
        if typeof(@k.value) == "function" then continue
        if typeof(k.value) == "map" then
            if Wyvern.IsA(Wyvern.BoundNode, k.value) then
                children.push(k.value)
            end if
        else if typeof(k.value) == "list" then
            for v in k.value
                if Wyvern.IsA(Wyvern.BoundNode, v) then
                    children.push(v)
                end if
            end for
        end if
    end for
    return children
end function

Wyvern.BoundNode.GetText = function(node)
    if Wyvern.IsA(Wyvern.BoundBinaryExpression, node) then
        return Wyvern.GetKey(Wyvern.BoundBinaryOperatorKind, node.Op.Kind) + "Expression"
    end if

    if Wyvern.IsA(Wyvern.BoundUnaryExpression, node) then
        return Wyvern.GetKey(Wyvern.BoundUnaryExpression, node.Op.Kind) + "Expression"
    end if

    return Wyvern.GetKey(Wyvern.BoundNodeKind, node.Kind)
end function

Wyvern.FindASTStringable = function(value, depth=false)
    if value.hasIndex("ToString") then
        return value.ToString()
    else if value.hasIndex("Name") then
        return value.Name
    else if typeof(value) == "list" then
        if depth then
            return "[...]"
        end if
        f = []
        for i in value
            f.push(Wyvern.FindASTStringable(value, true))
        end for
        return f.join(", ")
    else if value.hasIndex("Value") then
        return str(Wyvern.ConstantFolding.UnravelConstants(value))
    else if Wyvern.FindTypeName(value).len != 0 then
        return "(" + Wyvern.FindTypeName(value).pop() + ")"
    else
        return str(value).replace(char(0), "\0")
    end if
end function

Wyvern.BoundNode.PrettyPrint = function(node, indent="", out=null, isConsole=false)
    buf = []
    buf.push(indent)

    if isConsole then
        color = "#00FFFF"
        if Wyvern.IsA(Wyvern.BoundExpression, node) then
            color = "#0000FF"
        end if

        buf.push("<color=" + color + ">" + self.GetText(node) + "</color>")
    else
        buf.push(Wyvern.BoundNodeKind.ToString(node.Kind))
    end if

    if Wyvern.IsA(Wyvern.BoundExpression, node) then
        properties = []
        for prop in node
            if prop.key == "__isa" then continue
            if prop.key == "Kind" then continue
            if typeof(@prop.value) == "function" then continue
            if typeof(prop.value) == "map" or typeof(prop.value) == "list" then
                if Wyvern.IsA(Wyvern.BoundNode, prop.value) or Wyvern.IsA(Wyvern.BoundBinaryOperator, prop.value) or Wyvern.IsA(Wyvern.BoundUnaryOperator, prop.value) then
                    continue
                end if

                //prop.value = Wyvern.FindTypeName(prop.value).pop()
                prop.value = Wyvern.FindASTStringable(prop.value)
            end if

            if isConsole then
                properties.push("<color=#FFFF33>" + prop.key + "</color> = <color=#FFD700>" + prop.value + "</color>")
            else
                properties.push(prop.key + " = " + @prop.value)
            end if
        end for

        if properties.len > 0 then
            buf.push(" " + properties.join(", "))
        end if
    end if

    if out != null then
        out.push(buf.join(""))
    end if

    indent = indent + "    "

    for child in node.GetChildren()
        self.PrettyPrint(child, indent, out, isConsole)
    end for
end function

Wyvern.BoundNode.WriteTo = function(out, isConsole=false)
    self.PrettyPrint(self, "", out, isConsole)
end function

Wyvern.BoundNode.ToString = function(isConsole=false)
    out = []
    self.WriteTo(out, isConsole)
    return out.join(char(10))
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundExpression = new Wyvern.BoundNode + {"Type":"", "ConstantValue":-1}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundConstant = {"Value":-1}

Wyvern.BoundConstant.Init = function(value)
    self.Value = value
end function

Wyvern.BoundConstant.New = function(value)
    newInstance = new Wyvern.BoundConstant
    newInstance.Init(value)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.ConstantFolding = {}

Wyvern.ConstantFolding.CheckForValue = function(boundExpression)
    return boundExpression.hasIndex("ConstantValue")
end function

Wyvern.ConstantFolding.FoldUnary = function(op, operand)
    if not self.CheckForValue(operand) then
        return null
    end if

    if op.Kind == Wyvern.BoundUnaryOperatorKind.Negation then
        return Wyvern.BoundConstant.New(-self.UnravelConstants(operand.ConstantValue))
    else if op.Kind == Wyvern.BoundUnaryOperatorKind.LogicalNegation then
        return Wyvern.BoundConstant.New(not self.UnravelConstants(operand.ConstantValue))
    else if op.Kind == Wyvern.BoundUnaryOperatorKind.BitwiseComplement then
        return Wyvern.BoundConstant.New(bitwise("~", self.UnravelConstants(operand.ConstantValue)))
    else
        exit("Unexpected unary operator kind: " + Wyvern.GetKey(Wyvern.BoundUnaryOperatorKind, op.Kind))
    end if
end function

Wyvern.ConstantFolding.UnravelConstants = function(constant)
    if typeof(constant) == "map" and Wyvern.IsA(Wyvern.BoundConstant, constant) then
        return self.UnravelConstants(constant.Value)
    end if

    return constant
end function

Wyvern.ConstantFolding.FoldBinary = function(left, op, right)
    if self.CheckForValue(left) then
        leftConstant = left.ConstantValue
    else
        leftConstant = null
    end if

    if self.CheckForValue(right) then
        rightConstant = right.ConstantValue
    else
        rightConstant = null
    end if

    if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalAnd then
        if leftConstant != null and not leftConstant.Value or rightConstant != null and not rightConstant.Value then
            return Wyvern.BoundConstant.New(false)
        end if
    end if

    if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalOr then
        if leftConstant != null and leftConstant.Value or rightConstant != null and rightConstant.Value then
            return Wyvern.BoundConstant.New(true)
        end if
    end if

    if leftConstant == null or rightConstant == null then
        return null
    end if

    l = self.UnravelConstants(leftConstant.Value)
    r = self.UnravelConstants(rightConstant.Value)

    if l == null or r == null then
        return null
    end if

    if op.Kind == Wyvern.BoundBinaryOperatorKind.Addition then
        return Wyvern.BoundConstant.New(l + r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.Subtraction then
        return Wyvern.BoundConstant.New(l - r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.Multiplication then
        return Wyvern.BoundConstant.New(l * r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.Division then
        return Wyvern.BoundConstant.New(l / r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.Modulus then
        return Wyvern.BoundConstant.New(l % r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.Exponentiation then
        return Wyvern.BoundConstant.New(l ^ r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.BitwiseAnd then
        return Wyvern.BoundConstant.New(bitwise("&", l, r))
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.BitwiseOr then
        return Wyvern.BoundConstant.New(bitwise("|", l, r))
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.BitwiseXor then
        return Wyvern.BoundConstant.New(bitwise("^", l, r))
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.BitwiseLeftShift then
        return Wyvern.BoundConstant.New(bitwise("<<", l, r))
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.BitwiseRightShift then
        return Wyvern.BoundConstant.New(bitwise(">>", l, r))
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.BitwiseUnsignedRightShift then
        return Wyvern.BoundConstant.New(bitwise(">>>", l, r))
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalEquals then
        return Wyvern.BoundConstant.New(l == r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalNotEquals then
        return Wyvern.BoundConstant.New(l != r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalLessThan then
        return Wyvern.BoundConstant.New(l < r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalLessThanOrEqual then
        return Wyvern.BoundConstant.New(l <= r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalGreater then
        return Wyvern.BoundConstant.New(l > r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalGreaterOrEqual then
        return Wyvern.BoundConstant.New(l >= r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalAnd then
        return Wyvern.BoundConstant.New(l and r)
    else if op.Kind == Wyvern.BoundBinaryOperatorKind.LogicalOr then
        return Wyvern.BoundConstant.New(l or r)
    else
        exit("Unexpected binary operator kind: " + Wyvern.GetKey(Wyvern.BoundBinaryOperatorKind, op.Kind))
    end if
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundCallExpression = new Wyvern.BoundExpression + {"Function":-1, "Arguments":-1}

Wyvern.BoundCallExpression.Init = function(func, arguments)
    self.Function = func
    self.Arguments = arguments

    self.Type = func.Type
    self.Kind = Wyvern.BoundNodeKind.CallExpression
end function

Wyvern.BoundCallExpression.New = function(func, arguments)
    newInstance = new Wyvern.BoundCallExpression
    newInstance.Init(func, arguments)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundStructArgument = new Wyvern.BoundNode + {"Name":-1, "Symbol":-1, "Expression":-1}

Wyvern.BoundStructArgument.Init = function(name, symbol, expression)
    self.Name = name
    self.Symbol = symbol
    self.Expression = expression

    self.Kind = Wyvern.BoundNodeKind.StructArgument
end function

Wyvern.BoundStructArgument.New = function(name, symbol, expression)
    newInstance = new Wyvern.BoundStructArgument
    newInstance.Init(name, symbol, expression)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundNewStructExpression = new Wyvern.BoundExpression + {"Type":-1, "Arguments":-1}

Wyvern.BoundNewStructExpression.Init = function(type, arguments)
    self.Type = type
    self.Arguments = arguments

    self.Kind = Wyvern.BoundNodeKind.NewStructExpression
end function

Wyvern.BoundNewStructExpression.New = function(type, arguments)
    newInstance = new Wyvern.BoundNewStructExpression
    newInstance.Init(type, arguments)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundNewExpression = new Wyvern.BoundExpression + {"Type":-1, "Arguments":-1}

Wyvern.BoundNewExpression.Init = function(type, arguments)
    self.Type = type
    self.Arguments = arguments

    self.Kind = Wyvern.BoundNodeKind.NewExpression
end function

Wyvern.BoundNewExpression.New = function(type, arguments)
    newInstance = new Wyvern.BoundNewExpression
    newInstance.Init(type, arguments)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundNamecallExpression = new Wyvern.BoundExpression + {"Left":-1, "Right":-1}

Wyvern.BoundNamecallExpression.Init = function(left, right)
    self.Left = left
    self.Right = right

    if right.hasIndex("ConstantValue") and right.ConstantValue != null then
        self.ConstantValue = right.ConstantValue
    end if

    self.Type = right.Type
    self.Kind = Wyvern.BoundNodeKind.NamecallExpression
end function

Wyvern.BoundNamecallExpression.New = function(left, right)
    newInstance = new Wyvern.BoundNamecallExpression
    newInstance.Init(left, right)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundStatement = new Wyvern.BoundNode

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundIfStatement = new Wyvern.BoundStatement + {"Condition":-1, "ThenStatement":-1, "ElseStatement":-1}

Wyvern.BoundIfStatement.Init = function(condition, thenStatement, elseStatement)
    self.Condition = condition
    self.ThenStatement = thenStatement
    self.ElseStatement = elseStatement
    self.Kind = Wyvern.BoundNodeKind.IfStatement
end function

Wyvern.BoundIfStatement.New = function(condition, thenStatement, elseStatement)
    newInstance = new Wyvern.BoundIfStatement
    newInstance.Init(condition, thenStatement, elseStatement)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundSwitchStatement = new Wyvern.BoundStatement + {"Expression":-1, "Cases":-1, "Default":-1}

Wyvern.BoundSwitchStatement.Init = function(expression, cases, default)
    self.Expression = expression
    self.Cases = cases
    self.Default = default

    self.Kind = Wyvern.BoundNodeKind.SwitchStatement
end function

Wyvern.BoundSwitchStatement.New = function(expression, cases, default)
    newInstance = new Wyvern.BoundSwitchStatement
    newInstance.Init(expression, cases, default)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundCaseStatement = new Wyvern.BoundStatement + {"Cases":-1, "Body":-1}

Wyvern.BoundCaseStatement.Init = function(cases, body)
    self.Cases = cases
    self.Body = body
    
    self.Kind = Wyvern.BoundNodeKind.CaseStatement
end function

Wyvern.BoundCaseStatement.New = function(cases, body)
    newInstance = new Wyvern.BoundCaseStatement
    newInstance.Init(cases, body)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundWhileStatement = new Wyvern.BoundStatement + {"Condition":-1, "Body":-1}

Wyvern.BoundWhileStatement.Init = function(condition, body)
    self.Condition = condition
    self.Body = body
    self.Kind = Wyvern.BoundNodeKind.WhileStatement
end function

Wyvern.BoundWhileStatement.New = function(condition, body)
    newInstance = new Wyvern.BoundWhileStatement
    newInstance.Init(condition, body)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundDoWhileStatement = new Wyvern.BoundStatement + {"Condition":-1, "Body":-1}

Wyvern.BoundDoWhileStatement.Init = function(condition, body)
    self.Condition = condition
    self.Body = body
    self.Kind = Wyvern.BoundNodeKind.DoWhileStatement
end function

Wyvern.BoundDoWhileStatement.New = function(condition, body)
    newInstance = new Wyvern.BoundDoWhileStatement
    newInstance.Init(condition, body)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundForStatement = new Wyvern.BoundStatement + {"Pre":-1, "Condition":-1, "Post":-1, "Body":-1}

Wyvern.BoundForStatement.Init = function(pre, condition, post, body)
    self.Pre = pre
    self.Condition = condition
    self.Post = post
    self.Body = body
    self.Kind = Wyvern.BoundNodeKind.ForStatement
end function

Wyvern.BoundForStatement.New = function(pre, condition, post, body)
    newInstance = new Wyvern.BoundForStatement
    newInstance.Init(pre, condition, post, body)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundForeachStatement = new Wyvern.BoundStatement + {"Variable":-1, "Iterator":-1, "Body":-1}

Wyvern.BoundForeachStatement.Init = function(variable, iterator, body)
    self.Variable = variable
    self.Iterator = iterator
    self.Body = body
    self.Kind = Wyvern.BoundNodeKind.ForeachStatement
end function

Wyvern.BoundForeachStatement.New = function(variable, iterator, body)
    newInstance = new Wyvern.BoundForeachStatement
    newInstance.Init(variable, iterator, body)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundBlockStatement = new Wyvern.BoundStatement + {"Statements":-1}

Wyvern.BoundBlockStatement.Init = function(statements)
    self.Statements = statements
    self.Kind = Wyvern.BoundNodeKind.BlockStatement
end function

Wyvern.BoundBlockStatement.New = function(statements)
    newInstance = new Wyvern.BoundBlockStatement
    newInstance.Init(statements)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundCaseBodyStatement = new Wyvern.BoundStatement + {"Statements":-1}

Wyvern.BoundCaseBodyStatement.Init = function(statements)
    self.Statements = statements
    self.Kind = Wyvern.BoundNodeKind.CaseBodyStatement
end function

Wyvern.BoundCaseBodyStatement.New = function(statements)
    newInstance = new Wyvern.BoundCaseBodyStatement
    newInstance.Init(statements)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundReturnStatement = new Wyvern.BoundStatement + {"Expression":-1}

Wyvern.BoundReturnStatement.Init = function(expression)
    self.Expression = expression
    self.Kind = Wyvern.BoundNodeKind.ReturnStatement
end function

Wyvern.BoundReturnStatement.New = function(expression)
    newInstance = new Wyvern.BoundReturnStatement
    newInstance.Init(expression)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundVariableDeclaration = new Wyvern.BoundStatement + {"Name":-1, "Variable":-1, "Initializer":-1}

Wyvern.BoundVariableDeclaration.Init = function(variable, initializer)
    self.Name = variable.Name
    self.Variable = variable
    self.Initializer = initializer
    self.Symbol = variable
    self.Kind = Wyvern.BoundNodeKind.VariableDeclaration
end function

Wyvern.BoundVariableDeclaration.New = function(variable, initializer)
    newInstance = new Wyvern.BoundVariableDeclaration
    newInstance.Init(variable, initializer)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundExpressionStatement = new Wyvern.BoundStatement + {"Expression":-1}

Wyvern.BoundExpressionStatement.Init = function(expression)
    self.Expression = expression
    self.Kind = Wyvern.BoundNodeKind.ExpressionStatement
end function

Wyvern.BoundExpressionStatement.New = function(expression)
    newInstance = new Wyvern.BoundExpressionStatement
    newInstance.Init(expression)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundBreakStatement = new Wyvern.BoundStatement

Wyvern.BoundBreakStatement.Init = function()
    self.Kind = Wyvern.BoundNodeKind.BreakStatement
end function

Wyvern.BoundBreakStatement.New = function()
    newInstance = new Wyvern.BoundBreakStatement
    newInstance.Init()
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundContinueStatement = new Wyvern.BoundStatement

Wyvern.BoundContinueStatement.Init = function()
    self.Kind = Wyvern.BoundNodeKind.ContinueStatement
end function

Wyvern.BoundContinueStatement.New = function()
    newInstance = new Wyvern.BoundContinueStatement
    newInstance.Init()
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundLiteralExpression = new Wyvern.BoundExpression + {"Value":-1}

Wyvern.BoundLiteralExpression.Init = function(literalExpression)
    self.Value = literalExpression.Value
    typeName = Wyvern.GetTokenType(literalExpression.LiteralToken)
    self.Type = Wyvern.TypeSymbol.GetType(typeName)
    if self.Type == null then
        exit("Unexpected literal '" + literalExpression.Value + "' of type '" + typeName + "'")
    end if
    self.ConstantValue = Wyvern.BoundConstant.New(literalExpression.Value)
    self.Kind = Wyvern.BoundNodeKind.LiteralExpression
end function

Wyvern.BoundLiteralExpression.New = function(literalToken)
    newInstance = new Wyvern.BoundLiteralExpression
    newInstance.Init(literalToken)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundUnaryOperatorKind = {}
Wyvern.BoundUnaryOperatorKind.Negation          = Wyvern.auto()
Wyvern.BoundUnaryOperatorKind.LogicalNegation   = Wyvern.auto()
Wyvern.BoundUnaryOperatorKind.BitwiseComplement = Wyvern.auto()

Wyvern.auto(true)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundUnaryOperator = {"SyntaxKind":-1, "Kind":-1, "OperandType":-1, "Type":-1}

Wyvern.BoundUnaryOperator.Operators = []

Wyvern.BoundUnaryOperator.Init = function(syntaxKind, kind, operandType, resultType=null)
    self.SyntaxKind = syntaxKind
    self.Kind = kind
    self.OperandType = operandType
    if resultType == null then resultType = operandType
    self.Type = resultType
    self.Operators = []
end function

Wyvern.BoundUnaryOperator.New = function(syntaxKind, kind, operandType, resultType=null)
    newInstance = new Wyvern.BoundUnaryOperator
    newInstance.Init(syntaxKind, kind, operandType, resultType)
    return newInstance
end function

Wyvern.AddUnaryOperator = function(syntaxKind, kind, operandType, resultType=null)
    Wyvern.BoundUnaryOperator.Operators.push(Wyvern.BoundUnaryOperator.New(syntaxKind, kind, operandType, resultType))
end function

Wyvern.AddUnaryOperator(Wyvern.SyntaxKind.BangToken,  Wyvern.BoundUnaryOperatorKind.LogicalNegation,   Wyvern.TypeSymbols.Bool)
Wyvern.AddUnaryOperator(Wyvern.SyntaxKind.MinusToken, Wyvern.BoundUnaryOperatorKind.Negation,          Wyvern.TypeSymbols.Number)
Wyvern.AddUnaryOperator(Wyvern.SyntaxKind.TildeToken, Wyvern.BoundUnaryOperatorKind.BitwiseComplement, Wyvern.TypeSymbols.Number)
//Wyvern.AddUnaryOperator(Wyvern.SyntaxKind.AtToken,    Wyvern.BoundUnaryOperatorKind.Reference,         Wyvern.TypeSymbols.Any, Wyvern.TypeSymbols.Any)

Wyvern.BoundUnaryOperator.Bind = function(syntaxKind, operandType)
    for op in Wyvern.BoundUnaryOperator.Operators
        if op.SyntaxKind == syntaxKind and op.OperandType == operandType then return op
    end for

    return null
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundUnaryExpression = new Wyvern.BoundExpression + {"Op":-1, "Operand":-1}

Wyvern.BoundUnaryExpression.Init = function(op, operand)
    self.Op = op
    self.Operand = operand
    self.Type = op.Type
    self.ConstantValue = Wyvern.ConstantFolding.FoldUnary(op, operand)
    self.Kind = Wyvern.BoundNodeKind.UnaryExpression
end function

Wyvern.BoundUnaryExpression.New = function(op, operand)
    newInstance = new Wyvern.BoundUnaryExpression
    newInstance.Init(op, operand)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundBinaryOperatorKind = {}
Wyvern.BoundBinaryOperatorKind.Addition = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.Subtraction = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.Multiplication = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.Division = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.Modulus = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.Exponentiation = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.BitwiseAnd = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.BitwiseOr = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.BitwiseXor = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.BitwiseLeftShift = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.BitwiseRightShift = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.BitwiseUnsignedRightShift = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.LogicalEquals = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.LogicalNotEquals = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.LogicalLessThan = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.LogicalLessThanOrEqual = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.LogicalGreater = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.LogicalGreaterOrEqual = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.LogicalAnd = Wyvern.auto()
Wyvern.BoundBinaryOperatorKind.LogicalOr = Wyvern.auto()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundBinaryOperator = {"SyntaxKind":-1, "Kind":-1, "LeftType":-1, "RightType":-1, "Type":-1}

Wyvern.BoundBinaryOperator.Operators = []

Wyvern.BoundBinaryOperator.Init = function(syntaxKind, kind, leftType, rightType=null, resultType=null)
    self.SyntaxKind = syntaxKind
    self.Kind = kind
    self.LeftType = leftType
    if rightType == null then rightType = leftType
    self.RightType = rightType
    if resultType == null then resultType = leftType
    self.Type = resultType
end function

Wyvern.BoundBinaryOperator.Init2 = function(syntaxKind, kind, type, resultType)
    self.Init(syntaxKind, kind, type, type, resultType)
end function

Wyvern.BoundBinaryOperator.New = function(syntaxKind, kind, leftType, rightType=null, resultType=null)
    newInstance = new Wyvern.BoundBinaryOperator
    newInstance.Init(syntaxKind, kind, leftType, rightType, resultType)
    return newInstance
end function

Wyvern.BoundBinaryOperator.New2 = function(syntaxKind, kind, type, resultType)
    newInstance = new Wyvern.BoundBinaryOperator
    newInstance.Init2(syntaxKind, kind, type, resultType)
    return newInstance
end function

Wyvern.AddBinaryOperator = function(syntaxKind, kind, leftType, rightType=null, resultType=null)
    Wyvern.BoundBinaryOperator.Operators.push(Wyvern.BoundBinaryOperator.New(syntaxKind, kind, leftType, rightType, resultType))
end function

Wyvern.AddBinaryOperator2 = function(syntaxKind, kind, type, resultType)
    Wyvern.BoundBinaryOperator.Operators.push(Wyvern.BoundBinaryOperator.New2(syntaxKind, kind, type, resultType))
end function

Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.PlusToken,      Wyvern.BoundBinaryOperatorKind.Addition,        Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.MinusToken,     Wyvern.BoundBinaryOperatorKind.Subtraction,     Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.AsteriskToken,  Wyvern.BoundBinaryOperatorKind.Multiplication,  Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.SlashToken,     Wyvern.BoundBinaryOperatorKind.Division,        Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.PercentToken,   Wyvern.BoundBinaryOperatorKind.Modulus,         Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.CaretToken,     Wyvern.BoundBinaryOperatorKind.Exponentiation,  Wyvern.TypeSymbols.Number)

Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.AmpersandToken,              Wyvern.BoundBinaryOperatorKind.BitwiseAnd,                 Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.PipeToken,                   Wyvern.BoundBinaryOperatorKind.BitwiseOr,                  Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.CaretCaretToken,             Wyvern.BoundBinaryOperatorKind.BitwiseXor,                 Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.LessLessToken,               Wyvern.BoundBinaryOperatorKind.BitwiseLeftShift,           Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.GreaterGreaterToken,         Wyvern.BoundBinaryOperatorKind.BitwiseRightShift,          Wyvern.TypeSymbols.Number)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.GreaterGreaterGreaterToken,  Wyvern.BoundBinaryOperatorKind.BitwiseUnsignedRightShift,  Wyvern.TypeSymbols.Number)

Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.AmpersandAmpersandToken,  Wyvern.BoundBinaryOperatorKind.LogicalAnd,              Wyvern.TypeSymbols.Bool)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.PipePipeToken,            Wyvern.BoundBinaryOperatorKind.LogicalOr,               Wyvern.TypeSymbols.Bool)

Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.PlusToken,                Wyvern.BoundBinaryOperatorKind.Addition,               Wyvern.TypeSymbols.String)

Wyvern.AddBinaryOperator2(Wyvern.SyntaxKind.LessToken,                Wyvern.BoundBinaryOperatorKind.LogicalLessThan,         Wyvern.TypeSymbols.Number, Wyvern.TypeSymbols.Bool)
Wyvern.AddBinaryOperator2(Wyvern.SyntaxKind.LessEqualToken,           Wyvern.BoundBinaryOperatorKind.LogicalLessThanOrEqual,  Wyvern.TypeSymbols.Number, Wyvern.TypeSymbols.Bool)
Wyvern.AddBinaryOperator2(Wyvern.SyntaxKind.GreaterToken,             Wyvern.BoundBinaryOperatorKind.LogicalGreater,          Wyvern.TypeSymbols.Number, Wyvern.TypeSymbols.Bool)
Wyvern.AddBinaryOperator2(Wyvern.SyntaxKind.GreaterEqualToken,        Wyvern.BoundBinaryOperatorKind.LogicalGreaterOrEqual,   Wyvern.TypeSymbols.Number, Wyvern.TypeSymbols.Bool)

Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.PlusToken,                 Wyvern.BoundBinaryOperatorKind.Addition,                Wyvern.TypeSymbols.String, Wyvern.TypeSymbols.Number, Wyvern.TypeSymbols.String)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.AsteriskToken,             Wyvern.BoundBinaryOperatorKind.Multiplication,          Wyvern.TypeSymbols.String, Wyvern.TypeSymbols.Number, Wyvern.TypeSymbols.String)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.SlashToken,                Wyvern.BoundBinaryOperatorKind.Division,                Wyvern.TypeSymbols.String, Wyvern.TypeSymbols.Number, Wyvern.TypeSymbols.String)

Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.PlusToken,                 Wyvern.BoundBinaryOperatorKind.Addition,                Wyvern.ArraySymbol, Wyvern.ArraySymbol, Wyvern.ArraySymbol)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.AsteriskToken,             Wyvern.BoundBinaryOperatorKind.Multiplication,          Wyvern.ArraySymbol, Wyvern.TypeSymbols.Number, Wyvern.ArraySymbol)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.SlashToken,                Wyvern.BoundBinaryOperatorKind.Division,                Wyvern.ArraySymbol, Wyvern.TypeSymbols.Number, Wyvern.ArraySymbol)

Wyvern.AddBinaryOperator2(Wyvern.SyntaxKind.EqualsEqualsToken,        Wyvern.BoundBinaryOperatorKind.LogicalEquals,           Wyvern.EnumSymbol, Wyvern.TypeSymbols.Bool)
Wyvern.AddBinaryOperator2(Wyvern.SyntaxKind.BangEqualsToken,          Wyvern.BoundBinaryOperatorKind.LogicalNotEquals,        Wyvern.EnumSymbol, Wyvern.TypeSymbols.Bool)

Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.EqualsEqualsToken, Wyvern.BoundBinaryOperatorKind.LogicalEquals, Wyvern.TypeSymbols.Reference, Wyvern.FunctionReferenceSymbol, Wyvern.TypeSymbols.Bool)
Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.BangEqualsToken, Wyvern.BoundBinaryOperatorKind.LogicalNotEquals, Wyvern.TypeSymbols.Reference, Wyvern.FunctionReferenceSymbol, Wyvern.TypeSymbols.Bool)

for type in Wyvern.TypeSymbols.values
    Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.EqualsEqualsToken, Wyvern.BoundBinaryOperatorKind.LogicalEquals, type, Wyvern.TypeSymbols.Null, Wyvern.TypeSymbols.Bool)
    Wyvern.AddBinaryOperator(Wyvern.SyntaxKind.BangEqualsToken, Wyvern.BoundBinaryOperatorKind.LogicalNotEquals, type, Wyvern.TypeSymbols.Null, Wyvern.TypeSymbols.Bool)

    Wyvern.AddBinaryOperator2(Wyvern.SyntaxKind.EqualsEqualsToken,        Wyvern.BoundBinaryOperatorKind.LogicalEquals,    type, Wyvern.TypeSymbols.Bool)
    Wyvern.AddBinaryOperator2(Wyvern.SyntaxKind.BangEqualsToken,          Wyvern.BoundBinaryOperatorKind.LogicalNotEquals, type, Wyvern.TypeSymbols.Bool)
end for

Wyvern.BoundBinaryOperator.Bind = function(syntaxKind, leftType, rightType)
    originalLeftType = null
    originalRightType = null

    if Wyvern.IsA(Wyvern.ArraySymbol, leftType) or Wyvern.IsA(Wyvern.MapSymbol, leftType) or Wyvern.IsA(Wyvern.EnumSymbol, leftType) or leftType.Kind == Wyvern.SymbolKind.Enum or leftType.Kind == Wyvern.SymbolKind.FunctionReference then
        originalLeftType = leftType
        leftType = leftType.__isa
    end if

    if Wyvern.IsA(Wyvern.ArraySymbol, rightType) or Wyvern.IsA(Wyvern.MapSymbol, rightType) or Wyvern.IsA(Wyvern.EnumSymbol, rightType) or rightType.Kind == Wyvern.SymbolKind.Enum or rightType.Kind == Wyvern.SymbolKind.FunctionReference then
        originalRightType = rightType
        rightType = rightType.__isa
    end if

    if leftType == Wyvern.EnumSymbol and rightType == Wyvern.EnumSymbol then
        if originalLeftType != originalRightType then
            return null
        end if
    end if

    // Wyvern.TypeSymbols.Null
    if syntaxKind == Wyvern.SyntaxKind.EqualsEqualsToken then
        if leftType == Wyvern.TypeSymbols.Null or rightType == Wyvern.TypeSymbols.Null then
            return Wyvern.BoundBinaryOperator.New(syntaxKind, Wyvern.BoundBinaryOperatorKind.LogicalEquals, leftType, rightType, Wyvern.TypeSymbols.Bool)
        end if
    end if

    if syntaxKind == Wyvern.SyntaxKind.BangEqualsToken then
        if leftType == Wyvern.TypeSymbols.Null or rightType == Wyvern.TypeSymbols.Null then
            return Wyvern.BoundBinaryOperator.New(syntaxKind, Wyvern.BoundBinaryOperatorKind.LogicalNotEquals, leftType, rightType, Wyvern.TypeSymbols.Bool)
        end if
    end if

    operator = null
    for op in Wyvern.BoundBinaryOperator.Operators
        if op.SyntaxKind == syntaxKind and op.LeftType == leftType and op.RightType == rightType then
            operator = op
            break
        end if
    end for

    if operator == null then
        return null
    end if

    if operator.Type == Wyvern.ArraySymbol or operator.Type == Wyvern.MapSymbol then
        if originalLeftType == originalRightType then
            operator.Type = originalLeftType
        else
            if operator.Type == Wyvern.ArraySymbol then
                operator.Type = Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Any)
            else if operator.Type == Wyvern.MapSymbol then
                operator.Type = Wyvern.MapSymbol.New(Wyvern.TypeSymbols.Any, Wyvern.TypeSymbols.Any)
            end if
        end if
    end if

    return operator
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundBinaryExpression = new Wyvern.BoundExpression + {"Left":-1, "Op":-1, "Right":-1}

Wyvern.BoundBinaryExpression.Init = function(left, op, right)
    self.Left = left
    self.Op = op
    self.Right = right
    self.ConstantValue = Wyvern.ConstantFolding.FoldBinary(left, op, right)
    self.Type = op.Type
    self.Kind = Wyvern.BoundNodeKind.BinaryExpression
end function

Wyvern.BoundBinaryExpression.New = function(left, op, right)
    newInstance = new Wyvern.BoundBinaryExpression
    newInstance.Init(left, op, right)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundVariableExpression = new Wyvern.BoundExpression + {"Variable":-1}

Wyvern.BoundVariableExpression.Init = function(variable)
    self.Variable = variable
    if variable.hasIndex("Type") then
        self.Type = variable.Type
    else
        self.Type = variable
    end if

    if variable.hasIndex("Constant") then
        self.ConstantValue = Wyvern.BoundConstant.New(variable.Constant)
    else
        self.ConstantValue = null
    end if
    self.Kind = Wyvern.BoundNodeKind.VariableExpression
end function

Wyvern.BoundVariableExpression.New = function(variable)
    newInstance = new Wyvern.BoundVariableExpression
    newInstance.Init(variable)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundParenthesizedExpression = new Wyvern.BoundExpression + {"Expression":-1, "Type":-1}

Wyvern.BoundParenthesizedExpression.Init = function(expression)
    self.Expression = expression
    self.Type = expression.Type

    self.Kind = Wyvern.BoundNodeKind.ParenthesizedExpression
end function

Wyvern.BoundParenthesizedExpression.New = function(expression)
    newInstance = new Wyvern.BoundParenthesizedExpression
    newInstance.Init(expression)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundErrorExpression = new Wyvern.BoundExpression

Wyvern.BoundErrorExpression.Init = function()
    self.Type = Wyvern.TypeSymbols.Error
    self.Kind = Wyvern.BoundNodeKind.ErrorExpression
end function

Wyvern.BoundErrorExpression.New = function()
    newInstance = new Wyvern.BoundErrorExpression
    newInstance.Init()
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundAssignmentExpression = new Wyvern.BoundExpression + {"Variable":-1, "Expression":-1}

Wyvern.BoundAssignmentExpression.Init = function(variable, expression)
    self.Variable = variable
    self.Expression = expression
    self.Type = expression.Type
    self.Kind = Wyvern.BoundNodeKind.AssignmentExpression
end function

Wyvern.BoundAssignmentExpression.New = function(variable, expression)
    newInstance = new Wyvern.BoundAssignmentExpression
    newInstance.Init(variable, expression)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundCallingAssignmentExpression = new Wyvern.BoundExpression + {"Change":-1, "Expression":-1}

Wyvern.BoundCallingAssignmentExpression.Init = function(change, expression)
    self.Change = change
    self.Expression = expression
    self.Type = expression.Type
    self.Kind = Wyvern.BoundNodeKind.CallingAssignmentExpression
end function

Wyvern.BoundCallingAssignmentExpression.New = function(change, expression)
    newInstance = new Wyvern.BoundCallingAssignmentExpression
    newInstance.Init(change, expression)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundConversionExpression = new Wyvern.BoundExpression + {"Expression":-1, "Type":-1, "IsUnsafe":-1}

Wyvern.BoundConversionExpression.Init = function(type, expression, isUnsafe=false)
    self.Expression = expression
    self.Type = type
    self.IsUnsafe = isUnsafe
    self.Kind = Wyvern.BoundNodeKind.ConversionExpression
end function

Wyvern.BoundConversionExpression.New = function(type, expression, isUnsafe=false)
    newInstance = new Wyvern.BoundConversionExpression
    newInstance.Init(type, expression, isUnsafe)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundParameter = new Wyvern.BoundNode + {"Name":-1, "Type":-1, "Initializer":-1}

Wyvern.BoundParameter.Init = function(name, type, initializer=null)
    self.Name = name
    self.Type = type
    self.Initializer = initializer
    self.Kind = Wyvern.BoundNodeKind.Parameter
end function

Wyvern.BoundParameter.New = function(name, type, initializer=null)
    newInstance = new Wyvern.BoundParameter
    newInstance.Init(name, type, initializer)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundFunctionDeclaration = new Wyvern.BoundNode + {"Name":-1, "Parameters":-1, "Type":-1, "Body":-1, "Symbol":-1}

Wyvern.BoundFunctionDeclaration.Init = function(name, parameters, type, body, symbol=null)
    self.Name = name
    self.Parameters = parameters
    self.Type = type
    self.Body = body
    self.Symbol = symbol
    self.Kind = Wyvern.BoundNodeKind.FunctionDeclaration
end function

Wyvern.BoundFunctionDeclaration.New = function(name, parameters, type, body, symbol=null)
    newInstance = new Wyvern.BoundFunctionDeclaration
    newInstance.Init(name, parameters, type, body, symbol)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundClassDeclaration = new Wyvern.BoundNode + {"Name":-1, "ExtensionType":-1, "Members":-1, "Symbol":-1}

Wyvern.BoundClassDeclaration.Init = function(name, extensionType, members, symbol=null)
    self.Name = name
    self.ExtensionType = extensionType
    self.Members = members
    self.Symbol = symbol

    self.Kind = Wyvern.BoundNodeKind.ClassDeclaration
end function

Wyvern.BoundClassDeclaration.New = function(name, extensionType, members, symbol=null)
    newInstance = new Wyvern.BoundClassDeclaration
    newInstance.Init(name, extensionType, members, symbol)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundStructDeclaration = new Wyvern.BoundNode + {"Name":-1, "Members":-1, "Symbol":-1}

Wyvern.BoundStructDeclaration.Init = function(name, members, symbol)
    self.Name = name
    self.Members = members
    self.Symbol = symbol

    self.Kind = Wyvern.BoundNodeKind.StructDeclaration
end function

Wyvern.BoundStructDeclaration.New = function(name, members, symbol)
    newInstance = new Wyvern.BoundStructDeclaration
    newInstance.Init(name, members)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundImport = new Wyvern.BoundNode + {"Path":-1, "GlobalScope":-1, "File":-1}

Wyvern.BoundImport.Init = function(path, file, globalScope)
    self.Path = path
    self.GlobalScope = globalScope
    self.File = file

    self.Kind = Wyvern.BoundNodeKind.Import
end function

Wyvern.BoundImport.New = function(path, file, globalScope)
    newInstance = new Wyvern.BoundImport
    newInstance.Init(path, file, globalScope)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundMSImport = new Wyvern.BoundNode + {"Path":-1, "Members":-1}

Wyvern.BoundMSImport.Init = function(path, members)
    self.Path = path
    self.Members = members

    self.Kind = Wyvern.BoundNodeKind.MSImport
end function

Wyvern.BoundMSImport.New = function(path, members)
    newInstance = new Wyvern.BoundMSImport
    newInstance.Init(path, members)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundEnumMember = new Wyvern.BoundExpression + {"Name":-1, "Value":-1, "Symbol":-1}

Wyvern.BoundEnumMember.Init = function(name, value, type, symbol)
    self.Name = name
    if typeof(value) == "number" then
        self.ConstantValue = Wyvern.BoundConstant.New(value)
    else
        self.Value = value
        self.ConstantValue = value.ConstantValue
    end if
    self.Type = type
    self.Symbol = symbol
    self.Kind = Wyvern.BoundNodeKind.EnumMember
end function

Wyvern.BoundEnumMember.New = function(name, value, type, symbol=null)
    newInstance = new Wyvern.BoundEnumMember
    newInstance.Init(name, value, type, symbol)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundEnumDeclaration = new Wyvern.BoundNode + {"Name":-1, "Members":-1, "Symbol":-1}

Wyvern.BoundEnumDeclaration.Init = function(name, members, symbol)
    self.Name = name
    self.Members = members
    self.Symbol = symbol
    self.Kind = Wyvern.BoundNodeKind.EnumDeclaration
end function

Wyvern.BoundEnumDeclaration.New = function(name, members, symbol=null)
    newInstance = new Wyvern.BoundEnumDeclaration
    newInstance.Init(name, members, symbol)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundTypeMember = new Wyvern.BoundNode + {"IsPublic":-1, "IsPrivate":-1, "IsStatic":-1, "IsOverride":-1, "IsVirtual":-1, "Declaration":-1, "Symbol":-1}

Wyvern.BoundTypeMember.Init = function(isPublic, isStatic, isOverride, isVirtual, declaration, symbol=null)
    self.IsPublic = isPublic
    self.IsPrivate = not isPublic
    self.IsStatic = isStatic
    self.IsOverride = isOverride
    self.IsVirtual = isVirtual
    self.Declaration = declaration
    self.Symbol = symbol
end function

Wyvern.BoundTypeMember.New = function(isPublic, isStatic, isOverride, isVirtual, declaration, symbol=null)
    newInstance = new Wyvern.BoundTypeMember
    newInstance.Init(isPublic, isStatic, isOverride, isVirtual, declaration, symbol)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundArrayExpression = new Wyvern.BoundExpression + {"Items":-1, "Type":-1}

Wyvern.BoundArrayExpression.Init = function(items, type)
    self.Items = items
    self.Type = type
    self.Kind = Wyvern.BoundNodeKind.ArrayExpression
end function

Wyvern.BoundArrayExpression.New = function(items, type)
    newInstance = new Wyvern.BoundArrayExpression
    newInstance.Init(items, type)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundMapExpression = new Wyvern.BoundExpression + {"Pairs":-1, "KeyType":-1, "ValueType":-1}

Wyvern.BoundMapExpression.Init = function(pairs, keyType, valueType)
    self.Pairs = pairs
    self.KeyType = keyType
    self.ValueType = valueType
    self.Type = Wyvern.MapSymbol.New(keyType, valueType)

    self.Kind = Wyvern.BoundNodeKind.MapExpression
end function

Wyvern.BoundMapExpression.New = function(pairs, keyType, valueType)
    newInstance = new Wyvern.BoundMapExpression
    newInstance.Init(pairs, keyType, valueType)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundPair = new Wyvern.BoundNode + {"Key":-1, "Value":-1}

Wyvern.BoundPair.Init = function(key, value)
    self.Key = key
    self.Value = value

    self.Kind = Wyvern.BoundNodeKind.Pair
end function

Wyvern.BoundPair.New = function(key, value)
    newInstance = new Wyvern.BoundPair
    newInstance.Init(key, value)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundIndexExpression = new Wyvern.BoundExpression + {"Expression":-1, "Index":-1, "Type":-1}

Wyvern.BoundIndexExpression.Init = function(expression, index, type)
    self.Expression = expression
    self.Index = index
    self.Type = type

    self.Kind = Wyvern.BoundNodeKind.IndexExpression
end function

Wyvern.BoundIndexExpression.New = function(expression, index, type)
    newInstance = new Wyvern.BoundIndexExpression
    newInstance.Init(expression, index, type)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundScope = {"Symbols":-1, "Parent":-1}

Wyvern.BoundScope.Init = function(parent=null)
    self.Symbols = {}
    self.Parent = parent
end function

Wyvern.BoundScope.TryDeclareSymbol = function(symbol)
    if hasIndex(self.Symbols, symbol.Name) then
        return false
    end if

    self.Symbols[symbol.Name] = symbol
    return true
end function

Wyvern.BoundScope.TryLookupSymbol = function(name)
    if hasIndex(self.Symbols, name) then
        return self.Symbols[name]
    end if

    if self.Parent == null then
        return false
    end if

    return self.Parent.TryLookupSymbol(name)
end function

Wyvern.BoundScope.DeclareSymbol = function(symbol)
    self.Symbols[symbol.Name] = symbol
end function

Wyvern.BoundScope.UndeclareSymbol = function(symbol)
    remove(self.Symbols, symbol.Name)
end function

Wyvern.BoundScope.LookupSymbol = function(name, wrap=true)
    s = self._LookupSymbol(name)
    if s isa Wyvern.FunctionSymbol and wrap then
        return Wyvern.FunctionReferenceSymbol.New(s)
    end if
    return s
end function

Wyvern.BoundScope._LookupSymbol = function(name)
    if hasIndex(self.Symbols, name) then
        return self.Symbols[name]
    end if

    if self.Parent != null then
        return self.Parent.LookupSymbol(name)
    end if

    return null
end function

Wyvern.BoundScope.TryDeclareGlobalSymbol = function(symbol)
    if self.Parent == null then
        return self.TryDeclareSymbol(symbol)
    end if

    return self.Parent.TryDeclareGlobalSymbol(symbol)
end function

Wyvern.BoundScope.TryDeclareVariable = function(variable)
    return self.TryDeclareSymbol(variable)
end function

Wyvern.BoundScope.TryDeclareGlobalVariable = function(variable)
    if self.Parent == null then
        return self.TryDeclareVariable(variable)
    end if

    return self.Parent.TryDeclareGlobalVariable(variable)
end function

Wyvern.BoundScope.GetDeclaredFunctions = function()
    if self.Parent != null then
        result = self.Parent.GetDeclaredFunctions()
    else
        result = []
    end if

    for f in self.Symbols.values
        if Wyvern.IsA(Wyvern.FunctionSymbol, f) then
            result.push(f)
        end if
    end for

    return result
end function

Wyvern.BoundScope.GetDeclaredVariables = function()
    if self.Parent != null then
        result = self.Parent.GetDeclaredVariables()
    else
        result = []
    end if

    for v in self.Symbols.values
        if Wyvern.IsA(Wyvern.VariableSymbol, v) then
            result.push(v)
        end if
    end for

    return result
end function

Wyvern.BoundScope.GetDeclaredEnums = function()
    if self.Parent != null then
        result = self.Parent.GetDeclaredEnums()
    else
        result = []
    end if

    for e in self.Symbols.values
        if Wyvern.IsA(Wyvern.EnumSymbol, e) then
            result.push(e)
        end if
    end for

    return result
end function

Wyvern.BoundScope.GetDeclaredClasses = function()
    if self.Parent != null then
        result = self.Parent.GetDeclaredClasses()
    else
        result = []
    end if

    for c in self.Symbols.values
        if Wyvern.IsA(Wyvern.ClassSymbol, c) then
            result.push(c)
        end if
    end for

    return result
end function

Wyvern.BoundScope.GetDeclaredStructs = function()
    if self.Parent != null then
        result = self.Parent.GetDeclaredStructs()
    else
        result = []
    end if

    for s in self.Symbols.values
        if Wyvern.IsA(Wyvern.StructSymbol, s) then
            result.push(s)
        end if
    end for

    return result
end function

Wyvern.BoundScope.GetDeclaredContracts = function()
    if self.Parent != null then
        result = self.Parent.GetDeclaredContracts()
    else
        result = []
    end if

    for c in self.Symbols.values
        if Wyvern.IsA(Wyvern.ContractSymbol, c) then
            result.push(c)
        end if
    end for

    return result
end function

Wyvern.BoundScope.ToString = function()
    sb = []
    
    if self.Parent != null then
        sb.push(Wyvern.TabString(self.Parent.ToString()))
    end if

    for kv in self.Symbols
        if kv.value isa Wyvern.BuiltinFunctionSymbol or kv.value isa Wyvern.BuiltinVariableSymbol then
            continue
        end if
        sb.push(kv.key + " = " + kv.value.ToString())
    end for

    return sb.join(char(10))
end function

Wyvern.BoundScope.New = function(parent=null)
    newInstance = new Wyvern.BoundScope
    newInstance.Init(parent)
    return newInstance
end function
 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundGlobalScope = {"Previous":-1, "Diagnostics":-1, "Enums":-1, "Classes":-1, "Structs":-1, "Functions":-1, "Variables":-1, "Statement":-1, "BoundFunctions":-1, "MSImports":-1, "Imports":-1}

Wyvern.BoundGlobalScope.Init = function(previous, diagnostics, enums, classes, structs, functions, variables, statement, boundFunctions, msImports, imports)
    self.Previous = previous
    self.Diagnostics = diagnostics
    self.Functions = functions
    self.Variables = variables
    self.Classes = classes
    self.Structs = structs
    self.Enums = enums
    self.Statement = statement
    self.MSImports = msImports
    self.Imports = imports
    self.BoundFunctions = boundFunctions
end function

Wyvern.BoundGlobalScope.IsMiniscriptImport = function(member)
    for msImport in self.MSImports
        for msMember in msImport.Members
            if msMember == member then
                return true
            end if
        end for
    end for

    for import in self.Imports
        if import.GlobalScope.IsMiniscriptImport(member) then
            return true
        end if
    end for

    return false
end function

Wyvern.BoundGlobalScope.New = function(previous, diagnostics, enums, classes, structs, functions, variables, statement, boundFunctions, msImports, imports)
    newInstance = new Wyvern.BoundGlobalScope
    newInstance.Init(previous, diagnostics, enums, classes, structs, functions, variables, statement, boundFunctions, msImports, imports)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BoundProgram = {"GlobalScope":-1, "Diagnostics":-1, "FunctionBodies":-1, "BoundFunctions":-1}

Wyvern.BoundProgram.Init = function(globalScope, diagnostics, functionBodies, boundFunctions)
    self.GlobalScope = globalScope
    self.Diagnostics = diagnostics
    self.FunctionBodies = functionBodies
    self.BoundFunctions = boundFunctions
end function

Wyvern.BoundProgram.BoundClasses = function()
    classDeclarations = []
    for classSymbol in self.GlobalScope.Classes
        classDeclarations.push(classSymbol.Declaration)
    end for
    return classDeclarations
end function

Wyvern.BoundProgram.BoundStructs = function()
    structDeclarations = []
    for structSymbol in self.GlobalScope.Structs
        structDeclarations.push(structSymbol.Declaration)
    end for
    return structDeclarations
end function

Wyvern.BoundProgram.BoundEnums = function()
    enumDeclarations = []
    for enumSymbol in self.GlobalScope.Enums
        enumDeclarations.push(enumSymbol.Declaration)
    end for
    return enumDeclarations
end function

Wyvern.BoundProgram.BoundMSImports = function()
    msImports = []
    for msImport in self.GlobalScope.MSImports
        msImports.push(msImport)
    end for
    return msImports
end function

Wyvern.BoundProgram.New = function(globalScope, diagnostics, functionBodies, boundFunctions)
    newInstance = new Wyvern.BoundProgram
    newInstance.Init(globalScope, diagnostics, functionBodies, boundFunctions)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.Conversion = {"Exists":-1, "IsIdentity":-1, "IsExplicit":-1, "IsImplicit":-1}

Wyvern.Conversion.Init = function(exists, isIdentity, isImplicit)
    self.Exists = exists
    self.IsIdentity = isIdentity
    self.IsImplicit = isImplicit

    if exists and not isImplicit then
        self.IsExplicit = true
    else
        self.IsExplicit = false
    end if
end function

Wyvern.Conversion.New = function(exists, isIdentity, isImplicit)
    newInstance = new Wyvern.Conversion
    newInstance.Init(exists, isIdentity, isImplicit)
    return newInstance
end function

Wyvern.Conversions = {}
Wyvern.Conversions.None     = Wyvern.Conversion.New(false, false, false)
Wyvern.Conversions.Identity = Wyvern.Conversion.New(true , true , true )
Wyvern.Conversions.Implicit = Wyvern.Conversion.New(true , false, true )
Wyvern.Conversions.Explicit = Wyvern.Conversion.New(true , false, false)

Wyvern.Conversion.Classify = function(from, to)
    if from == to then
        return Wyvern.Conversions.Identity
    end if

    if from.Kind == Wyvern.SymbolKind.Class and to.Kind == Wyvern.SymbolKind.Class then
        if from.IsAncestor(to) then
            return Wyvern.Conversions.Implicit
        end if
    end if

    if from.Kind == Wyvern.SymbolKind.Class and to.Kind == Wyvern.SymbolKind.Contract then
        if from.HasContract(to) then
            return Wyvern.Conversions.Implicit
        end if
    end if

    if from.Kind == Wyvern.SymbolKind.EnumMember or from.Kind == Wyvern.SymbolKind.Enum then
        if to.Kind == Wyvern.SymbolKind.Enum then
            if from.Kind == Wyvern.SymbolKind.EnumMember and from.Enum == to then
                return Wyvern.Conversions.Identity
            end if
        end if

        if to == Wyvern.TypeSymbols.Number then
            return Wyvern.Conversions.Explicit
        end if

        if to == Wyvern.TypeSymbols.String then
            return Wyvern.Conversions.Explicit
        end if
    end if

    if from.Kind == Wyvern.SymbolKind.Array or to.Kind == Wyvern.SymbolKind.Array then
        return Wyvern.Conversion.ClassifyArray(from, to)
    end if

    if from.Kind == Wyvern.SymbolKind.Map or to.Kind == Wyvern.SymbolKind.Map then
        return Wyvern.Conversion.ClassifyMap(from, to)
    end if

    if from.Kind == Wyvern.SymbolKind.FunctionReference and to == Wyvern.TypeSymbols.Reference then
        return Wyvern.Conversions.Identity
    end if

    if from == Wyvern.TypeSymbols.Reference and to.Kind == Wyvern.SymbolKind.FunctionReference then
        return Wyvern.Conversions.Implicit
    end if

    if from == Wyvern.TypeSymbols.Shell then
        if to == Wyvern.TypeSymbols.FtpShell then
            return Wyvern.Conversions.Implicit
        end if
    end if

    if from == Wyvern.TypeSymbols.Library then
        if to == Wyvern.TypeSymbols.AptClient or to == Wyvern.TypeSymbols.Metaxploit or to == Wyvern.TypeSymbols.Crypto or to == Wyvern.TypeSymbols.Blockchain or to == Wyvern.TypeSymbols.Service then
            return Wyvern.Conversions.Implicit
        end if
    end if

    if (from != Wyvern.TypeSymbols.Void and from != Wyvern.TypeSymbols.Error) and to == Wyvern.TypeSymbols.Any then
        return Wyvern.Conversions.Identity
    end if

    if from == Wyvern.TypeSymbols.Null and (to != Wyvern.TypeSymbols.Void and to != Wyvern.TypeSymbols.Error) then
        return Wyvern.Conversions.Identity
    end if

    if from == Wyvern.TypeSymbols.Any and (to != Wyvern.TypeSymbols.Void and to != Wyvern.TypeSymbols.Error) then
        return Wyvern.Conversions.Implicit
    end if

    if from == Wyvern.TypeSymbols.Bool or from == Wyvern.TypeSymbols.Number then
        if to == Wyvern.TypeSymbols.String then
            return Wyvern.Conversions.Explicit
        end if
    end if

    if from == Wyvern.TypeSymbols.String then
        if to == Wyvern.TypeSymbols.Bool or to == Wyvern.TypeSymbols.Number then
            return Wyvern.Conversions.Explicit
        end if

        if to.Kind == Wyvern.SymbolKind.Enum then
            return Wyvern.Conversions.Explicit
        end if
    end if

    if from == Wyvern.TypeSymbols.Number then
        if to.Kind == Wyvern.SymbolKind.Enum then
            return Wyvern.Conversions.Explicit
        end if
    end if

    return Wyvern.Conversions.None
end function

Wyvern.Conversion.ClassifyArray = function(from, to)
    if from.Kind == Wyvern.SymbolKind.Type then
        fromType = from
    else
        fromType = from.Type
    end if

    if to.Kind == Wyvern.SymbolKind.Type then
        toType = to
    else
        toType = to.Type
    end if

    return Wyvern.Conversion.Classify(fromType, toType)
end function

Wyvern.Conversion.ClassifyMap = function(from, to)
    return Wyvern.Conversions.Implicit
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.Binder = {"Diagnostics":-1, "Function":-1, "Class":-1, "Scope":-1, "LoopCount":-1, "Statements":-1}

Wyvern.Binder.Init = function(parent, func=null) 
    self.Diagnostics = Wyvern.DiagnosticBag.New()
    self.Scope = Wyvern.BoundScope.New(parent)
    self.Function = func
    self.Class = null
    self.LoopCount = 0
    self.Statements = []

    if func != null then
        for p in func.Parameters
            self.Scope.TryDeclareVariable(p)
        end for
    end if
end function

Wyvern.Binder.New = function(parent, func=null)
    newInstance = new Wyvern.Binder
    newInstance.Init(parent, func)
    return newInstance
end function

Wyvern.Binder.BindGlobalScope = function(previous, syntax)
    parentScope = Wyvern.Binder.CreateParentScope(previous)
    if not self.hasIndex("__isa") then
        binder = Wyvern.Binder.New(parentScope)
    else
        binder = self
    end if

    boundMSImports = []
    boundImports = []
    for item in syntax.Members
        if item isa Wyvern.GlobalStatementSyntax then
            s = binder.BindStatement(item.Statement)
            binder.Statements.push(s)
        else if item isa Wyvern.FunctionDeclarationSyntax then
            binder.BindFunctionDeclaration(item)
        else if item isa Wyvern.ClassDeclarationSyntax then
            binder.BindClassDeclaration(item)
        else if item isa Wyvern.StructDeclarationSyntax then
            binder.BindStructDeclaration(item)
        else if item isa Wyvern.ContractDeclarationSyntax then
            binder.BindContractDeclaration(item)
        else if item isa Wyvern.EnumDeclarationSyntax then
            binder.BindEnumDeclaration(item)
        else if item isa Wyvern.MSImportSyntax then
            boundMSImports.push(binder.BindMSImport(item))
        else if item isa Wyvern.ImportSyntax then
            boundImports.push(binder.BindImport(item))
        end if
    end for

    statement = Wyvern.BoundBlockStatement.New(binder.Statements)

    functions = binder.Scope.GetDeclaredFunctions()
    variables = binder.Scope.GetDeclaredVariables()
    classes   = binder.Scope.GetDeclaredClasses()
    enums     = binder.Scope.GetDeclaredEnums()
    structs   = binder.Scope.GetDeclaredStructs()
    diagnostics = binder.Diagnostics.ToArray()

    boundFunctions = []
    for functionSymbol in functions
        if not Wyvern.IsA(Wyvern.BuiltinFunctionSymbol, functionSymbol) then
            boundFunctions.push(functionSymbol.Bound)
        end if
    end for

    return Wyvern.BoundGlobalScope.New(previous, diagnostics, enums, classes, structs, functions, variables, statement, boundFunctions, boundMSImports, boundImports)
end function

Wyvern.Binder.BindProgram = function(globalScope)
    parentScope = Wyvern.Binder.CreateParentScope(globalScope)

    functionBodies = Wyvern.Dictionary.New()
    diagnostics = Wyvern.DiagnosticBag.New()
    diagnostics.AddRange(globalScope.Diagnostics)

    scope = globalScope
    while scope != null
        for func in scope.Functions
            if not func.hasIndex("Declaration") or func.Declaration == null then
                continue
            end if
            binder = Wyvern.Binder.New(parentScope, func)
            if func.Declaration.Body.Kind == Wyvern.SyntaxKind.SemicolonToken then
                functionBodies.Set(func, null)
                continue
            end if
            body = binder.BindStatement(func.Declaration.Body)
            func.Bound.Body = body
            functionBodies.Set(func, body)

            diagnostics.AddRange(binder.Diagnostics)
        end for
        
        scope = scope.Previous
    end while

    boundProgram = Wyvern.BoundProgram.New(globalScope, diagnostics, functionBodies, globalScope.BoundFunctions)
    return boundProgram
end function

Wyvern.Binder.BindImport = function(syntax)
    path = syntax.StringPath.Value
    globalScope = self.BindGlobalScope(null, syntax.ImportTree.Root)
    
    return Wyvern.BoundImport.New(path, syntax.File, globalScope)
end function

Wyvern.Binder.BindFunctionDeclaration = function(syntax, declare=true, noBody=false)
    parameters = []

    seenParameterNames = []

    for parameterSyntax in syntax.Parameters.GetEnumurator()
        parameterName = parameterSyntax.Identifier.Text
        parameterType = self.BindTypeClause(parameterSyntax.Type)

        if seenParameterNames.indexOf(parameterName) != null then
            self.Diagnostics.ReportParameterAlreadyDeclared(parameterSyntax.Location, parameterName)
        else
            seenParameterNames.push(parameterName)
            if parameterSyntax.Initializer != null then
                if noBody then
                    self.Diagnostics.ReportNoBodyAllowed(syntax.Identifier.Location, boundDeclaration.Name)
                end if

                initializer = self.BindConversion(parameterSyntax.Initializer, parameterType)
            else
                initializer = null
            end if

            parameter = Wyvern.ParameterSymbol.New(parameterName, parameterType, initializer)
            parameters.push(parameter)
        end if
    end for

    type = self.BindTypeClause(syntax.TypeClause)
    if type == null then
        type = Wyvern.TypeSymbols.Void
    end if

    boundParameters = []
    for parameterSyntax in syntax.Parameters.GetEnumurator()
        boundParameters.push(self.BindParameter(parameterSyntax))
    end for

    boundFunction = Wyvern.BoundFunctionDeclaration.New(syntax.Identifier.Text, boundParameters, type, null)

    func = Wyvern.FunctionSymbol.New(syntax.Identifier.Text, parameters, type, syntax, boundFunction)
    if declare == true then
        if self.Scope.TryLookupSymbol(func.Name) then
            self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, func.Name)
        else
            self.Scope.TryDeclareSymbol(func)
        end if
    end if

    boundFunction.Symbol = func

    return boundFunction
end function

Wyvern.Binder.BindTypeSignature = function(syntax)
    if syntax == null then
        return null
    end if

    type = self.LookupType(syntax.Identifier.Text)
    if type == null then
        self.Diagnostics.ReportUndefinedType(syntax.Identifier.Location, syntax.Identifier.Text)
    end if

    if type != null then
        if syntax.MapClause != null then
            type = Wyvern.MapSymbol.New(type, self.BindTypeSignature(syntax.MapClause.Signature))
        end if

        for arrayClause in syntax.ArrayClauses
            type = Wyvern.ArraySymbol.New(type)
        end for
    end if

    return type
end function

Wyvern.Binder.BindIfStatement = function(syntax)
    condition = self.BindExpression(syntax.Condition, Wyvern.TypeSymbols.Bool)
    self.Scope = Wyvern.BoundScope.New(self.Scope)
    thenStatement = self.BindStatement(syntax.ThenStatement)
    self.Scope = self.Scope.Parent
    if syntax.ElseClause != null then
        self.Scope = Wyvern.BoundScope.New(self.Scope)
        elseStatement = self.BindStatement(syntax.ElseClause.ElseStatement)
        self.Scope = self.Scope.Parent
    else
        elseStatement = null
    end if
    return Wyvern.BoundIfStatement.New(condition, thenStatement, elseStatement)
end function

Wyvern.Binder.BindExpression = function(syntax, canBeVoid=false)
    if typeof(canBeVoid) == "map" and Wyvern.IsA(Wyvern.TypeSymbol, canBeVoid) then
        return self.BindConversion(syntax, canBeVoid)
    end if

    result = self.BindExpressionInternal(syntax)
    if not canBeVoid and result.Type == Wyvern.TypeSymbols.Void then
        self.Diagnostics.ReportExpressionMustHaveValue(syntax.Location)
        return Wyvern.BoundErrorExpression.New()
    end if

    return result
end function

Wyvern.Binder.BindExpressionInternal = function(syntax)
    if syntax.Kind == Wyvern.SyntaxKind.LiteralExpression then
        return self.BindLiteralExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.UnaryExpression or syntax.Kind == Wyvern.SyntaxKind.AfterUnaryExpression then
        return self.BindUnaryExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.BinaryExpression then
        return self.BindBinaryExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.ParenthesizedExpression then
        return self.BindParenthesizedExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.NameExpression then
        return self.BindNameExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.AssignmentExpression then
        return self.BindAssignmentExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.CallExpression then
        return self.BindCallExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.ArrayExpression then
        return self.BindArrayExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.MapExpression then
        return self.BindMapExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.IndexExpression then
        return self.BindIndexExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.NamecallExpression then
        return self.BindNamecallExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.NewExpression then
        return self.BindNewExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.NewStructExpression then
        return self.BindNewStructExpression(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.CastExpression then
        return self.BindCastExpression(syntax)
    end if
    exit("ERROR: Unhandled syntax kind: " + Wyvern.SyntaxKind.ToString(syntax.Kind))
end function

Wyvern.Binder.BindCastExpression = function(syntax)
    type = self.BindTypeSignature(syntax.Signature)
    if type == null then
        return Wyvern.BoundErrorExpression.New()
    end if
    boundExpression = self.BindExpression(syntax.Expression)

    // Ok for error handling with GH API. Not Recommended to use a lot.
    if syntax.Cast.Kind == Wyvern.SyntaxKind.UnsafeCastKeyword then
        return Wyvern.BoundConversionExpression.New(type, boundExpression, true)
    end if

    conversion = Wyvern.Conversion.Classify(boundExpression.Type, type)

    if not conversion.Exists then
        if boundExpression.Type != Wyvern.TypeSymbols.Error and type != Wyvern.TypeSymbols.Error then
            self.Diagnostics.ReportCannotConvert(syntax.Location, boundExpression.Type, type)
        end if
         
        return Wyvern.BoundErrorExpression.New()
    end if

    if conversion.IsIdentity then
        return boundExpression
    end if

    return Wyvern.BoundConversionExpression.New(type, boundExpression)
end function

Wyvern.Binder.BindNamecall = function(type, syntax)
    if syntax.Kind == Wyvern.SyntaxKind.CallExpression then
        methodName = syntax.Identifier.Text
        method = type.GetField(methodName)

        if Wyvern.IsA(Wyvern.MemberSymbol, method) and not Wyvern.IsCallable(method.Symbol) then
            self.Diagnostics.ReportCouldntFindMethod(syntax.Identifier.Location, type, methodName)
            return Wyvern.BoundErrorExpression.New()
        else if not Wyvern.IsA(Wyvern.MemberSymbol, method) and not Wyvern.IsCallable(method) then
            self.Diagnostics.ReportCouldntFindMethod(syntax.Identifier.Location, type, methodName)
            return Wyvern.BoundErrorExpression.New()
        end if

        return method
    else if syntax.Kind == Wyvern.SyntaxKind.NameExpression then
        propertyName = syntax.Identifier.Text
        property = type.GetProperty(propertyName)
        if property == null then
            self.Diagnostics.ReportCouldntFindProperty(syntax.Identifier.Location, type, propertyName)
            return Wyvern.BoundErrorExpression.New()
        end if

        return property
    end if
end function

Wyvern.Binder.BindNamecallExpression = function(syntax)
    left = self.BindExpression(syntax.Left)
    
    if left.Type == Wyvern.TypeSymbols.Error then
        return Wyvern.BoundErrorExpression.New()
    end if

    if Wyvern.IsA(Wyvern.TypeSymbol, left.Type) then
        symbol = self.BindNamecall(left.Type, syntax.Right)

        if Wyvern.IsA(Wyvern.BoundErrorExpression, symbol) then
            return Wyvern.BoundErrorExpression.New()
        end if

        if Wyvern.IsCallable(symbol) and Wyvern.IsA(Wyvern.CallExpressionSyntax, syntax.Right) then
            return Wyvern.BoundNamecallExpression.New(left, self.BindCallExpression(syntax.Right, symbol))
        else if syntax.Right isa Wyvern.NameExpressionSyntax then
            return Wyvern.BoundNamecallExpression.New(left, Wyvern.BoundVariableExpression.New(symbol))
        end if
    else if Wyvern.IsA(Wyvern.EnumSymbol, left.Type) then
        right = syntax.Right
        if right.Kind != Wyvern.SyntaxKind.NameExpression then
            self.Diagnostics.ReportCanOnlyUseSyntax(right.Location, Wyvern.SyntaxKind.NameExpression)
            return Wyvern.BoundErrorExpression.New()
        end if

        enum = left.Type
        memberName = right.Identifier.Text
        enumMember = enum.GetMember(memberName)
        if not enumMember then
            self.Diagnostics.ReportEnumDoesntHaveMember(right.Location, memberName)
            return Wyvern.BoundErrorExpression.New()
        end if

        return Wyvern.BoundNamecallExpression.New(left, Wyvern.BoundVariableExpression.New(enumMember))
    else if left.Kind == Wyvern.BoundNodeKind.VariableExpression and Wyvern.IsA(Wyvern.ClassSymbol, left.Variable) then
        // For Static Member calls
        right = syntax.Right
        if right.Kind == Wyvern.SyntaxKind.CallExpression then
            methodName = right.Identifier.Text
            method = left.Variable.GetField(methodName, true)
            if Wyvern.IsA(Wyvern.MemberSymbol, method) and not Wyvern.IsCallable(method.Symbol) then
                self.Diagnostics.ReportCouldntFindMethod(right.Identifier.Location, left.Variable, methodName)
                return Wyvern.BoundErrorExpression.New()
            else if not Wyvern.IsA(Wyvern.MemberSymbol, method) and not Wyvern.IsCallable(method) then
                self.Diagnostics.ReportCouldntFindMethod(right.Identifier.Location, left.Variable, methodName)
                return Wyvern.BoundErrorExpression.New()
            end if

            if not method.Modifiers.IsPublic and left.Variable != self.Class then
                self.Diagnostics.ReportSymbolIsntPublic(right.Identifier.Location, method.Name)
                return Wyvern.BoundErrorExpression.New()
            end if
            return Wyvern.BoundNamecallExpression.New(left, self.BindCallExpression(syntax.Right, method.Symbol))
        else if right.Kind == Wyvern.SyntaxKind.NameExpression then
            propertyName = right.Identifier.Text
            property = left.Variable.GetProperty(propertyName, true)
            if property == null then
                self.Diagnostics.ReportCouldntFindProperty(right.Identifier.Location, left.Variable, propertyName)
                return Wyvern.BoundErrorExpression.New()
            end if

            if not property.Modifiers.IsPublic and left.Variable != self.Class then
                self.Diagnostics.ReportSymbolIsntPublic(right.Identifier.Location, property.Name)
                return Wyvern.BoundErrorExpression.New()
            end if

            return Wyvern.BoundNamecallExpression.New(left, Wyvern.BoundVariableExpression.New(property.Symbol))
        end if
    else if left.Type.Kind == Wyvern.SymbolKind.Array or left.Type.Kind == Wyvern.SymbolKind.Map then
        left.Type.LoadMembers() // We load them in here to stop them from going on a infinte loop
        symbol = self.BindNamecall(left.Type, syntax.Right)

        if Wyvern.IsA(Wyvern.BoundErrorExpression, symbol) then
            return Wyvern.BoundErrorExpression.New()
        end if

        if Wyvern.IsCallable(symbol) and Wyvern.IsA(Wyvern.CallExpressionSyntax, syntax.Right) then
            return Wyvern.BoundNamecallExpression.New(left, self.BindCallExpression(syntax.Right, symbol))
        else if syntax.Right isa Wyvern.NameExpressionSyntax then
            return Wyvern.BoundNamecallExpression.New(left, Wyvern.BoundVariableExpression.New(symbol))
        end if
    else if Wyvern.IsA(Wyvern.ClassSymbol, left.Type) or Wyvern.IsA(Wyvern.ContractSymbol, left.Type) then
        symbol = self.BindNamecall(left.Type, syntax.Right)

        if Wyvern.IsA(Wyvern.BoundErrorExpression, symbol) then
            return Wyvern.BoundErrorExpression.New()
        end if

        actualSymbol = symbol.Symbol
        if not symbol.Modifiers.IsPublic and left.Type != self.Class then
            self.Diagnostics.ReportSymbolIsntPublic(syntax.Right.Identifier.Location, symbol.Name)
            return Wyvern.BoundErrorExpression.New()
        end if

        if Wyvern.IsCallable(actualSymbol) and Wyvern.IsA(Wyvern.CallExpressionSyntax, syntax.Right) then
            return Wyvern.BoundNamecallExpression.New(left, self.BindCallExpression(syntax.Right, actualSymbol))
        else if syntax.Right isa Wyvern.NameExpressionSyntax then
            return Wyvern.BoundNamecallExpression.New(left, Wyvern.BoundVariableExpression.New(actualSymbol))
        end if
    else if Wyvern.IsA(Wyvern.StructSymbol, left.Type) then
        right = syntax.Right
        if right.Kind != Wyvern.SyntaxKind.NameExpression then
            self.Diagnostics.ReportCannotUseFunctionInStruct(syntax.Right.Location)
            return Wyvern.BoundErrorExpression.New()
        end if

        struct = left.Type
        memberName = right.Identifier.Text
        structMember = struct.GetField(memberName)
        if not structMember then
            self.Diagnostics.ReportStructDoesntHaveMember(right.Location, memberName)
            return Wyvern.BoundErrorExpression.New()
        end if

        return Wyvern.BoundNamecallExpression.New(left, Wyvern.BoundVariableExpression.New(structMember))
    end if

    exit("Unable to bind namecall:" + char(10) + syntax.ToString(true))
end function

Wyvern.Binder.BindIndexExpression = function(syntax)
    boundExpression = self.BindExpression(syntax.Expression)

    if Wyvern.IsA(Wyvern.ArraySymbol, boundExpression.Type) or boundExpression.Type == Wyvern.TypeSymbols.String then
        index = self.BindConversion(syntax.ValueExpression, Wyvern.TypeSymbols.Number)
        if index.Type != Wyvern.TypeSymbols.Number then
            self.Diagnostics.ReportWrongIndexType(syntax.ValueExpression.Location, Wyvern.TypeSymbols.Number, index.Type)
            return Wyvern.BoundErrorExpression.New()
        end if

        type = boundExpression.Type
        if Wyvern.IsA(Wyvern.ArraySymbol, type) then
            type = type.Type
        end if

        return Wyvern.BoundIndexExpression.New(boundExpression, index, type)
    else if Wyvern.IsA(Wyvern.MapSymbol, boundExpression.Type) then
        index = self.BindConversion(syntax.ValueExpression, boundExpression.Type.KeyType)

        if index.Type != boundExpression.Type.KeyType then
            self.Diagnostics.ReportWrongIndexType(syntax.ValueExpression.Location, boundExpression.Type.KeyType, index.Type)
            return Wyvern.BoundErrorExpression.New()
        end if
        
        return Wyvern.BoundIndexExpression.New(boundExpression, index, boundExpression.Type.ValueType)
    else
        self.Diagnostics.ReportUnindexableType(syntax.Expression.Location, boundExpression.Type)
        return Wyvern.BoundErrorExpression.New()
    end if
end function

Wyvern.Binder.BindArrayExpression = function(syntax)
    boundItems = []
    type = null

    for item in syntax.Items.GetEnumurator()
        boundItem = self.BindExpression(item)
        if type == null then
            type = boundItem.Type
        else if boundItem.Type != type then
            type = Wyvern.TypeSymbols.Any
        end if

        if boundItem.Type != type and type != Wyvern.TypeSymbols.Any then
            self.Diagnostics.ReportUnexpectedType(item.Location, type, boundItem.Type)
            return Wyvern.BoundErrorExpression.New()
        end if

        boundItems.push(boundItem)
    end for

    if type == null then
        type = Wyvern.TypeSymbols.Any
    end if

    return Wyvern.BoundArrayExpression.New(boundItems, Wyvern.ArraySymbol.New(type))
end function

Wyvern.Binder.BindPair = function(syntax)
    return Wyvern.BoundPair.New(self.BindExpression(syntax.Key), self.BindExpression(syntax.Value))
end function

Wyvern.Binder.BindMapExpression = function(syntax)
    boundPairs = []
    keyType = null
    valueType = null

    for pair in syntax.Pairs.GetEnumurator()
        boundPair = self.BindPair(pair)

        if keyType == null then
            keyType = boundPair.Key.Type
        else if boundPair.Key.Type != type then
            keyType = Wyvern.TypeSymbols.Any
        end if

        if valueType == null then
            valueType = boundPair.Value.Type
        else if boundPair.Value.Type != type then
            valueType = Wyvern.TypeSymbols.Any
        end if

        if boundPair.Key.Type != keyType and keyType != Wyvern.TypeSymbols.Any then
            self.Diagnostics.ReportUnexpectedType(pair.Location, keyType, boundPair.Key.Type)
            return Wyvern.BoundErrorExpression.New()
        end if

        if boundPair.Value.Type != valueType and valueType != Wyvern.TypeSymbols.Any then
            self.Diagnostics.ReportUnexpectedType(pair.Location, valueType, boundPair.Value.Type)
            return Wyvern.BoundErrorExpression.New()
        end if

        boundPairs.push(boundPair)
    end for

    if keyType == null then
        keyType = Wyvern.TypeSymbols.Any
    end if

    if valueType == null then
        valueType = Wyvern.TypeSymbols.Any
    end if

    return Wyvern.BoundMapExpression.New(boundPairs, keyType, valueType)
end function

Wyvern.Binder.BindParenthesizedExpression = function(syntax)
    return Wyvern.BoundParenthesizedExpression.New(self.BindExpression(syntax.Expression))
end function

Wyvern.Binder.BindCallExpression = function(syntax, actualSymbol=null)
    arguments = []
    for argument in syntax.Arguments.GetEnumurator()
        arguments.push(self.BindExpression(argument))
    end for

    if not self.Scope.TryLookupSymbol(syntax.Identifier.Text) and not actualSymbol then
        self.Diagnostics.ReportUndefinedFunction(syntax.Identifier.Location, syntax.Identifier.Text)
        return Wyvern.BoundErrorExpression.New()
    end if
    if not actualSymbol then
        func = self.Scope.LookupSymbol(syntax.Identifier.Text, false)

        if Wyvern.IsA(Wyvern.FunctionReferenceSymbol, func) then
            func = func.Function
        end if
        if func.Type != Wyvern.TypeSymbols.Reference then
            if not Wyvern.IsA(Wyvern.FunctionSymbol, func) then
                self.Diagnostics.ReportSymbolIsntAFunction(syntax.Identifier.Location, syntax.Identifier.Text)
                return Wyvern.BoundErrorExpression.New()
            end if
        end if
    else
        func = actualSymbol
    end if

    if func.Type != Wyvern.TypeSymbols.Reference then
        if arguments.len() > func.Parameters.len() or arguments.len() < func.GetParameterLengthWithoutOptionals() then
            self.Diagnostics.ReportWrongArgumentCount(syntax.Identifier.Location, syntax.Identifier.Text, func.GetParameterLengthWithoutOptionals(), arguments.len())
            return Wyvern.BoundErrorExpression.New()
        end if

        for i in Wyvern.SafeRange(0, syntax.Arguments.Count - 1)
            parameter = func.Parameters[i]
            arguments[i] = self.BindConversionInternal(syntax.Arguments.Get(i).Location, arguments[i], parameter.Type)

            //if not argument.Type.Compare(parameter.Type) and parameter.Type != Wyvern.TypeSymbols.Any then
            //    self.Diagnostics.ReportWrongArgumentType(syntax.Arguments.Get(i).Location, parameter.Name, parameter.Type, argument.Type)
            //    return Wyvern.BoundErrorExpression.New()
            //end if
        end for
    end if

    return Wyvern.BoundCallExpression.New(func, arguments)
end function

Wyvern.Binder.BindNewExpression = function(syntax)
    callSyntax = syntax.Expression

    if not self.Scope.TryLookupSymbol(callSyntax.Identifier.Text) then
        self.Diagnostics.ReportUndefinedClass(callSyntax.Identifier.Location, callSyntax.Identifier.Text)
        return Wyvern.BoundErrorExpression.New()
    end if

    class = self.Scope.LookupSymbol(callSyntax.Identifier.Text)
    if not Wyvern.IsA(Wyvern.ClassSymbol, class) then
        self.Diagnostics.ReportSymbolIsntAClass(callSyntax.Identifier.Location, callSyntax.Identifier.Text)
        return Wyvern.BoundErrorExpression.New()
    end if

    constructorMember = class.GetMethod("@constructor")
    if constructorMember == null then
        return Wyvern.BoundNewExpression.New(class, [])
    end if
    constructorMethod = constructorMember.Symbol
    boundCall = self.BindCallExpression(callSyntax, constructorMethod)
    if boundCall.Kind == Wyvern.BoundNodeKind.ErrorExpression then
        return Wyvern.BoundErrorExpression.New()
    end if
    return Wyvern.BoundNewExpression.New(class, boundCall.Arguments)
end function

Wyvern.Binder.BindNewStructExpression = function(syntax)
    name = syntax.Identifier.Text

    if not self.Scope.TryLookupSymbol(name) then
        self.Diagnostics.ReportUndefinedStruct(syntax.Identifier.Location, name)
        return Wyvern.BoundErrorExpression.New()
    end if

    struct = self.Scope.LookupSymbol(name)
    if not (struct isa Wyvern.StructSymbol) then
        self.Diagnostics.ReportSymbolIsntAStruct(syntax.Identifier.Location, name)
        return Wyvern.BoundErrorExpression.New()
    end if

    // Verify arguments
    arguments = []
    for argumentSyntax in syntax.Arguments.GetEnumurator()
        memberName = argumentSyntax.Identifier.Text
        member = struct.GetField(memberName)
        if member == null then
            self.Diagnostics.ReportCannotFindStructMember(argumentSyntax.Identifier.Location, memberName)
            continue
        end if
        
        boundExpression = self.BindExpression(argumentSyntax.Expression, member.Type)
        arguments.push(Wyvern.BoundStructArgument.New(memberName, member, boundExpression))
    end for

    return Wyvern.BoundNewStructExpression.New(struct, arguments)
end function

Wyvern.Binder.BindLiteralExpression = function(syntax)
    return Wyvern.BoundLiteralExpression.New(syntax)
end function

Wyvern.Binder.BindNameExpression = function(syntax)
    name = syntax.Identifier.Text
    if syntax.Identifier.IsMissing then
        return Wyvern.BoundErrorExpression.New()
    end if

    if not self.Scope.TryLookupSymbol(name) then
        self.Diagnostics.ReportUndefinedName(syntax.Location, name)
        return Wyvern.BoundErrorExpression.New()
    end if

    variable = self.Scope.LookupSymbol(name)
    return Wyvern.BoundVariableExpression.New(variable)
end function

Wyvern.Binder.BindAssignmentExpression = function(syntax)
    if syntax.Left.Kind == Wyvern.SyntaxKind.IdentifierToken then
        name = syntax.Left.Text
        boundExpression = self.BindExpression(syntax.Expression)

        variable = self.Scope.LookupSymbol(name)
        if not self.Scope.TryLookupSymbol(name) then
            self.Diagnostics.ReportUndefinedName(syntax.Location, name)
            return boundExpression
        end if

        if variable.IsReadOnly then
            self.Diagnostics.ReportCannotAssign(syntax.Location, name)
        end if

        convertedExpression = self.BindConversionInternal(syntax.Expression.Location, boundExpression, variable.Type)

        return Wyvern.BoundAssignmentExpression.New(variable, boundExpression)
    else
        change = self.BindExpression(syntax.Left)
        boundExpression = self.BindConversion(syntax.Expression, change.Type)

        return Wyvern.BoundCallingAssignmentExpression.New(change, boundExpression)
    end if
end function

Wyvern.Binder.BindUnaryExpression = function(syntax)
    boundOperand = self.BindExpression(syntax.Operand)

    if boundOperand.Type == Wyvern.TypeSymbols.Error then
        return Wyvern.BoundErrorExpression.New()
    end if

    boundOperator = Wyvern.BoundUnaryOperator.Bind(syntax.Operator.Kind, boundOperand.Type)
    if boundOperator == null then
        self.Diagnostics.ReportUndefinedUnaryOperator(syntax.Operator.Location, syntax.Operator.Text, boundOperand.Type)
        return Wyvern.BoundErrorExpression.New()
    end if

    return Wyvern.BoundUnaryExpression.New(boundOperator, boundOperand)
end function

Wyvern.Binder.BindBinaryExpression = function(syntax)
    boundLeft = self.BindExpression(syntax.Left)
    boundRight = self.BindExpression(syntax.Right)

    if boundLeft.Type == Wyvern.TypeSymbols.Error or boundRight.Type == Wyvern.TypeSymbols.Error then
        return Wyvern.BoundErrorExpression.New()
    end if

    boundOperator = Wyvern.BoundBinaryOperator.Bind(syntax.Operator.Kind, boundLeft.Type, boundRight.Type)
    
    if boundOperator == null then
        self.Diagnostics.ReportUndefinedBinaryOperator(syntax, boundLeft.Type, boundRight.Type)
        return Wyvern.BoundErrorExpression.New()
    end if

    return Wyvern.BoundBinaryExpression.New(boundLeft, boundOperator, boundRight)
end function

Wyvern.Binder.BindConversion = function(syntax, type, allowExplicit=false)
    expression = self.BindExpression(syntax)
    diagnosticLocation = syntax.Location
    return self.BindConversionInternal(diagnosticLocation, expression, type, allowExplicit)
end function

Wyvern.Binder.BindConversionInternal = function(diagnosticLocation, expression, type, allowExplicit=false)
    conversion = Wyvern.Conversion.Classify(expression.Type, type)

    if not conversion.Exists then
        if expression.Type != Wyvern.TypeSymbols.Error and type != Wyvern.TypeSymbols.Error then
            self.Diagnostics.ReportCannotConvert(diagnosticLocation, expression.Type, type)
        end if
        return Wyvern.BoundErrorExpression.New()
    end if

    if not allowExplicit and conversion.IsExplicit then
        self.Diagnostics.ReportCannotConvertImplicitly(diagnosticLocation, expression.Type, type)
        return Wyvern.BoundErrorExpression.New()
    end if

    if conversion.IsIdentity and (expression.Type != Wyvern.TypeSymbols.Any and type != Wyvern.TypeSymbols.Any) then
        return expression
    end if

    return Wyvern.BoundConversionExpression.New(type, expression)
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Wyvern.Binder.BindClassDeclaration = function(syntax, noBody=false)
    name = syntax.Identifier.Text

    extension = null
    extensionDeclaration = null
    if syntax.ExtensionClause != null then
        extensionName = syntax.ExtensionClause.Identifier.Text
        extension = self.Scope.LookupSymbol(extensionName)

        if not extension or extension.Kind != Wyvern.SymbolKind.Class then
            self.Diagnostics.ReportCouldntFindExtensionClass(syntax.ExtensionClause.Identifier.Location, extensionName)
            return Wyvern.BoundErrorExpression.New()
        end if

        extensionDeclaration = extension.Declaration
    end if

    contracts = []
    if syntax.ContractClause != null then
        contracts = self.BindContractClause(syntax.ContractClause)
    end if

    members = []
    memberTypes = []
    classSymbol = Wyvern.ClassSymbol.New(name, extension, contracts, memberTypes)

    if self.Scope.TryDeclareGlobalSymbol(classSymbol) == false then
        self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, name)
        return Wyvern.BoundErrorExpression.New()
    end if

    memberBind = {}
    for memberSyntax in syntax.Members
        bindingData = self.BindMemberType(memberSyntax, name)
        
        memberType = bindingData[0]
        boundDeclaration = bindingData[1]
        syntaxDecl = memberSyntax.Declaration
        if memberBind.hasIndex(memberType.Name) then //indexOf(members, memberType) != null then
            self.Diagnostics.ReportSymbolAlreadyDeclared(syntaxDecl.Identifier.Location, boundDeclaration.Name)
            continue
        end if

        // Override checks
        if extension != null then
            extField = extension.GetField(memberType.Name)
            if extField then
                if not extField.Modifiers.IsVirtual and not memberType.Modifiers.IsOverride then
                    self.Diagnostics.ReportSymbolAlreadyDeclared(syntaxDecl.Identifier.Location, boundDeclaration.Name)
                    continue
                end if

                if not memberType.Modifiers.IsOverride then
                    self.Diagnostics.ReportVirtualSymbolExists(syntaxDecl.Identifier.Location, boundDeclaration.Name)
                    continue
                end if

                if extField.Modifiers.IsPublic != memberType.Modifiers.IsPublic or extField.Modifiers.IsStatic != memberType.Modifiers.IsStatic then
                    self.Diagnostics.ReportFieldDoesntHaveSameModifiers(syntaxDecl.Identifier.Location, boundDeclaration.Name)
                    continue
                end if

                if Wyvern.IsA(Wyvern.FunctionSymbol, extField.Symbol) != Wyvern.IsA(Wyvern.FunctionSymbol, memberType.Symbol) then
                    self.Diagnostics.ReportAttemptedOverrideWrongField(syntaxDecl.Identifier.Location, extField.Symbol, memberType.Symbol)
                    continue
                end if

                efSymbol = extField.Symbol
                mtSymbol = memberType.Symbol
                if Wyvern.IsA(Wyvern.FunctionSymbol, efSymbol) then
                    if efSymbol.Type != mtSymbol.Type then
                        self.Diagnostics.ReportOverrideDoesntHaveSameType(syntaxDecl.TypeClause.Location, boundDeclaration.Name, efSymbol.Type, mtSymbol.Type)
                        continue
                    end if

                    if not efSymbol.CompareParameters(mtSymbol) and mtSymbol.Name != "@constructor" then
                        self.Diagnostics.ReportOverrideDoesntHaveSameParameters(syntaxDecl.OpenParenthesis.Location.Combine(syntaxDecl.CloseParenthesis.Location), boundDeclaration.Name)
                        continue
                    end if
                else
                    if efSymbol.Type != mtSymbol.Type then
                        self.Diagnostics.ReportOverrideDoesntHaveSameType(syntaxDecl.Identifier.Location, boundDeclaration.Name, efSymbol.Type, mtSymbol.Type)
                        continue
                    end if

                    if efSymbol.IsReadOnly != mtSymbol.IsReadOnly then
                        self.Diagnostics.ReportOverrideIsntSameWrite(syntaxDecl.Identifier.Location, boundDeclaration.Name)
                        continue
                    end if
                end if
            end if
        end if

        boundTypeMember = Wyvern.BoundTypeMember.New(memberType.Modifiers.IsPublic, memberType.Modifiers.IsStatic, memberType.Modifiers.IsOverride, memberType.Modifiers.IsVirtual, boundDeclaration, memberType)
        if noBody then
            if boundDeclaration.Kind == Wyvern.BoundNodeKind.FunctionDeclaration then
                if boundDeclaration.Body.Kind != Wyvern.SyntaxKind.SemicolonToken then
                    self.Diagnostics.ReportNoBodyAllowed(memberSyntax.Declaration.Identifier.Location, boundDeclaration.Name)
                    continue
                end if
            else
                if boundDeclaration.Initializer != null then
                    self.Diagnostics.ReportNoInitializerAllowed(memberSyntax.Declaration.Identifier.Location, boundDeclaration.Name)
                    continue
                end if
            end if
        end if
        //ReportNoBodyAllowedInMiniscriptImport
        //if boundTypeMember.IsVirtual then
        //    if boundDeclaration.Kind == Wyvern.SyntaxKind.FunctionDeclaration then
        //        if boundDeclaration.Body.Kind != Wyvern.SyntaxKind.SemicolonToken then
        //            self.Diagnostics.ReportVirtualWithBody(memberSyntax.Location, boundDeclaration.Name)
        //            continue
        //        end if
        //    else
        //        if boundDeclaration.Initializer != null then
        //            self.Diagnostics.ReportVirtualWithBody(memberSyntax.Location, boundDeclaration.Name)
        //            continue
        //        end if
        //    end if
        //end if
        memberBind[memberType.Name] = memberType
        members.push(boundTypeMember)
        memberTypes.push(memberType)
    end for

    classSymbol.Members = memberTypes
    classSymbol.LoadStatics()
    // name, extensionType, members, symbol=null
    classDeclaration = Wyvern.BoundClassDeclaration.New(name, extensionDeclaration, members, classSymbol)
    classSymbol.Declaration = classDeclaration

    for boundMember in members
        if Wyvern.IsA(Wyvern.BoundFunctionDeclaration, boundMember.Declaration) then
            boundDeclaration = boundMember.Declaration
            if boundDeclaration.Body.Kind == Wyvern.SyntaxKind.SemicolonToken then
                boundDeclaration.Body = null
                continue
            end if

            binder = Wyvern.Binder.New(self.Scope, boundDeclaration.Symbol)
            binder.Class = classSymbol
            if not boundMember.IsStatic then
                binder.Scope.TryDeclareVariable(Wyvern.LocalVariableSymbol.New("self", false, classSymbol)) // defines the "self" variable
                if extension != null then
                    binder.Scope.TryDeclareVariable(Wyvern.LocalVariableSymbol.New("super", false, extension)) // defines the "self" variable
                end if
            end if
            body = binder.BindStatement(boundDeclaration.Body)
            boundDeclaration.Body = body
            self.Diagnostics.AddRange(binder.Diagnostics)
        end if
    end for

    for contract in contracts
        // I can feel the Technical Debt
        identifier = null
        for contractIdentifier in syntax.ContractClause.Contracts.GetEnumurator()
            if contractIdentifier.Text == contract.Name then
                identifier = contractIdentifier
                break
            end if
        end for
        requirements = contract.GetFailingRequirements(classSymbol)
        
        for requirement in requirements
            self.Diagnostics.ReportMissingContractRequirement(identifier.Location, requirement.Contract.Name, requirement.Name)
        end for
    end for

    return classDeclaration
end function

Wyvern.Binder.BindStructDeclaration = function(syntax, declare=true)
    name = syntax.Identifier.Text

    members = {}
    membersSymbols = {}
    for syntaxMember in syntax.Members
        member = self.BindVariableDeclaration(syntaxMember, false, true)
        if members.hasIndex(member.Name) then
            self.Diagnostics.ReportSymbolAlreadyDeclared(syntaxMember.Identifier.Location, member.Name)
            continue
        end if

        members[member.Name] = member
        membersSymbols[member.Name] = member.Variable
    end for

    symbol = Wyvern.StructSymbol.New(name, membersSymbols.values, null)
    if declare then
        if not self.Scope.TryDeclareSymbol(symbol) then
            self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, name)
            return Wyvern.BoundErrorExpression.New()
        end if
    end if

    declaration = Wyvern.BoundStructDeclaration.New(name, members.values, symbol)
    symbol.Declaration = declaration

    return declaration
end function

Wyvern.Binder.BindEnumDeclaration = function(syntax)
    name = syntax.Identifier.Text
    boundMembers = []

    symbol = Wyvern.EnumSymbol.New(name, [])
    boundEnum = Wyvern.BoundEnumDeclaration.New(name, boundMembers, symbol)
    symbol.Declaration = boundEnum
    constant = 0
    for member in syntax.Members.GetEnumurator()
        if member.Kind == Wyvern.SyntaxKind.IdentifierToken then
            name = member.Text
            memberSymbol = Wyvern.EnumMemberSymbol.New(name, symbol, symbol, constant)
            boundEnumMember = Wyvern.BoundEnumMember.New(name, constant, symbol, memberSymbol)

            memberSymbol.Declaration = boundEnumMember
            symbol.Members.push(memberSymbol)
            boundMembers.push(boundEnumMember)
        else if member.Kind == Wyvern.SyntaxKind.AssignmentExpression then
            name = member.Left.Text
            expression = self.BindExpression(member.Expression, Wyvern.TypeSymbols.Number)
            memberSymbol = Wyvern.EnumMemberSymbol.New(name, symbol, symbol, expression.ConstantValue)
            boundEnumMember = Wyvern.BoundEnumMember.New(name, expression, symbol, memberSymbol)
            constant = expression.ConstantValue.Value
            
            memberSymbol.Declaration = boundEnumMember
            symbol.Members.push(memberSymbol)
            boundMembers.push(boundEnumMember)
        end if

        constant = constant + 1
    end for
    
    if not self.Scope.TryDeclareSymbol(symbol) then
        self.Scope.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, name)
        return Wyvern.BoundErrorExpression.New()
    end if
    return boundEnum
end function

Wyvern.Binder.BindMemberType = function(syntax, className="")
    isPublic = false
    isStatic = false
    isOverride = false
    isVirtual = false
    for modifierSyntax in syntax.Modifiers
        if modifierSyntax.Kind == Wyvern.SyntaxKind.PublicKeyword then
            isPublic = true
        else if modifierSyntax.Kind == Wyvern.SyntaxKind.PrivateKeyword then
            isPublic = false
        else if modifierSyntax.Kind == Wyvern.SyntaxKind.StaticKeyword then
            isStatic = true
        else if modifierSyntax.Kind == Wyvern.SyntaxKind.OverrideKeyword then
            isOverride = true
        else if modifierSyntax.Kind == Wyvern.SyntaxKind.VirtualKeyword then
            isVirtual = true
        end if
    end for
    
    boundDeclaration = self.BindMemberDeclaration(syntax.Declaration, className)

    return [Wyvern.MemberSymbol.New(Wyvern.Modifiers.New(isPublic, isStatic, isOverride, isVirtual), boundDeclaration.Symbol), boundDeclaration]
end function

Wyvern.Binder.BindMemberDeclaration = function(syntax, name="")
    boundDeclaration = null
    if Wyvern.IsA(Wyvern.VariableDeclarationSyntax, syntax) then
        boundDeclaration = self.BindVariableDeclaration(syntax, false)
    else if Wyvern.IsA(Wyvern.FunctionDeclarationSyntax, syntax) then
        boundDeclaration = self.BindFunctionDeclaration(syntax, false)
        if boundDeclaration.Name == name then
            boundDeclaration.Symbol.Name = "@constructor"
        end if
        boundDeclaration.Body = syntax.Body
    end if

    return boundDeclaration
end function

Wyvern.Binder.BindContractDeclaration = function(syntax)
    name = syntax.Identifier.Text

    contracts = []
    if syntax.ContractClause != null then
        contracts = self.BindContractClause(syntax.ContractClause)
    end if

    members = []
    for memberSyntax in syntax.Members
        bindingData = self.BindMemberType(memberSyntax)

        memberType = bindingData[0]
        boundDeclaration = bindingData[1]
        if members.indexOf(memberType) != null then
            self.Diagnostics.ReportSymbolAlreadyDeclared(memberSyntax.Identifier.Location, boundDeclaration.Name)
            continue
        end if

        members.push(memberType)
    end for

    contractType = Wyvern.ContractSymbol.New(name, contracts, members)
    if not self.Scope.TryDeclareGlobalSymbol(contractType) then
        self.Scope.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, name)
        return Wyvern.BoundErrorExpression.New()
    end if
    return contractType
end function

Wyvern.Binder.BindMSImport = function(syntax)
    path = syntax.StringPath.Value

    members = []
    for member in syntax.Members
        if Wyvern.IsA(Wyvern.FunctionDeclarationSyntax, member) then
            members.push(self.BindFunctionDeclaration(member, true, true))
        else if Wyvern.IsA(Wyvern.ClassDeclarationSyntax, member) then
            members.push(self.BindClassDeclaration(member, true))
        else if Wyvern.IsA(Wyvern.StructDeclarationSyntax, member) then
            members.push(self.BindStructDeclaration(member))
        else if Wyvern.IsA(Wyvern.EnumDeclarationSyntax, member) then
            members.push(self.BindEnumDeclaration(member))
        else if Wyvern.IsA(Wyvern.VariableDeclarationSyntax, member) then
            members.push(self.BindVariableDeclaration(member, true, true))
        end if
    end for

    return Wyvern.BoundMSImport.New(path, members)
end function

// {"Signature":-1, "Contracts":-1}
Wyvern.Binder.BindContractClause = function(syntax)
    contracts = []
    for contract in syntax.Contracts.GetEnumurator()
        symbol = self.Scope.LookupSymbol(contract.Text)
        
        if symbol == null then
            self.Diagnostics.ReportUndefinedSymbol(contract.Location, contract.Text)
            continue
        end if

        if symbol.Kind != Wyvern.SymbolKind.Contract then
            self.Diagnostics.ReportSymbolIsntAContract(contract.Location, contract.Text)
            continue
        end if

        contracts.push(symbol)
    end for

    return contracts
end function

Wyvern.Binder.BindParameter = function(syntax)
    if syntax.Initializer != null then
        initializer = self.BindExpression(syntax.Initializer, false)
    else
        initializer = null
    end if
    
    return Wyvern.BoundParameter.New(syntax.Identifier.Text, self.BindTypeClause(syntax.Type), initializer)
end function

Wyvern.Binder.CreateParentScope = function(previous)
    stack = Wyvern.Stack.New()
    while previous != null
        stack.Push(previous)
        previous = previous.Previous
    end while

    parent = Wyvern.Binder.CreateRootScope()
    while stack.Count > 0
        previous = stack.Pop()
        scope = Wyvern.BoundScope.New(parent)

        for f in previous.Functions
            scope.TryDeclareSymbol(f)
        end for

        for v in previous.Variables
            scope.TryDeclareSymbol(v)
        end for

        for c in previous.Classes
            scope.TryDeclareSymbol(c)
        end for

        for e in previous.Enums
            scope.TryDeclareSymbol(e)
        end for

        for s in previous.Structs
            scope.TryDeclareSymbol(s)
        end for

        parent = scope
    end while

    return parent
end function

Wyvern.Binder.CreateRootScope = function()
    result = Wyvern.BoundScope.New(null)

    for f in Wyvern.BuiltinFunctions.GetAll()
        result.TryDeclareSymbol(f)
    end for

    for v in Wyvern.BuiltinVariables.GetAll()
        result.TryDeclareSymbol(v)
    end for

    return result
end function

Wyvern.Binder.BindStatement = function(syntax)
    if syntax.Kind == Wyvern.SyntaxKind.BlockStatement then
        return self.BindBlockStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.CaseBodyStatement then
        return self.BindCaseBodyStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.IfStatement then
        return self.BindIfStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.WhileStatement then
        return self.BindWhileStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.DoWhileStatement then
        return self.BindDoWhileStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.SwitchStatement then
        return self.BindSwitchStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.ForStatement then
        return self.BindForStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.ForeachStatement then
        return self.BindForeachStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.VariableDeclaration then
        return self.BindVariableDeclaration(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.ExpressionStatement then
        return self.BindExpressionStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.BreakStatement then
        return self.BindBreakStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.ContinueStatement then
        return self.BindContinueStatement(syntax)
    else if syntax.Kind == Wyvern.SyntaxKind.ReturnStatement then
        return self.BindReturnStatement(syntax)
    end if

    exit("Unhandled statement kind: " + Wyvern.SyntaxKind.ToString(syntax.Kind))
end function

Wyvern.Binder.BindCaseStatement = function(syntax, type)
    cases = []
    for caseSyntax in syntax.Cases
        boundExpression = self.BindConversion(caseSyntax.Expression, type)
        if boundExpression.Kind == Wyvern.BoundNodeKind.ErrorExpression then
            continue
        end if

        if not boundExpression.hasIndex("ConstantValue") then
            self.Diagnostics.ReportCaseMustHaveConstantValue(caseSyntax.Expression.Location)
            continue
        end if
        cases.push(boundExpression.ConstantValue)
    end for

    body = self.BindStatement(syntax.Body)
    return Wyvern.BoundCaseStatement.New(cases, body)
end function

Wyvern.Binder.BindSwitchStatement = function(syntax)
    expression = self.BindExpression(syntax.Expression)

    if syntax.Cases[1] != null then
        defaultStatement = self.BindStatement(syntax.Cases[1].Body)
    else
        defaultStatement = null
    end if

    cases = []
    everyCase = []
    for i in Wyvern.SafeRange(0, syntax.Cases[0].len - 1)
        boundCase = self.BindCaseStatement(syntax.Cases[0][i], expression.Type)
        for v in Wyvern.SafeRange(0, boundCase.Cases.len - 1)
            caseValue = boundCase.Cases[v]
            if everyCase.indexOf(caseValue) != null then
                self.Diagnostics.ReportCantHaveMultipleSameCases(syntax.Cases[0][i].Cases[v].Expression.Location)
                continue
            end if
            everyCase.push(caseValue)
        end for

        cases.push(boundCase)
    end for

    return Wyvern.BoundSwitchStatement.New(expression, cases, defaultStatement)
end function

Wyvern.Binder.BindReturnStatement = function(syntax)
    if self.Function == null then
        self.Diagnostics.ReportInvalidReturnStatement(syntax.Location)
        return Wyvern.BoundErrorExpression.New()
    end if
    
    if syntax.Expression == null then
        expression = null
    else
        expression = self.BindExpression(syntax.Expression, false)
    end if

    if self.Function.Type == Wyvern.TypeSymbols.Void then
        if expression != null then
            self.Diagnostics.ReportInvalidReturnExpression(syntax.Location, self.Function.Name)
        end if
    else
        if expression == null then
            self.Diagnostics.ReportMissingReturnExpression(syntax.Location, self.Function.Name)
        else if expression.Type != self.Function.Type then
            expression = self.BindConversionInternal(syntax.Expression.Location, expression, self.Function.Type)
        end if
    end if

    return Wyvern.BoundReturnStatement.New(expression)
end function

Wyvern.Binder.BindBreakStatement = function(syntax)
    if self.IsInLoop() then
        return Wyvern.BoundBreakStatement.New()
    else
        self.Diagnostics.ReportBreakOutsideLoop(syntax.Location)
        return Wyvern.BoundErrorExpression.New()
    end if
end function

Wyvern.Binder.BindContinueStatement = function(syntax)
    if self.IsInLoop() then
        return Wyvern.BoundContinueStatement.New()
    else
        self.Diagnostics.ReportContinueOutsideLoop(syntax.Location)
        return Wyvern.BoundErrorExpression.New()
    end if
end function

Wyvern.Binder.BindBlockStatement = function(syntax)
    statements = []
    self.Scope = Wyvern.BoundScope.New(self.Scope)

    for statementSyntax in syntax.Statements
        statement = self.BindStatement(statementSyntax)
        statements.push(statement)
    end for

    self.Scope = self.Scope.Parent

    return Wyvern.BoundBlockStatement.New(statements)
end function

// IK this is clone of this ^ but it's more efficient this way
Wyvern.Binder.BindCaseBodyStatement = function(syntax)
    statements = []
    self.Scope = Wyvern.BoundScope.New(self.Scope)

    for statementSyntax in syntax.Statements
        statement = self.BindStatement(statementSyntax)
        statements.push(statement)
    end for

    self.Scope = self.Scope.Parent

    return Wyvern.BoundCaseBodyStatement.New(statements)
end function

Wyvern.Binder.BindExpressionStatement = function(syntax)
    expression = self.BindExpression(syntax.Expression, true)
    return Wyvern.BoundExpressionStatement.New(expression)
end function

// Loop tracker
Wyvern.Binder.EnterLoop = function()
    self.LoopCount = self.LoopCount + 1
end function

Wyvern.Binder.IsInLoop = function()
    return self.LoopCount > 0
end function

Wyvern.Binder.ExitLoop = function()
    if self.IsInLoop() then
        self.LoopCount = self.LoopCount - 1
    end if
end function

Wyvern.Binder.BindWhileStatement = function(syntax)
    condition = self.BindConversion(syntax.Condition, Wyvern.TypeSymbols.Bool)
    self.EnterLoop()
    self.Scope = Wyvern.BoundScope.New(self.Scope)
    body = self.BindStatement(syntax.Body)
    self.Scope = self.Scope.Parent
    self.ExitLoop()
    return Wyvern.BoundWhileStatement.New(condition, body)
end function

Wyvern.Binder.BindDoWhileStatement = function(syntax)
    condition = self.BindConversion(syntax.Condition, Wyvern.TypeSymbols.Bool)
    self.EnterLoop()
    self.Scope = Wyvern.BoundScope.New(self.Scope)
    body = self.BindStatement(syntax.Body)
    self.Scope = self.Scope.Parent
    self.ExitLoop()
    return Wyvern.BoundDoWhileStatement.New(condition, body)
end function

Wyvern.Binder.BindForStatement = function(syntax)
    self.Scope = Wyvern.BoundScope.New(self.Scope)
    preStatement = self.BindStatement(syntax.Pre)
    condition = self.BindExpression(syntax.Condition, Wyvern.TypeSymbols.Bool)
    postStatement = self.BindStatement(syntax.Post)
    self.EnterLoop()
    body = self.BindStatement(syntax.Body)
    self.ExitLoop()
    self.Scope = self.Scope.Parent
    return Wyvern.BoundForStatement.New(preStatement, condition, postStatement, body)
end function

Wyvern.Binder.BindForeachStatement = function(syntax)
    name = syntax.Identifier.Text
    isReadOnly = syntax.VKeyword.Kind == Wyvern.SyntaxKind.ConstKeyword
    type = self.BindTypeClause(syntax.TypeClause)
    iterator = self.BindExpression(syntax.Iterator)

    if iterator.Type.Kind != Wyvern.SymbolKind.Array and iterator.Type != Wyvern.TypeSymbols.String then
        self.Diagnostics.ReportUnableToLoop(syntax.Iterator.Location)
        return Wyvern.BoundErrorExpression.New()
    end if

    if type == null then
        if iterator.Type.Kind == Wyvern.SymbolKind.Array then
            type = iterator.Type.Type
        else
            type = iterator.Type
        end if
    else
        conversion = Wyvern.Conversion.Classify(type, iterator.Type.Type)

        if not conversion.Exists then
            self.Diagnostics.ReportCannotConvert(syntax.TypeClause.Location, type, iterator.Type.Type)
            return Wyvern.BoundErrorExpression.New()
        end if

        if conversion.IsExplicit then
            self.Diagnostics.ReportCannotConvertImplicitly(syntax.TypeClause.Location, type, iterator.Type.Type)
            return Wyvern.BoundErrorExpression.New()
        end if
    end if

    if syntax.VKeyword.Kind != Wyvern.SyntaxKind.LetKeyword then
        variable = Wyvern.GlobalVariableSymbol.New(name, isReadOnly, type, null)
    else
        variable = Wyvern.LocalVariableSymbol.New(name, isReadOnly, type, null)
    end if

    self.Scope = Wyvern.BoundScope.New(self.Scope)
    if syntax.VKeyword.Kind == Wyvern.SyntaxKind.LetKeyword then
        if self.Scope.TryDeclareVariable(variable) == false then
            self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, variable.Name)
        end if
    else
        if self.Scope.TryDeclareGlobalVariable(variable) == false then
            self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, variable.Name)
        end if
    end if

    self.EnterLoop()
    self.Scope.DeclareSymbol(Wyvern.LocalVariableSymbol.New("__" + variable.Name + "_idx", true, Wyvern.TypeSymbols.Number))
    body = self.BindStatement(syntax.Body)
    self.ExitLoop()
    self.Scope = self.Scope.Parent
    return Wyvern.BoundForeachStatement.New(variable, iterator, body)
end function

Wyvern.Binder.BindVariableDeclaration = function(syntax, declare=true, noBody=false)
    name = syntax.Identifier.Text
    declare = not syntax.Identifier.IsMissing and declare
    isReadOnly = syntax.Keyword.Kind == Wyvern.SyntaxKind.ConstKeyword
    type = self.BindTypeClause(syntax.TypeClause)

    if syntax.Initializer == null then
        if type == null then
            type = Wyvern.TypeSymbols.Any
        end if

        if syntax.Keyword.Kind != Wyvern.SyntaxKind.LetKeyword then
            variable = Wyvern.GlobalVariableSymbol.New(syntax.Identifier.Text, isReadOnly, type, null)
        else
            variable = Wyvern.LocalVariableSymbol.New(syntax.Identifier.Text, isReadOnly, type, null)
        end if

        if syntax.Keyword.Kind == Wyvern.SyntaxKind.LetKeyword then
            if declare and self.Scope.TryDeclareVariable(variable) == false then
                self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, variable.Name)
            end if
        else
            if declare and self.Scope.TryDeclareGlobalVariable(variable) == false then
                self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, variable.Name)
            end if
        end if
        
        return Wyvern.BoundVariableDeclaration.New(variable, null)
    else
        if noBody then
            self.Diagnostics.ReportNoInitializerAllowed(syntax.Identifier.Location, name)
        end if
        initializer = self.BindExpression(syntax.Initializer)
    end if

    if type == null then
        type = initializer.Type
    end if

    if initializer.hasIndex("ConstantValue") then
        constantValue = initializer.ConstantValue
    else
        constantValue = null
    end if

    variable = self.BindVariable(syntax, isReadOnly, type, constantValue, declare)
    convertedInitializer = self.BindConversionInternal(syntax.Initializer.Location, initializer, type)

    return Wyvern.BoundVariableDeclaration.New(variable, convertedInitializer)
end function

Wyvern.Binder.BindVariable = function(syntax, isReadOnly, variableType, constant=null, declare=true)
    if self.Function == null or syntax.Keyword.Kind != Wyvern.SyntaxKind.LetKeyword  then
        variable = Wyvern.GlobalVariableSymbol.New(syntax.Identifier.Text, isReadOnly, variableType, constant)
    else
        variable = Wyvern.LocalVariableSymbol.New(syntax.Identifier.Text, isReadOnly, variableType, constant)
    end if

    if syntax.Keyword.Kind == Wyvern.SyntaxKind.LetKeyword then
        if declare and self.Scope.TryDeclareVariable(variable) == false then
            self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, variable.Name)
        end if
    else
        if declare and self.Scope.TryDeclareGlobalVariable(variable) == false then
            self.Diagnostics.ReportSymbolAlreadyDeclared(syntax.Identifier.Location, variable.Name)
        end if
    end if

    return variable
end function

Wyvern.Binder.BindTypeClause = function(syntax)
    if syntax == null then return null
    return self.BindTypeSignature(syntax.TypeSignature)
end function

Wyvern.Binder.LookupType = function(name)
    if Wyvern.TypeNameBindings.hasIndex(name) then
        return Wyvern.TypeNameBindings[name]
    end if
    
    symbol = self.Scope.LookupSymbol(name)
    
    if symbol != null then
        if symbol.Kind != Wyvern.SymbolKind.Class and symbol.Kind != Wyvern.SymbolKind.Contract and symbol.Kind != Wyvern.SymbolKind.Enum and symbol.Kind != Wyvern.SymbolKind.Struct then
            return null
        end if

        return symbol
    end if

    return null
end function