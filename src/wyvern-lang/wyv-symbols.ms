Wyvern.Symbol = {"Name":-1, "Kind":-1}

Wyvern.Symbol.ToString = function()
    return self.Name
end function

Wyvern.Symbol.Compare = function(symbol)
    return self.ToString() == symbol.ToString()
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.SymbolKind = {}
Wyvern.SymbolKind.Variable          = Wyvern.auto()
Wyvern.SymbolKind.Type              = Wyvern.auto()
Wyvern.SymbolKind.Function          = Wyvern.auto()
Wyvern.SymbolKind.Builtin           = Wyvern.auto()
Wyvern.SymbolKind.Parameter         = Wyvern.auto()
Wyvern.SymbolKind.Class             = Wyvern.auto()
Wyvern.SymbolKind.Member            = Wyvern.auto()
Wyvern.SymbolKind.Array             = Wyvern.auto()
Wyvern.SymbolKind.Map               = Wyvern.auto()
Wyvern.SymbolKind.Contract          = Wyvern.auto()
Wyvern.SymbolKind.Enum              = Wyvern.auto()
Wyvern.SymbolKind.EnumMember        = Wyvern.auto()
Wyvern.SymbolKind.Temp              = Wyvern.auto()
Wyvern.SymbolKind.FunctionReference = Wyvern.auto()
Wyvern.SymbolKind.Struct            = Wyvern.auto()

Wyvern.SymbolKind.GlobalVariable  = Wyvern.auto()
Wyvern.SymbolKind.LocalVariable   = Wyvern.auto()
Wyvern.SymbolKind.BuiltinVariable = Wyvern.auto()

Wyvern.auto(true)

Wyvern.SymbolKind.ToString = function(nKind)
    for kvI in Wyvern.SymbolKind
        if kvI.value == nKind then
            return kvI.key
        end if
    end for

    return "Unkown"
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.TypeNameBindings = {}

Wyvern.TypeSymbol = new Wyvern.Symbol + {"Methods":-1, "Properties":-1}

Wyvern.TypeSymbol.Init = function(name)
    self.Name = name
    self.Methods = {}
    self.Properties = {}
    self.Kind = Wyvern.SymbolKind.Type
end function

Wyvern.TypeSymbol.New = function(name, add=true)
    newInstance = new Wyvern.TypeSymbol
    newInstance.Init(name)
    if add == true then
        Wyvern.TypeNameBindings[newInstance.Name] = newInstance
    end if
    return newInstance
end function

Wyvern.TypeSymbol.GetType = function(name)
    name = name[0].upper() + name[1:]
    if not Wyvern.TypeSymbols.hasIndex(name) then return null
    return Wyvern.TypeSymbols[name]
end function

Wyvern.TypeSymbol.GetMethod = function(name)
    if hasIndex(self.Methods, name) then
        return self.Methods[name]
    end if

    return null
end function

Wyvern.TypeSymbol.GetProperty = function(name)
    if hasIndex(self.Properties, name) then
        p = self.Properties[name]
        if Wyvern.IsA(Wyvern.FunctionSymbol, p) then
            return Wyvern.FunctionReferenceSymbol.New(p)
        end if
        return p
    end if

    return null
end function

Wyvern.TypeSymbol.GetField = function(name)
    combine = self.Methods + self.Properties

    if hasIndex(combine, name) then
        return combine[name]
    end if

    return null
end function

Wyvern.TypeSymbol.AddMethod = function(method)
    self.Methods[method.Name] = method
end function

Wyvern.TypeSymbol.AddProperty = function(property)
    self.Properties[property.Name] = property
end function

Wyvern.TypeSymbol.ToString = function()
    return self.Name
end function

Wyvern.TypeSymbols = {}
// System Types
Wyvern.TypeSymbols.Error      = Wyvern.TypeSymbol.New("?", false)
Wyvern.TypeSymbols.Void       = Wyvern.TypeSymbol.New("void", false)

Wyvern.TypeSymbols.Reference  = Wyvern.TypeSymbol.New("reference")

