#!/usr/bin/lua

-- xstat v0.02
-- reports total amount of sent/recieved traffic in megabytes.

local app     = "xstat";
local version = 0.02;

function printf(s,...)
  return io.write(s:format(...))
end

function mb(bytes)
  return (bytes / 1024) / 1024;
end

function get_stats()
  local tx_file = "/sys/class/net/eth0/statistics/tx_bytes";
  local rx_file = "/sys/class/net/eth0/statistics/rx_bytes";

  io.input(tx_file);
  local tx_mb = mb( io.read("*line") );
  io.input(rx_file);
  local rx_mb = mb( io.read("*line") );

  return tx_mb, rx_mb;
end


function to_tty(s, r) 
  printf("%8s: %4d MB\n%s: %4d MB\n",
    "Sent",     s,
    "Recieved", r
  );
end

function to_dzen(s, r)
  io.write("^fg(#ff0000)Sent^fg(): ", s,
    "^fg(#ffff00)Recieved^fg(): ", r
    );
end

function usage(app, ver)
  printf("%s v%.2f\n\nUsage: %s [-t -d -h]\n", app, ver, app);
end


if(argv == 0) then
  usage(app, version);
end

local sent, recieved = get_stats();

if(arg[1] == '-d') then
  to_dzen(sent, recieved);
elseif(arg[1] == '-t') then
  to_tty(sent, recieved);
elseif(arg[1] == '-h') then
  usage(app, version);
else
  to_tty(sent, recieved);
end
