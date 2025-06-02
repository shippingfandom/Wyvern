Wyvern.GetKey = function(oMap, oValue)
    if typeof(oMap) == "map" then
        for v in oMap
            if @v.value == @oValue then
                return v.key
            end if
        end for
    end if
    return null
end function

Wyvern.FindClassOfInstance = function(i)
    for kv in Wyvern
        if typeof(@kv.value) == "map" then
            if Wyvern.IsA(kv.value, i) then
                return kv.key
            end if
        end if
    end for

    return "Unkown"
end function

Wyvern.SafeRange = function(from, to, interval=null)
    if to < from then
        return []
    end if
    return range(from, to, interval)
end function

Wyvern.SafeGet = function(map, key, default=null)
    if map.hasIndex(key) then
        return map[key]
    else
        return default
    end if
end function

// DEPRICATED: Buggy and unpredictable
Wyvern.DeepCompare = function(a, b)
    if typeof(@a) != typeof(@b) then
        return false
    end if
    if typeof(@a) == "map" then
        for kv in a
            if not Wyvern.DeepCompare(@kv.value, @Wyvern.SafeGet(b, @kv.key)) then
                return false
            end if
        end for
    else if typeof(@b) == "list" then
        for i in a.indexes
            if not Wyvern.DeepCompare(@a[@i], @Wyvern.SafeGet(b, @i)) then
                return false
            end if
        end for
    else
        return @a == @b
    end if
    return true
end function

Wyvern.TabString = function(s0)
    f = []
    for s1 in s0.split(char(10))
        f.push(char(9) + s1)
    end for
    return f.join(char(10))
end function

Wyvern.EmptyOutMap = function(map)
    for kv in map
        map.remove(kv.key)
    end for
end function

Wyvern.CompareExchange = function(mapRef, set, ifValueEqual)
    if mapRef == ifValueEqual then
        Wyvern.EmptyOutMap(mapRef)
        Wyvern.extend(set, null, mapRef)
    end if
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Util class to emulate the C# Stack class
Wyvern.Stack = {"realArray":[]}

Wyvern.Stack.Init = function()
    self.realArray = []
end function

Wyvern.Stack.Push = function(item)
    self.realArray.reverse()
    self.realArray.push(item)
    self.realArray.reverse()
end function

Wyvern.Stack.Pop = function()
    self.realArray.reverse()
    result = self.realArray.pop()
    self.realArray.reverse()
    return result
end function

Wyvern.Stack.Pull = function()
    self.realArray.reverse()
    result = self.realArray.pull()
    self.realArray.reverse()
    return result
end function

Wyvern.Stack.Get = function(index)
    return self.realArray[index]
end function

Wyvern.Stack.Set = function(index, value)
    self.realArray[index] = value
end function

Wyvern.Stack.Peek = function()
    result = self.Pop()
    self.Push(result)
    return result
end function

Wyvern.Stack.PeekLast = function()
    result = self.Pull()
    self.Push(result)
    return result
end function

Wyvern.Stack.New = function()
    newInstance = new Wyvern.Stack
    newInstance.Init()
    return newInstance
end function

Wyvern.Stack.Count = function()
    return self.realArray.len()
end function

Wyvern.Stack.ToArray = function()
    return self.realArray
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.Dictionary = {"keysArray":[], "valuesArray":[]}

Wyvern.Dictionary.Init = function()
    self.keysArray = []
    self.valuesArray = []
end function

Wyvern.Dictionary.Add = function(key, value)
    if self.KeyExists(key) then
        return false
    end if

    self.keysArray.push(key)
    self.valuesArray.push(value)
    return true
end function

Wyvern.Dictionary.GetKeyIndex = function(key)
    return self.keysArray.indexOf(key)
end function

Wyvern.Dictionary.Get = function(key)
    valueIndex = self.GetKeyIndex(key)
    if valueIndex == null then
        return null
    end if

    return self.valuesArray[valueIndex]
end function

Wyvern.Dictionary.Set = function(key, value)
    valueIndex = self.GetKeyIndex(key)
    if valueIndex == null then
        self.Add(key, value)
    else
        self.valuesArray[valueIndex] = value
    end if
end function

Wyvern.Dictionary.Remove = function(key)
    valueIndex = self.GetKeyIndex(key)
    if valueIndex == null then
        return null
    end if

    self.keysArray.remove(valueIndex)
    self.valuesArray.remove(valueIndex)
end function