// Builtin Types
Wyvern.TypeSymbols.Bool       = Wyvern.TypeSymbol.New("bool")
Wyvern.TypeSymbols.Number     = Wyvern.TypeSymbol.New("number")
Wyvern.TypeSymbols.String     = Wyvern.TypeSymbol.New("string")
Wyvern.TypeSymbols.Any        = Wyvern.TypeSymbol.New("any")
Wyvern.TypeSymbols.Null       = Wyvern.TypeSymbol.New("null")

// Intermediate Types
Wyvern.TypeSymbols.Library    = Wyvern.TypeSymbol.New("library")

// GreyHack Types
Wyvern.TypeSymbols.Computer   = Wyvern.TypeSymbol.New("computer")
Wyvern.TypeSymbols.Router     = Wyvern.TypeSymbol.New("router")
Wyvern.TypeSymbols.File       = Wyvern.TypeSymbol.New("file")
Wyvern.TypeSymbols.Port       = Wyvern.TypeSymbol.New("port")
Wyvern.TypeSymbols.Shell      = Wyvern.TypeSymbol.New("shell")
Wyvern.TypeSymbols.FtpShell   = Wyvern.TypeSymbol.New("ftpshell")
Wyvern.TypeSymbols.MetaLib    = Wyvern.TypeSymbol.New("metalib")
Wyvern.TypeSymbols.NetSession = Wyvern.TypeSymbol.New("netsession")
Wyvern.TypeSymbols.Wallet     = Wyvern.TypeSymbol.New("wallet")
Wyvern.TypeSymbols.MetaMail   = Wyvern.TypeSymbol.New("metamail")
Wyvern.TypeSymbols.Coin       = Wyvern.TypeSymbol.New("coin")
Wyvern.TypeSymbols.SubWallet  = Wyvern.TypeSymbol.New("subwallet")

// Library types
Wyvern.TypeSymbols.AptClient  = Wyvern.TypeSymbol.New("aptclient")
Wyvern.TypeSymbols.Metaxploit = Wyvern.TypeSymbol.New("metaxploit")
Wyvern.TypeSymbols.Crypto     = Wyvern.TypeSymbol.New("crypto")
Wyvern.TypeSymbols.Blockchain = Wyvern.TypeSymbol.New("blockchain")
Wyvern.TypeSymbols.Service    = Wyvern.TypeSymbol.New("service")

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Arrays and Maps
Wyvern.MapArrayCallbacks = {}

Wyvern.MapArrayCallbacks.HasIndex = function(self, args)
    return self.hasIndex(args[0])
end function

Wyvern.MapArrayCallbacks.IndexOf = function(self, args)
    return self.indexOf(args[0], args[1])
end function

Wyvern.MapArrayCallbacks.Insert = function(self, args)
    return self.insert(args[0], args[1])
end function

Wyvern.MapArrayCallbacks.Pop = function(self, args)
    return self.pop()
end function

Wyvern.MapArrayCallbacks.Pull = function(self, args)
    return self.pull()
end function

Wyvern.MapArrayCallbacks.Pull = function(self, args)
    return self.pull()
end function

Wyvern.MapArrayCallbacks.Push = function(self, args)
    return self.push(args[0])
end function

Wyvern.MapArrayCallbacks.Shuffle = function(self, args)
    return self.shuffle()
end function

Wyvern.MapArrayCallbacks.Sum = function(self, args)
    return self.sum()
end function

Wyvern.MapArrayCallbacks.Remove = function(self, args)
    return self.remove(args[0])
end function

Wyvern.MapArrayCallbacks.Replace = function(self, args)
    return self.replace(args[0], args[1], args[2])
end function

Wyvern.MapArrayCallbacks.Len = function(self)
    return self.len()
end function

Wyvern.MapArrayCallbacks.Indexes = function(self)
    return self.indexes()
end function

Wyvern.MapArrayCallbacks.Values = function(self)
    return self.values()
end function

Wyvern.MapArrayCallbacks.Join = function(self, args)
    return self.join(args[0])
end function

Wyvern.MapArrayCallbacks.Sort = function(self, args)
    return self.sort(args[0])
end function

Wyvern.MapArrayCallbacks.Reverse = function(self, args)
    return self.reverse
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.ArraySymbol = new Wyvern.Symbol + {"Type":-1, "Members":-1, "LoadedMembers":-1}

