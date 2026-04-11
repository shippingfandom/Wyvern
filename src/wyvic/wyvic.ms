// /// WYVERN IMPORT \\\
import_code("/lib/wyvern/namespace") 	// override=../wyvern-lang/wyv-namespace.ms
import_code("/lib/wyvern/utils")		// override=../wyvern-lang/wyv-utils.ms
import_code("/lib/wyvern/diagnostics")	// override=../wyvern-lang/wyv-diagnostics.ms
import_code("/lib/wyvern/symbols")		// override=../wyvern-lang/wyv-symbols.ms
import_code("/lib/wyvern/syntax")		// override=../wyvern-lang/wyv-syntax.ms
import_code("/lib/wyvern/ast")			// override=../wyvern-lang/wyv-ast.ms
import_code("/lib/wyvern/builtins")		// override=../wyvern-lang/wyv-builtins.ms

import_code("/lib/wyvern/api")			// override=../wyvern-lang/wyv-api.ms
import_code("/lib/wyvern/compiler")		// override=../wyvern-lang/wyv-compiler.ms
import_code("/lib/wvyern/interpreter") // override=../wyvern-lang/wyv-interpreter.ms
// \\\ END WY IMPORT ///
loadTime = time()

GetErrorCodeString = function(error)
	for code in Wyvern.DiagnosticCode
		if code.value == error then
			return code.key
		end if
	end for
end function

ColorCast = function(color, message)
    return "<color=" + color + ">" + message + "</color>"
end function

BoldCast = function(message)
    return "<b>" + message + "</b>"
end function

StampNumber = function(zeroCount, num)
    strNum = str(num)
    zeros = ""
    for i in range(0, zeroCount - strNum.len)
        zeros = "0" + zeros
    end for
    return zeros + strNum
end function

GetFileName = function(path)
	if path == null then
		return "unkown"
	end if
    if typeof(path) == "file" then
        path = path.path
    end if
    if path.hasIndex("/") then
        return path.split("/").pop()
    end if
    return path
end function

GetLineTabbing = function(line)
	start = 0
	current = 0
	
	while current < line.len() and (line[current] == " " or line[current] == char(9))
		current = current + 1
	end while
	
	return line[start:current]
end function

RemoveLineTabbing = function(line)
	start = 0
	current = 0
	
	while current < line.len() and (line[current] == " " or line[current] == char(9))
		current = current + 1
	end while
	
	return line[current:]
end function

RemoveFileExtension = function(name)
	return name.split("\.")[0]
end function

CreateDiagnosticString = function(diagnostic)
	sourceText = diagnostic.Location.Text
	linePosition = diagnostic.Location.StartLine
	lineColumn = diagnostic.Location.StartCharacter

	numberSpacing = ""
	for i in range(0, str(linePosition + 1).len)
		numberSpacing = numberSpacing + " "
	end for

	line = sourceText.Lines[linePosition].ToString()
	fileName = GetFileName(sourceText.File)
	message = []
	message.push(BoldCast(ColorCast("#ff0000", "error") + BoldCast(" (WY" + StampNumber(3, diagnostic.Code) + ")") + ": " + GetErrorCodeString(diagnostic.Code).lower().replace("_", " ")))
	message.push(numberSpacing + ColorCast("#0a84ff", "--> ") + fileName + ":" + (linePosition + 1) + ":" + (lineColumn + 1))
	message.push(numberSpacing + ColorCast("#0a84ff", "|"))
	message.push(ColorCast("#0a84ff", str(linePosition + 1) + " | ") + line.replace("\\", "<color=#ffffff>\</color>"))

	pointerSpace = ""
	if lineColumn != 0 then
		if line[:lineColumn] != null then
			pointerSpace = GetLineTabbing(line)
			length = RemoveLineTabbing(line[:lineColumn]).len
			if length > 0 then
				pointerSpace = pointerSpace + (" " * length)
			end if
		end if
	end if

	pointers = "^" * diagnostic.Location.Span.Length

	message.push(numberSpacing + ColorCast("#0a84ff", "| ") + pointerSpace + ColorCast("#ff0000", pointers + " " + diagnostic.Message))
	message.push(numberSpacing + ColorCast("#0a84ff", "|"))
	return message.join(char(10))
end function

