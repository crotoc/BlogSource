' 将运行ubuntu服务器上的terminator.sh作为一个参数存放在args里面
args = "-c" & " -l " & """bash ~/SHscript/terminator.sh"""
' 然后用wscript调用bash运行上面的参数
WScript.CreateObject("Shell.Application").ShellExecute "bash", args, "", "open", 0