Wyvern.ArraySymbol.Init = function(type)
    self.Name = type.Name + "[]"
    self.Members = []
    self.Type = type
    self.LoadedMembers = false
    self.Kind = Wyvern.SymbolKind.Array
end function

Wyvern.ArraySymbol.New = function(type)
    newInstance = new Wyvern.ArraySymbol
    newInstance.Init(type)
    return newInstance
end function

Wyvern.ArraySymbol.LoadMembers = function()
    if self.LoadedMembers == true then return null
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("hasIndex", [Wyvern.CreateParameter("i", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Bool, @Wyvern.MapArrayCallbacks.HasIndex))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("indexOf", [Wyvern.CreateParameter("x", self.Type), Wyvern.CreateParameter("after", Wyvern.TypeSymbols.Number, "null")], Wyvern.TypeSymbols.Number, @Wyvern.MapArrayCallbacks.IndexOf))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("insert", [Wyvern.CreateParameter("index", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("value", self.Type)], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Insert))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("pop", [], self.Type, @Wyvern.MapArrayCallbacks.Pop))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("pull", [], self.Type, @Wyvern.MapArrayCallbacks.Pull))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("push", [Wyvern.CreateParameter("x", self.Type)], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Push))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("shuffle", [], Wyvern.ArraySymbol.New(self.Type), @Wyvern.MapArrayCallbacks.Shuffle))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("sum", [], Wyvern.TypeSymbols.Number, @Wyvern.MapArrayCallbacks.Sum))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("remove", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Remove))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("replace", [Wyvern.CreateParameter("oldval", self.Type), Wyvern.CreateParameter("newval", self.Type), Wyvern.CreateParameter("maxCount", Wyvern.TypeSymbols.Number, "null")], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Replace))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("sort", [Wyvern.CreateParameter("key", Wyvern.TypeSymbols.Any, "null")], Wyvern.ArraySymbol.New(self.Type), @Wyvern.MapArrayCallbacks.Sort))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("reverse", [], Wyvern.ArraySymbol.New(self.Type), @Wyvern.MapArrayCallbacks.Reverse))

    self.AddMember(Wyvern.BuiltinVariableSymbol.New("len", true, Wyvern.TypeSymbols.Number, @Wyvern.MapArrayCallbacks.Len))
    self.AddMember(Wyvern.BuiltinVariableSymbol.New("indexes", true, Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Number), @Wyvern.MapArrayCallbacks.Indexes))
    self.AddMember(Wyvern.BuiltinVariableSymbol.New("values", true, Wyvern.ArraySymbol.New(self.Type), @Wyvern.MapArrayCallbacks.Values))

    if self.Type == Wyvern.TypeSymbols.String then
        self.AddMember(Wyvern.BuiltinFunctionSymbol.New("join", [Wyvern.CreateParameter("delimeter", Wyvern.TypeSymbols.String, """""")], Wyvern.TypeSymbols.String, @Wyvern.MapArrayCallbacks.Join))
    end if

    self.LoadedMembers = true
end function

Wyvern.ArraySymbol.AddMember = function(member)
    self.Members.push(member)
end function

Wyvern.ArraySymbol.GetMethod = function(name)
    methods = self.GetMethods()
    if hasIndex(methods, name) then
        return methods[name]
    end if

    return null
end function

Wyvern.ArraySymbol.GetProperty = function(name)
    properties = self.GetProperties()
    if hasIndex(properties, name) then
        p = properties[name]
        if Wyvern.IsA(Wyvern.FunctionSymbol, p) then
            return Wyvern.FunctionReferenceSymbol.New(p)
        end if
        return p
    end if

    return null
end function

Wyvern.ArraySymbol.GetField = function(name)
    fields = self.GetFields()
    if hasIndex(fields, name) then
        return fields[name]
    end if

    return null
end function

Wyvern.ArraySymbol.GetMethods = function()
    methods = {}
    for member in self.Members
        if Wyvern.IsA(Wyvern.FunctionSymbol, member) then
            methods[member.Name] = member
        end if
    end for

    return methods
end function

