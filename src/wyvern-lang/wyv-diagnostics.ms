Wyvern.Diagnostic = {"Message":"", "Code":-1, "Location":-1}

Wyvern.Diagnostic.Init = function(message, code, location)
    self.Message = message
    self.Code = code
    self.Location = location
end function

Wyvern.Diagnostic.New = function(message, code, location)
    newInstance = new Wyvern.Diagnostic
    newInstance.Init(message, code, location)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.DiagnosticBag = {"Diagnostics":[]}

Wyvern.DiagnosticBag.Init = function(diagnostics=null)
    if diagnostics == null then diagnostics = []
    self.Diagnostics = diagnostics
end function

Wyvern.DiagnosticBag.New = function(diagnostics=null)
    newInstance = new Wyvern.DiagnosticBag
    newInstance.Init(diagnostics)
    return newInstance
end function

Wyvern.DiagnosticBag.Add = function(diagnostic)
    self.Diagnostics.push(diagnostic)
end function

Wyvern.DiagnosticBag.Length = function()
    return self.Diagnostics.len()
end function

Wyvern.DiagnosticBag.ToArray = function()
    return self.Diagnostics
end function

Wyvern.DiagnosticBag.Concat = function(diagnosticBag)
    return Wyvern.DiagnosticBag.New(self.Diagnostics + diagnosticBag.Diagnostics)
end function

Wyvern.DiagnosticBag.AddRange = function(diagnosticBag)
    if typeof(diagnosticBag) == "map" then
        self.Diagnostics = self.Diagnostics + diagnosticBag.ToArray()
    else if typeof(diagnosticBag) == "list" then
        self.Diagnostics = self.Diagnostics + diagnosticBag
    end if
end function

Wyvern.DiagnosticBag.Report = function(message, location, code)
    self.Add(Wyvern.Diagnostic.New(message, code, location))
end function

