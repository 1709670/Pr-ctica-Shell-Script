#!/bin/bash

#Es declaren les variables codi_estat i codi_pais, s'inicialitzen a "XX".
codi_estat="XX"
codi_pais="XX"


#Comanda lp

#Extreu les columnes 7 i 8 (country_code i country_name) de dintre de l'arxiu, les ordena alfabèticament, treu les linies que es repeteixen, les posa com a columnes de taula rectes i en treu la coma i hi afegeix espai entre les dues.

listar_paises() {
	cut -d',' -f7,8 cities.csv | sort | uniq | column -t -s ','
}

#Comanda sc

seleccionar_pais() {
		#Es demana el nom del pais.
                read -p "Introdueix el nom del pais: " pais
		#Si la variable "pais" no s'ha deixat buida, es busquen les linies que contenen el pais a l'arxi. S'extreuen les repeticions, de manera que només surt un codi.. La sortida és el codi del pais. Si la variable "pais" deixat buida, no es fa res, de manera que es mantindrà el valor de codi_pais anterior. Si el pais no existeix (no es troba a l'arxiu el seu codi), el codi_pais valdrà "XX".
		if [ -n "$pais" ]; then
			codi_pais=$(grep -w "$pais" cities.csv | awk -F ',' 'NR==1 {print $7; exit}'u)
                	if [ -z "$codi_pais" ]; then
                        	codi_pais="XX"
                	fi

                fi
		 #S'imprimeix el codi del pais.
                echo "Codi del país seleccionat: $codi_pais"

        }
	


# Comanda se
 
seleccionar_estat() {
  #Si no s'ha escollit abans un pais (la variable de codi_pais es manté a XX) escriu el missatge i surt.
  if [ "$codi_pais" == "XX" ]; then
    echo "Has de seleccionar un país primer."
  fi
    #Es demana que s'introdueixi un estat i es guarda aquest com a variable.
    read -p "Introdueix el nom de l'estat: " estat
    #Si la variable "estat" no s'ha deixat buida, es busquen les liniea que contenen l'estat a l'arxiu, es busca si els valors de la columna 7 (la del codi dels països) coincideixen amb la variable country, que és igual a la codi_pais. Si coincidiexien, l'estat es troba dintre del pais seleccionat i awk imprimeix la columna 4 (el codi de l'estat). S'extreuen les repeticions de codi. La sortida és el codi de l'estat. Si la variable "estat" deixat buida, no es fa res, de manera que es mantindrà el valor de codi_estat anterior. 
    if [ -n "$estat" ]; then
      	codi_estat=$(grep -i "$estat" cities.csv | awk -F',' -v country="$codi_pais" '$7 == country {print $4}' | uniq)
	#Si no es troba un codi_estat (perquè l'estat no pertany al pais seleccionat o no existeix), aquest valdrà "XX".
      	if [ -z "$codi_estat" ]; then
        	codi_estat="XX"
      	fi
    fi
    #S'imprimeix per pantalla el codi de l'estat seleccionat.
    echo "Codi de l'estat seleccionat: $codi_estat"
 
}



#Comanda le

llistar_estats() {
		#Si el codi_pais té valor "XX", significa que no s'ha escollit un pais i l'ordre no s'executarà. S'imprimeix el missatge.
		if [ "$codi_pais" = "XX" ]; then
			echo "Has de seleccionar un pais primer."
		#Si el codi_pais té un valor diferent de "XX", s'ha seleccionnat anteriorment un pais. Es seleccionen les columnes state_code, stat_name i country_name (4, 5 i 8) de l'arxiu. Es treuen les repeticions, es busca quines linies contenen la variable "pais" i n'extreiem només les columnes de state_name i state_code que surten en format de columna sense coma. 
		else
 			cut -d, -f4,5,8 cities.csv | uniq | grep -e "$pais" | cut -d, -f1,2 | column -t -s ',' 
		fi	}

#Comanda lcp

