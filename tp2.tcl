# Création d'une instance de simulateur
set ns [new Simulator]

# Définition des fichiers de trace
set tracefile [open out.tr w]
$ns trace-all $tracefile

# Création des nœuds
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Création des liens full-duplex
$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 50ms DropTail

# Réglage de la taille du buffer pour le lien n2-n3
$ns queue-limit $n2 $n3 10

# Configuration des agents TCP et des sinks
set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp1
$ns attach-agent $n3 $sink1
$ns connect $tcp1 $sink1

set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp2
$ns attach-agent $n4 $sink2
$ns connect $tcp2 $sink2

# Configuration des applications FTP
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 0.0 "$ftp1 start"
$ns at 5.0 "$ftp1 stop"

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 0.0 "$ftp2 start"
$ns at 10.0 "$ftp2 stop"

# Démarrage de la simulation
$ns at 10.5 "finish"
proc finish {} {
    global ns tracefile
    $ns flush-trace
    close $tracefile
    exit 0
}

$ns run
