TEXODE_WAREHOUSE_DIR="${TEXODE_WAREHOUSE_DIR:-$HOME/.texode}"

if [ -z $1 ]
then
  echo "TeXode renders Markdown code blocks as LaTex."
  echo "Find out more at http://github.com/mattneary/TeXode."
  echo ""
  echo "Manage configuration:"
  echo "    texode --config"
  echo "    texode --reset"
  echo "Manage version:"
  echo "    texode --update"
  echo "    texode --version"
  echo "Build to LaTeX (or code only):"
  echo "    texode -c *.md build/folder"
  echo "    texode -b [book|document] *.md build/folder"
  echo "Interactive Rendering:"
  echo "    texode -i"
elif [ $1 == "-i" ]
then
  :>$TEXODE_WAREHOUSE_DIR/input
  vi $TEXODE_WAREHOUSE_DIR/input
  cat $TEXODE_WAREHOUSE_DIR/input | ruby $TEXODE_WAREHOUSE_DIR/filter.rb
elif [ $1 == "-c" ]  
then
  for build_dir; do true; done
  index=0
  for arg
  do
    if [ $index -gt 0 ] && [ $arg != $build_dir ]
    then
      echo "Rendering the contents of \`$arg\` to the folder \`$build_dir\`."
      ruby $TEXODE_WAREHOUSE_DIR/filter.rb < $arg > $TEXODE_WAREHOUSE_DIR/tmp
      cat $TEXODE_WAREHOUSE_DIR/tmp > $build_dir/$(basename $arg)
    fi
    ((index++))
  done
elif [ $1 == "-b" ]  
then
  if [ $2 == "document" ]
  then
    mode="article"
  else
    mode="book"
  fi
    
  for build_dir; do true; done
  index=0
  for arg
  do
    if [ $index -gt 1 ] && [ $arg != $build_dir ]
    then
      echo "Rendering the contents of \`$arg\` as a LaTeX doc to the folder \`$build_dir\`."
      ruby $TEXODE_WAREHOUSE_DIR/filter.rb $mode < $arg > $TEXODE_WAREHOUSE_DIR/tmp
      cat $TEXODE_WAREHOUSE_DIR/tmp > $build_dir/$(basename $arg).tex
    fi
    ((index++))
  done     
elif [ $1 == "--version" ]
then
  echo "Currently running TeXode version `cat $TEXODE_WAREHOUSE_DIR/version.txt`."
  echo ""
  echo "Find this version on Github at "
  echo "  https://github.com/mattneary/TeXode/commit/`cat $TEXODE_WAREHOUSE_DIR/version.txt`."
elif [ $1 == "--update" ]
then
  echo "Getting fresh install of latest TeXode version..."
  echo ""
  
  rm ~/.texode/*.sh
  rm ~/.texode/*.rb
  rm ~/.texode/*.txt  
  cd ~/.texode
  rm -rf TeXode
  git clone https://github.com/mattneary/TeXode.git
  echo ""
  cd TeXode/lib
  exec ./install.sh `git log --pretty=format:'%h' -n 1`    
elif [ $1 == "--config" ]
then
  if [ -f $TEXODE_WAREHOUSE_DIR/config.json ]
  then
  vi $TEXODE_WAREHOUSE_DIR/config.json
  else
  cp $TEXODE_WAREHOUSE_DIR/_config.json $TEXODE_WAREHOUSE_DIR/config.json
  vi $TEXODE_WAREHOUSE_DIR/config.json
  fi 
elif [ $1 == "--reset" ]
then
  rm $TEXODE_WAREHOUSE_DIR/config.json
  echo "Your configuration file has been reset."   
else
  echo "Invalid arguments provided. Run \`texode\` for help."
fi
