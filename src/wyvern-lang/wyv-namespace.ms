Wyvern = {}

// Miniscript's has things that wouldn't be possible to compile to
// so this flag exists so parsers and binders know what to allow
// and not allow
Wyvern.MiniscriptLimitation = true

Wyvern.EnableMiniscriptLimits = function()
    Wyvern.MiniscriptLimitation = true
end function

Wyvern.DisableMiniscriptLimits = function()
    Wyvern.MiniscriptLimitation = false
end function

// Swapable file search function for parser use
Wyvern.SearchFile = function(path)
    f = get_shell.host_computer.File(path)

    if not f then f = get_shell.host_computer.File(current_path + "/" + path)

    if not f then return null

    if not f.has_permission("r") then return null

    return f
end function

Wyvern.extend = function(oOrginal, oAppend=null, oOutClone=null)
    oClone = oOutClone

    if typeof(oOrginal) == "list" then
        if oClone == null then
            oClone = []
        end if

        for v in oOrginal
            if typeof(@v) == "function" then
                oClone.push(@v)
            else if typeof(v) == "map" or typeof(v) == "list" then
                oClone.push(Wyvern.extend(v, null))
            else
                oClone.push(v)
            end if
        end for
    else if typeof(oOrginal) == "map" then
        if oClone == null then
            oClone = {}
        end if

        for v in oOrginal
            if typeof(@v.value) == "function" then
                oClone[v.key] = @v.value
            else if typeof(v.value) == "map" or typeof(v) == "list" then
                oClone[v.key] = Wyvern.extend(v.value, null)
            else
                oClone[v.key] = v.value
            end if
        end for
    end if

    if oAppend != null then
        for v in oAppend
            if typeof(@v) == "function" then
                oClone.push(@v)
            else if typeof(v) == "map" or typeof(v) == "list" then
                oClone.push(Wyvern.extend(v, null, oOutClone))
            else
                oClone.push(v)
            end if
        end for
    end if

    return oClone
end function

Wyvern.IsA = function(compareTo, o, static=false)
    return o isa compareTo
    //if not typeof(o) == "map" then return false
    //if not typeof(compareTo) == "map" then return false
//
    //if not o.hasIndex("__isa") then
    //    return compareTo == o
    //end if
//
    //if static then
    //    return o.__isa == compareTo
    //else
    //    for compare in compareTo
    //        if not o.__isa.hasIndex(compare.key) then
    //            return false
    //        end if
    //    end for
    //end if
//
    //return true
end function

Wyvern.RepRegexChars = function(s)
    s = s.replace("\\", "\\")
    s = s.replace("\+", "\+")
    s = s.replace("\*", "\*")
    s = s.replace("\^", "\^")
    s = s.replace("\?", "\?")
    s = s.replace("\|", "\|")
    s = s.replace("\$", "\$")
    s = s.replace("\#", "\#")
    s = s.replace("\.", "\.")

    s = s.replace("\(", "\(")
    s = s.replace("\)", "\)")

    s = s.replace("\[", "\[")
    s = s.replace("\]", "\]")

    s = s.replace("\{", "\{")
    s = s.replace("\}", "\}")

    s = s.replace("\""", "\""")
    return s
end function

Wyvern.ReplaceEveryChar = function(baseString, oldChars, newChar="")
    for c in oldChars
        baseString = baseString.replace(Wyvern.RepRegexChars(c), newChar)
    end for

    return baseString
end function

Wyvern.IsAPIEnabled = function()
    return Wyvern.hasIndex("Compilation")
end function

Wyvern.FindTypeName = function(type)
    //types = []
    //for kv in Wyvern
    //    if typeof(@kv.value) != "map" then
    //        continue
    //    end if
    //    if Wyvern.IsA(kv.value, type) then
    //        types.push(kv.key)
    //    end if
    //end for
    //return types
    for kv in Wyvern
        if @kv.value == type.__isa then
            return kv.key
        end if
    end for

    return "None"
end function

// Enum
Wyvern.__nAutoCount = 0
Wyvern.auto = function(bReset=false)
    nCount = Wyvern.__nAutoCount
    if bReset == true then
        Wyvern.__nAutoCount = 0
    else
        Wyvern.__nAutoCount = Wyvern.__nAutoCount + 1
    end if
    return nCount
end function

// Builtins
Wyvern.BuiltinFunctions = {}
Wyvern.BuiltinVariables = {}

Wyvern.BuiltinFunctions.GetAll = function()
    list = []
    for kv in Wyvern.BuiltinFunctions
        if typeof(@kv.value) == "function" then continue
        if typeof(kv.value)  != "map" then continue
        if Wyvern.IsA(Wyvern.BuiltinFunctionSymbol, kv.value) then
            list.push(kv.value)
        end if
    end for

    return list
end function

Wyvern.BuiltinVariables.GetAll = function()
    list = []

    for kv in Wyvern.BuiltinVariables
        if typeof(@kv.value) == "function" then continue
        if typeof(kv.value)  != "map" then continue
        if Wyvern.IsA(Wyvern.BuiltinVariableSymbol, kv.value) then
            list.push(kv.value)
        end if
    end for

    return list
end function