Wyvern.DiagnosticCode = {}
Wyvern.DiagnosticCode.UNKOWN_TOKEN                         = Wyvern.auto()
Wyvern.DiagnosticCode.INVALID_NUMBER                       = Wyvern.auto()
Wyvern.DiagnosticCode.DOUBLE_DOT_FLOAT                     = Wyvern.auto()
Wyvern.DiagnosticCode.UNTERMINATED_STRING                  = Wyvern.auto()
Wyvern.DiagnosticCode.UNKOWN_ESCAPE_CHAR                   = Wyvern.auto()
Wyvern.DiagnosticCode.UNTERMINATED_COMMENT                 = Wyvern.auto()
Wyvern.DiagnosticCode.UNDEFINED_UNARY_OPERATOR             = Wyvern.auto()
Wyvern.DiagnosticCode.UNDEFINED_BINARY_OPERATOR            = Wyvern.auto()
Wyvern.DiagnosticCode.UNDEFINED_VARIABLE                   = Wyvern.auto()
Wyvern.DiagnosticCode.UNEXPECTED_TOKEN                     = Wyvern.auto()
Wyvern.DiagnosticCode.VARIABLE_ALREADY_DECLARED            = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_CONVERT_TYPE                  = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_CONVERT_TYPE_IMPLICITLY       = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_ASSIGN                        = Wyvern.auto()
Wyvern.DiagnosticCode.UNDEFINED_FUNCTION                   = Wyvern.auto()
Wyvern.DiagnosticCode.WRONG_ARGUMENT_COUNT                 = Wyvern.auto()
Wyvern.DiagnosticCode.WRONG_ARGUMENT_TYPE                  = Wyvern.auto()
Wyvern.DiagnosticCode.EXPRESSION_MUST_HAVE_VALUE           = Wyvern.auto()
Wyvern.DiagnosticCode.UNDEFINED_TYPE                       = Wyvern.auto()
Wyvern.DiagnosticCode.PARAMETER_ALREADY_DECLARED           = Wyvern.auto()
Wyvern.DiagnosticCode.BREAK_OUTSIDE_LOOP                   = Wyvern.auto()
Wyvern.DiagnosticCode.CONTINUE_OUTSIDE_LOOP                = Wyvern.auto()
Wyvern.DiagnosticCode.INCOMPATIBLE_TYPE                    = Wyvern.auto()
Wyvern.DiagnosticCode.INVALID_RETURN_STATEMENT             = Wyvern.auto()
Wyvern.DiagnosticCode.MISSING_RETURN_EXPRESSION            = Wyvern.auto()
Wyvern.DiagnosticCode.INVALID_RETURN_EXPRESSION            = Wyvern.auto()
Wyvern.DiagnosticCode.UNEXPECTED_TYPE                      = Wyvern.auto()
Wyvern.DiagnosticCode.WRONG_INDEX_TYPE                     = Wyvern.auto()
Wyvern.DiagnosticCode.UNINDEXABLE_TYPE                     = Wyvern.auto()
Wyvern.DiagnosticCode.COULDNT_FIND_METHOD                  = Wyvern.auto()
Wyvern.DiagnosticCode.COULDNT_FIND_PROPERTY                = Wyvern.auto()
Wyvern.DiagnosticCode.COULDNT_FIND_EXTENSION_CLASS         = Wyvern.auto()
Wyvern.DiagnosticCode.UNDEFINED_CLASS                      = Wyvern.auto()
Wyvern.DiagnosticCode.UNDEFINED_STRUCT                     = Wyvern.auto()
Wyvern.DiagnosticCode.SYMBOL_ISNT_A_FUNCTION               = Wyvern.auto()
Wyvern.DiagnosticCode.SYMBOL_ISNT_A_CLASS                  = Wyvern.auto()
Wyvern.DiagnosticCode.SYMBOL_ISNT_A_STRUCT                 = Wyvern.auto()
Wyvern.DiagnosticCode.SYMBOL_ISNT_A_CONTRACT               = Wyvern.auto()
Wyvern.DiagnosticCode.MEMBER_CANT_HAVE_BODY                = Wyvern.auto()
Wyvern.DiagnosticCode.UNDEFINED_SYMBOL                     = Wyvern.auto()
Wyvern.DiagnosticCode.MISSING_CONTRACT_REQUIREMENT         = Wyvern.auto()
Wyvern.DiagnosticCode.SYMBOL_ISNT_PUBLIC                   = Wyvern.auto()
Wyvern.DiagnosticCode.ISNT_MEMBER                          = Wyvern.auto()
Wyvern.DiagnosticCode.VIRTUAL_WITH_BODY                    = Wyvern.auto()
Wyvern.DiagnosticCode.FIELD_DOESNT_HAVE_SAME_MODIFIERS     = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_OVERRIDE_AND_VIRTUAL          = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_PUBLIC_AND_PRIVATE            = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_REPEAT_MODIFIER               = Wyvern.auto()
Wyvern.DiagnosticCode.ATTEMPTED_OVERRIDE_WRONG_FIELD       = Wyvern.auto()
Wyvern.DiagnosticCode.OVERRIDE_DOESNT_HAVE_SAME_TYPE       = Wyvern.auto()
Wyvern.DiagnosticCode.OVERRIDE_DOESNT_HAVE_SAME_PARAMETERS = Wyvern.auto()
Wyvern.DiagnosticCode.OVERRIDE_ISNT_SAME_WRITE             = Wyvern.auto()
Wyvern.DiagnosticCode.VIRTUAL_SYMBOL_EXISTS                = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_OVERRIDE_NONVIRTUAL_SYMBOL    = Wyvern.auto()
Wyvern.DiagnosticCode.CAN_ONLY_USE_SYNTAX                  = Wyvern.auto()
Wyvern.DiagnosticCode.ENUM_DOESNT_HAVE_MEMBER              = Wyvern.auto()
Wyvern.DiagnosticCode.UNABLE_TO_LOOP                       = Wyvern.auto()
Wyvern.DiagnosticCode.NO_BODY_ALLOWED                      = Wyvern.auto()
Wyvern.DiagnosticCode.NO_INIT_ALLOWED                      = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_HAVE_MULTIPLE_DEFAULTS        = Wyvern.auto()
Wyvern.DiagnosticCode.CASE_MUST_HAVE_CONSTANT_VALUE        = Wyvern.auto()
Wyvern.DiagnosticCode.CANT_HAVE_MULTIPLE_SAME_CASES        = Wyvern.auto()
Wyvern.DiagnosticCode.UNABLE_TO_OPEN_FILE                  = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_FIND_STRUCT_MEMBER            = Wyvern.auto()
Wyvern.DiagnosticCode.CANNOT_USE_FUNCTION_IN_STRUCT        = Wyvern.auto()
Wyvern.DiagnosticCode.STRUCT_DOESNT_HAVE_MEMBER            = Wyvern.auto()

Wyvern.DiagnosticCode.TEMP_DEBUG = -1

Wyvern.auto(true)

