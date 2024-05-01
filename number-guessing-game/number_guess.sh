#!/bin/bash
NUMBER=$(( RANDOM % 1000 + 1 ))
ATTEMPTS=1
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# echo Random number: $NUMBER

echo Enter your username:
read USERNAME
EXISTING_USER=$($PSQL "SELECT games_played, best_game FROM users WHERE username = '$USERNAME'")
if [[ -z $EXISTING_USER ]]
then
  NEW_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  echo "$EXISTING_USER" | while IFS="|" read GAMES_PLAYED BEST_GAME
  do
    if [[ -z $BEST_GAME ]]
    then
      echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    else
      echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    fi
  done
fi

echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS
while [[ $GUESS != $NUMBER ]]
do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
  elif [[ $GUESS -lt $NUMBER ]]
  then
    echo -e "\nIt's higher than that, guess again:"
  else
    echo -e "\nIt's lower than that, guess again:"
  fi
  ((ATTEMPTS++))
  read GUESS
done

NEW_GAMES_PLAYED=$((GAMES_PLAYED + 1))
if [[ -z $BEST_GAME || $ATTEMPTS -lt $BEST_GAME ]]
then
  NEW_BEST_GAME=$ATTEMPTS
else
  NEW_BEST_GAME=$BEST_GAME
fi
echo -e "\nYou guessed it in $ATTEMPTS tries. The secret number was $NUMBER. Nice job!"
UPDATE_USER_RESULT=$($PSQL "UPDATE users SET games_played = $NEW_GAMES_PLAYED, best_game = $NEW_BEST_GAME WHERE username = '$USERNAME'")