Wyvern.ArraySymbol.GetProperties = function()
    properties = {}
    for member in self.Members
        if Wyvern.IsA(Wyvern.VariableSymbol, member) then
            properties[member.Name] = member
        end if
    end for

    return properties
end function

Wyvern.ArraySymbol.GetFields = function()
    fields = {}
    for member in self.Members
        fields[member.Name] = member
    end for

    return fields
end function

Wyvern.ArraySymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.MapSymbol = new Wyvern.Symbol + {"KeyType":-1, "ValueType":-1, "Members":-1, "LoadedMembers":-1}

Wyvern.MapSymbol.Init = function(keyType, valueType)
    self.Name = keyType.Name + "<" + valueType.Name + ">"
    self.KeyType = keyType
    self.ValueType = valueType
    self.Members = []
    self.LoadedMembers = false
    self.Kind = Wyvern.SymbolKind.Map
end function

Wyvern.MapSymbol.LoadMembers = function()
    if self.LoadedMembers == true then return null
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("hasIndex", [Wyvern.CreateParameter("i", self.KeyType)], Wyvern.TypeSymbols.Bool, @Wyvern.MapArrayCallbacks.HasIndex))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("indexOf", [Wyvern.CreateParameter("x", self.ValueType), Wyvern.CreateParameter("after", Wyvern.TypeSymbols.Number, "null")], self.KeyType, @Wyvern.MapArrayCallbacks.IndexOf))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("insert", [Wyvern.CreateParameter("index", self.KeyType), Wyvern.CreateParameter("value", self.ValueType)], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Insert))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("pop", [], self.ValueType, @Wyvern.MapArrayCallbacks.Pop))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("pull", [], self.ValueType, @Wyvern.MapArrayCallbacks.Pull))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("push", [Wyvern.CreateParameter("x", self.ValueType)], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Push))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("shuffle", [], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Shuffle))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("sum", [], Wyvern.TypeSymbols.Number, @Wyvern.MapArrayCallbacks.Sum))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("remove", [Wyvern.CreateParameter("x", self.KeyType)], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Remove))
    self.AddMember(Wyvern.BuiltinFunctionSymbol.New("replace", [Wyvern.CreateParameter("oldval", self.ValueType), Wyvern.CreateParameter("newval", self.ValueType), Wyvern.CreateParameter("maxCount", Wyvern.TypeSymbols.Number, "null")], Wyvern.TypeSymbols.Void, @Wyvern.MapArrayCallbacks.Replace))

    self.AddMember(Wyvern.BuiltinVariableSymbol.New("len", true, Wyvern.TypeSymbols.Number, @Wyvern.MapArrayCallbacks.Len))
    self.AddMember(Wyvern.BuiltinVariableSymbol.New("indexes", true, Wyvern.ArraySymbol.New(self.KeyType), @Wyvern.MapArrayCallbacks.Indexes))
    self.AddMember(Wyvern.BuiltinVariableSymbol.New("values", true, Wyvern.ArraySymbol.New(self.ValueType), @Wyvern.MapArrayCallbacks.Values))
    self.LoadedMembers = true
end function

Wyvern.MapSymbol.AddMember = function(member)
    self.Members.push(member)
end function

Wyvern.MapSymbol.GetMethod = function(name)
    methods = self.GetMethods()
    if hasIndex(methods, name) then
        return methods[name]
    end if

    return null
end function

Wyvern.MapSymbol.GetProperty = function(name)
    properties = self.GetProperties()
    if hasIndex(properties, name) then
        p = properties[name]
        if Wyvern.IsA(Wyvern.FunctionSymbol, p) then
            return Wyvern.FunctionReferenceSymbol.New(p)
        end if
        return p
    end if

    return null
end function

Wyvern.MapSymbol.GetField = function(name)
    fields = self.GetFields()
    if hasIndex(fields, name) then
        return fields[name]
    end if

    return null
end function

Wyvern.MapSymbol.GetMethods = function()
    methods = {}
    for member in self.Members
        if Wyvern.IsA(Wyvern.FunctionSymbol, member) then
            methods[member.Name] = member
        end if
    end for

    return methods
end function

