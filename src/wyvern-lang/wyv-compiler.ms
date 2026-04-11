Wyvern.CompilationResults = {"Diagnostics":-1, "Code":-1}

Wyvern.CompilationResults.Init = function(diagnostics, code)
    self.Diagnostics = diagnostics
    self.Code = code
end function

Wyvern.CompilationResults.New = function(diagnostics, code)
    newInstance = new Wyvern.CompilationResults
    newInstance.Init(diagnostics, code)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.Compiler = {"Root":-1, "ClassDeclarations":-1, "StructDeclarations":-1, "FunctionDeclarations":-1, "EnumDeclarations":-1, "MSImports":-1, "SwitchMaps":-1, "SwitchGuard":-1}

Wyvern.Compiler.Init = function(program, root)
    self.ClassDeclarations = program.BoundClasses
    self.StructDeclarations = program.BoundStructs
    self.FunctionDeclarations = program.BoundFunctions
    self.EnumDeclarations = program.BoundEnums
    self.MSImports = program.BoundMSImports
    self.SwitchMaps = []
    self.SwitchGuard = {}
    self.Root = root

    self.Program = program
end function

Wyvern.Compiler.Indent = function(s)
    f = []
    for l in s.split(char(10))
        f.push(char(9) + l)
    end for
    return f.join(char(10))
end function

Wyvern.Compiler.New = function(program, root)
    newInstance = new Wyvern.Compiler
    newInstance.Init(program, root)
    return newInstance
end function

Wyvern.Compiler.Compile = function()
    out = []
    for i in self.MSImports
        out.push(self.CompileMSImport(i))
    end for

    for e in self.EnumDeclarations
        if self.InImports(e) then continue
        out.push(self.CompileEnumDeclaration(e))
    end for

    for c in self.ClassDeclarations
        if self.InImports(c) then continue
        out.push(self.CompileClassDeclaration(c))
    end for

    for s in self.StructDeclarations
        out.push(self.CompileStructDeclaration(s))
    end for

    for f in self.FunctionDeclarations
        if self.InImports(f) then continue
        out.push(self.CompileFunctionDeclaration(f))
    end for

    out.push(self.CompileStatement(self.Root))
    if self.SwitchMaps.len != 0 then
        out.insert(0, self.SwitchMaps.join(char(10)))
    end if
    return out.join(char(10))
end function

Wyvern.Compiler.InImports = function(declaration)
    //for import in self.MSImports
    //    for decl in import.Members
    //        if decl == declaration then
    //            return true
    //        end if
    //    end for
    //end for

    //return false
    
    return self.Program.GlobalScope.IsMiniscriptImport(declaration)
end function

