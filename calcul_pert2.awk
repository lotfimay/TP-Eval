BEGIN {
   lossCbr = 0;
   lossFtp = 0;
   sentCbr = 0;
   sentFtp = 0;
}

{
   event = $1;
   time = $2;
   fromNode = $3;
   bNode = $4 ;
   typepaquet = $5;
}

{

   if(typepaquet == "cbr")
    {
        sentCbr++;
        if(event == "d" && event == "e")
          {
                lossCbr++;
        }
   }

   if(typepaquet == "tcp")
    {
          sentFtp++;

        if(event == "d" && event == "e")
          {
                lossFtp++;
          }
   }

}


END {
          printf("paquets CBR envoyés : %d\n", sentCbr);
          printf("paquets CBR perdu : %d\n", lossCbr);
          printf("paquets FTP envoyés: %d\n", sentFtp);
          printf("paquets FTP perdu :  %d\n", lossFtp);
}