Wyvern.MapSymbol.GetProperties = function()
    properties = {}
    for member in self.Members
        if Wyvern.IsA(Wyvern.VariableSymbol, member) then
            properties[member.Name] = member
        end if
    end for

    return properties
end function

Wyvern.MapSymbol.GetFields = function()
    fields = {}
    for member in self.Members
        fields[member.Name] = member
    end for

    return fields
end function

Wyvern.MapSymbol.New = function(keyType, valueType)
    newInstance = new Wyvern.MapSymbol
    newInstance.Init(keyType, valueType)
    return newInstance
end function

Wyvern.MapSymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.VariableSymbol = new Wyvern.Symbol + {"IsReadOnly":-1, "Type":-1, "Constant":-1}

Wyvern.VariableSymbol.Init = function(name, isReadOnly, type, constant=null)
    self.Name = name
    self.IsReadOnly = isReadOnly
    self.Type = type
    self.Constant = constant
    self.Kind = Wyvern.SymbolKind.Variable
end function

Wyvern.VariableSymbol.New = function(name, isReadOnly, type, constant=null)
    newInstance = new Wyvern.VariableSymbol
    newInstance.Init(name, isReadOnly, type, constant)
    return newInstance
end function

Wyvern.VariableSymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.GlobalVariableSymbol = new Wyvern.VariableSymbol

Wyvern.GlobalVariableSymbol.Init = function(name, isReadOnly, type, constant=null)
    self.Name = name
    self.IsReadOnly = isReadOnly
    self.Type = type
    self.Constant = constant
    self.Kind = Wyvern.SymbolKind.GlobalVariable
end function

Wyvern.GlobalVariableSymbol.New = function(name, isReadOnly, type, constant=null)
    newInstance = new Wyvern.GlobalVariableSymbol
    newInstance.Init(name, isReadOnly, type, constant)
    return newInstance
end function

Wyvern.GlobalVariableSymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.LocalVariableSymbol = new Wyvern.VariableSymbol

Wyvern.LocalVariableSymbol.Init = function(name, isReadOnly, type, constant=null)
    self.Name = name
    self.IsReadOnly = isReadOnly
    self.Type = type
    self.Constant = constant
    self.Kind = Wyvern.SymbolKind.LocalVariable
end function

Wyvern.LocalVariableSymbol.New = function(name, isReadOnly, type, constant=null)
    newInstance = new Wyvern.LocalVariableSymbol
    newInstance.Init(name, isReadOnly, type, constant)
    return newInstance
end function

Wyvern.LocalVariableSymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BuiltinVariableSymbol = new Wyvern.VariableSymbol + {"Callback":-1}

Wyvern.BuiltinVariableSymbol.Init = function(name, isReadOnly, type, callback=null)
    self.Name = name
    self.IsReadOnly = isReadOnly
    self.Type = type
    self.Callback = @callback
    self.Constant = null
    self.Kind = Wyvern.SymbolKind.BuiltinVariable
end function

Wyvern.BuiltinVariableSymbol.New = function(name, isReadOnly, type, callback=null)
    newInstance = new Wyvern.BuiltinVariableSymbol
    newInstance.Init(name, isReadOnly, type, @callback)
    return newInstance
end function

Wyvern.BuiltinVariableSymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.ParameterSymbol = new Wyvern.LocalVariableSymbol + {"IsOptional":-1, "DefaultValue":-1}

Wyvern.ParameterSymbol.Init = function(name, type, default=null)
    self.Name = name
    self.IsReadOnly = true
    self.Type = type
    self.IsOptional = default != null
    self.DefaultValue = default
    self.Constant = null
    self.Kind = Wyvern.SymbolKind.Parameter
end function

Wyvern.ParameterSymbol.New = function(name, type, default=null)
    newInstance = new Wyvern.ParameterSymbol
    newInstance.Init(name, type, default)
    return newInstance
end function

Wyvern.ParameterSymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.FunctionSymbol = new Wyvern.Symbol + {"Parameters":-1, "Type":-1, "Declaration":-1, "Bound":-1}

Wyvern.FunctionSymbol.Init = function(name, parameters, type, declaration=null, bound=null)
    self.Name = name
    self.Parameters = parameters
    self.Type = type
    self.Declaration = declaration
    self.Bound = bound
    self.Kind = Wyvern.SymbolKind.Function
