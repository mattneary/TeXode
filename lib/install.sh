TEXODE_WAREHOUSE_DIR="${TEXODE_WAREHOUSE_DIR:-$HOME/.texode}"
BUILD_DIR=$(dirname $0)

cp -R $BUILD_DIR/../src/* $TEXODE_WAREHOUSE_DIR
cp $BUILD_DIR/../src/texode.sh /usr/local/bin/texode
if [ -z $1 ]
then
  true
else  
  echo "$1" > $TEXODE_WAREHOUSE_DIR/version.txt
  echo ""
  echo "You are now running TeXode version $1."
  echo ""
  echo "Find this version on Github at "
  echo "  https://github.com/mattneary/TeXode/commit/$1."
fi  

echo "TeXode has been installed."
echo ""
echo "Restart your terminal for stability, then start using TeXode"
echo "to build full documents, just code, or in interactive mode."
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
echo ""
echo "Get more information at http://github.com/mattneary/TeXode"