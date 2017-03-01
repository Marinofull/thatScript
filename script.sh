#The MIT License (MIT)
#
#Copyright (c) 2015 Marino Souza and Nilton Vasques
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

#It requires the ghostscript

#a primeira input deve ser o nome do pdf e a segunda o número final de páginas
#se a última página for em branco, não a contabilize
pdf=$1
max=$2
ini=1
fim=3

#neste for o ghostscript quebra a cada 3 páginas em arquivos separados com nomes padrões
for ((a=1; fim<= $max; a++))
do

    gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dFirstPage=$ini -dLastPage=$fim -sOutputFile=page$a.pdf $pdf
    #gs -dBATCH -sOutputFile=page$a.pdf -dFirstPage=$ini -dLastPage=$fim -sDEVICE=pdfwrite $pdf

    ((ini+=3))
    ((fim+=3))

done

mkdir -p out

#neste for a 4a linha, 1a cauda do arquivo é lida e usada pra renomear cada pdf
for i in $(ls page*.pdf); do
    #evince $i
    pdftotext $i
    name=$(echo $i | cut -f1 -d.)
    echo $name
    equipe=$(cat $name.txt | head -n 1 | cut -f2 -d-)
    echo $equipe
    mv $i "out/$equipe".pdf
    rm $name.txt
done

#se é passado 'y' no 3o parametro ele abre cada saída pra ser conferida no olho msm
if [ "$3" = y ]; then
    for i in $(ls out/*pdf); do
        evince $i
    done
fi