end function

Wyvern.FunctionSymbol.CompareParameters = function(fSymbol)
    if self.Parameters.len != fSymbol.Parameters.len then
        return false
    end if

    if self.Parameters.len == 0 then
        return true
    end if

    for i in range(0, self.Parameters.len - 1)
        paramS = self.Parameters[i]
        paramF = fSymbol.Parameters[i]

        if paramS.Type != paramF.Type then
            return false
        end if

        if (paramS.DefaultValue == null) != (paramF.DefaultValue == null) then
            return false
        end if
    end for

    return true
end function

Wyvern.FunctionSymbol.ToString = function()
    return self.Name
end function

Wyvern.FunctionSymbol.GetParameterLengthWithoutOptionals = function()
    count = 0
    for i in self.Parameters
        if not i.IsOptional then
            count = count + 1
        end if
    end for
    return count
end function

Wyvern.FunctionSymbol.New = function(name, parameters, type, declaration=null, bound=null)
    newInstance = new Wyvern.FunctionSymbol
    newInstance.Init(name, parameters, type, declaration, bound)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.FunctionReferenceSymbol = new Wyvern.Symbol + {"Function":-1}

Wyvern.FunctionReferenceSymbol.Init = function(functionSymbol)
    self.Function = functionSymbol
    self.Name = "function_reference<" + functionSymbol.Name + ">"

    self.Kind = Wyvern.SymbolKind.FunctionReference
end function

Wyvern.FunctionReferenceSymbol.New = function(functionSymbol)
    newInstance = new Wyvern.FunctionReferenceSymbol
    newInstance.Init(functionSymbol)
    return newInstance
end function

Wyvern.FunctionReferenceSymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.BuiltinFunctionSymbol = new Wyvern.FunctionSymbol + {"Callback":-1}

Wyvern.BuiltinFunctionSymbol.Init = function(name, parameters, type, callback)
    self.Name = name
    self.Parameters = parameters
    self.Type = type
    self.Callback = @callback

    self.Kind = Wyvern.SymbolKind.Builtin
end function

Wyvern.BuiltinFunctionSymbol.New = function(name, parameters, type, callback)
    newInstance = new Wyvern.BuiltinFunctionSymbol
    newInstance.Init(name, parameters, type, @callback)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.Modifiers = {"IsPublic":-1, "IsPrivate":-1, "IsStatic":-1, "IsOverride":-1, "IsVirtual":-1}

Wyvern.Modifiers.Init = function(isPublic, isStatic, isOverride, isVirtual)
    self.IsPublic = isPublic
    self.IsPrivate = not isPublic
    self.IsStatic = isStatic
    self.IsOverride = isOverride
    self.IsVirtual = isVirtual
end function

Wyvern.Modifiers.New = function(isPublic, isStatic, isOverride, isVirtual)
    newInstance = new Wyvern.Modifiers
    newInstance.Init(isPublic, isStatic, isOverride, isVirtual)
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.MemberSymbol = new Wyvern.Symbol + {"Name":-1, "Modifiers":-1, "Symbol":-1}

Wyvern.MemberSymbol.Init = function(modifiers, symbol)
    self.Name = symbol.Name
    self.Modifiers = modifiers
    self.Symbol = symbol
    self.Kind = Wyvern.SymbolKind.Member
end function

Wyvern.MemberSymbol.ToString = function()
    return self.Name
end function

Wyvern.MemberSymbol.New = function(modifiers, symbol)
    newInstance = new Wyvern.MemberSymbol
    newInstance.Init(modifiers, symbol)
    return newInstance
end function

