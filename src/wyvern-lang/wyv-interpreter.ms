Wyvern.InterpreterResults = {"Diagnostics":-1, "Result":-1}

Wyvern.InterpreterResults.Init = function(diagnostics, result)
    self.Diagnostics = diagnostics
    self.Result = result
end function

Wyvern.InterpreterResults.New = function(diagnostics, result)
    newInstance = new Wyvern.InterpreterResults
    newInstance.Init(diagnostics, result)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.InterpreterContext = {"Variables":-1, "Parent":-1}

Wyvern.InterpreterContext.Init = function(_parent=null)
    self.Parent = _parent
    self.Variables = Wyvern.Dictionary.New()
end function

Wyvern.InterpreterContext.New = function(_parent = null)
    instance = new Wyvern.InterpreterContext
    instance.Init(_parent)
    return instance
end function

Wyvern.InterpreterContext.SetVariable = function(name, value)
    self.Variables.Set(name, value)
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.InterpreterValue = {"Type":-1, "Value":-1}

Wyvern.InterpreterValue.Init = function(type, value)
    self.Type = type
    self.Value = value
end function

Wyvern.InterpreterValue.New = function(type, value)
    instance = new Wyvern.InterpreterValue
    instance.Init(type, value)
    return instance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.Interpreter = {"Root":-1, "ClassDeclarations":-1, "StructDeclarations":-1, "FunctionDeclarations":-1, "EnumDeclarations":-1, "MSImports":-1, "SwitchMaps":-1, "SwitchGuard":-1}

Wyvern.Interpreter.Init = function(program, root)
    self.ClassDeclarations = program.BoundClasses
    self.StructDeclarations = program.BoundStructs
    self.FunctionDeclarations = program.BoundFunctions
    self.EnumDeclarations = program.BoundEnums
    self.MSImports = program.BoundMSImports
    self.Root = root

    self.Context = Wyvern.InterpreterContext.New()

    self.Program = program
end function

Wyvern.Interpreter.New = function(program, root)
    newInstance = new Wyvern.Interpreter
    newInstance.Init(program, root)
    return newInstance
end function

Wyvern.Interpreter.Execute = function()
    return self.InterpretStatement(self.Root)
end function

Wyvern.Interpreter.InterpretStatement = function(statement)
    if statement.Kind == Wyvern.BoundNodeKind.BlockStatement then
        return self.InterpretBlockStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.ExpressionStatement then
        return self.InterpretExpressionStatement(statement)
    end if
end function

Wyvern.Interpreter.InterpretBlockStatement = function(blockStatement)
    result = null
    for statement in blockStatement.Statements
        result = self.InterpretStatement(statement)
    end for

    return result
end function

Wyvern.Interpreter.InterpretExpressionStatement = function(statement)
    return self.InterpretExpression(statement.Expression)
end function

Wyvern.Interpreter.InterpretExpression = function(expression)
    if not (expression isa Wyvern.BoundExpression) then
        exit("Can't compile non bound expression: " + expression)
    end if

    if expression.Kind == Wyvern.BoundNodeKind.LiteralExpression then
        return self.InterpretLiteralExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.AssignmentExpression then
        return self.InterpretAssignmentExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.BinaryExpression then
        return self.InterpretBinaryExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.CallExpression then
        return self.InterpretCallExpression(expression)
    end if
end function

Wyvern.Interpreter.InterpretAssignmentExpression = function(expression)
    value = self.InterpretExpression(expression.Expression)
    self.Context.SetVariable(expression.Variable.Name, value)
    return value
end function

Wyvern.Interpreter.InterpretLiteralExpression = function(expression)
    return Wyvern.InterpreterValue.New(expression.Type, expression.Value)
end function

Wyvern.Interpreter.InterpretBinaryExpression = function(expression)
    return Wyvern.InterpreterValue.New(expression.Type, self.InterpretBinaryExpressionInternal(expression))
end function

Wyvern.Interpreter.InterpretBinaryExpressionInternal = function(expression)
    left = self.InterpretExpression(expression.Left).Value
    right = self.InterpretExpression(expression.Right).Value

    operatorKind = expression.Op.Kind

    if operatorKind == Wyvern.BoundBinaryOperatorKind.Addition then
        return left + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Subtraction then
        return left - right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Multiplication then
        return left * right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Division then
        return left / right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Modulus then
        return left % right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Exponentiation then
        return left ^ right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseAnd then
        return bitwise("&", left, right)
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseOr then
        return bitwise("|", left, right)
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseXor then
        return bitwise("^", left, right)
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseRightShift then
        return bitwise(">>", left, right)
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseLeftShift then
        return bitwise("<<", left, right)
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseUnsignedRightShift then
        return bitwise(">>>", left, right)
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalEquals then
        return left == right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalNotEquals then
        return left != right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalLessThan then
        return left < right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalLessThanOrEqual then
        return left <= right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalGreater then
        return left > right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalGreaterOrEqual then
        return left >= right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalAnd then
        return left and right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalOr then
        return left or right
    else
        exit("ERROR: Unexpected binary operator kind: " + Wyvern.BoundBinaryOperatorKind.ToString(operatorKind))
    end if

    exit("ERROR: Unknown binary operator kind: " + Wyvern.GetKey(Wyvern.BoundBinaryOperatorKind, operatorKind))
end function

Wyvern.Interpreter.InterpretCallExpression = function(expression)
    if expression.Function.Kind == Wyvern.SymbolKind.Builtin then
    end if
end function

// Insert into API
if Wyvern.IsAPIEnabled() then
    Wyvern.Compilation.Execute = function()
        diagnostics = self.Syntax.Diagnostics + self.GlobalScope.Diagnostics

        if diagnostics.len > 0 then
            return Wyvern.InterpreterResults.New(diagnostics, null)
        end if

        program = Wyvern.Binder.BindProgram(self.GlobalScope)
        if program.Diagnostics.Length > 0 then
            return Wyvern.InterpreterResults.New(program.Diagnostics.ToArray(), null)
        end if

        statement = self.GlobalScope.Statement
        interpreter = Wyvern.Interpreter.New(program, statement)
        result = interpreter.Execute()
        return Wyvern.InterpreterResults.New(diagnostics, result)
    end function
end if