#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements
    INNER JOIN properties using(atomic_number) INNER JOIN types using(type_id) 
    WHERE atomic_number = $ATOMIC_NUMBER")
    if [[ -z $ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT" | while IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING_P BOILING_P 
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). \
It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of \
$MELTING_P celsius and a boiling point of $BOILING_P celsius."
      done
    fi
  else
    NAME_OR_SYMBOL=$1
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements
    INNER JOIN properties using(atomic_number) INNER JOIN types using(type_id)  
    WHERE symbol = '$NAME_OR_SYMBOL' OR name = '$NAME_OR_SYMBOL'")
    if [[ -z $ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT" | while IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING_P BOILING_P 
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). \
It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of \
$MELTING_P celsius and a boiling point of $BOILING_P celsius."
      done
    fi
  fi
fi
