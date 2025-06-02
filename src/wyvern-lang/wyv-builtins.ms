Wyvern.AddTypeMethod = function(typeName, funcName, parameters, returnType, callback=null)
    Wyvern.TypeNameBindings[typeName].AddMethod(Wyvern.BuiltinFunctionSymbol.New(funcName, parameters, returnType, @callback))
end function

Wyvern.AddTypeProperty = function(typeName, propName, isReadOnly, type, callback=null)
    Wyvern.TypeNameBindings[typeName].AddProperty(Wyvern.BuiltinVariableSymbol.New(propName, isReadOnly, type, @callback))
end function

Wyvern.Methods = {}

// Computer Methods
Wyvern.Methods.ActiveNetCard = function(self, args)
    return self.active_net_card()
end function
Wyvern.Methods.ChangePassword = function(self, args)
    return self.change_password(args[0], args[1])
end function
Wyvern.Methods.CloseProgram = function(self, args)
    return self.close_program(args[0])
end function
Wyvern.Methods.ConnectEthernet = function(self, args)
    return self.connect_ethernet(args[0], args[1], args[2])
end function
Wyvern.Methods.ConnectWifi = function(self, args)
    return self.connect_wifi(args[0], args[1], args[2], args[3])
end function
Wyvern.Methods.CreateFolder = function(self, args)
    return self.create_folder(args[0], args[1])
end function
Wyvern.Methods.CreateGroup = function(self, args)
    return self.create_group(args[0], args[1])
end function
Wyvern.Methods.CreateUser = function(self, args)
    return self.create_user(args[0], args[1])
end function
Wyvern.Methods.DeleteGroup = function(self, args)
    return self.delete_group(args[0], args[1])
end function
Wyvern.Methods.DeleteUser = function(self, args)
    return self.delete_user(args[0], args[1])
end function
Wyvern.Methods.File = function(self, args)
    return self.File(args[0])
end function
Wyvern.Methods.GetPorts = function(self, args)
    return self.get_ports()
end function
Wyvern.Methods.Groups = function(self, args)
    return self.groups(args[0])
end function
Wyvern.Methods.IsNetworkActive = function(self, args)
    return self.is_network_active()
end function
Wyvern.Methods.LocalIp = function(self, args)
    return self.local_ip()
end function
Wyvern.Methods.NetworkDevices = function(self, args)
    return self.network_devices()
end function
Wyvern.Methods.NetworkGateway = function(self, args)
    return self.network_gateway()
end function
Wyvern.Methods.PublicIp = function(self, args)
    return self.public_ip()
end function
Wyvern.Methods.ShowProcs = function(self, args)
    return self.show_procs()
end function
Wyvern.Methods.Touch = function(self, args)
    return self.touch(args[0], args[1])
end function
Wyvern.Methods.WifiNetworks = function(self, args)
    return self.wifi_networks(args[0])
end function

