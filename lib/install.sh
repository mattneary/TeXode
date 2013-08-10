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
echo "in build, update, output, or interactive mode."
echo "    texode -b *.md build/"
echo "    texode -u *.md"
echo "    texode -o input.md output.md"
echo "    texode -i"
echo ""
echo "Find you current version and update."
echo "    texode -v"
echo "    texode --update"
echo ""
echo "Edit your configuration."
echo "    texode --config"
echo ""
echo "Get more information at http://github.com/mattneary/TeXode"