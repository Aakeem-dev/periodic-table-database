PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi
#assign the first argument to your ELEMENT variable
ELEMENT=$1
#if argument has been provided, query the database once.
ELEMENTS=$($PSQL "SELECT atomic_number, symbol, name FROM elements");
#extract element from query
ELEMENT_FOUND=$( echo "$ELEMENTS" | grep -E "^$ELEMENT\||\|$ELEMENT\||\|$ELEMENT$")
#if the element is not found
if [[ -z "$ELEMENT_FOUND" ]]
then
  echo "I could not find that element in the database."
else 
  #extract the elements data
  IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT_FOUND"
  #get the rest of the elements info
  ELEMENT_INFO=$($PSQL "SELECT types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM properties INNER JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number = $ATOMIC_NUMBER;")
  #extract the properties
  IFS="|" read -r TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_INFO"

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