// Lexer error
Wyvern.DiagnosticBag.ReportUnkownToken = function(location)
    self.Report("Unkown token '" + location.Text.ToString(location.Span) + "'", location, Wyvern.DiagnosticCode.UNKOWN_TOKEN)
end function

Wyvern.DiagnosticBag.ReportInvalidNumber = function(location)
    self.Report("'" + location.Text.ToString(location.Span) + "' isn't a valid number", location, Wyvern.DiagnosticCode.INVALID_NUMBER)
end function

Wyvern.DiagnosticBag.ReportDoubleDotFloat = function(location)
    self.Report("'" + location.Text.ToString(location.Span) + "' isn't a valid float", location, Wyvern.DiagnosticCode.DOUBLE_DOT_FLOAT)
end function

Wyvern.DiagnosticBag.ReportUnterminatedString = function(location)
    self.Report("Unterminated string", location, Wyvern.DiagnosticCode.UNTERMINATED_STRING)
end function

Wyvern.DiagnosticBag.ReportUnkownEscapeCharacter = function(location)
    self.Report("Unkown escape character '" + location.Text.ToString(location.Span) + "'", location, Wyvern.DiagnosticCode.UNKOWN_ESCAPE_CHAR)
end function

Wyvern.DiagnosticBag.ReportUnterminatedComment = function(location)
    self.Report("Unterminated comment", location, Wyvern.DiagnosticCode.UNTERMINATED_COMMENT)
end function

// Parser error
Wyvern.DiagnosticBag.ReportUnexpectedToken = function(token, expectedKind)
    self.Report("Unexpected token <" + Wyvern.SyntaxKind.ToString(token.Kind) + ">, expected <" + Wyvern.SyntaxKind.ToString(expectedKind) + ">", token.Location, Wyvern.DiagnosticCode.UNEXPECTED_TOKEN)
end function

Wyvern.DiagnosticBag.ReportCannotOverrideAndVirtual = function(location, name)
    self.Report("Field '" + name + "' cannot be an overrider and virtual", location, Wyvern.DiagnosticCode.CANNOT_OVERRIDE_AND_VIRTUAL)
end function

Wyvern.DiagnosticBag.ReportCannotPublicAndPrivate = function(location, name)
    self.Report("Field '" + name + "' cannot be public and private", location, Wyvern.DiagnosticCode.CANNOT_PUBLIC_AND_PRIVATE)
end function

Wyvern.DiagnosticBag.ReportCannotRepeatModifier = function(location, name, modifier)
    self.Report("Modifier <" + modifier.ToString() + "> in field '" + name + "' repeats", location, Wyvern.DiagnosticCode.CANNOT_REPEAT_MODIFIER)
end function

Wyvern.DiagnosticBag.ReportCannotHaveMultipleDefaults = function(location)
    self.Report("Cannot have multiple default statements in switch statements", location, Wyvern.DiagnosticCode.CANNOT_HAVE_MULTIPLE_DEFAULTS)
end function