printSyntaxTree = false
displayTime = false
displayWyvLoadTime = false
build = false
astTree = false
if params.len > 1 then
    isInterpreting = params[0] == "-i"
    isCompiling = params[0] == "-c"
	isErrorChecking = params[0] == "-e"
	filePath = params[1]

	if params.len > 2 then
		opts = params.values
		opts.remove(0)
		opts.remove(0)

		for opt in opts
			if opt == "--tree" then
				printSyntaxTree = true
			else if opt == "--time" then
				displayTime = true
			else if opt == "--wyv-lib-load-time" then
				displayWyvLoadTime = true
			else if opt == "--build" then
				build = true
			else if opt == "--ast-tree" then
				astTree = true
			end if
		end for
	end if

	if displayWyvLoadTime then
		print("Wyvern Library Load Time: " + loadTime)
	end if

    file = get_shell.host_computer.File(filePath)

    if not file then
        file = get_shell.host_computer.File(current_path + "/" + filePath)
        if not file then
            exit("File not found: " + filePath)
        end if
    end if

	beginParseTime = time()
    syntaxTree = Wyvern.SyntaxTree.ParseFile(file)
	parseTime = time() - beginParseTime

    diagnostics = syntaxTree.Diagnostics
	if diagnostics.len() > 0 then
		for diagnostic in diagnostics
			print(CreateDiagnosticString(diagnostic))
		end for
		exit()
	end if

	if printSyntaxTree then
		exit(syntaxTree.Root.ToString(true))
	end if

    compilation = Wyvern.Compilation.New(syntaxTree)
	beginAstTime = time()
	asc = compilation.GlobalScope()
	astTime = time() - beginAstTime
    if isInterpreting then
		interpreterResult = compilation.Execute()
		if interpreterResult.Diagnostics.len > 0 then
			for diagnostic in interpreterResult.Diagnostics
				print(CreateDiagnosticString(diagnostic))
			end for
		else
			print(interpreterResult.Result)
		end if
		//print("Interpreting is not supported right now.")
        //variables = Wyvern.Dictionary.New()
        //result = compilation.Evaluate(variables)
        //diagnostics = result.Diagnostics
        //
        //if diagnostics.len > 0 then
        //    for diagnostic in diagnostics
        //        print(CreateDiagnosticString(diagnostic))
        //    end for
        //end if
	else if isCompiling then
		//result = compilation.Compile()
		diagnostics = compilation.Syntax.Diagnostics + compilation.GlobalScope.Diagnostics

		program = Wyvern.Binder.BindProgram(compilation.GlobalScope)
		if program.Diagnostics.Length > 0 then
			result = Wyvern.CompilationResults.New(program.Diagnostics.ToArray(), null)
			compilationTime = 0
		else
			statement = compilation.GlobalScope.Statement
			compiler = Wyvern.Compiler.New(program, statement)
			
			beginCompilationTime = time()
			code = compiler.Compile()
			compilationTime = time() - beginCompilationTime

			result = Wyvern.CompilationResults.New(diagnostics, code)
		end if

		diagnostics = result.Diagnostics
		if diagnostics.len > 0 then
            for diagnostic in diagnostics
                print(CreateDiagnosticString(diagnostic))
            end for
		else
			out = RemoveFileExtension(file.name) + ".src"

			get_shell.host_computer.touch(current_path, out)
			get_shell.host_computer.File(current_path + "/" + out).set_content(result.Code)

			if build then
				buildOutput = get_shell.build(current_path + "/" + out, current_path)
				if buildOutput.len != 0 then
					print(buildOutput)
				end if
			end if
		end if
	else if isErrorChecking then
		program = Wyvern.Binder.BindProgram(compilation.GlobalScope)
		
		for diagnostic in program.Diagnostics.ToArray()
			print(CreateDiagnosticString(diagnostic))
		end for
    end if

	if displayWyvLoadTime then
		print("Wyvern Library Load Time: " + loadTime)
	end if

	if displayTime then
		print("===== TIME STATS =====")
		total = (parseTime + astTime)
		print("Parse: " + parseTime)
		print("AST: " + astTime)
		if isCompiling then
			print("Compilation: " + compilationTime)
			total = total + compilationTime
		end if
		print("Total: " + total)
		print("======================")

		u = user_input("Run lexer to see lex time? ")
		if u.lower() == "y" then
			lexer = Wyvern.Lexer.New(Wyvern.SourceText.From(file.get_content()))
			beginLexerTime = time()
			while lexer.Lex().Kind != Wyvern.SyntaxKind.EndOfFileToken
			end while
			lexerTime = time() - beginLexerTime

			print("Lexer: " + lexerTime)
		end if
	end if

    exit()
else
    exit("Usage: wyvic [-c | -i (interpreter is not implemented yet)] <file> [extra opts: --tree, --time, --wyv-lib-load-time, --build, --ast-tree]")
end if