llistar_poblacions() {
		  #Si el codi_pais té valor "XX", significa que no s'ha escollit un pais i l'ordre no s'executarà. S'imprimeix el missatge.
		  if [ "$codi_pais" == "XX" ]; then
			  echo "Has de seleccionar primer un pais."
		  #Si el codi_estat té un valor diferent de "XX", s'ha seleccionnat anteriorment un estat. Es seleccionen les columnes name, country_name i wikiDataId (2, 8 i 11) de l'arxiu. Es treuen les repeticions, es busca quines linies contenen la variable "pais" i n'extreiem només les columnes de name i wikiDataId que surten en format de columna sense coma. S'imprimeix per pantalla.
		  else
		  	cut -d, -f2,8,11 cities.csv | uniq | grep -e "$pais" | cut -d, -f1,3 | column -t -s ','
		  fi 
		}

#Comanda ecp
extreure_poblacions() {
	#Si el codi_pais té valor "XX", significa que no s'ha escollit un pais i l'ordre no s'executarà. S'imprimeix el missatge.
	if [ "$codi_pais" == "XX" ]; then
		echo "Has de seleccionar primer un pais."
	#Si el codi_pais té un valor diferent de "XX", s'ha seleccionat anteriorment un pais. Es seleccionen les columnes name, country_name i wikiDataId (2, 8 i 11) de l'arxiu. Es treuen les repeticions, es busca quines linies contenen la variable "pais" i n'extreiem només les columnes de name i wikiDataId que surten en format de columna sense coma. La sortida es guarda en un arxiu anomenat "$codi_pais".csv.
	else
		  cut -d, -f2,8,11 cities.csv | uniq | grep -e "$pais" | cut -d, -f1,3 | column -t -s ',' > "$codi_pais".csv
	fi

	  }

#Comanda lce
llistar_poblacions_estat() {
	#Si el codi_estat té valor "XX", significa que no s'ha escollit un estat i l'ordre no s'executarà. S'imprimeix el missatge.
	if [ "$codi_estat" == "XX" ]; then
		echo "Has de seleccionar primer un estat."
	#Si el codi_estat té un valor diferent de "XX", s'ha seleccionat anteriorment un estat. Es seleccionen les columnes name, state_name i wikiDataId (2, 5 i 11) de l'arxiu. Es treuen les repeticions, es busca quines linies contenen la variable "estat" i n'extreiem només les columnes de name i wikiDataId que surten en format de columna sense coma. S'imprimeix la sortida en pantalla.
	else
		cut -d, -f2,11,5 cities.csv | uniq | grep -e "$estat" | cut -d, -f1,3 | column -t -s ','
	fi
	}


#Comanda ece

extreure_poblacions_estat() {
	#Si el codi_estat té valor "XX", significa que no s'ha escollit un estat i l'ordre no s'executarà. S'imprimeix el missatge.
	if [ "$codi_estat" == "XX" ]; then
                echo "Has de seleccionar primer un estat."
	 #Si el codi_estat té un valor diferent de "XX", s'ha seleccionat anteriorment un estat. Es seleccionen les columnes name, state_name i wikiDataId (2, 5 i 11) de l'arxiu. Es treuen les repeticions, es busca quines linies contenen la variable "estat" i n'extreiem només les columnes de name i wikiDataId que surten en format de columna sense coma. Es guarda la sortida en un arxiu anomenat "$codi_pais"_"$codi_estat".csv.
        else
                cut -d, -f2,11,5 cities.csv | uniq | grep -e "$estat" | cut -d, -f1,3 | sed 's/,/  /g' > ""$codi_pais"_"$codi_estat"".csv
	fi
	}

#Comanda gwd
gwd() {
   #Demana el nom d'una població. Filtra buscant les files que continguin la variable de la població, estat i pais seleccionats. Imprimeix la fila 11 dela linea que conté els 3 i la sortida es el wikidataId.
   echo -n "Introdueix el nom de la població: "
   read poblacio
   wikidataId=$(grep -i "$poblacio" cities.csv | grep -i "$estat" | grep -i "$pais" | cut -d ',' -f 11)

  if [ -n "$wikidataId" ]; then
    # Realitza la solicitud a WikiData y desa la resposta en un arxiu anomenar "$wikidataId.json".
    wget -O "$wikidataId.json" "https://www.wikidata.org/wiki/Special:EntityData/$wikidataId.json"
    echo "Informació guardada com a $wikidataId.json"
  # Si no es troba cap fila amb les 3 coincidencies o la població no té un wikiData, imprimeix el missatge.
  else
    echo "No s'ha trobat informació a WikiData per a aquesta població."
  fi
}

