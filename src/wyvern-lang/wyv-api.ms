Wyvern.Compilation = {"Syntax":-1, "Previous":-1}

Wyvern.Compilation.Init = function(syntax)
    self.Init2(null, syntax)
end function

Wyvern.Compilation.Init2 = function(previous, syntax)
    self.Syntax = syntax
    self.Previous = previous
    self._globalScope = {}
end function

Wyvern.Compilation.New = function(syntax)
    newInstance = new Wyvern.Compilation
    newInstance.Init(syntax)
    return newInstance
end function

Wyvern.Compilation.New2 = function(previous, syntax)
    newInstance = new Wyvern.Compilation
    newInstance.Init2(previous, syntax)
    return newInstance
end function

Wyvern.Compilation.GlobalScope = function()
    if self._globalScope == {} then
        previousGlobalScope = null
        if self.Previous != null then
            previousGlobalScope = self.Previous.GlobalScope
        end if

        globalScope = Wyvern.Binder.BindGlobalScope(previousGlobalScope, self.Syntax.Root)
        Wyvern.CompareExchange(self._globalScope, globalScope, {})
    end if

    return self._globalScope
end function

Wyvern.Compilation.ContinueWith = function(syntaxTree)
    return Wyvern.Compilation.New2(self, syntaxTree)
end function

Wyvern.Compilation.EmitTree = function(out, isConsole=false)
    self.GlobalScope.Statement.WriteTo(out, isConsole)
end function