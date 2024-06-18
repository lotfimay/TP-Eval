# Créer un objet simulateur
set ns [new Simulator]

# Informer le simulateur d'utiliser le routage dynamique
$ns rtproto DV

# Ouvrir le fichier de trace NAM
set nf [open grid9.nam w]
$ns namtrace-all $nf

# Définir une procédure 'finish'
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam grid9.nam &
    exit 0
}

# Créer neuf nœuds (3x3 grille)
set i 0
while {$i < 9} {
    set n($i) [$ns node]
    incr i
}

# Créer des liens pour former une grille
# Liaisons horizontales
$ns duplex-link $n(0) $n(1) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 1Mb 10ms DropTail
$ns duplex-link $n(3) $n(4) 1Mb 10ms DropTail
$ns duplex-link $n(4) $n(5) 1Mb 10ms DropTail
$ns duplex-link $n(6) $n(7) 1Mb 10ms DropTail
$ns duplex-link $n(7) $n(8) 1Mb 10ms DropTail

# Liaisons verticales
$ns duplex-link $n(0) $n(3) 1Mb 10ms DropTail
$ns duplex-link $n(3) $n(6) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(4) 1Mb 10ms DropTail
$ns duplex-link $n(4) $n(7) 1Mb 10ms DropTail
$ns duplex-link $n(2) $n(5) 1Mb 10ms DropTail
$ns duplex-link $n(5) $n(8) 1Mb 10ms DropTail

# Configurer une connexion UDP et un flux CBR entre n(3) et n(8)
set udp [new Agent/UDP]
$ns attach-agent $n(3) $udp
set null [new Agent/Null]
$ns attach-agent $n(8) $null
$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packet_size_ 1000
$cbr set rate_ 1Mb
$cbr set random_ false

# Planifier le démarrage et l'arrêt du flux CBR
$ns at 0.1 "$cbr start"
$ns at 21.0 "$cbr stop"

# Planifier la défaillance des liens
set time 2.0
set links [list [list $n(5) $n(8)] [list $n(3) $n(6)] [list $n(6) $n(7)] [list $n(3) $n(4)] [list $n(1) $n(4)]]
foreach link $links {
    set src [lindex $link 0]
    set dst [lindex $link 1]
    $ns rtmodel-at $time down $src $dst
    set time [expr $time + 2.0]
}

# Planification de la fin de la simulation
$ns at 22.0 "finish"

# Lancer la simulation
$ns run