Wyvern.Dictionary.KeyExists = function(key)
    return self.GetKeyIndex(key) != null
end function

Wyvern.Dictionary.Keys = function()
    return self.keysArray
end function

Wyvern.Dictionary.Values = function()
    return self.valuesArray
end function

Wyvern.Dictionary.Count = function()
    return self.keysArray.len()
end function

Wyvern.Dictionary.ForEach = function(callback)
    i = 0
    while i < self.keysArray.len()
        callback(self.keysArray[i], self.valuesArray[i])
        i = i + 1
    end while
end function

Wyvern.Dictionary.New = function()
    newInstance = new Wyvern.Dictionary
    newInstance.Init()
    return newInstance
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.TextSpan = {"Start":0, "Length":0, "End":0}

Wyvern.TextSpan.Init = function(Start, Length)
    self.Start = Start
    self.Length = Length
    self.End = Start + Length
end function

Wyvern.TextSpan.Init2 = function(Start, End)
    self.Init(Start, End - Start)
end function

Wyvern.TextSpan.New = function(Start, Length)
    newInstance = new Wyvern.TextSpan
    newInstance.Init(Start, Length)
    return newInstance
end function

Wyvern.TextSpan.FromBounds = function(Start, End)
    newInstance = new Wyvern.TextSpan
    newInstance.Init2(Start, End)
    return newInstance
end function

Wyvern.TextSpan.Combine = function(span)
    if self.Start < span.Start then
        start = self.Start
    else
        start = span.Start
    end if

    if self.End > span.End then
        endd = self.End
    else
        endd = span.End
    end if

    return Wyvern.TextSpan.FromBounds(start, endd)
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.TextLine = {"Text":-1, "Start":-1, "Length":-1, "LengthIncludingLineBreak":-1, "End":-1, "Span":-1, "SpanIncludingLineBreak":-1}

Wyvern.TextLine.Init = function(text, start, length, lengthIncludingLineBreak)
    self.Text = text
    self.Start = start
    self.Length = length
    self.End = start + length
    self.LengthIncludingLineBreak = lengthIncludingLineBreak

    self.Span = Wyvern.TextSpan.New(start, length)
    self.SpanIncludingLineBreak = Wyvern.TextSpan.New(start, lengthIncludingLineBreak)
end function

Wyvern.TextLine.New = function(text, start, length, lengthIncludingLineBreak)
    newInstance = new Wyvern.TextLine
    newInstance.Init(text, start, length, lengthIncludingLineBreak)
    return newInstance
end function

Wyvern.TextLine.ToString = function()
    return self.Text.ToString(self.Span)
end function

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.SourceText = {"Text":-1, "Lines":-1, "File":-1}

Wyvern.SourceText.Init = function(text, file=null)
    self.Text = text + char(0)
    self.File = file
    self.Lines = Wyvern.SourceText.ParseLines(self, self.Text)
end function

Wyvern.SourceText.GetLineIndex = function(position)
    lower = 0
    upper = self.Lines.len - 1

    while lower <= upper
        index = floor(lower + (upper - lower) / 2)
        start = self.Lines[index].Start

        if position == start then
            return index
        end if

        if start > position then
            upper = index - 1
        else
            lower = index + 1
        end if
    end while

    return lower - 1
end function

Wyvern.SourceText.ParseLines = function(sourceText, text)
    result = []

    position = 0
    lineStart = 0

    while position < text.len - 1
        lineBreakWidth = Wyvern.SourceText.GetLineBreakWidth(text, position)
        
        if lineBreakWidth == 0 then
            position = position + 1
        else
            Wyvern.SourceText.AddLine(result, sourceText, position, lineStart, lineBreakWidth)

            position = position + lineBreakWidth
            lineStart = position
        end if
    end while

    if position >= lineStart then
        Wyvern.SourceText.AddLine(result, sourceText, position, lineStart, 0)
    end if

    return result
end function

Wyvern.SourceText.AddLine = function(result, sourceText, position, lineStart, lineBreakWidth)
    lineLength = position - lineStart
    lineLengthIncludingLineBreak = lineLength + lineBreakWidth
    line = Wyvern.TextLine.New(sourceText, lineStart, lineLength, lineLengthIncludingLineBreak)
    result.push(line)
end function

