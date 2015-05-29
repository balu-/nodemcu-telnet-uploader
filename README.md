# nodemcu-telnet-uploader
fast &amp; easy way to upload files via telnet to esp8266 running nodemcu.

I was tired pluging the mcu onto the serial port all the time to upload an updated init.lua script or things like that.

So i wrote a little upload script myself.

**Be warned there might be escaping issues after upload, i'm not sure if fixed them all**

### Usage
```bash
./uload.sh <NodeMCU-IP> <Telnet-Port> <Dst-Filename> <Source-File>
```
**Example**
```bash
./uload.sh 192.168.2.3 2323 init.lua ../scripts/Wifi-Init.lua
```

### Run Telnetserver on NodeMCU
Code from [here](https://github.com/nodemcu/nodemcu-firmware#with-below-code-you-can-telnet-to-your-esp8266-now)
```lua
    -- a simple telnet server
    s=net.createServer(net.TCP,180)
    s:listen(2323,function(c)
       function s_output(str)
          if(c~=nil)
             then c:send(str)
          end
       end
       node.output(s_output, 0)   -- re-direct output to function s_ouput.
       c:on("receive",function(c,l)
          node.input(l)           -- works like pcall(loadstring(l)) but support multiple separate line
       end)
       c:on("disconnection",function(c)
          node.output(nil)        -- un-regist the redirect output function, output goes to serial
       end)
       print("Welcome to NodeMcu world.")
    end)
```