Wyvern.DiagnosticBag.ReportUnableToOpenFile = function(location, path)
    self.Report("Unable to open file """ + path + """", location, Wyvern.DiagnosticCode.UNABLE_TO_OPEN_FILE)
end function

// Binder error
Wyvern.DiagnosticBag.ReportUndefinedUnaryOperator = function(location, operator, type)
    self.Report("Unary operator '" + operator + "' is not defined for type '" + type.ToString() + "'", location, Wyvern.DiagnosticCode.UNDEFINED_UNARY_OPERATOR)
end function

Wyvern.DiagnosticBag.ReportUndefinedBinaryOperator = function(syntax, leftType, rightType)
    self.Report("Binary operator '" + syntax.Operator.Text + "' is not defined for types '" + leftType.ToString() + "' and '" + rightType.ToString() + "'", syntax.Operator.Location, Wyvern.DiagnosticCode.UNDEFINED_BINARY_OPERATOR)
end function

Wyvern.DiagnosticBag.ReportUnindexableType = function(location, type)
    self.Report("Unable to index type, '" + type.ToString() + "'", location, Wyvern.DiagnosticCode.UNINDEXABLE_TYPE)
end function

Wyvern.DiagnosticBag.ReportUndefinedName = function(location, name)
    self.Report("Undefined variable '" + name + "'", location, Wyvern.DiagnosticCode.UNDEFINED_VARIABLE)
end function

Wyvern.DiagnosticBag.ReportUndefinedSymbol = function(location, symbolName)
    self.Report("Undefined symbol '" + symbolName + "'", location, Wyvern.DiagnosticCode.UNDEFINED_SYMBOL)
end function

Wyvern.DiagnosticBag.ReportSymbolAlreadyDeclared = function(location, name)
    self.Report("'" + name + "' is already declared", location, Wyvern.DiagnosticCode.VARIABLE_ALREADY_DECLARED)
end function

Wyvern.DiagnosticBag.ReportCannotConvert = function(location, fromType, toType)
    self.Report("Cannot convert from type '" + fromType.ToString() + "' to type '" + toType.ToString() + "'", location, Wyvern.DiagnosticCode.CANNOT_CONVERT_TYPE)
end function

Wyvern.DiagnosticBag.ReportCannotConvertImplicitly = function(location, fromType, toType)
    self.Report("Cannot convert from type '" + fromType.ToString() + "' to type '" + toType.ToString() + "'. An explicit conversion exists; Are you missing a cast?", location, Wyvern.DiagnosticCode.CANNOT_CONVERT_TYPE)
end function

Wyvern.DiagnosticBag.ReportCannotAssign = function(location, name)
    self.Report("Variable '" + name + "' is read-only", location, Wyvern.DiagnosticCode.CANNOT_ASSIGN)
end function

Wyvern.DiagnosticBag.ReportUndefinedFunction = function(location, functionName)
    self.Report("Function '" + functionName + "' doesn't exist", location, Wyvern.DiagnosticCode.UNDEFINED_FUNCTION)
end function

Wyvern.DiagnosticBag.ReportUndefinedClass = function(location, className)
    self.Report("Class '" + className + "' doesn't exist", location, Wyvern.DiagnosticCode.UNDEFINED_CLASS)
end function

Wyvern.DiagnosticBag.ReportUndefinedStruct = function(location, structName)
    self.Report("Structure '" + structName + "' doesn't exist", location, Wyvern.DiagnosticCode.UNDEFINED_STRUCT)
end function

Wyvern.DiagnosticBag.ReportWrongArgumentCount = function(location, functionName, expectedCount, actualCount)
    self.Report("Function '" + functionName + "' expects " + expectedCount + " arguments, but got " + actualCount, location, Wyvern.DiagnosticCode.WRONG_ARGUMENT_COUNT)
end function

Wyvern.DiagnosticBag.ReportUnexpectedType = function(location, expectedType, actualType)
    self.Report("Expected type, '" + expectedType.ToString() + "', but got '" + actualType.ToString() + "'", location, Wyvern.DiagnosticCode.UNEXPECTED_TYPE)
end function

Wyvern.DiagnosticBag.ReportWrongIndexType = function(location, expectedType, actualType)
    self.Report("Wrong type of indexing. Expected '" + expectedType.ToString() + "', but got '" + actualType.ToString() + "'", location, Wyvern.DiagnosticCode.WRONG_INDEX_TYPE)
end function

Wyvern.DiagnosticBag.ReportWrongArgumentType = function(location, name, expectedType, actualType)
    self.Report("Parameter '" + name + "' requires a value of type '" + expectedType.ToString() + "', but got '" + actualType.ToString() + "'", location, Wyvern.DiagnosticCode.WRONG_ARGUMENT_TYPE)
end function

Wyvern.DiagnosticBag.ReportExpressionMustHaveValue = function(location)
    self.Report("Expression must have a value.", location, Wyvern.DiagnosticCode.EXPRESSION_MUST_HAVE_VALUE)
end function

Wyvern.DiagnosticBag.ReportUndefinedType = function(location, text)
    self.Report("Type '" + text + "' doesn't exist", location, Wyvern.DiagnosticCode.UNDEFINED_TYPE)
end function

Wyvern.DiagnosticBag.ReportParameterAlreadyDeclared = function(location, parameterName)
    self.Report("Parameter '" + parameterName + "' is already declared", location, Wyvern.DiagnosticCode.PARAMETER_ALREADY_DECLARED)
end function

Wyvern.DiagnosticBag.ReportBreakOutsideLoop = function(location)
    self.Report("Break statement is not inside a loop", location, Wyvern.DiagnosticCode.BREAK_OUTSIDE_LOOP)
end function

Wyvern.DiagnosticBag.ReportContinueOutsideLoop = function(location)
    self.Report("Continue statement is not inside a loop", location, Wyvern.DiagnosticCode.CONTINUE_OUTSIDE_LOOP)
end function

Wyvern.DiagnosticBag.ReportIncompatibleType = function(location, type1, type2)
    self.Report("Incompatible types '" + type1.ToString() + "' and '" + type2.ToString() + "'", location, Wyvern.DiagnosticCode.INCOMPATIBLE_TYPE)
end function

Wyvern.DiagnosticBag.ReportInvalidReturnStatement = function(location)
    self.Report("Return statement is not inside a function", location, Wyvern.DiagnosticCode.INVALID_RETURN_STATEMENT)
end function

Wyvern.DiagnosticBag.ReportMissingReturnExpression = function(location, functionName)
    self.Report("Missing return expression in function '" + functionName + "'", location, Wyvern.DiagnosticCode.MISSING_RETURN_EXPRESSION)
end function

Wyvern.DiagnosticBag.ReportInvalidReturnExpression = function(location, functionName)
    self.Report("Invalid return expression in function '" + functionName + "'", location, Wyvern.DiagnosticCode.INVALID_RETURN_EXPRESSION)
end function

Wyvern.DiagnosticBag.ReportCouldntFindMethod = function(location, type, methodName)
    self.Report("Couldn't find method '" + methodName + "' in type '" + type.Name + "'", location, Wyvern.DiagnosticCode.COULDNT_FIND_METHOD)
end function

Wyvern.DiagnosticBag.ReportCouldntFindProperty = function(location, type, propertyName)
    self.Report("Couldn't find property '" + propertyName + "' in type '" + type.Name + "'", location, Wyvern.DiagnosticCode.COULDNT_FIND_PROPERTY)
end function

Wyvern.DiagnosticBag.ReportCouldntFindExtensionClass = function(location, extensionName)
    self.Report("Couldn't find extension class '" + extensionName + "'", location, Wyvern.DiagnosticCode.COULDNT_FIND_EXTENSION_CLASS)
end function

Wyvern.DiagnosticBag.ReportSymbolIsntAFunction = function(location, symbolName)
    self.Report("Symbol '" + symbolName + "' isn't a function", location, Wyvern.DiagnosticCode.SYMBOL_ISNT_A_FUNCTION)
end function

Wyvern.DiagnosticBag.ReportSymbolIsntAClass = function(location, symbolName)
    self.Report("Symbol '" + symbolName + "' isn't a class", location, Wyvern.DiagnosticCode.SYMBOL_ISNT_A_CLASS)
end function

Wyvern.DiagnosticBag.ReportSymbolIsntAStruct = function(location, symbolName)
    self.Report("Symbol '" + symbolName + "' isn't a structure", location, Wyvern.DiagnosticCode.SYMBOL_ISNT_A_STRUCT)
end function

Wyvern.DiagnosticBag.ReportSymbolIsntAContract = function(location, symbolName)
    self.Report("Symbol '" + symbolName + "' isn't a contract", location, Wyvern.DiagnosticCode.SYMBOL_ISNT_A_CONTRACT)
end function

Wyvern.DiagnosticBag.ReportMemberCantHave = function(location, memberName)
    self.Report("Contract member (" + memberName + ") can't have a body.", location, Wyvern.DiagnosticCode.MEMBER_CANT_HAVE_BODY)
end function

Wyvern.DiagnosticBag.ReportMissingContractRequirement = function(location, contractName, requirementName)
    self.Report("Missing contract (" + contractName + ") requirement '" + requirementName + "'", location, Wyvern.DiagnosticCode.MISSING_CONTRACT_REQUIREMENT)
end function

Wyvern.DiagnosticBag.ReportSymbolIsntPublic = function(location, symbolName)
    self.Report("Symbol '" + symbolName + "' isn't public", location, Wyvern.DiagnosticCode.SYMBOL_ISNT_PUBLIC)
end function

Wyvern.DiagnosticBag.ReportIsntMember = function(location)
    self.Report("Isn't member", location, Wyvern.DiagnosticCode.ISNT_MEMBER)
end function

Wyvern.DiagnosticBag.ReportCannotFindStructMember = function(location, name)
    self.Report("Cannot find structure member '" + name + "'", location, Wyvern.DiagnosticCode.CANNOT_FIND_STRUCT_MEMBER)
end function

Wyvern.DiagnosticBag.ReportCannotUseFunctionInStruct = function(location)
    self.Report("Cannot use function in a struct", location, Wyvern.DiagnosticCode.CANNOT_USE_FUNCTION_IN_STRUCT)
end function

Wyvern.DiagnosticBag.ReportVirtualWithBody = function(location, fieldName)
    self.Report("Virtual member '" + fieldName + "' is not allowed to have a body", location, Wyvern.DiagnosticCode.VIRTUAL_WITH_BODY)
end function

Wyvern.DiagnosticBag.ReportFieldDoesntHaveSameModifiers = function(location, name)
    self.Report("Field '" + name + "' doesn't have same modifiers", location, Wyvern.DiagnosticCode.FIELD_DOESNT_HAVE_SAME_MODIFIERS)
end function

Wyvern.DiagnosticBag.ReportAttemptedOverrideWrongField = function(location, virtualSymbol, overrideSymbol)
    self.Report("Attempted override a " + Wyvern.GetKey(Wyvern.SymbolKind, virtualSymbol.Kind) + " with a " + Wyvern.GetKey(Wyvern.SymbolKind, overrideSymbol.Kind), location, Wyvern.DiagnosticCode.ATTEMPTED_OVERRIDE_WRONG_FIELD)
end function


Wyvern.DiagnosticBag.ReportOverrideDoesntHaveSameType = function(location, name, originalType, newType)
    self.Report("Override method '" + name + "' isn't type " + originalType.ToString() + ", got " + newType.ToString(), location, Wyvern.DiagnosticCode.OVERRIDE_DOESNT_HAVE_SAME_TYPE)
end function

Wyvern.DiagnosticBag.ReportOverrideDoesntHaveSameParameters = function(location, name)
    self.Report("Override method '" + name + "' doesn't have same parameters", location, Wyvern.DiagnosticCode.OVERRIDE_DOESNT_HAVE_SAME_PARAMETERS)
end function

Wyvern.DiagnosticBag.ReportOverrideIsntSameWrite = function(location, name)
    self.Report("Override variable '" + name + "' isn't same write level", location, Wyvern.DiagnosticCode.OVERRIDE_ISNT_SAME_WRITE)
end function

Wyvern.DiagnosticBag.ReportVirtualSymbolExists = function(location, name)
    self.Report("Virtual symbol '" + name + "' already exists (Try using the 'override' modifier)", location, Wyvern.DiagnosticCode.VIRTUAL_SYMBOL_EXISTS)
end function

Wyvern.DiagnosticBag.ReportCannotOverrideNonVirtualSymbol = function(location, name)
    self.Report("Cannot override non virtual symbol '" + name + "'", location, Wyvern.DiagnosticCode.CANNOT_OVERRIDE_NONVIRTUAL_SYMBOL)
end function

Wyvern.DiagnosticBag.ReportCanOnlyUseSyntax = function(location, kind)
    self.Report("Can only use <" + Wyvern.SyntaxKind.ToString(kind) + ">", location, Wyvern.DiagnosticCode.CAN_ONLY_USE_SYNTAX)
end function

Wyvern.DiagnosticBag.ReportEnumDoesntHaveMember = function(location, name)
    self.Report("Enum doesn't have member '" + name + "'", location, Wyvern.DiagnosticCode.ENUM_DOESNT_HAVE_MEMBER)
end function

Wyvern.DiagnosticBag.ReportStructDoesntHaveMember = function(location, name)
    self.Report("Structure doesn't have member '" + name + "'", location, Wyvern.DiagnosticCode.STRUCT_DOESNT_HAVE_MEMBER)
end function

Wyvern.DiagnosticBag.ReportUnableToLoop = function(location)
    self.Report("Can't perform foreach loop through non-array type", location, Wyvern.DiagnosticCode.UNABLE_TO_LOOP)
end function

Wyvern.DiagnosticBag.ReportNoBodyAllowed = function(location, name)
    self.Report("Function (" + name + ") bodies aren't allowed", location, Wyvern.DiagnosticCode.NO_BODY_ALLOWED)
end function

Wyvern.DiagnosticBag.ReportNoInitializerAllowed = function(location, name)
    self.Report("Variable (" + name + ") initializers aren't allowed", location, Wyvern.DiagnosticCode.NO_INIT_ALLOWED)
end function

Wyvern.DiagnosticBag.ReportCaseMustHaveConstantValue = function(location)
    self.Report("Switch statement case must have a constant value", location, Wyvern.DiagnosticCode.CASE_MUST_HAVE_CONSTANT_VALUE)
end function

Wyvern.DiagnosticBag.ReportCantHaveMultipleSameCases = function(location)
    self.Report("Switch statements can't have multiple cases with same value", location, Wyvern.DiagnosticCode.CANT_HAVE_MULTIPLE_SAME_CASES)
end function