Wyvern.SourceText.GetLineBreakWidth = function(text, position)
    c = text[position]
    if position >= text.len then
        l = char(0)
    else
        l = text[position + 1]
    end if

    if c == char(13) and l == char(10) then
        return 2
    end if

    if c == char(13) or c == char(10) then
        return 1
    end if

    return 0
end function

Wyvern.SourceText.From = function(text)
    newInstance = new Wyvern.SourceText
    newInstance.Init(text)
    return newInstance
end function

Wyvern.SourceText.FromFile = function(file)
    text = file.get_content()
    newInstance = new Wyvern.SourceText
    newInstance.Init(text, file)
    return newInstance
end function

Wyvern.SourceText.ToString = function(startOrSpan=null, length=null)
    if length != null and startOrSpan != null then
        return self.Text[startOrSpan:startOrSpan + length]
    end if

    if startOrSpan != null then
        return self.ToString(startOrSpan.Start, startOrSpan.Length)
    end if

    return self.Text
end function

Wyvern.SourceText.len = function()
    return self.Text.len
end function

Wyvern.SourceText.Length = function()
    return self.Text.len
end function
//////////////////////////////////////////////////////////////////////////////////////////

Wyvern.TextLocation = {"Text":-1, "Span":-1}

Wyvern.TextLocation.Init = function(text, span)
    self.Text = text
    self.Span = span
end function

Wyvern.TextLocation.New = function(text, span)
    newInstance = new Wyvern.TextLocation
    newInstance.Init(text, span)
    return newInstance
end function

Wyvern.TextLocation.File = function()
    return self.Text.File
end function

Wyvern.TextLocation.StartLine = function()
    return self.Text.GetLineIndex(self.Span.Start)
end function

Wyvern.TextLocation.StartCharacter = function()
    return self.Span.Start - self.Text.Lines[self.StartLine].Start
end function

Wyvern.TextLocation.EndLine = function()
    return self.Text.GetLineIndex(self.Span.End)
end function

Wyvern.TextLocation.EndCharacter = function()
    return self.Span.End - self.Text.Lines[self.EndLine].Start
end function

//////////////////////////////////////////////////////////////////////////////////////////

Wyvern.FakeSyntaxTree = function(text)
    f = {}
    f.Text = Wyvern.SourceText.From(text)
    return f
end function

//////////////////////////////////////////////////////////////////////////////////////////

Wyvern.Macro_CreateBoundPrimary = function(text)
    parser = Wyvern.Parser.New(Wyvern.FakeSyntaxTree(text))
    syntax = parser.ParsePrimaryExpression()

    binder = Wyvern.Binder.New()
    boundExpression = binder.BindExpression(syntax)
    return boundExpression
end function

Wyvern.CreateParameter = function(name, returnType, default=null)
    if default == null then
        return Wyvern.ParameterSymbol.New(name, returnType)
    else
        return Wyvern.ParameterSymbol.New(name, returnType, Wyvern.Macro_CreateBoundPrimary(default))
    end if
end function

Wyvern.CreateBuiltinMethod = function(name, parameters, returnType, callback)
    Wyvern.BuiltinFunctions[name] = Wyvern.BuiltinFunctionSymbol.New(name, parameters, returnType, @callback)
end function

Wyvern.CreateBuiltinVariable = function(name, isReadOnly, type, callback=null)
    Wyvern.BuiltinVariables[name] = Wyvern.BuiltinVariableSymbol.New(name, isReadOnly, type, @callback)
end function

Wyvern.IsAModifier = function(kind)
    return kind == Wyvern.SyntaxKind.PublicKeyword or kind == Wyvern.SyntaxKind.PrivateKeyword or kind == Wyvern.SyntaxKind.StaticKeyword or kind == Wyvern.SyntaxKind.OverrideKeyword or kind == Wyvern.SyntaxKind.VirtualKeyword
end function

Wyvern.DumpKeys = function(m)
    for k in indexes(m)
        print(k)
    end for
end function

Wyvern.IsCallable = function(f)
    return f != null and ((Wyvern.IsA(Wyvern.FunctionSymbol, f) or Wyvern.IsA(Wyvern.FunctionReferenceSymbol, f)) or (hasIndex(f, "Type") and f.Type == Wyvern.TypeSymbols.Reference))
end function

Wyvern.ScanForElement = function(m, c)
    for kv in m
        if @kv.value == @c then
            return m
        end if
    end for

    for kv in m
        if typeof(@kv.value) == "map" then
            return Wyvern.ScanForElement(kv.value, c)
        end if
    end for
    
    return null
end function