#!/bin/bash

# Author: Matteo Brivio

FASTTEXT_EN_mCBOW=./fasttext/fasttext_english_mcbow/wiki-news-300d-1M.vec
FASTTEXT_EN_SKIP=./fasttext/fasttext_english_skip/wiki.en.vec

FASTTEXT_GL_SKIP=./fasttext/fasttext_galician_skip/fasttext_sg_300d_w5.vec

FASTTEXT_PT_SKIP=./fasttext/fasttext_portuguese_skip/skip_s300.txt

FASTTEXT_IT_SKIP=./fasttext/fasttext_italian_skip/wiki.it.vec

FASTTEXT_ES_SKIP=./fasttext/fasttext_spanish_skip/wiki.es.vec
FASTTEXT_ES_CBOW=./fasttext/fasttext_spanish_cbow/cc.es.300.vec


mkdir ./triples_comparisons

# generate English fastText and BERT comparisons
if [ -f "$FASTTEXT_EN_mCBOW" -a -f "$FASTTEXT_EN_SKIP" ]; then
    echo "generate English fastText mcbow comparisons."
    python compare_embeddings_static.py --file datasets/dataset_triples_en.tsv --lang en --system fasttext --model "$FASTTEXT_EN_mCBOW" > triples_comparisons/output_fasttext_mcbow_en.tsv
    echo "generate English fastText skip-gram comparisons."
    python compare_embeddings_static.py --file datasets/dataset_triples_en.tsv --lang en --system fasttext --model "$FASTTEXT_EN_SKIP" > triples_comparisons/output_fasttext_skip_en.tsv
    echo "generate English BERT comparisons."
    python compare_embeddings_transformers.py --file datasets/dataset_triples_en.tsv --lang en --system bert --model 2  > triples_comparisons/output_bert_en.tsv
else
    echo "English fastText model not found."
fi

# generate Galician fastText and BERT comparisons
if [ -f "$FASTTEXT_GL_SKIP" ]; then
    echo "generate Galician fastText skip-gram comparisons."
    python compare_embeddings_static.py --file datasets/dataset_triples_gl.tsv --lang gl --system fasttext --model "$FASTTEXT_GL_SKIP" > triples_comparisons/output_fasttext_skip_gl.tsv
    echo "generate Galician BERT comparisons."
    python compare_embeddings_transformers.py --file datasets/dataset_triples_gl.tsv --lang gl --system bert --model 3  > triples_comparisons/output_bert_gl.tsv
else
    echo "Galician fastText model not found."
fi

# generate Portuguese fastText and BERT comparisons
if [ -f "$FASTTEXT_PT_SKIP" ]; then
    echo "generate Portuguese fastText skip-gram comparisons."
    python compare_embeddings_static.py --file datasets/dataset_triples_pt.tsv --lang pt --system fasttext --model "$FASTTEXT_PT_SKIP" > triples_comparisons/output_fasttext_skip_pt.tsv
    echo "generate Portuguese BERT comparisons."
    python compare_embeddings_transformers.py --file datasets/dataset_triples_pt.tsv --lang pt --system bert --model 2  > triples_comparisons/output_bert_pt.tsv
else
    echo "Portuguese fastText model not found."
fi

# generate Spanish fastText and BERT comparisons
if [ -f "$FASTTEXT_ES_SKIP" -a -f "$FASTTEXT_ES_CBOW" ]; then
    echo "generate Spanish fastText skip-gram comparisons."
    python compare_embeddings_static.py --file datasets/dataset_triples_es.tsv --lang es --system fasttext --model "$FASTTEXT_ES_SKIP" > triples_comparisons/output_fasttext_skip_es.tsv
    echo "generate Spanish fastText cbow comparisons."
    python compare_embeddings_static.py --file datasets/dataset_triples_es.tsv --lang es --system fasttext --model "$FASTTEXT_ES_CBOW" > triples_comparisons/output_fasttext_cbow_es.tsv
    echo "generate Spanish BERT comparisons."
    python compare_embeddings_transformers.py --file datasets/dataset_triples_es.tsv --lang es --system bert --model 2  > triples_comparisons/output_bert_es.tsv
else
    echo "Spanish fastText model not found."
fi

# generate Italian fastText and BERT comparisons
if [ -f "$FASTTEXT_IT_SKIP" ]; then
    echo "generate Italian fastText skip-gram comparisons."
    python compare_embeddings_static.py --file datasets/dataset_triples_it.tsv --lang it --system fasttext --model "$FASTTEXT_IT_SKIP" > triples_comparisons/output_fasttext_skip_it.tsv
    echo "generate Italian BERT comparisons."
    python compare_embeddings_transformers.py --file datasets/dataset_triples_it.tsv --lang it --system bert --model 2  > triples_comparisons/output_bert_it.tsv
else
    echo "Italian fastText model not found."
fi
