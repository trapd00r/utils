#!/usr/bin/lua

-- xstat v0.01
-- reports total amount of sent/recieved traffic in megabytes.

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

local sent, recieved = get_stats();

printf("%8s: %d MB\n%s: %d MB\n\n",
  "Sent",     sent,
  "Recieved", recieved
);
