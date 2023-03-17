#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then

    data=$($PSQL "SELECT * FROM elements AS e 
                INNER JOIN properties AS p USING(atomic_number) 
                INNER JOIN types AS t USING(type_id) 
                WHERE e.atomic_number='$1';")
  else

    data=$($PSQL "SELECT * FROM elements AS e 
                INNER JOIN properties AS p USING(atomic_number) 
                INNER JOIN types AS t USING(type_id) 
                WHERE symbol='$1' or name='$1';")
  fi

  echo "$data" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done

fi