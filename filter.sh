if [ -z $1 ]
then
  echo "help:"
elif [ $1 == "-i" ]
then
  :>input
  vi input
  cat input | ruby filter.rb
elif [ $1 == "-u" ]  
then
  echo "Rendering the contents of \`$2\`."
  ruby filter.rb  < $2 > $2
elif [ $1 == "-o" ]
then
  echo "Rendering contents of \`$2\` to the file \`$3\`."
  ruby filter.rb  < $2 > $3
else
  echo "Invalid arguments provided. Run \`texode\` for help."
fi