Wyvern.MemberSymbol.BoundlessCompare = function(member)
    if self.Modifiers != member.Modifiers then
        return false
    end if

    if self.Symbol.Kind != member.Symbol.Kind then //not (Wyvern.IsA(Wyvern.FunctionSymbol, self.Symbol) and Wyvern.IsA(Wyvern.FunctionSymbol, member.Symbol)) then
        return false
    end if

    // Name, Parameters, Type
    if Wyvern.IsA(Wyvern.FunctionSymbol, self.Symbol) then
        if self.Symbol.Name != member.Symbol.Name or self.Symbol.Parameters != member.Symbol.Parameters or self.Symbol.Type != member.Symbol.Type then
            return false
        end if
    else
        if self.Symbol.Name != member.Symbol.Name or self.Symbol.Type != member.Symbol.Type then
            return false
        end if
    end if

    return true
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.ClassSymbol = new Wyvern.Symbol + {"Name":-1, "Super":-1, "Contracts":-1, "Members":-1, "Statics":-1, "Declaration":-1}

Wyvern.ClassSymbol.Init = function(name, extension, contracts, members, declaration=null)
    self.Name = name
    self.Super = extension
    self.Contracts = contracts
    self.Members = members
    self.LoadStatics()
    self.Declaration = declaration
    self.Kind = Wyvern.SymbolKind.Class
end function

Wyvern.ClassSymbol.New = function(name, extension, contracts, members, declaration=null)
    newInstance = new Wyvern.ClassSymbol
    newInstance.Init(name, extension, contracts, members, declaration)
    return newInstance
end function

Wyvern.ClassSymbol.IsAncestor = function(classSymbol)
    if self.Super == null then
        return false
    end if

    if self.Super != classSymbol then
        return self.Super.IsAncestor(classSymbol)
    end if

    return true
end function

Wyvern.ClassSymbol.LoadStatics = function()
    self.Statics = []
    for member in self.Members
        if member.Modifiers.IsStatic then
            self.Statics.push(member)
        end if
    end for
end function

Wyvern.ClassSymbol.ToString = function()
    name = self.Name
    if self.Super != null then
        name = name + " : " + self.Super.Name
    end if

    if self.Contracts.len != 0 then
        contracts = []
        for i in self.Contracts
            contracts.push(i.Name)
        end for
        name = name + " $ " + contracts.join(", ")
    end if

    return name
end function

Wyvern.ClassSymbol.GetField = function(name, static=false)
    if not static then
        members = self.Members
    else
        members = self.Statics
    end if

    for field in members
        if field.Name == name then
            return field
        end if
    end for

    if self.Super != null then
        return self.Super.GetField(name, static)
    end if

    return null
end function

Wyvern.ClassSymbol.GetProperty = function(name, static=false)
    if not static then
        members = self.Members
    else
        members = self.Statics
    end if

    for property in members
        if property.Name == name then
            if Wyvern.IsA(Wyvern.FunctionSymbol, property.Symbol) then
                return Wyvern.MemberSymbol.New(property.Modifiers, Wyvern.FunctionReferenceSymbol.New(property.Symbol))
            end if
            return property
        end if
    end for

    if self.Super != null then
        return self.Super.GetProperty(name, static)
    end if

    return null
end function

Wyvern.ClassSymbol.GetMethod = function(name, static=false)
    if not static then
        members = self.Members
    else
        members = self.Statics
    end if
    
    for method in members
        if Wyvern.IsA(Wyvern.FunctionSymbol, method.Symbol) and method.Name == name then
            return method
        end if
    end for

    if self.Super != null then
        return self.Super.GetMethod(name, static)
    end if

    return null
end function

Wyvern.ClassSymbol.MemberExists = function(checkMember, static=false)
    if not static then
        members = self.Members
    else
        members = self.Statics
    end if
    
    for member in members
        if member.BoundlessCompare(checkMember) then
            return true
        end if
    end for

    if self.Super != null then
        return self.Super.MemberExists(checkMember, static)
    end if

    return false
end function

Wyvern.ClassSymbol.HasContract = function(contract)
    for classContract in self.Contracts
        if classContract == contract then
            return true
        end if
    end for

    return false
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.TempSymbol = new Wyvern.Symbol + {"Name":-1}

Wyvern.TempSymbol.Init = function(name)
    self.Name = name

    self.Kind = Wyvern.SymbolKind.Temp
end function

Wyvern.TempSymbol.New = function(name)
    newInstance = new Wyvern.TempSymbol
    newInstance.Init(name)
    return newInstance
end function

Wyvern.TempSymbol.ToString = function()
    return name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.EnumMemberSymbol = new Wyvern.Symbol + {"Name":-1, "Enum":-1, "Type":-1, "Constant":-1, "Declaration":-1}

