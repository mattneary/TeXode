TEXODE_WAREHOUSE_DIR="${TEXODE_WAREHOUSE_DIR:-$HOME/.texode}"

if [ -z $1 ]
then
  echo "TeXode renders Markdown code blocks as LaTex."
  echo "Find out more at http://github.com/mattneary/TeXode."
  echo ""
  echo "Get this Help Screen:"
  echo "    texode"
  echo "Run in Interactive Mode:"
  echo "    texode -i"
  echo "Update File(s) with Rendered Code:"
  echo "    texode -u *.md"
  echo "Output Rendered Markdown to File:"
  echo "    texode -o input.md output.md"
  echo "Build File(s) to a Directory:"
  echo "    texode -b *.md build/"
elif [ $1 == "-i" ]
then
  :>$TEXODE_WAREHOUSE_DIR/input
  vi $TEXODE_WAREHOUSE_DIR/input
  cat $TEXODE_WAREHOUSE_DIR/input | ruby $TEXODE_WAREHOUSE_DIR/filter.rb
elif [ $1 == "-u" ]  
then
  index=0
  for arg
  do
    if [ $index -gt 0 ]
    then
      echo "Rendering the contents of \`$arg\`."
      ruby $TEXODE_WAREHOUSE_DIR/filter.rb  < $arg > $TEXODE_WAREHOUSE_DIR/tmp
      cat $TEXODE_WAREHOUSE_DIR/tmp > $arg      
    fi
    ((index++))
  done 
elif [ $1 == "-b" ]  
then
  for build_dir; do true; done
  index=0
  for arg
  do
    if [ $index -gt 0 ] && [ $arg != $build_dir ]
    then
      echo "Rendering the contents of \`$arg\` to the folder \`$build_dir\`."
      ruby $TEXODE_WAREHOUSE_DIR/filter.rb  < $arg > $TEXODE_WAREHOUSE_DIR/tmp
      cat $TEXODE_WAREHOUSE_DIR/tmp > $build_dir/$(basename $arg)
    fi
    ((index++))
  done    
elif [ $1 == "-o" ]
then
  echo "Rendering contents of \`$2\` to the file \`$3\`."
  ruby $TEXODE_WAREHOUSE_DIR/filter.rb  < $2 > $TEXODE_WAREHOUSE_DIR/tmp
  cat $TEXODE_WAREHOUSE_DIR/tmp > $3
elif [ $1 == "-v" ]
then
  echo "Currently running TeXode version `cat $TEXODE_WAREHOUSE_DIR/version.txt`."
  echo ""
  echo "Find this version on Github at "
  echo "  https://github.com/mattneary/TeXode/commit/`cat $TEXODE_WAREHOUSE_DIR/version.txt`."
elif [ $1 == "-u" ]
then
  echo "Getting fresh install of latest TeXode version..."
  echo ""
  
  git clone https://github.com/mattneary/TeXode.git
  echo ""
  cd TeXode/lib
  ./install.sh `git log --pretty=format:'%h' -n 1`
  cd ../..
  rm -rf TeXode/
  
  echo "You are now running TeXode version `cat $TEXODE_WAREHOUSE_DIR/version.txt`."
  echo ""
  echo "Find this version on Github at "
  echo "  https://github.com/mattneary/TeXode/commit/`cat $TEXODE_WAREHOUSE_DIR/version.txt`."
else
  echo "Invalid arguments provided. Run \`texode\` for help."
fi