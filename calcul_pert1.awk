BEGIN {
    lossBlue = 0;
    lossRed = 0;
    sentBlue = 0;
    sentRed = 0;
}

{
   
    if ($9 == 0.0 && $10 == 4.0) {
        sentBlue++;
    } else if ($9 == 1.0 && $10 == 5.0) {
        sentRed++;
    }

    if ($1 == "d") {
        if ($9 == 0.0 && $10 == 4.0) {
            lossBlue++;
        } else if ($9 == 1.0 && $10 == 5.0) {
            lossRed++;
        }
    }
}

END {
    
    print "Flux Bleu (CBR) : ";
    print "Paquets envoyés :" sentBlue " Paquets perdu :" lossBlue;
    print "-----------------------------------------------"

    print "Flux Rouge (CBR) : ";
    print "Paquets envoyés :" sentRed " Paquets perdu :" lossBlue;
    print "-----------------------------------------------"
   
    taux_perteBleu = (lossBlue / sentBlue) * 100 ;
    taux_perteRouge = (lossRed / sentRed) * 100 ;

    print "Taux de perte pour le flux Bleu (CBR) : " taux_perteBleu "%";
    print "Taux de perte pour le flux Rouge (CBR) : " taux_perteRouge "%";

   
    if (lossBlue > lossRed) {
        print "Le flux Bleu (CBR) a perdu le plus de paquets.";
    } else if (lossBlue < lossRed) {
        print "Le flux Rouge (CBR) a perdu le plus de paquets.";
    } else {
        print "Les deux flux ont perdu le même nombre de paquets.";
    }
}