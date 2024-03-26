#!/bin/sh

set -e

SPHINX="$(dirname $(python -c "import os;print(os.path.realpath('$0'))"))"

cd "$SPHINX"

# Make the inc folder.
mkdir -p source/inc

# Delete .pyo files, which could not include docstrings.
find ../renpy -name \*.pyo -delete

# Run a Ren'Py game that generates documentation.
#../renpy.sh .
python ../renpy.py . || ../renpy.sh .

# Clear out generated images.
rm -Rf ../doc-web/_images || true
rm -Rf ../doc/_images || true

# Build the full web documentation.
sphinx-build -E -a source ../doc-web &

# Build the included-with-Ren'Py documentation.
RENPY_NO_FIGURES=1 sphinx-build -E -a source ../doc 2>/dev/null

# Wait for both builds to finish.
wait

# Run some checks.
python checks.py

cd ~/renpy-zh/doc-web

sed -i 's/placeholder="Search docs"/placeholder="搜索文档"/g' *.html

sed -i 's/Home Page/官方主页/g' *.html

sed -i 's/Online Documentation/Ren\&#39;Py中文空间/g' *.html 

sed -i 's/Ren\&#39;Py Documentation/Ren\&#39;Py 中文文档/g' *.html

sed -i '0,/https:\/\/www.renpy.org\/doc\/html/s/https:\/\/www.renpy.org\/doc\/html/https:\/\/www.renpy.cn\/forum.php/g' *.html

sed -i 's/https:\/\/github.com\/renpy\/renpy\/blob\/master\/sphinx/https:\/\/gitee.com\/kurororo666\/Renpydoc-ranslate\/tree\/master/g' *.html

sed -i 's/fa fa-github/fa fa-git-square/g' *.html

sed -i 's/Edit on GitHub/给文档捉虫/g' *.html

