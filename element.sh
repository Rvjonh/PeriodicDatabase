#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#if an argument is not passed
if [[ -z $1 ]]
then
  #print message to ask argument
  echo "Please provide an element as an argument."
else
  #detect if its a numeric argument
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #request the element with its atomic number
    data=$($PSQL "SELECT * FROM elements AS e 
                INNER JOIN properties AS p USING(atomic_number) 
                INNER JOIN types AS t USING(type_id) 
                WHERE e.atomic_number='$1';")
  else
    #request the element with its symbol or name
    data=$($PSQL "SELECT * FROM elements AS e 
                INNER JOIN properties AS p USING(atomic_number) 
                INNER JOIN types AS t USING(type_id) 
                WHERE symbol='$1' or name='$1';")
  fi

  #if the element was found
  if [[ $data ]]
  then
    #print it formatted message
    echo "$data" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    #print a message to inform used element was not found
    echo "I could not find that element in the database."
  fi
fi