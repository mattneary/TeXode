TEXODE_WAREHOUSE_DIR="${TEXODE_WAREHOUSE_DIR:-$HOME/.texode}"

if [ -z $1 ]
then
  echo "help:"
elif [ $1 == "-i" ]
then
  :>$TEXODE_WAREHOUSE_DIR/input
  vi $TEXODE_WAREHOUSE_DIR/input
  cat $TEXODE_WAREHOUSE_DIR/input | ruby $TEXODE_WAREHOUSE_DIR/filter.rb
elif [ $1 == "-u" ]  
then
  echo "Rendering the contents of \`$2\`."
  ruby $TEXODE_WAREHOUSE_DIR/filter.rb  < $2 > $2
elif [ $1 == "-o" ]
then
  echo "Rendering contents of \`$2\` to the file \`$3\`."
  ruby $TEXODE_WAREHOUSE_DIR/filter.rb  < $2 > $3
else
  echo "Invalid arguments provided. Run \`texode\` for help."
fi