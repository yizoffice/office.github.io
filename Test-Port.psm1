<#
.synopsis
Test-Port 主要为解决服务器维护人员批量测试各种主机端口状态，支持主机名称及ip地址
.parameter ComputerName
如名所示，为主机名称或主机ip地址，此参数类型可以为字符串，也可以为数组。
.parameter Port
需要查询的主机端口，此参数类型可以为字符串，也可以为数组。
.parameter timeout
超时时间，默认为1000毫秒
.example
test-port baidu.com 80
此命令测试baidu.com的80端口
返回：baidu.com 端口80 正常连接
.example
test-port baidu.com,sina.com 80,25
此命令测试baidu.com,sina.com的80及25端口
返回：
baidu.com 端口80 正常连接
警告: baidu.com 端口25 失败
sina.com 端口80 正常连接
警告: sina.com 端口25 失败
.example
$ip=get-content "d:\ip.txt"
$port=get-content "d:\port.txt"
test-port -com $ip -p $port
建议使用此命令格式，我们可以把主机ip或名称和端口分别写到ip.txt和port.txt,然后使用get-content 读取文本内容，在分别传递到参数
如主机名称不经常变动，我们可以把读取的内容放到个人目录，每次启动powershell自动读取主机名称和端口。



#>
[CmdletBinding]
function Test-Port{
    Param([string[]]$ComputerName,[string[]]$Port,$timeout = 1000)
    for($i=0;$i -lt $ComputerName.count;$i++){
    $com=$ComputerName[$i]
    for($j=0;$j -lt $Port.count;$j++){
    $duankou=$Port[$j]
       $tcpclient = New-Object -TypeName system.Net.Sockets.TcpClient
       $iar = $tcpclient.BeginConnect($com,$duankou,$null,$null)
      $wait = $iar.AsyncWaitHandle.WaitOne($timeout,$false)
      
      if(!$wait)
      {
          $tcpclient.Close()
         Write-Warning "$com 端口$duankou 失败"
      }
     else
      {
            # Close the connection and report the error if there is one

           $null = $tcpclient.EndConnect($iar)
           $tcpclient.Close()
          Write-host "$com 端口$duankou 正常连接"
       }

    }
   
}
}
