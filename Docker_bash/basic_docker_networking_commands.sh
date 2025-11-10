#!/bin/bash
# Ditt script demonstreert de basis Docker netwerkcommando's. Het maakt een tijdelijk netwerk en
# een testcontainer aan, koppelt/ontkoppelt deze, en verwijdert
# alles daarna weer netjes.


set -e  #stop script bij foutenn

echo "➡️  1) Lijst van bestaande netwerken weergeven"
sudo docker network ls
echo

echo "➡️  2) Maak een nieuw user-defined bridge netwerk genaamd 'test'"
sudo docker network create --driver bridge test
echo

echo "➡️  3) Start een simpele tijdelijke container"
# De container wordt automatisch verwijderd als hij stopt (--rm)
# 'alpine' is een kleine Linux image; hij draait 'sleep 60' zodat hij even actief blijft
sudo docker run -dit --name demo_container --rm alpine sleep 60
echo

echo "➡️  4) Verbind de draaiende container met het 'test' netwerk"
sudo docker network connect test demo_container
echo

echo "➡️  5) Verbind de container opnieuw, met een specifiek IP-adres binnen het test-netwerk"
# Hier geven we een voorbeeld IP mee, binnen Docker’s test-subnet (172.28.0.0/16)
sudo docker network connect --ip 172.28.0.10 test demo_container || true
echo

echo "➡️  6) Verbind de container met extra aliassen (db, mysql)"
sudo docker network connect --alias db --alias mysql test demo_container || true
echo

echo "➡️  7) Ontkoppel de container van het netwerk"
sudo docker network disconnect test demo_container
echo

echo "➡️  8) Verwijder het test-netwerk"
sudo docker network rm test
echo

echo "➡️  9) Verwijder alle ongebruikte netwerken (optioneel)"
sudo docker network prune -f
echo

echo "  we zijn klaar bro."