# Comanda est

est() {

  # Número de poblacions en l'hemisferi nort (latitud > 0). Extraiem la fila 9 (latitud) i veiem si el seu valor és possitiu. Al final de tenir totes les latituds que ho compleixen, comptem el nombre de línies, correspon al número de poblacions al nord.
  nord=$(cut -d ',' -f9 cities.csv | awk -F ',' '$1 > 0' | wc -l)

  #Número de poblacions en l'hemisferi sud (latitud < 0). Extraiem la fila 9 (latitud) i veiem si el seu valor és negatiu. Al final de tenir totes les latituds que ho compleixen, comptem el nombre de línies, correspon al número de poblacions al sud.
  sud=$(cut -d ',' -f9 cities.csv | awk -F ',' '$1 < 0' | wc -l)

   # Número de poblacions en l'hemisferi oriental (longitud > 0). Extraiem la fila 10 (longitud) i veiem si el seu valor és possitiu. Al final de tenir totes les longituds que ho compleixen, comptem el nombre de línies, correspon al número de poblacions a orient.
  est=$(cut -d ',' -f10 cities.csv | awk -F ',' '$1 > 0' | wc -l)

   # Número de poblacions en l'hemisferi occidental (longitud < 0). Extraiem la fila 10 (longitud) i veiem si el seu valor és negatiu. Al final de tenir totes les longituds que ho compleixen, comptem el nombre de línies, correspon al número de poblacions a occident.
  oest=$(cut -d ',' -f10 cities.csv | awk -F ',' '$1 < 0' | wc -l)

  # Número de poblacions sense ubicació (latitud i longitud == 0). Fem el procés de les altres, però en aquest cas els dos valors resultants són 0.
  no_ubic=$(cut -d ',' -f9,10 cities.csv | awk -F ',' '$1 == 0 && $2 == 0' | wc -l)

  # Número de poblaciones sense wikidataId. 
  no_wdid=$(cut -d ',' -f11 cities.csv | grep -c -w '')
  #Imprimeix-los per pantalla.
  echo "Nord $nord Sud $sud Est $est Oest $oest No ubic $no_ubic No WDId $no_wdid"
}

#Bucle, el menú s'executa de forma continua fins que es surti. Es mostra el conjunt d'opcions ordenades.
while true; do
  echo "Menú de opciones:"
  echo "1. Llistar països (lp)"
  echo "2. Seleccionar país (sc)"
  echo "3. Seleccionar estat (se)"
  echo "4. Llistar estats del país seleccionat (le)"
  echo "5. Llistar les poblacions del país seleccionat (lcp)"
  echo "6. Extreure les poblacions del país seleccionat (ecp)"
  echo "7. Llistar les poblacions de l'estat seleccionat (lce)"
  echo "8. Extreure les poblacions de l'estat seleccionat (ece)"
  echo "9. Obtenir dades d'una ciutat de la WikiData (gwd)"
  echo "10. Obtenir estadístiques (est)"
  echo "0. Sortir"
#Es demana seleccionar una de les opcions del menú.
  echo -n "Selecciona una opció: "
  read opcio
#Introduïnt el número o l'abreviatura de les opcions, es crida a la funció que les executa.
   case $opcio in
    1|lp)
      listar_paises
      ;;
    2|sc)
      seleccionar_pais
      ;;
    3|se)
      seleccionar_estat	
      ;;
    4|le)
      llistar_estats
      ;;
    5|lcp)
      llistar_poblacions
      ;;
    6|ecp)
      extreure_poblacions
      ;;
    7|lce)
      llistar_poblacions_estat
      ;;
    8|ece)
      extreure_poblacions_estat
      ;;
    9|gwd)
      gwd
      ;;
    10|est)
      est
      ;;
    0|q)
      echo "Sortint de l'aplicació"
      exit 0
      ;;
     #Si no s'introdueix cap de les opcions posibles, s'imprimeix el missatge per pantalla.  
    *)
      echo "Opció no vàlida"
      ;;
  esac
done