Wyvern.EnumMemberSymbol.Init = function(name, enum, type, constant, declaration)
    self.Name = name
    self.Enum = enum
    self.Type = type
    self.Constant = constant
    self.Declaration = declaration
    self.Kind = Wyvern.SymbolKind.EnumMember
end function

Wyvern.EnumMemberSymbol.New = function(name, enum, type, constant, declaration=null)
    newInstance = new Wyvern.EnumMemberSymbol
    newInstance.Init(name, enum, type, constant, declaration)
    return newInstance
end function

Wyvern.EnumMemberSymbol.ToString = function()
    return self.Name
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.EnumSymbol = new Wyvern.Symbol + {"Name":-1, "Members":-1, "Declaration":-1}

Wyvern.EnumSymbol.Init = function(name, members, declaration)
    self.Name = name
    self.Members = members
    self.Declaration = declaration
    self.Kind = Wyvern.SymbolKind.Enum
end function

Wyvern.EnumSymbol.New = function(name, members, declaration=null)
    newInstance = new Wyvern.EnumSymbol
    newInstance.Init(name, members, declaration)
    return newInstance
end function

Wyvern.EnumSymbol.ToString = function()
    return self.Name
end function

Wyvern.EnumSymbol.GetMember = function(name)
    for member in self.Members
        if member.Name == name then
            return member
        end if
    end for
    
    return null
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.ContractSymbol = new Wyvern.Symbol + {"Name":-1, "Contracts":-1, "Members":-1, "Identifier":-1}

Wyvern.ContractSymbol.Init = function(name, contracts, members, identifier=null)
    self.Name = name
    self.Members = members
    self.Contracts = contracts
    self.Identifier = identifier
    self.Kind = Wyvern.SymbolKind.Contract

    for member in self.Members
        member.Contract = self
    end for
end function

Wyvern.ContractSymbol.New = function(name, contracts, members, identifier=null)
    newInstance = new Wyvern.ContractSymbol
    newInstance.Init(name, contracts, members, identifier)
    return newInstance
end function

Wyvern.ContractSymbol.ToString = function()
    return self.Name
end function

Wyvern.ContractSymbol.GetFailingRequirements = function(classSymbol)
    failing = []

    for contract in self.Contracts
        failing = failing + contract.GetFailingRequirements(classSymbol)
    end for
    
    for member in self.Members
        if not classSymbol.MemberExists(member) then
            failing.push(member)
        end if
    end for

    return failing
end function

Wyvern.ContractSymbol.GetField = function(name)
    for field in self.Members
        if field.Name == name then
            return field
        end if
    end for

    return null
end function

Wyvern.ContractSymbol.GetProperty = function(name)
    for property in self.Members
        if property.Name == name then
            if Wyvern.IsA(Wyvern.FunctionSymbol, property.Symbol) then
                return Wyvern.FunctionReferenceSymbol.New(property.Symbol)
            end if
            return property
        end if
    end for

    return null
end function

Wyvern.ContractSymbol.GetMethod = function(name)
    for method in self.Members
        if Wyvern.IsA(Wyvern.FunctionSymbol, method.Symbol) and method.Name == name then
            return method
        end if
    end for

    return null
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.StructSymbol = new Wyvern.Symbol + {"Name":-1, "Members":-1, "Declaration":-1}

Wyvern.StructSymbol.Init = function(name, members, declaration)
    self.Name = name
    self.Members = members
    self.Declaration = declaration

    self.Kind = Wyvern.SymbolKind.Struct
end function

Wyvern.StructSymbol.New = function(name, members, declaration)
    newInstance = new Wyvern.StructSymbol
    newInstance.Init(name, members, declaration)
    return newInstance
end function

Wyvern.StructSymbol.ToString = function() 
    return self.Name
end function

Wyvern.StructSymbol.GetField = function(name)
    for property in self.Members
        if property.Name == name then
            if Wyvern.IsA(Wyvern.FunctionSymbol, property) then
                return Wyvern.FunctionReferenceSymbol.New(property)
            end if
            return property
        end if
    end for

    return null
end function