#!/usr/bin/expect #Where the script should be run from.
#If it all goes pear shaped the script will timeout after 20 seconds.
set timeout 20
#First argument is assigned to the variable ip
set ip [lindex $argv 0]
#Second argument is assigned to the variable port
set port [lindex $argv 1]
#Third argument is assigned to the variable filename
set remotefilename [lindex $argv 2]
set filename [lindex $argv 3]
#prep file content
set fp [open "$filename" r]
set file_data [read -nonewline $fp]
close $fp
#  Process data file
set data [split $file_data "\n"]
#This spawns the telnet program and connects it to the variable ip
spawn telnet $ip $port
#The script expects login
#expect "Connected to $ip."
expect "Escape character is '^]'."
sleep 1
send "if true == file.open(\"$remotefilename\", \"w+\") then \r"
expect ">>"
send "print(\"ok\")\r"
expect ">>"
send "end\r"
expect "ok"
foreach line $data {
          # do some line processing here
          expect ">"
          #replace all ' with \'
          regsub -all {\\r} $line {\\\\r} line
          regsub -all {\\n} $line {\\\\n} line
          regsub -all {'} $line {\\'} line
          puts "writing $line"
          send "if true == file.writeline('$line') then \r"
		  expect ">>"
		  send "print(\"ok\")\r"
		  expect ">>"
		  send "end\r"
		  expect "ok"
}
expect ">"
send "file.flush()\r"
expect ">"
send "file.close()\r"
expect ">"
send "print(\"done\")\r"
expect "done"
sleep 1
close
#This hands control of the keyboard over two you (Nice expect feature!)
#interact 
