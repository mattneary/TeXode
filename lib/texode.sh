TEXODE_WAREHOUSE_DIR="${TEXODE_WAREHOUSE_DIR:-$HOME/.texode}"

if [ -z $1 ]
then
  echo "TeXode renders Markdown code blocks as LaTex."
  echo "Find out more at http://github.com/mattneary/TeXode."
  echo ""
  echo "Get this Help Screen:"
  echo "    texode"
  echo ""
  echo "Run in Interactive Mode:"
  echo "    texode -i"
  echo ""
  echo "Update a File with Rendered Code:"
  echo "    texode -u input.md"
  echo ""
  echo "Output Rendered Markdown to File:"
  echo "    texode -o input.md output.md"
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