// string
// number / bool
// null
// map
// list
Wyvern.Compiler.CharConversions = [10, 13, 9, 0, 12, 8, 11]
Wyvern.Compiler.GenerateMSString = function(s0)
    s = []
    sroll = ""
    for c in s0
        if self.CharConversions.indexOf(c.code) != null then
            if sroll != "" then
                s.push("""" + sroll + """")
                sroll = ""
            end if
            s.push("char(" + c.code + ")")
        else if c == """" then
            sroll = sroll + """"""
        else
            sroll = sroll + c
        end if
    end for
    if sroll != "" then
        s.push("""" + sroll + """")
    end if

    if s.len == 0 then
        return """"""
    end if
    return s.join("+")
end function

Wyvern.Compiler.CompileLiteralExpression = function(expression)
    if expression.Type == Wyvern.TypeSymbols.String then
        return self.GenerateMSString(expression.Value)
    else if expression.Type == Wyvern.TypeSymbols.Bool then
        if expression.Value == true then
            return "true"
        end if
        return "false"
    else if expression.Type == Wyvern.TypeSymbols.Null then
        return "null"
    else
        return str(expression.Value)
    end if
end function

Wyvern.Compiler.CompileAssignmentExpression = function(expression)
    name = expression.Variable.Name

    return name + " = " + self.CompileExpression(expression.Expression)
end function

Wyvern.Compiler.CompileCallingAssignmentExpression = function(expression)
    left = self.CompileExpression(expression.Change, true)

    return left + " = " + self.CompileExpression(expression.Expression)
end function

Wyvern.Compiler.CompileVariableExpression = function(expression, noAt=false)
    if expression.Type isa Wyvern.FunctionReferenceSymbol then
        return expression.Type.Function.Name
    end if
    return expression.Variable.Name
end function

Wyvern.Compiler.CompileBinaryExpression = function(expression)
    left = self.CompileExpression(expression.Left)
    right = self.CompileExpression(expression.Right)

    operatorKind = expression.Op.Kind

    if operatorKind == Wyvern.BoundBinaryOperatorKind.Addition then
        return left + " + " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Subtraction then
        return left + " - " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Multiplication then
        return left + " * " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Division then
        return left + " / " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Modulus then
        return left + " % " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.Exponentiation then
        return left + " ^ " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseAnd then
        return "bitwise(""&"", " + left + ", " + right + ")"
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseOr then
        return "bitwise(""|"", " + left + ", " + right + ")"
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseXor then
        return "bitwise(""^"", " + left + ", " + right + ")"
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseRightShift then
        return "bitwise("">>"", " + left + ", " + right + ")"
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseLeftShift then
        return "bitwise(""<<"", " + left + ", " + right + ")"
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.BitwiseUnsignedRightShift then
        return "bitwise("">>>"", " + left + ", " + right + ")"
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalEquals then
        return left + " == " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalNotEquals then
        return left + " != " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalLessThan then
        return left + " < " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalLessThanOrEqual then
        return left + " <= " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalGreater then
        return left + " > " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalGreaterOrEqual then
        return left + " >= " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalAnd then
        return left + " and " + right
    else if operatorKind == Wyvern.BoundBinaryOperatorKind.LogicalOr then
        return left + " or " + right
    else
        exit("ERROR: Unexpected binary operator kind: " + Wyvern.BoundBinaryOperatorKind.ToString(operatorKind))
    end if

    exit("ERROR: Unknown binary operator kind: " + Wyvern.GetKey(Wyvern.BoundBinaryOperatorKind, operatorKind))
end function

Wyvern.Compiler.CompileUnaryExpression = function(expression)
    operand = self.CompileExpression(expression.Operand)

    operatorKind = expression.Op.Kind

    if operatorKind == Wyvern.BoundUnaryOperatorKind.Negation then
        return "-" + operand
    else if operatorKind == Wyvern.BoundUnaryOperatorKind.BitwiseComplement then
        return "bitwise(""~"", " + operand + ")"
    else if operatorKind == Wyvern.BoundUnaryOperatorKind.LogicalNegation then
        return "not " + operand
    end if

    exit("ERROR: Unkown unary operator kind: " + Wyvern.GetKey(Wyvern.BoundUnaryOperatorKind, unaryExpression.Op))
end function

Wyvern.Compiler.CompileCallExpression = function(expression)
    if expression.Arguments.len() <= 0 then
        if expression.Function.Type == Wyvern.TypeSymbols.Reference then
            return expression.Function.Name + "()"
        end if
        return expression.Function.Name
    end if
    name = expression.Function.Name

    args = []
    for arg in expression.Arguments
        args.push(self.CompileExpression(arg))
    end for

    return name + "(" + args.join(", ") + ")"
end function

Wyvern.Compiler.CompileConversionExpression = function(expression)
    value = self.CompileExpression(expression.Expression)
    if expression.IsUnsafe then
        return value
    end if

    if (expression.Type == Wyvern.TypeSymbols.Bool or expression.Type == Wyvern.TypeSymbols.Number) and expression.Expression.Type == Wyvern.TypeSymbols.String then
        return "(" + value + ").val"
    else if expression.Type == Wyvern.TypeSymbols.String then
        if expression.Expression.Type isa Wyvern.EnumSymbol then
            return expression.Expression.Type.Name + ".indexOf(" + value + ")"
        end if
        return "str(" + value + ")"
    else if expression.Type == Wyvern.TypeSymbols.Null or expression.Type == Wyvern.TypeSymbols.Void then
        return "null"
    else if expression.Type == Wyvern.TypeSymbols.Any then
        return value
    else if expression.Expression.Type == Wyvern.TypeSymbols.Library then
        return value
    else if expression.Type.Kind == Wyvern.SymbolKind.Enum and expression.Expression.Type == Wyvern.TypeSymbols.String then
        return expression.Type.Name + "[" + value + "]" 
    else if expression.Type.Kind == Wyvern.SymbolKind.Map or expression.Type.Kind == Wyvern.SymbolKind.Array then
        return value
    end if

    return value
    //exit("ERROR: Unknown conversion type: " + expression.Type.Name)
end function

Wyvern.Compiler.CompileArrayExpression = function(expression)
    items = []
    for item in expression.Items
        items.push(self.CompileExpression(item))
    end for

    return "[" + items.join(", ") + "]"
end function

Wyvern.Compiler.CompileMapExpression = function(expression)
    pairs = []
    for pair in expression.Pairs
        pairs.push(self.CompileExpression(pair.Key) + ":" + self.CompileExpression(pair.Value))
    end for

    return "{" + pairs.join(", ") + "}"
end function

Wyvern.Compiler.CompileParenthesizedExpression = function(expression)
    return "(" + self.CompileExpression(expression.Expression) + ")"
end function

Wyvern.Compiler.CompileIndexExpression = function(expression)
    return self.CompileExpression(expression.Expression) + "[" + self.CompileExpression(expression.Index) + "]"
end function

Wyvern.Compiler.CompileNamecallExpression = function(expression)
    return self.CompileExpression(expression.Left) + "." + self.CompileExpression(expression.Right, true)
end function

Wyvern.Compiler.CompileNewExpression = function(expression)
    args = []
    for arg in expression.Arguments
        args.push(self.CompileExpression(arg))
    end for

    return expression.Type.Name + ".__new__(" + args.join(", ") + ")"
end function

Wyvern.Compiler.CompileNewStructExpression = function(expression)
    if expression.Arguments.len <= 0 then
        return "(new " + expression.Type.Name + ")"
    end if
    construct = []
    for argument in expression.Arguments
        construct.push("""" + argument.Name + """:" + self.CompileExpression(argument.Expression))
    end for

    return "(new " + expression.Type.Name + " + {" + construct.join(", ") + "})"
end function

Wyvern.Compiler.CompileExpression = function(expression, noAt=false)
    result = self.CompileExpressionInternal(expression)

    if not noAt then
        if expression.Type == Wyvern.TypeSymbols.Reference then
            return "@" + result
        else if expression.Type isa Wyvern.FunctionReferenceSymbol then
            return "@" + result
        end if
    end if

    return result
end function

Wyvern.Compiler.CompileExpressionInternal = function(expression)
    if not (expression isa Wyvern.BoundExpression) then
        exit("Can't compile non bound expression: " + expression)
    end if

    if expression.Kind == Wyvern.BoundNodeKind.LiteralExpression then
        return self.CompileLiteralExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.AssignmentExpression then
        return self.CompileAssignmentExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.CallingAssignmentExpression then
        return self.CompileCallingAssignmentExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.VariableExpression then
        return self.CompileVariableExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.BinaryExpression then
        return self.CompileBinaryExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.UnaryExpression then
        return self.CompileUnaryExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.CallExpression then
        return self.CompileCallExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.ConversionExpression then
        return self.CompileConversionExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.ArrayExpression then
        return self.CompileArrayExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.MapExpression then
        return self.CompileMapExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.ParenthesizedExpression then
        return self.CompileParenthesizedExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.IndexExpression then
        return self.CompileIndexExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.NamecallExpression then
        return self.CompileNamecallExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.NewExpression then
        return self.CompileNewExpression(expression)
    else if expression.Kind == Wyvern.BoundNodeKind.NewStructExpression then
        return self.CompileNewStructExpression(expression)
    end if

    exit("ERROR: Unkown Expression: " + Wyvern.GetKey(Wyvern.BoundNodeKind, expression.Kind))
end function


Wyvern.Compiler.CompileBlockStatement = function(blockStatement)
    statements = []
    for statement in blockStatement.Statements
        statements.push(self.CompileStatement(statement))
    end for
    return statements.join(char(10))
end function

Wyvern.Compiler.CompileCaseBodyStatement = function(statement)
    statements = []
    for statement in statement.Statements
        statements.push(self.CompileStatement(statement))
    end for
    return statements.join(char(10))
end function

Wyvern.Compiler.CompileVariableDeclaration = function(expression)
    name = expression.Variable.Name

    if expression.Initializer == null then
        return name + " = null"
    end if

    return name + " = " + self.CompileExpression(expression.Initializer)
end function

Wyvern.Compiler.CompileExpressionStatement = function(statement)
    return self.CompileExpression(statement.Expression)
end function

Wyvern.Compiler.CompileIfStatement = function(statement, noEnd=false)
    condition = self.CompileExpression(statement.Condition)

    fstate = []
    fstate.push("if " + condition + " then")
    fstate.push(char(10))
    fstate.push(self.Indent(self.CompileStatement(statement.ThenStatement)))
    
    fstate.push(char(10))
    if statement.ElseStatement != null then
        fstate.push("else")
        if statement.ElseStatement.Kind == Wyvern.BoundNodeKind.IfStatement then
            fstate.push(" " + self.CompileIfStatement(statement.ElseStatement))
        else
            fstate.push(char(10))
            fstate.push(self.Indent(self.CompileStatement(statement.ElseStatement)))
            
            fstate.push(char(10))
            fstate.push("end if")
        end if
    else if noEnd == false then
        fstate.push("end if")
    end if

    return fstate.join("")
end function

Wyvern.Compiler.GenerateSwitchMap = function(cases)
    if self.SwitchGuard.hasIndex(cases) then
        return self.SwitchGuard[cases]
    end if

    switchNumber = self.SwitchMaps.len
    switchName = "__SM" + switchNumber

    fstate = []
    fstate.push(switchName)
    fstate.push(" = {}")
    fstate.push(char(10))
    for c in cases
        for i in Wyvern.SafeRange(0, c.Cases.len - 1)
            case = c.Cases[i]
            fstate.push(switchName)
            fstate.push("[")
            fstate.push(self.CompileConstantValue(case))
            fstate.push("]")
            fstate.push(" = ")

            if i == 0 then
                fstate.push("function(__l)")
                fstate.push(char(10))
                fstate.push(self.Indent("for k in __l;locals[k.key]=k.value;end for"))
                fstate.push(char(10))
                fstate.push(self.Indent(self.CompileStatement(c.Body)))
                fstate.push(char(10))
                fstate.push("end function")
            else
                fstate.push("@")
                fstate.push(switchName)
                fstate.push("[")
                fstate.push(self.CompileConstantValue(c.Cases[0]))
                fstate.push("]")
            end if
            fstate.push(char(10))
        end for
    end for
    fstate.pop()

    self.SwitchMaps.push(fstate.join(""))
    self.SwitchGuard[cases] = switchName

    return switchName
end function

Wyvern.Compiler.DEPRICATED__CompileSwitchStatement = function(statement)
    switchMapName = self.GenerateSwitchMap(statement.Cases)
    expression = self.CompileExpression(statement.Expression)

    fstate = []
    fstate.push("if ")
    fstate.push(switchMapName)
    fstate.push(".hasIndex")
    fstate.push("(")
    fstate.push(expression)
    fstate.push(")")
    fstate.push(" then")
    fstate.push(char(10))
    fstate.push(char(9))
    fstate.push(switchMapName)
    fstate.push("[")
    fstate.push(expression)
    fstate.push("]")
    fstate.push("(locals)")
    fstate.push(char(10))
    
    if statement.Default != null then
        fstate.push("else")
        fstate.push(char(10))
        fstate.push(self.Indent(self.CompileStatement(statement.Default)))
        fstate.push(char(10))
        fstate.push("end if")
    else
        fstate.push("end if")
    end if

    return fstate.join("")
end function

Wyvern.Compiler.CompileSwitchStatement = function(statement)
    fstate = []
    fstate.push("__SS = ")
    fstate.push(self.CompileExpression(statement.Expression))
    fstate.push(char(10))
    fstate.push("if ")

    for caseBody in statement.Cases
        cstate = []
        for case in caseBody.Cases
            cstate.push("__SS == " + self.CompileConstantValue(case))
        end for

        fstate.push(cstate.join(" or "))
        fstate.push(" then")
        fstate.push(char(10))
        fstate.push(self.Indent(self.CompileStatement(caseBody.Body)))
        fstate.push(char(10))
        fstate.push("else")
        fstate.push(" if ")
    end for

    fstate.pop()
    if statement.Default != null then
        fstate.push(char(10))
        fstate.push(self.Indent(self.CompileStatement(statement.Default)))
        fstate.push(char(10))
    else
        fstate.pop()
    end if

    fstate.push("end if")
    
    return fstate.join("")
end function

Wyvern.Compiler.CompileWhileStatement = function(statement)
    condition = self.CompileExpression(statement.Condition)
    
    fstate = []
    fstate.push("while " + condition)
    fstate.push(char(10))
    fstate.push(self.Indent(self.CompileStatement(statement.Body)))
    fstate.push(char(10))
    fstate.push("end while")

    return fstate.join("")
end function

Wyvern.Compiler.CompileDoWhileStatement = function(statement)
    condition = self.CompileExpression(statement.Condition)

    fstate = []
    fstate.push("while true")
    fstate.push(char(10))
    fstate.push(self.Indent(self.CompileStatement(statement.Body)))
    fstate.push(char(10))
    fstate.push(char(9))
    fstate.push("if not ")
    fstate.push("(")
    fstate.push(condition)
    fstate.push(")")
    fstate.push("then break")
    fstate.push(char(10))
    fstate.push("end while")

    return fstate.join("")
end function

Wyvern.Compiler.CompileForStatement = function(statement)
    pre = self.CompileStatement(statement.Pre)
    condition = self.CompileExpression(statement.Condition)
    post = self.CompileStatement(statement.Post)

    fstate = []
    fstate.push(pre)
    fstate.push(char(10))
    fstate.push("while " + condition)
    fstate.push(char(10))
    fstate.push(self.Indent(self.CompileStatement(statement.Body)))
    fstate.push(char(10))
    fstate.push(self.Indent(post))
    fstate.push(char(10))
    fstate.push("end while")

    return fstate.join("")
end function

Wyvern.Compiler.CompileForeachStatement = function(statement)
    fstate = []
    fstate.push("for ")
    fstate.push(statement.Variable.Name)
    fstate.push(" in ")
    fstate.push(self.CompileExpression(statement.Iterator))
    fstate.push(char(10))
    fstate.push(self.Indent(self.CompileStatement(statement.Body)))
    fstate.push(char(10))
    fstate.push("end for")

    return fstate.join("")
end function

Wyvern.Compiler.CompileReturnStatement = function(statement)
    if statement.Expression != null then
        value = self.CompileExpression(statement.Expression)
    else
        value = "null"
    end if

    return "return " + value
end function

Wyvern.Compiler.CompileContinueStatement = function(statement)
    return "continue"
end function

Wyvern.Compiler.CompileBreakStatement = function(statement)
    return "break"
end function

Wyvern.Compiler.CompileStatement = function(statement, skip=false)
    if statement.Kind == Wyvern.BoundNodeKind.BlockStatement then
        return self.CompileBlockStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.CaseBodyStatement then
        return self.CompileCaseBodyStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.VariableDeclaration then
        return self.CompileVariableDeclaration(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.ExpressionStatement then
        return self.CompileExpressionStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.IfStatement then
        return self.CompileIfStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.SwitchStatement then
        return self.CompileSwitchStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.WhileStatement then
        return self.CompileWhileStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.DoWhileStatement then
        return self.CompileDoWhileStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.ForStatement then
        return self.CompileForStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.ForeachStatement then
        return self.CompileForeachStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.ReturnStatement then
        return self.CompileReturnStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.ContinueStatement then
        return self.CompileContinueStatement(statement)
    else if statement.Kind == Wyvern.BoundNodeKind.BreakStatement then
        return self.CompileBreakStatement(statement)
    end if

    exit("ERROR: Unexpected statement kind: " + Wyvern.GetKey(Wyvern.BoundNodeKind, statement.Kind))
end function

Wyvern.Compiler.CreateRuntimeErrorCall = function(text)
    return "exit(""[WyvCompiler Runtime Error]: " + text + """)"
end function

Wyvern.Compiler.CompileConstantValue = function(value)
    if typeof(value.Value) == "string" then
        return self.GenerateMSString(value.Value)
    else if typeof(value.Value) == "null" then
        return "null"
    else
        return str(value.Value)
    end if
end function

Wyvern.Compiler.GenerateFunctionParameters = function(parameters)
    fparams = []
    for param in parameters
        fparam = param.Name
        if param.Initializer != null then
            fparam = fparam + "="
            if param.Initializer.hasIndex("ConstantValue") then
                fparam = fparam + self.CompileConstantValue(param.Initializer.ConstantValue)
            else
                fparam = fparam + self.CompileExpression(param.Initializer)
            end if
        end if
        fparams.push(fparam)
    end for
    return fparams.join(", ")
end function

Wyvern.Compiler.CompileFunctionDeclaration = function(declaration, name=null)
    if name == null then
        name = declaration.Name
    end if

    fstate = []
    fstate.push(name)
    fstate.push(" = ")
    fstate.push("function")
    fstate.push("(")

    fstate.push(self.GenerateFunctionParameters(declaration.Parameters))

    fstate.push(")")
    fstate.push(char(10))

    if declaration.Body == null then
        fstate.push(char(9))
        fstate.push(self.CreateRuntimeErrorCall(declaration.Name + "( " + self.GenerateFunctionParameters(declaration.Parameters) + " ) : Unimplemented"))
    else
        fstate.push(self.Indent(self.CompileStatement(declaration.Body)))
    end if
    
    fstate.push(char(10))
    fstate.push("end function")
    return fstate.join("")
end function

Wyvern.Compiler.CreateClassManifesto = function(declaration)
    manifesto = []
    for property in declaration.Members
        pdeclaration = property.Declaration
        if pdeclaration.Kind == Wyvern.BoundNodeKind.VariableDeclaration then
            manifesto.push("""" + pdeclaration.Variable.Name + """:null")
            //if pdeclaration.Initializer == null then
            //    manifesto.push("""" + pdeclaration.Variable.Name + """:null")
            //else
            //    manifesto.push("""" + pdeclaration.Variable.Name + """:" + "null")//self.CompileExpression(pdeclaration.Initializer))
            //end if
        end if
    end for
    return manifesto.join(", ")
end function

Wyvern.Compiler.CompileMSImport = function(msImport)
    if msImport.Path == "" then
        return ""
    end if
    return "import_code(""" + msImport.Path + """)"
end function

// {"Name":-1, "ExtensionType":-1, "Members":-1, "Symbol":-1}
// {"IsPublic":-1, "IsPrivate":-1, "IsStatic":-1, "IsOverride":-1, "IsVirtual":-1, "Declaration":-1, "Symbol":-1}
Wyvern.Compiler.CompileClassDeclaration = function(declaration)
    fstate = []
    className = declaration.Name
    fstate.push(className)
    fstate.push(" = ")

    if declaration.ExtensionType != null then
        fstate.push("new ")
        fstate.push(declaration.ExtensionType.Name)
        fstate.push(" + ")
    end if

    fstate.push("{")
    fstate.push(self.CreateClassManifesto(declaration))
    fstate.push("}")

    fstate.push(char(10))

    funcDeclarations = []
    constructorIndex = -1

    for method in declaration.Members
        fdeclaration = method.Declaration
        if fdeclaration.Kind == Wyvern.BoundNodeKind.FunctionDeclaration then
            funcDeclarations.push(fdeclaration)
            if fdeclaration.Symbol.Name == "__constructor__" then
                constructorIndex = funcDeclarations.len() - 1
            end if
        end if
    end for

    for funcDeclaration in funcDeclarations
        fstate.push(className)
        fstate.push(".")

        if funcDeclaration.Symbol.Name == "__constructor__" then
            fstate.push(self.CompileFunctionDeclaration(funcDeclaration, "__constructor__"))
        else
            fstate.push(self.CompileFunctionDeclaration(funcDeclaration))
        end if

        fstate.push(char(10))
    end for

    fstate.push(className)
    fstate.push(".__new__")
    
    if constructorIndex == -1 then
        fstate.push(" = function()")

        fstate.push(char(10))
        fstate.push(char(9))
        fstate.push("newInstance = new ")
        fstate.push(className)

        fstate.push(char(10))
        fstate.push(char(9))

        fstate.push("newInstance.classID = """ + className + """")
        fstate.push(char(10))
        fstate.push(char(9))

        fstate.push("return newInstance")
        fstate.push(char(10))
        
        fstate.push("end function")
    else
        constructorFunc = funcDeclarations[constructorIndex]
        fstate.push(" = function")
        fstate.push("(")
        fstate.push(self.GenerateFunctionParameters(constructorFunc.Parameters))
        fstate.push(")")

        fstate.push(char(10))
        fstate.push(char(9))

        fstate.push("newInstance = new ")
        fstate.push(className)

        fstate.push(char(10))
        fstate.push(char(9))
        
        fstate.push("newInstance.__constructor__")
        fparams = []
        for param in constructorFunc.Parameters
            fparams.push(param.Name)
        end for
        fstate.push("(")
        fstate.push(fparams.join(", "))
        fstate.push(")")
        
        fstate.push(char(10))
        fstate.push(char(9) + "newInstance.classID = """ + className + """" + char(10))
        fstate.push(char(9))
        fstate.push("return newInstance")
        fstate.push(char(10))
        fstate.push("end function")
    end if

    for property in declaration.Members
        pdeclaration = property.Declaration
        if pdeclaration.Kind == Wyvern.BoundNodeKind.VariableDeclaration then
            if pdeclaration.Initializer == null then
                fstate.push(char(10) + className + "[""" + pdeclaration.Variable.Name + """] = null")
            else
                fstate.push(char(10) + className + "[""" + pdeclaration.Variable.Name + """] = " + self.CompileExpression(pdeclaration.Initializer))
            end if
        end if
    end for

    fstate.push(char(10) + className + ".classID = """ + className + """")

    return fstate.join("")
end function

Wyvern.Compiler.CompileStructDeclaration = function(declaration)
    fstate = []
    structName = declaration.Name

    fstate.push(structName)
    fstate.push(" = ")
    fstate.push("{")
    
    decls = []
    
    for member in declaration.Members
        decls.push("""" + member.Name + """:null")
    end for

    fstate.push(decls.join(", "))
    fstate.push("}")
    return fstate.join("")
end function

Wyvern.Compiler.CompileEnumDeclaration = function(declaration)
    fstate = []
    fstate.push(declaration.Name)
    fstate.push(" = ")
    fstate.push("{")
    keys = []
    
    for member in declaration.Members
        keys.push("""" + member.Name + """:" + self.CompileConstantValue(member.ConstantValue))
    end for
    fstate.push(keys.join(", "))
    fstate.push("}")
    return fstate.join("")
end function

// Insert into API
if Wyvern.IsAPIEnabled() then
    Wyvern.Compilation.Compile = function()
        diagnostics = self.Syntax.Diagnostics + self.GlobalScope.Diagnostics

        if diagnostics.len > 0 then
            return Wyvern.CompilationResults.New(diagnostics, null)
        end if

        program = Wyvern.Binder.BindProgram(self.GlobalScope)
        if program.Diagnostics.Length > 0 then
            return Wyvern.CompilationResults.New(program.Diagnostics.ToArray(), null)
        end if

        statement = self.GlobalScope.Statement
        compiler = Wyvern.Compiler.New(program, statement)
        code = compiler.Compile()
        return Wyvern.CompilationResults.New(diagnostics, code)
    end function
end if