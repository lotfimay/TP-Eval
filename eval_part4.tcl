set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red

#Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf
set f [open out.tr w]
$ns trace-all $f

#Define a 'finish' procedure
proc finish {} {
  global ns nf
  $ns flush-trace
  #Close the NAM trace file
  close $nf
  #Execute NAM on the trace file
  exec nam out.nam &
  exit 0
}

#Create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#Create links between the nodes
$ns duplex-link $n0 $n2 1Mb 50ms DropTail
$ns duplex-link $n1 $n2 1Mb 50ms DropTail
$ns duplex-link $n2 $n3 1Mb 50ms DropTail
$ns duplex-link $n3 $n4 1Mb 50ms DropTail
$ns duplex-link $n3 $n5 1Mb 50ms DropTail

#Give node position (for NAM)
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down

#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

set null4 [new Agent/Null]
$ns attach-agent $n4 $null4
$ns connect $udp0 $null4
$udp0 set fid_ 1

set sink5 [new Agent/TCPSink]
$ns attach-agent $n5 $sink5
$ns connect $tcp1 $sink5
$tcp1 set fid_ 2

#Setup a CBR over UDP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set type_ CBR
$cbr0 set packet_size_ 1000
$cbr0 set rate_ 2.0mb

#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

#Schedule events for the CBR and FTP agents
$ns at 0 "$cbr0 start"
$ns at 0 "$ftp1 start"
$ns at 1 "$cbr0 stop"
$ns at 1 "$ftp1 stop"

#Call the finish procedure after 5 seconds of simulation time
$ns at 1.0 "finish"

#Run the simulation
$ns run