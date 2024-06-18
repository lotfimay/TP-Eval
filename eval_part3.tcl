#
# This is a simple demonstration of how to send data in UDP datagrams
#
set ns [new Simulator]
$ns color 0 blue
$ns color 1 red
# open trace files
set f [open out.tr w]
$ns trace-all $f
set nf [open out.nam w]
$ns namtrace-all $nf
# create topology. three nodes in line: (0)--(2)--(1)
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
$ns duplex-link $n0 $n2 2Mb 5ms DropTail
$ns duplex-link $n2 $n1 1.5Mb 10ms DropTail
$ns duplex-link-op $n0 $n2 orient right
$ns duplex-link-op $n2 $n1 orient right
# create UDP agents
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
$ns connect $udp0 $udp1
# The "process_data" instance procedure is what will process received data
# if no application is attached to the agent.
# In this case, we respond to messages of the form "ping(###)".
# We also print received messages to the trace file.
Agent/UDP instproc process_data {size data} {
global ns
$self instvar node_
# note in the trace file that the packet was received
$ns trace-annotate "[$node_ node-addr] received {$data}"

# if the message was of the form "ping(###)" then send a response of
# the form "pong(###)"
if {[regexp {ping *\(([0-9]+)\)} $data entirematch number]} {
$self send 100 "pong($number)"
} elseif {[regexp {countdown *\(([0-9]+)\)} $data entirematch number]
&& $number > 0 } {
incr number -1
$self send 100 "countdown($number)"
}
}
# Setting the class allows us to color the packets in nam.
$udp0 set class_ 0
$udp1 set class_ 1
$ns at 0.1 "$udp0 send 724 ping(42)"
$ns at 0.2 "$udp1 send 100 countdown(5)"
$ns at 0.3 "$udp0 send 500 {ignore this message please}"
$ns at 0.4 "$udp1 send 828 {ping (12345678)}"
$ns at 1.0 "finish"
proc finish {} {
global ns f nf
$ns flush-trace
close $f
close $nf
puts "running nam..."
exec nam out.nam &
exit 0
}
$ns run

