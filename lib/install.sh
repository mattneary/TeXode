TEXODE_WAREHOUSE_DIR="${TEXODE_WAREHOUSE_DIR:-$HOME/.texode}"
BUILD_DIR=$(dirname $0)

cp -R $BUILD_DIR/../src $TEXODE_WAREHOUSE_DIR
cp $BUILD_DIR/../src/texode.sh /usr/local/bin/texode

echo "TeXode has been installed."
echo ""
echo "Restart your terminal to use it in interactive, updating,"
echo "or outputting mode:"
echo "    texode -i"
echo "    texode -u input.md"
echo "    texode -o input.md output.md"
echo ""
echo "Get more information at http://github.com/mattneary/TeXode"