// Computer definitions
Wyvern.AddTypeMethod("computer", "active_net_card", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.ActiveNetCard)
Wyvern.AddTypeMethod("computer", "change_password", [Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.ChangePassword)
Wyvern.AddTypeMethod("computer", "close_program", [Wyvern.CreateParameter("PID", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Void, @Wyvern.Methods.CloseProgram)
Wyvern.AddTypeMethod("computer", "connect_ethernet", [Wyvern.CreateParameter("net_device", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("local_address", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("gateway", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.ConnectEthernet)
Wyvern.AddTypeMethod("computer", "connect_wifi", [Wyvern.CreateParameter("net_device", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("bssid", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("essid", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.ConnectWifi)
Wyvern.AddTypeMethod("computer", "create_folder", [Wyvern.CreateParameter("path", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("folder_name", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Any, @Wyvern.Methods.CreateFolder)
Wyvern.AddTypeMethod("computer", "create_group", [Wyvern.CreateParameter("username", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("groupname", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Any, @Wyvern.Methods.CreateGroup)
Wyvern.AddTypeMethod("computer", "create_user", [Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Any, @Wyvern.Methods.CreateUser)
Wyvern.AddTypeMethod("computer", "delete_group", [Wyvern.CreateParameter("username", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("groupname", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Any, @Wyvern.Methods.DeleteGroup)
Wyvern.AddTypeMethod("computer", "delete_user", [Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("deleteHome", Wyvern.TypeSymbols.Bool)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.DeleteUser)
Wyvern.AddTypeMethod("computer", "File", [Wyvern.CreateParameter("path_file", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.File, @Wyvern.Methods.File)
Wyvern.AddTypeMethod("computer", "get_ports", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Port), @Wyvern.Methods.GetPorts)
Wyvern.AddTypeMethod("computer", "groups", [Wyvern.CreateParameter("username", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Groups)
Wyvern.AddTypeMethod("computer", "is_network_active", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.IsNetworkActive)
Wyvern.AddTypeMethod("computer", "local_ip", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.LocalIp)
Wyvern.AddTypeMethod("computer", "network_devices", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.NetworkDevices)
Wyvern.AddTypeMethod("computer", "network_gateway", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.NetworkGateway)
Wyvern.AddTypeMethod("computer", "public_ip", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.PublicIp)
Wyvern.AddTypeMethod("computer", "shows_procs", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.ShowProcs)
Wyvern.AddTypeMethod("computer", "touch", [Wyvern.CreateParameter("path", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("name", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.Touch)
Wyvern.AddTypeMethod("computer", "wifi_networks", [Wyvern.CreateParameter("net_device", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.WifiNetworks)

// Router methods
Wyvern.Methods.BssidName = function(self, args)
    return self.bssid_name()
end function

Wyvern.Methods.DevicePorts = function(self, args)
    return self.device_ports(args[0])
end function

Wyvern.Methods.DevicesLanIp = function(self, args)
    return self.devices_lan_ip()
end function
Wyvern.Methods.EssidName = function(self, args)
    return self.essid_name()
end function
Wyvern.Methods.FirewallRules = function(self, args)
    return self.firewall_rules()
end function
Wyvern.Methods.KernelVersion = function(self, args)
    return self.kernel_version()
end function
Wyvern.Methods.LocalIp = function(self, args)
    return self.local_ip()
end function
Wyvern.Methods.PingPort = function(self, args)
    return self.ping_port(args[0])
end function
Wyvern.Methods.PortInfo = function(self, args)
    return self.port_info(args[0])
end function
Wyvern.Methods.PublicIp = function(self, args)
    return self.public_ip()
end function
Wyvern.Methods.UsedPorts = function(self, args)
    return self.used_ports()
end function

// Router definitions
Wyvern.AddTypeMethod("router", "bssid_name", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.BssidName)
Wyvern.AddTypeMethod("router", "device_ports", [Wyvern.CreateParameter("ip_address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Any, @Wyvern.Methods.DevicePorts)
Wyvern.AddTypeMethod("router", "devices_lan_ip", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.DevicesLanIp)
Wyvern.AddTypeMethod("router", "essid_name", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.EssidName)
Wyvern.AddTypeMethod("router", "firewall_rules", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.FirewallRules)
Wyvern.AddTypeMethod("router", "kernel_version", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.KernelVersion)
Wyvern.AddTypeMethod("router", "local_ip", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.LocalIp)
Wyvern.AddTypeMethod("router", "ping_port", [Wyvern.CreateParameter("port_number", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Port, @Wyvern.Methods.PingPort)
Wyvern.AddTypeMethod("router", "port_info", [Wyvern.CreateParameter("object", Wyvern.TypeSymbols.Port)], Wyvern.TypeSymbols.String, @Wyvern.Methods.PortInfo)
Wyvern.AddTypeMethod("router", "public_ip", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.PublicIp)
Wyvern.AddTypeMethod("router", "used_ports", [], Wyvern.TypeSymbols.Port, @Wyvern.Methods.UsedPorts)

// File methods
Wyvern.Methods.AllowImport = function(self, args)
    return self.allow_import()
end function
Wyvern.Methods.Chmod = function(self, args)
    return self.chmod(args[0], args[1])
end function
Wyvern.Methods.Copy = function(self, args)
    return self.copy(args[0], args[1])
end function
Wyvern.Methods.Delete = function(self, args)
    return self.delete()
end function
Wyvern.Methods.GetContent = function(self, args)
    return self.get_content()
end function
Wyvern.Methods.GetFiles = function(self, args)
    return self.get_files()
end function
Wyvern.Methods.GetFolders = function(self, args)
    return self.get_folders()
end function
Wyvern.Methods.Group = function(self, args)
    return self.group()
end function
Wyvern.Methods.HasPermission = function(self, args)
    return self.has_permission(args[0])
end function
Wyvern.Methods.IsBinary = function(self, args)
    return self.is_binary()
end function
Wyvern.Methods.IsFolder = function(self, args)
    return self.is_folder()
end function
Wyvern.Methods.Move = function(self, args)
    return self.move(args[0], args[1])
end function
Wyvern.Methods.Name = function(self, args)
    return self.name()
end function
Wyvern.Methods.Owner = function(self, args)
    return self.owner()
end function
Wyvern.Methods.Parent = function(self, args)
    return self.parent()
end function
Wyvern.Methods.Path = function(self, args)
    return self.path()
end function
Wyvern.Methods.Permissions = function(self, args)
    return self.permissions()
end function
Wyvern.Methods.Rename = function(self, args)
    return self.rename(args[0])
end function
Wyvern.Methods.SetContent = function(self, args)
    return self.set_content(args[0])
end function
Wyvern.Methods.SetGroup = function(self, args)
    return self.set_group(args[0], args[1])
end function
Wyvern.Methods.SetOwner = function(self, args)
    return self.set_owner(args[0], args[1])
end function
Wyvern.Methods.Size = function(self, args)
    return self.size()
end function

// File definitions
Wyvern.AddTypeMethod("file", "allow_import", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.AllowImport)
Wyvern.AddTypeMethod("file", "chmod", [Wyvern.CreateParameter("permissions", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("isRecursive", Wyvern.TypeSymbols.Bool, "false")], Wyvern.TypeSymbols.String, @Wyvern.Methods.Chmod)
Wyvern.AddTypeMethod("file", "copy", [Wyvern.CreateParameter("path", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("file_new_name", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Copy)
Wyvern.AddTypeMethod("file", "delete", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Delete)
Wyvern.AddTypeMethod("file", "get_content", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.GetContent)
Wyvern.AddTypeMethod("file", "get_files", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.File), @Wyvern.Methods.GetFiles)
Wyvern.AddTypeMethod("file", "get_folders", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.File), @Wyvern.Methods.GetFolders)
Wyvern.AddTypeMethod("file", "group", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Group)
Wyvern.AddTypeMethod("file", "has_permission", [Wyvern.CreateParameter("type_perm", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.HasPermission)
Wyvern.AddTypeMethod("file", "is_binary", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.IsBinary)
Wyvern.AddTypeMethod("file", "is_folder", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.IsFolder)
Wyvern.AddTypeMethod("file", "move", [Wyvern.CreateParameter("path", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("file_new_name", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Move)
Wyvern.AddTypeMethod("file", "name", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Name)
Wyvern.AddTypeMethod("file", "owner", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Owner)
Wyvern.AddTypeMethod("file", "parent", [], Wyvern.TypeSymbols.File, @Wyvern.Methods.Parent)
Wyvern.AddTypeMethod("file", "path", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Path)
Wyvern.AddTypeMethod("file", "permissions", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Permissions)
Wyvern.AddTypeMethod("file", "rename", [Wyvern.CreateParameter("new_name", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Rename)
Wyvern.AddTypeMethod("file", "set_content", [Wyvern.CreateParameter("text", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.SetContent)
Wyvern.AddTypeMethod("file", "set_group", [Wyvern.CreateParameter("groupname", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("isRecursive", Wyvern.TypeSymbols.Bool, "false")], Wyvern.TypeSymbols.String, @Wyvern.Methods.SetGroup)
Wyvern.AddTypeMethod("file", "set_owner", [Wyvern.CreateParameter("ownerName", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("isRecursive", Wyvern.TypeSymbols.Bool, "false")], Wyvern.TypeSymbols.String, @Wyvern.Methods.SetOwner)
Wyvern.AddTypeMethod("file", "size", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Size)

// Port Methods
Wyvern.Methods.GetLanIp = function(self, args)
    return self.get_lan_ip()
end function
Wyvern.Methods.IsClosed = function(self, args)
    return self.is_closed()
end function
Wyvern.Methods.PortNumber = function(self, args)
    return self.port_number()
end function

// Port Definitions
Wyvern.AddTypeMethod("port", "get_lan_ip", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.GetLanIp)
Wyvern.AddTypeMethod("port", "is_closed", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.IsClosed)
Wyvern.AddTypeMethod("port", "port_number", [], Wyvern.TypeSymbols.Number, @Wyvern.Methods.PortNumber)

// Shell Methods
Wyvern.Methods.Build = function(self, args)
    return self.build(args[0], args[1], args[2])
end function
Wyvern.Methods.ConnectService = function(self, args)
    return self.connect_service(args[0], args[1], args[2], args[3])
end function
Wyvern.Methods.HostComputer = function(self, args)
    return self.host_computer()
end function
Wyvern.Methods.Launch = function(self, args)
    return self.launch(args[0], args[1])
end function
Wyvern.Methods.Ping = function(self, args)
    return self.ping(args[0])
end function
Wyvern.Methods.Put = function(self, args)
    return self.put(args[0], args[1], args[2])
end function
Wyvern.Methods.Scp = function(self, args)
    return self.scp(args[0], args[1], args[2])
end function
Wyvern.Methods.StartTerminal = function(self, args)
    return self.start_terminal()
end function

// Shell Definitions
Wyvern.AddTypeMethod("shell", "build", [Wyvern.CreateParameter("path_source_code", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("path_destination_folder", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("allow_import", Wyvern.TypeSymbols.Bool, "false")], Wyvern.TypeSymbols.String, @Wyvern.Methods.Build)
Wyvern.AddTypeMethod("shell", "connect_service", [Wyvern.CreateParameter("ipAddress", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("port", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("service", Wyvern.TypeSymbols.String, """ssh""")], Wyvern.TypeSymbols.Shell, @Wyvern.Methods.ConnectService)
Wyvern.AddTypeMethod("shell", "host_computer", [], Wyvern.TypeSymbols.Computer, @Wyvern.Methods.HostComputer)
Wyvern.AddTypeMethod("shell", "launch", [Wyvern.CreateParameter("program_path", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("program_parameters", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Void, @Wyvern.Methods.Launch)
Wyvern.AddTypeMethod("shell", "ping", [Wyvern.CreateParameter("address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.Ping)
Wyvern.AddTypeMethod("shell", "put", [Wyvern.CreateParameter("path_orig", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("path_dest", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("remoteShell", Wyvern.TypeSymbols.Shell)], Wyvern.TypeSymbols.Void, @Wyvern.Methods.Put)
Wyvern.AddTypeMethod("shell", "scp", [Wyvern.CreateParameter("path_orig", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("path_dest", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("remoteShell", Wyvern.TypeSymbols.Shell)], Wyvern.TypeSymbols.Void, @Wyvern.Methods.Scp)
Wyvern.AddTypeMethod("shell", "start_terminal", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.StartTerminal)

// FtpShell Methods
Wyvern.Methods.FtpPut = function(self, args)
    return self.put(args[0], args[1], args[2])
end function

// FtpShell Definitions
Wyvern.AddTypeMethod("ftpshell", "start_terminal", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.StartTerminal)
Wyvern.AddTypeMethod("ftpshell", "host_computer", [], Wyvern.TypeSymbols.Computer, @Wyvern.Methods.HostComputer)
Wyvern.AddTypeMethod("ftpshell", "put", [Wyvern.CreateParameter("path_orig", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("path_dest", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("remote_shell", Wyvern.TypeSymbols.Shell)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.FtpPut)

// Crypto Methods
Wyvern.Methods.Aircrack = function(self, args)
    return self.aircrack(args[0])
end function
Wyvern.Methods.Aireplay = function(self, args)
    return self.aireplay(args[0], args[1], args[2])
end function
Wyvern.Methods.Airmon = function(self, args)
    return self.airmon(args[0], args[1])
end function
Wyvern.Methods.Decipher = function(self, args)
    return self.decipher(args[0])
end function
Wyvern.Methods.SmtpUserList = function(self, args)
    return self.smtp_user_list(args[0], args[1])
end function

// Crypto Definitions
Wyvern.AddTypeMethod("crypto", "aircrack", [Wyvern.CreateParameter("filePath", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Aircrack)
Wyvern.AddTypeMethod("crypto", "aireplay", [Wyvern.CreateParameter("bssid", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("essid", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("maxAcks", Wyvern.TypeSymbols.Number, "-1")], Wyvern.TypeSymbols.String, @Wyvern.Methods.Aireplay)
Wyvern.AddTypeMethod("crypto", "airmon", [Wyvern.CreateParameter("option", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("device", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Airmon)
Wyvern.AddTypeMethod("crypto", "decipher", [Wyvern.CreateParameter("encrypted_pass", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Decipher)
Wyvern.AddTypeMethod("crypto", "smtp_user_list", [Wyvern.CreateParameter("ip_address", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("port", Wyvern.TypeSymbols.Number)], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.SmtpUserList)

// Aptclient Methods
Wyvern.Methods.AddRepo = function(self, args)
    return self.add_repo(args[0], args[1])
end function
Wyvern.Methods.CheckUpgrade = function(self, args)
    return self.check_upgrade(args[0])
end function
Wyvern.Methods.DelRepo = function(self, args)
    return self.del_repo(args[0])
end function
Wyvern.Methods.Install = function(self, args)
    return self.install(args[0], args[1])
end function
Wyvern.Methods.Search = function(self, args)
    return self.search(args[0])
end function
Wyvern.Methods.Show = function(self, args)
    return self.show(args[0])
end function
Wyvern.Methods.Update = function(self, args)
    return self.update()
end function

// Aptclient Definitions
Wyvern.AddTypeMethod("aptclient", "add_repo", [Wyvern.CreateParameter("repository_address", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("port", Wyvern.TypeSymbols.Number, "1542")], Wyvern.TypeSymbols.String, @Wyvern.Methods.AddRepo)
Wyvern.AddTypeMethod("aptclient", "check_upgrade", [Wyvern.CreateParameter("file_path", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.CheckUpgrade)
Wyvern.AddTypeMethod("aptclient", "del_repo", [Wyvern.CreateParameter("repository_address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.DelRepo)
Wyvern.AddTypeMethod("aptclient", "install", [Wyvern.CreateParameter("package_name", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("install_path", Wyvern.TypeSymbols.String, """""")], Wyvern.TypeSymbols.Any, @Wyvern.Methods.Install)
Wyvern.AddTypeMethod("aptclient", "search", [Wyvern.CreateParameter("package_name", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Search)
Wyvern.AddTypeMethod("aptclient", "show", [Wyvern.CreateParameter("repository_name", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Show)
Wyvern.AddTypeMethod("aptclient", "update", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Update)

// Metaxploit Methods
Wyvern.Methods.Load = function(self, args)
    return self.load(args[0])
end function
Wyvern.Methods.NetUse = function(self, args)
    return self.net_use(args[0], args[1])
end function
Wyvern.Methods.RshellClient = function(self, args)
    return self.rshell_client(args[0], args[1], args[2])
end function
Wyvern.Methods.RshellServer = function(self, args)
    return self.rshell_server()
end function
Wyvern.Methods.Scan = function(self, args)
    return self.scan(args[0])
end function
Wyvern.Methods.ScanAddress = function(self, args)
    return self.scan_address(args[0], args[1])
end function
Wyvern.Methods.Sniffer = function(self, args)
    return self.sniffer(args[0])
end function

// Metaxploit Definitions
Wyvern.AddTypeMethod("metaxploit", "load", [Wyvern.CreateParameter("lib_path", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.MetaLib, @Wyvern.Methods.Load)
Wyvern.AddTypeMethod("metaxploit", "net_use", [Wyvern.CreateParameter("ip_address", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("port", Wyvern.TypeSymbols.Number, "0")], Wyvern.TypeSymbols.NetSession, @Wyvern.Methods.NetUse)
Wyvern.AddTypeMethod("metaxploit", "rshell_client", [Wyvern.CreateParameter("ipAddress", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("port", Wyvern.TypeSymbols.Number, "1222"), Wyvern.CreateParameter("procName", Wyvern.TypeSymbols.String, """rshell_client""")], Wyvern.TypeSymbols.Shell, @Wyvern.Methods.RshellClient)
Wyvern.AddTypeMethod("metaxploit", "rshell_server", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Shell), @Wyvern.Methods.RshellServer)
Wyvern.AddTypeMethod("metaxploit", "scan", [Wyvern.CreateParameter("metalib", Wyvern.TypeSymbols.MetaLib)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Scan)
Wyvern.AddTypeMethod("metaxploit", "scan_address", [Wyvern.CreateParameter("metalib", Wyvern.TypeSymbols.MetaLib), Wyvern.CreateParameter("mem_address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.ScanAddress)
Wyvern.AddTypeMethod("metaxploit", "sniffer", [Wyvern.CreateParameter("saveEncSource", Wyvern.TypeSymbols.Bool, "false")], Wyvern.TypeSymbols.String, @Wyvern.Methods.Sniffer)

// MetaLib Methods
Wyvern.Methods.LibName = function(self, args)
    return self.lib_name()
end function
Wyvern.Methods.Overflow = function(self, args)
    return self.overflow(args[0], args[1], args[2])
end function
Wyvern.Methods.Version = function(self, args)
    return self.version()
end function

// MetaLib Definition
Wyvern.AddTypeMethod("metalib", "lib_name", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.LibName)
Wyvern.AddTypeMethod("metalib", "overflow", [Wyvern.CreateParameter("mem_address", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("unsec_value", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("extra_args", Wyvern.TypeSymbols.Any, """""")], Wyvern.TypeSymbols.Any, @Wyvern.Methods.Overflow)
Wyvern.AddTypeMethod("metalib", "version", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Version)

// NetSession Methods
Wyvern.Methods.DumpLib = function(self, args)
    return self.dump_lib()
end function

// NetSession Definition
Wyvern.AddTypeMethod("netsession", "dump_lib", [], Wyvern.TypeSymbols.MetaLib, @Wyvern.Methods.DumpLib)

// Blockchain Methods
Wyvern.Methods.AmountMined = function(self, args)
    return self.amount_mined(args[0])
end function
Wyvern.Methods.CoinPrice = function(self, args)
    return self.coin_price(args[0])
end function
Wyvern.Methods.CreateWallet = function(self, args)
    return self.create_wallet(args[0], args[1])
end function
Wyvern.Methods.DeleteCoin = function(self, args)
    return self.delete_coin(args[0], args[1], args[2])
end function
Wyvern.Methods.GetCoin = function(self, args)
    return self.get_coin(args[0], args[1], args[2])
end function
Wyvern.Methods.LoginWallet = function(self, args)
    return self.login_wallet(args[0], args[1])
end function
Wyvern.Methods.ShowHistory = function(self, args)
    return self.show_history(args[0])
end function

// Blockchain Definitions
Wyvern.AddTypeMethod("blockchain", "amount_mined", [Wyvern.CreateParameter("coinName", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Number, @Wyvern.Methods.AmountMined)
Wyvern.AddTypeMethod("blockchain", "coin_price", [Wyvern.CreateParameter("coinName", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Number, @Wyvern.Methods.CoinPrice)
Wyvern.AddTypeMethod("blockchain", "create_wallet", [Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.SubWallet, @Wyvern.Methods.CreateWallet)
Wyvern.AddTypeMethod("blockchain", "delete_coin", [Wyvern.CreateParameter("name", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Void, @Wyvern.Methods.DeleteCoin)
Wyvern.AddTypeMethod("blockchain", "get_coin", [Wyvern.CreateParameter("name", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Coin, @Wyvern.Methods.GetCoin)
Wyvern.AddTypeMethod("blockchain", "login_wallet", [Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.SubWallet, @Wyvern.Methods.LoginWallet)
Wyvern.AddTypeMethod("blockchain", "show_history", [Wyvern.CreateParameter("coinName", Wyvern.TypeSymbols.String)], Wyvern.MapSymbol.New(Wyvern.TypeSymbols.Number, Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Any)), @Wyvern.Methods.ShowHistory)

// SubWallet Methods
Wyvern.Methods.BuyCoin = function(self, args)
    return self.buy_coin(args[0], args[1], args[2])
end function
Wyvern.Methods.CancelPendingTrade = function(self, args)
    return self.cancel_pending_trade(args[0])
end function
Wyvern.Methods.GetBalance = function(self, args)
    return self.get_balance(args[0])
end function
Wyvern.Methods.GetGlobalOffers = function(self, args)
    return self.get_global_offers(args[0])
end function
Wyvern.Methods.GetPendingTrade = function(self, args)
    return self.get_pending_trade(args[0])
end function
Wyvern.Methods.GetPin = function(self, args)
    return self.get_pin()
end function
Wyvern.Methods.ListCoins = function(self, args)
    return self.list_coins()
end function
Wyvern.Methods.ListGlobalCoins = function(self, args)
    return self.list_global_coins()
end function
Wyvern.Methods.ResetPassword = function(self, args)
    return self.reset_password(args[0])
end function
Wyvern.Methods.SellCoin = function(self, args)
    return self.sell_coin(args[0], args[1], args[2])
end function
Wyvern.Methods.ShowNodes = function(self, args)
    return self.show_nodes(args[0])
end function

// SubWallet Definitions
Wyvern.AddTypeMethod("wallet", "buy_coin", [Wyvern.CreateParameter("currencyName", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("quantity", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("UnitPrice", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.BuyCoin)
Wyvern.AddTypeMethod("wallet", "cancel_pending_trade", [Wyvern.CreateParameter("currencyName", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Void, @Wyvern.Methods.CancelPendingTrade)
Wyvern.AddTypeMethod("wallet", "get_balance", [Wyvern.CreateParameter("coinName", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Number, @Wyvern.Methods.GetBalance)
Wyvern.AddTypeMethod("wallet", "get_global_offers", [Wyvern.CreateParameter("currencyName", Wyvern.TypeSymbols.String)], Wyvern.MapSymbol.New(Wyvern.TypeSymbols.String, Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Any)), @Wyvern.Methods.GetGlobalOffers)
Wyvern.AddTypeMethod("wallet", "get_pending_trade", [Wyvern.CreateParameter("currencyName", Wyvern.TypeSymbols.String)], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Any), @Wyvern.Methods.GetPendingTrade)
Wyvern.AddTypeMethod("wallet", "get_pin", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.GetPin) 
Wyvern.AddTypeMethod("wallet", "list_coins", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.ListCoins)
Wyvern.AddTypeMethod("wallet", "list_global_coins", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.ListGlobalCoins)
Wyvern.AddTypeMethod("wallet", "reset_password", [Wyvern.CreateParameter("newPassword", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.ResetPassword)
Wyvern.AddTypeMethod("wallet", "sell_coin", [Wyvern.CreateParameter("currencyName", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("quantity", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("UnitPrice", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.SellCoin)
Wyvern.AddTypeMethod("wallet", "show_nodes", [Wyvern.CreateParameter("coinName", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Number, @Wyvern.Methods.ShowNodes)

// MetaMail Methods
Wyvern.Methods.MailDelete = function(self, args)
    return self.delete(args[0])
end function
Wyvern.Methods.Fetch = function(self, args)
    return self.fetch()
end function
Wyvern.Methods.Read = function(self, args)
    return self.read(args[0])
end function
Wyvern.Methods.Send = function(self, args)
    return self.send(args[0], args[1], args[2])
end function

// MetaMail Definitions
Wyvern.AddTypeMethod("metamail", "delete", [Wyvern.CreateParameter("mail_ID", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.MailDelete)
Wyvern.AddTypeMethod("metamail", "fetch", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.Fetch)
Wyvern.AddTypeMethod("metamail", "read", [Wyvern.CreateParameter("mail_ID", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Methods.Read)
Wyvern.AddTypeMethod("metamail", "send", [Wyvern.CreateParameter("address", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("subject", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("message", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.Send)

// Coin Methods
Wyvern.Methods.CreateSubwallet = function(self, args)
    return self.create_subwallet(args[0], args[1], args[2], args[3])
end function
Wyvern.Methods.GetAddress = function(self, args)
    return self.get_address()
end function
Wyvern.Methods.GetCycleMining = function(self, args)
    return self.get_cycle_mining()
end function
Wyvern.Methods.GetMinedCoins = function(self, args)
    return self.get_mined_coins()
end function
Wyvern.Methods.GetReward = function(self, args)
    return self.get_reward()
end function
Wyvern.Methods.GetSubwallet = function(self, args)
    return self.get_subwallet(args[0])
end function
Wyvern.Methods.GetSubwallets = function(self, args)
    return self.get_subwallets()
end function
Wyvern.Methods.SetAddress = function(self, args)
    return self.set_address(args[0])
end function
Wyvern.Methods.SetCycleMining = function(self, args)
    return self.set_cycle_mining(args[0])
end function
Wyvern.Methods.SetReward = function(self, args)
    return self.set_reward(args[0])
end function
Wyvern.Methods.Transaction = function(self, args)
    return self.transaction(args[0], args[1], args[2])
end function

// Coin Definitions
Wyvern.AddTypeMethod("coin", "create_subwallet", [Wyvern.CreateParameter("walletID", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("pin", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("subWalletUser", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("subWalletPass", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.SubWallet, @Wyvern.Methods.CreateSubwallet)
Wyvern.AddTypeMethod("coin", "get_address", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.GetAddress)
Wyvern.AddTypeMethod("coin", "get_cycle_mining", [], Wyvern.TypeSymbols.Number, @Wyvern.Methods.GetCycleMining)
Wyvern.AddTypeMethod("coin", "get_mined_coins", [], Wyvern.TypeSymbols.Number, @Wyvern.Methods.GetMinedCoins)
Wyvern.AddTypeMethod("coin", "get_reward", [], Wyvern.TypeSymbols.Number, @Wyvern.Methods.GetReward)
Wyvern.AddTypeMethod("coin", "get_subwallet", [Wyvern.CreateParameter("subWalletUser", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.SubWallet, @Wyvern.Methods.GetSubwallet)
Wyvern.AddTypeMethod("coin", "get_subwallets", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.SubWallet), @Wyvern.Methods.GetSubwallets)
Wyvern.AddTypeMethod("coin", "set_address", [Wyvern.CreateParameter("address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.SetAddress)
Wyvern.AddTypeMethod("coin", "set_cycle_mining", [Wyvern.CreateParameter("rateHours", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.SetCycleMining)
Wyvern.AddTypeMethod("coin", "set_reward", [Wyvern.CreateParameter("coinAmount", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.SetReward)
Wyvern.AddTypeMethod("coin", "transaction", [Wyvern.CreateParameter("origSubWallet", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("destSubWallet", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("amount", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.Transaction)

// Subwallet Methods
Wyvern.Methods.CheckPassword = function(self, args)
    return self.check_password(args[0])
end function
Wyvern.Methods.SubWalletDelete = function(self, args)
    return self.delete()
end function
Wyvern.Methods.GetBalance = function(self, args)
    return self.get_balance()
end function
Wyvern.Methods.GetInfo = function(self, args)
    return self.get_info()
end function
Wyvern.Methods.GetUser = function(self, args)
    return self.get_user()
end function
Wyvern.Methods.LastTransaction = function(self, args)
    return self.last_transaction()
end function
Wyvern.Methods.Mining = function(self, args)
    return self.mining()
end function
Wyvern.Methods.SetInfo = function(self, args)
    return self.set_info(args[0])
end function
Wyvern.Methods.WalletUsername = function(self, args)
    return self.wallet_username()
end function

// SubWallet Definitions
Wyvern.AddTypeMethod("subwallet", "check_password", [Wyvern.CreateParameter("subWalletPass", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.CheckPassword)
Wyvern.AddTypeMethod("subwallet", "delete", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.SubWalletDelete)
Wyvern.AddTypeMethod("subwallet", "get_balance", [], Wyvern.TypeSymbols.Number, @Wyvern.Methods.GetBalance)
Wyvern.AddTypeMethod("subwallet", "get_info", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.GetInfo)
Wyvern.AddTypeMethod("subwallet", "get_user", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.GetUser)
Wyvern.AddTypeMethod("subwallet", "last_transaction", [], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Any), @Wyvern.Methods.LastTransaction)
Wyvern.AddTypeMethod("subwallet", "mining", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.Mining)
Wyvern.AddTypeMethod("subwallet", "set_info", [Wyvern.CreateParameter("info", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.SetInfo)
Wyvern.AddTypeMethod("subwallet", "wallet_username", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.WalletUsername)

// Service Methods
Wyvern.Methods.InstallService = function(self, args)
    return self.install_service()
end function
Wyvern.Methods.StartService = function(self, args)
    return self.start_service()
end function
Wyvern.Methods.StopService = function(self, args)
    return self.stop_service()
end function

// Service Definitions
Wyvern.AddTypeMethod("service", "install_service", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.InstallService)
Wyvern.AddTypeMethod("service", "start_service", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.StartService)
Wyvern.AddTypeMethod("service", "stop_service", [], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.StopService)

// String Methods
Wyvern.Methods.HasIndex = function(self, args)
    return self.hasIndex(args[0])
end function

Wyvern.Methods.IndexOf = function(self, args)
    return self.indexOf(args[0], args[1])
end function

Wyvern.Methods.Insert = function(self, args)
    return self.insert(args[0], args[1])
end function

Wyvern.Methods.Remove = function(self, args)
    return self.remove(args[0])
end function

Wyvern.Methods.Replace = function(self, args)
    return self.replace(args[0], args[1], args[2])
end function

Wyvern.Methods.Upper = function(self, args)
    return self.upper()
end function

Wyvern.Methods.Lower = function(self, args)
    return self.lower()
end function

Wyvern.Methods.Split = function(self, args)
    return self.split(args[0], args[1])
end function

Wyvern.Methods.Reverse = function(self, args)
    return self.reverse
end function

Wyvern.Methods.Len = function(self)
    return self.len()
end function

Wyvern.Methods.Indexes = function(self)
    return self.indexes()
end function

Wyvern.Methods.Values = function(self)
    return self.values()
end function

Wyvern.Methods.Val = function(self)
    return self.val
end function

Wyvern.Methods.Code = function(self)
    return self.code
end function

// String Definitions
// typeName, propName, isReadOnly, type, callback=null
Wyvern.AddTypeMethod("string", "hasIndex", [Wyvern.CreateParameter("i", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Bool, @Wyvern.Methods.HasIndex)
Wyvern.AddTypeMethod("string", "indexOf", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("after", Wyvern.TypeSymbols.Number, "null")], Wyvern.TypeSymbols.Number, @Wyvern.Methods.IndexOf)
Wyvern.AddTypeMethod("string", "insert", [Wyvern.CreateParameter("index", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("value", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Void, @Wyvern.Methods.Insert)
Wyvern.AddTypeMethod("string", "remove", [Wyvern.CreateParameter("s", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Void, @Wyvern.Methods.Remove)
Wyvern.AddTypeMethod("string", "replace", [Wyvern.CreateParameter("oldval", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("newval", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("maxCount", Wyvern.TypeSymbols.Number, "null")], Wyvern.TypeSymbols.String, @Wyvern.Methods.Replace)
Wyvern.AddTypeMethod("string", "upper", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Upper)
Wyvern.AddTypeMethod("string", "lower", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Lower)
Wyvern.AddTypeMethod("string", "split", [Wyvern.CreateParameter("delimeter", Wyvern.TypeSymbols.String, """ """), Wyvern.CreateParameter("maxCount", Wyvern.TypeSymbols.Number, "null")], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.Split)
Wyvern.AddTypeMethod("string", "reverse", [], Wyvern.TypeSymbols.String, @Wyvern.Methods.Reverse)

Wyvern.AddTypeProperty("string", "len", true, Wyvern.TypeSymbols.Number, @Wyvern.Methods.Len)
Wyvern.AddTypeProperty("string", "indexes", true, Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Number), @Wyvern.Methods.Indexes)
Wyvern.AddTypeProperty("string", "values", true, Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Methods.Values)
Wyvern.AddTypeProperty("string", "val", true, Wyvern.TypeSymbols.Number, @Wyvern.Methods.Val)
Wyvern.AddTypeProperty("string", "code", true, Wyvern.TypeSymbols.Number, @Wyvern.Methods.Code)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Wyvern.Callbacks = {}
Wyvern.Callbacks.Print_Callback = function(args)
    print(args[0], args[1])
end function

Wyvern.Callbacks.UserInput_Callback = function(args)
    return user_input(args[0], args[1], args[2])
end function

Wyvern.Callbacks.ClearScreen_Callback = function(args)
    clear_screen()
end function

Wyvern.Callbacks.GetShell_Callback = function(args)
    return get_shell(args[0], args[1])
end function

Wyvern.Callbacks.ActiveUser = function(args)
    return active_user()
end function

Wyvern.Callbacks.Bitwise = function(args)
    return bitwise(args[0], args[1], args[2])
end function

Wyvern.Callbacks.CommandInfo = function(args)
    return command_info(args[0])
end function

Wyvern.Callbacks.Exit = function(args)
    return exit(args[0])
end function

Wyvern.Callbacks.FormatColumns = function(args)
    return format_columns(args[0])
end function

Wyvern.Callbacks.GetCustomObject = function(args)
    return get_custom_object()
end function

Wyvern.Callbacks.GetRouter = function(args)
    return get_router(args[0])
end function

Wyvern.Callbacks.GetSwitch = function(args)
    return get_switch(args[0])
end function

Wyvern.Callbacks.HomeDir = function(args)
    return home_dir()
end function

Wyvern.Callbacks.IncludeLib = function(args)
    return include_lib(args[0])
end function

Wyvern.Callbacks.IsLanIp = function(args)
    return is_lan_ip(args[0])
end function

Wyvern.Callbacks.IsValidIp = function(args)
    return is_valid_ip(args[0])
end function

Wyvern.Callbacks.LaunchPath = function(args)
    return launch_path()
end function

Wyvern.Callbacks.MailLogin = function(args)
    return mail_login(args[0], args[1])
end function

Wyvern.Callbacks.NsLookUp = function(args)
    return nslookup(args[0])
end function

Wyvern.Callbacks.ParentPath = function(args)
    return parent_path(args[0])
end function

Wyvern.Callbacks.ProgramPath = function(args)
    return program_path()
end function

Wyvern.Callbacks.TypeOf = function(args)
    return typeof(args[0])
end function

Wyvern.Callbacks.UserBankNumber = function(args)
    return user_bank_number()
end function

Wyvern.Callbacks.UserMailAddress = function(args)
    return user_mail_address()
end function

Wyvern.Callbacks.Wait = function(args)
    return wait(args[0])
end function

Wyvern.Callbacks.WhoIs = function(args)
    return whois(args[0])
end function

Wyvern.Callbacks.Slice = function(args)
    return slice(args[0], args[1], args[2])
end function

Wyvern.Callbacks.Yield = function(args)
    yield()
end function

Wyvern.Callbacks.Str = function(args)
    return str(args[0])
end function

// Number builtins
Wyvern.Callbacks.Abs = function(args)
    return abs(args[0])
end function

Wyvern.Callbacks.Acos = function(args)
    return acos(args[0])
end function

Wyvern.Callbacks.Asin = function(args)
    return asin(args[0])
end function

Wyvern.Callbacks.Atan = function(args)
    return atan(args[0], args[1])
end function

Wyvern.Callbacks.Ceil = function(args)
    return ceil(args[0])
end function

Wyvern.Callbacks.Char = function(args)
    return char(args[0])
end function

Wyvern.Callbacks.Cos = function(args)
    return cos(args[0])
end function

Wyvern.Callbacks.Floor = function(args)
    return floor(args[0])
end function

Wyvern.Callbacks.Log = function(args)
    return log(args[0], args[1])
end function

Wyvern.Callbacks.Range = function(args)
    return range(args[0], args[1], args[2])
end function

Wyvern.Callbacks.Round = function(args)
    return round(args[0], args[1])
end function

Wyvern.Callbacks.Rnd = function(args)
    return rnd(args[0])
end function

Wyvern.Callbacks.Sign = function(args)
    return sign(args[0])
end function

Wyvern.Callbacks.Sin = function(args)
    return sin(args[0])
end function

Wyvern.Callbacks.Sqrt = function(args)
    return sqrt(args[0])
end function

Wyvern.Callbacks.Tan = function(args)
    return tan(args[0])
end function

Wyvern.Callbacks.Md5 = function(args)
    return md5(args[0])
end function

Wyvern.CreateBuiltinMethod("print", [Wyvern.CreateParameter("text", Wyvern.TypeSymbols.Any), Wyvern.CreateParameter("clear", Wyvern.TypeSymbols.Bool, "false")], Wyvern.TypeSymbols.Void, @Wyvern.Callbacks.Print_Callback)
Wyvern.CreateBuiltinMethod("user_input", [Wyvern.CreateParameter("text", Wyvern.TypeSymbols.String, """"""), Wyvern.CreateParameter("passwordMode", Wyvern.TypeSymbols.Bool, "false"), Wyvern.CreateParameter("anyKey", Wyvern.TypeSymbols.Bool, "false")], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.UserInput_Callback)
Wyvern.CreateBuiltinMethod("clear_screen", [], Wyvern.TypeSymbols.Void, @Wyvern.Callbacks.ClearScreen_Callback)
Wyvern.CreateBuiltinMethod("get_shell", [Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String, """"), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String, """")], Wyvern.TypeSymbols.Shell, @Wyvern.Callbacks.GetShell_Callback)
Wyvern.CreateBuiltinMethod("active_user", [], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.ActiveUser)
Wyvern.CreateBuiltinMethod("bitwise", [Wyvern.CreateParameter("operator", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("num1", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("num2", Wyvern.TypeSymbols.Number, "-1")], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Bitwise)
Wyvern.CreateBuiltinMethod("command_info", [Wyvern.CreateParameter("key_command", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.CommandInfo)
Wyvern.CreateBuiltinMethod("exit", [Wyvern.CreateParameter("message", Wyvern.TypeSymbols.Any, """""")], Wyvern.TypeSymbols.Void, @Wyvern.Callbacks.Exit)
Wyvern.CreateBuiltinMethod("format_columns", [Wyvern.CreateParameter("text", Wyvern.TypeSymbols.String), Wyvern.TypeSymbols.String, @Wyvern.Callbacks.FormatColumns])
Wyvern.CreateBuiltinMethod("get_custom_object", [], Wyvern.MapSymbol.New(Wyvern.TypeSymbols.Any, Wyvern.TypeSymbols.Any), @Wyvern.Callbacks.GetCustomObject)
Wyvern.CreateBuiltinMethod("get_router", [Wyvern.CreateParameter("ip_address", Wyvern.TypeSymbols.String, """""")], Wyvern.TypeSymbols.Router, @Wyvern.Callbacks.GetRouter)
Wyvern.CreateBuiltinMethod("get_switch", [Wyvern.CreateParameter("ip_address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Router, @Wyvern.Callbacks.GetSwitch)
Wyvern.CreateBuiltinMethod("home_dir", [], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.HomeDir)
Wyvern.CreateBuiltinMethod("include_lib", [Wyvern.CreateParameter("lib_path", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Library, @Wyvern.Callbacks.IncludeLib)
Wyvern.CreateBuiltinMethod("is_lan_ip", [Wyvern.CreateParameter("ip_address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Callbacks.IsLanIp)
Wyvern.CreateBuiltinMethod("is_valid_ip", [Wyvern.CreateParameter("ip_address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.Bool, @Wyvern.Callbacks.IsValidIp)
Wyvern.CreateBuiltinMethod("launch_path", [], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.LaunchPath)
Wyvern.CreateBuiltinMethod("mail_login", [Wyvern.CreateParameter("user", Wyvern.TypeSymbols.String), Wyvern.CreateParameter("password", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.MetaMail, @Wyvern.Callbacks.MailLogin)
Wyvern.CreateBuiltinMethod("nslookup", [Wyvern.CreateParameter("web_address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.NsLookUp)
Wyvern.CreateBuiltinMethod("parent_path", [Wyvern.CreateParameter("path", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.ParentPath)
Wyvern.CreateBuiltinMethod("program_path", [], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.ProgramPath)
Wyvern.CreateBuiltinMethod("typeof", [Wyvern.CreateParameter("object", Wyvern.TypeSymbols.Any)], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.TypeOf)
Wyvern.CreateBuiltinMethod("user_bank_number", [], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.UserBankNumber)
Wyvern.CreateBuiltinMethod("user_mail_address", [], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.UserMailAddress)
Wyvern.CreateBuiltinMethod("wait", [Wyvern.CreateParameter("seconds", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Void, @Wyvern.Callbacks.Wait)
Wyvern.CreateBuiltinMethod("whois", [Wyvern.CreateParameter("ip_address", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.WhoIs)
Wyvern.CreateBuiltinMethod("slice", [Wyvern.CreateParameter("str_or_list", Wyvern.TypeSymbols.Any), Wyvern.CreateParameter("start", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("end", Wyvern.TypeSymbols.Number, "null")], Wyvern.TypeSymbols.Any, @Wyvern.Callbacks.Slice)
Wyvern.CreateBuiltinMethod("yield", [], Wyvern.TypeSymbols.Void, @Wyvern.Callbacks.Yield)
Wyvern.CreateBuiltinMethod("str", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Any)], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.Str)

// Number builtins
Wyvern.CreateBuiltinMethod("abs" , [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Abs)
Wyvern.CreateBuiltinMethod("acos", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Acos)
Wyvern.CreateBuiltinMethod("asin", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Asin)
Wyvern.CreateBuiltinMethod("atan", [Wyvern.CreateParameter("y", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number, "1")], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Atan)
Wyvern.CreateBuiltinMethod("ceil", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Ceil)
Wyvern.CreateBuiltinMethod("char", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.Char)
Wyvern.CreateBuiltinMethod("sin", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Sin)
Wyvern.CreateBuiltinMethod("cos", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Cos)
Wyvern.CreateBuiltinMethod("floor", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Floor)
Wyvern.CreateBuiltinMethod("log", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("base", Wyvern.TypeSymbols.Number, "10")], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Log)
Wyvern.CreateBuiltinMethod("range", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("y", Wyvern.TypeSymbols.Number, "0"), Wyvern.CreateParameter("step", Wyvern.TypeSymbols.Number, "null")], Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.Number), @Wyvern.Callbacks.Range)
Wyvern.CreateBuiltinMethod("round", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number), Wyvern.CreateParameter("d", Wyvern.TypeSymbols.Number, "0")], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Round)
Wyvern.CreateBuiltinMethod("rnd", [Wyvern.CreateParameter("seed", Wyvern.TypeSymbols.Number, "null")], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Rnd)
Wyvern.CreateBuiltinMethod("sign", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Sign)
Wyvern.CreateBuiltinMethod("sqrt", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Sqrt)
Wyvern.CreateBuiltinMethod("tan", [Wyvern.CreateParameter("x", Wyvern.TypeSymbols.Number)], Wyvern.TypeSymbols.Number, @Wyvern.Callbacks.Tan)

// Misc builtins
Wyvern.CreateBuiltinMethod("md5", [Wyvern.CreateParameter("value", Wyvern.TypeSymbols.String)], Wyvern.TypeSymbols.String, @Wyvern.Callbacks.Md5)

Wyvern.Variablebacks = {}

Wyvern.Variablebacks.Params = function()
    return params
end function

Wyvern.Variablebacks.CurrentDate = function()
    return current_date()
end function

Wyvern.Variablebacks.CurrentPath = function()
    return current_path()
end function

Wyvern.Variablebacks.Globals = function()
    return globals
end function

Wyvern.Variablebacks.Outer = function()
    return outer
end function

Wyvern.Variablebacks.Locals = function()
    return locals
end function

Wyvern.Variablebacks.Time = function()
    return time()
end function

Wyvern.Variablebacks.Pi = function()
    return pi
end function

Wyvern.CreateBuiltinVariable("params", true, Wyvern.ArraySymbol.New(Wyvern.TypeSymbols.String), @Wyvern.Variablebacks.Params)
Wyvern.CreateBuiltinVariable("globals", true, Wyvern.MapSymbol.New(Wyvern.TypeSymbols.Any, Wyvern.TypeSymbols.Any), @Wyvern.Variablebacks.Globals)
Wyvern.CreateBuiltinVariable("outer", true, Wyvern.MapSymbol.New(Wyvern.TypeSymbols.Any, Wyvern.TypeSymbols.Any), @Wyvern.Variablebacks.Outer)
Wyvern.CreateBuiltinVariable("locals", true, Wyvern.MapSymbol.New(Wyvern.TypeSymbols.Any, Wyvern.TypeSymbols.Any), @Wyvern.Variablebacks.Locals)
Wyvern.CreateBuiltinVariable("time", true, Wyvern.TypeSymbols.Number, @Wyvern.Variablebacks.Time)
Wyvern.CreateBuiltinVariable("current_date", true, Wyvern.TypeSymbols.String, @Wyvern.Variablebacks.CurrentDate)
Wyvern.CreateBuiltinVariable("current_path", true, Wyvern.TypeSymbols.String, @Wyvern.Variablebacks.CurrentPath)
Wyvern.CreateBuiltinVariable("pi", true, Wyvern.TypeSymbols.Number, @Wyvern.Variablebacks.Pi)