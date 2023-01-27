#!/bin/bash

# Author: Matteo Brivio

URL_ENG_MCBOW=https://dl.fbaipublicfiles.com/fasttext/vectors-english/wiki-news-300d-1M.vec.zip
URL_ENG_SKIPGRAM=https://dl.fbaipublicfiles.com/fasttext/vectors-wiki/wiki.en.vec

URL_ES_CBOW=https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.es.300.vec.gz
URL_ES_SKIPGRAM=https://dl.fbaipublicfiles.com/fasttext/vectors-wiki/wiki.es.vec

URL_GL_SKIPGRAM=https://zenodo.org/record/4481614/files/fasttext_sg_300d_w5.zip?download=1

URL_PT_SKIPGRAM=http://143.107.183.175:22980/download.php?file=embeddings/fasttext/skip_s300.zip

URL_IT_SKIPGRAM=https://dl.fbaipublicfiles.com/fasttext/vectors-wiki/wiki.it.vec


# get the English fastText mcbow model
curl "$URL_ENG_MCBOW" --create-dirs -o ./fasttext/fasttext_english_mcbow/temp.zip
unzip ./fasttext/fasttext_english_mcbow/temp.zip -d ./fasttext/fasttext_english_mcbow/
rm ./fasttext/fasttext_english_mcbow/temp.zip

# get the English fastText skipgram model
curl "$URL_ENG_SKIPGRAM" --create-dirs -o ./fasttext/fasttext_english_skip/wiki.en.vec

# get the Spanish fastText cbow model
curl "$URL_ES_CBOW" --create-dirs -o ./fasttext/fasttext_spanish_cbow/temp.gz
gunzip -c ./fasttext/fasttext_spanish_cbow/temp.gz > ./fasttext/fasttext_spanish_cbow/cc.es.300.vec
rm ./fasttext/fasttext_spanish_cbow/temp.gz

# get the Spanish fastText skipgram model
curl "$URL_ES_SKIPGRAM" --create-dirs -o ./fasttext/fasttext_spanish_skip/wiki.es.vec

# get the Galician fastText skipgram model
curl "$URL_GL_SKIPGRAM" --create-dirs -o ./fasttext/fasttext_galician_skip/temp.zip
unzip ./fasttext/fasttext_galician_skip/temp.zip -d ./fasttext/fasttext_galician_skip/
rm ./fasttext/fasttext_galician_skip/temp.zip

# get the Portuguese fastText skipgram model
curl "$URL_PT_SKIPGRAM" --create-dirs -o ./fasttext/fasttext_portuguese_skip/temp.zip
unzip ./fasttext/fasttext_portuguese_skip/temp.zip -d ./fasttext/fasttext_portuguese_skip/
rm ./fasttext/fasttext_portuguese_skip/temp.zip

# get the Italian fastText skipgram model
curl "$URL_IT_SKIPGRAM" --create-dirs -o ./fasttext/fasttext_italian_skip/wiki.it.vec
