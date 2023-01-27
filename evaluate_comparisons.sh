#!/bin/bash

# Author: Matteo Brivio

FASTTEXT_EN_mCBOW_RESULTS=triples_comparisons/output_fasttext_mcbow_en.tsv
FASTTEXT_EN_SKIP_RESULTS=triples_comparisons/output_fasttext_skip_en.tsv

FASTTEXT_GL_SKIP_RESULTS=triples_comparisons/output_fasttext_skip_gl.tsv

FASTTEXT_PT_SKIP_RESULTS=triples_comparisons/output_fasttext_skip_pt.tsv

FASTTEXT_IT_SKIP_RESULTS=triples_comparisons/output_fasttext_skip_it.tsv

FASTTEXT_ES_SKIP_RESULTS=triples_comparisons/output_fasttext_skip_es.tsv
FASTTEXT_ES_CBOW_RESULTS=triples_comparisons/output_fasttext_cbow_es.tsv

BERT_EN_RESULTS=triples_comparisons/output_bert_en.tsv
BERT_GL_RESULTS=triples_comparisons/output_bert_gl.tsv
BERT_PT_RESULTS=triples_comparisons/output_bert_pt.tsv
BERT_ES_RESULTS=triples_comparisons/output_bert_es.tsv
BERT_IT_RESULTS=triples_comparisons/output_bert_it.tsv

mkdir ./results

# evaluate English fastText and BERT outputs
if [ -f "$FASTTEXT_EN_SKIP_RESULTS" -a -f "$FASTTEXT_EN_mCBOW_RESULTS" -a -f "$BERT_EN_RESULTS" ]; then
    echo "evaluate English fastText and BERT outputs"
    python eval_results.py -f "$FASTTEXT_EN_mCBOW_RESULTS" -t fasttext -o results/results_fasttext_mcbow_en.txt
    python eval_results.py -f "$FASTTEXT_EN_SKIP_RESULTS" -t fasttext -o results/results_fasttext_skip_en.txt
    python eval_results.py -f "$BERT_EN_RESULTS" -t transformers -o results/results_bert_en.txt
else
    echo "either or both the English fastText and BERT outputs are missing."
fi

# evaluate Galician fastText and BERT outputs
if [ -f "$FASTTEXT_GL_SKIP_RESULTS" -a -f "$BERT_GL_RESULTS" ]; then
    echo "evaluate Galician fastText and BERT outputs"
    python eval_results.py -f "$FASTTEXT_GL_SKIP_RESULTS" -t fasttext -o results/results_fasttext_skip_gl.txt
    python eval_results.py -f "$BERT_GL_RESULTS" -t transformers -o results/results_bert_gl.txt
else
    echo "either or both the Galician fastText and BERT outputs are missing."
fi

# evaluate Portuguese fastText and BERT outputs
if [ -f "$FASTTEXT_PT_SKIP_RESULTS" -a -f "$BERT_PT_RESULTS" ]; then
    echo "evaluate Portuguese fastText and BERT outputs"
    python eval_results.py -f "$FASTTEXT_PT_SKIP_RESULTS" -t fasttext -o results/results_fasttext_skip_pt.txt
    python eval_results.py -f "$BERT_PT_RESULTS" -t transformers -o results/results_bert_pt.txt
else
    echo "either or both the Portuguese fastText and BERT outputs are missing."
fi

# evaluate Spanish fastText and BERT outputs
if [ -f "$FASTTEXT_ES_SKIP_RESULTS" -a -f "$FASTTEXT_ES_CBOW_RESULTS" -a -f "$BERT_ES_RESULTS" ]; then
    echo "evaluate Spanish fastText and BERT outputs"
    python eval_results.py -f "$FASTTEXT_ES_SKIP_RESULTS" -t fasttext -o results/results_fasttext_skip_es.txt
    python eval_results.py -f "$FASTTEXT_ES_CBOW_RESULTS" -t fasttext -o results/results_fasttext_cbow_es.txt
    python eval_results.py -f "$BERT_ES_RESULTS" -t transformers -o results/results_bert_es.txt
else
    echo "either or both the Spanish fastText and BERT outputs are missing."
fi

# evaluate Italian fastText and BERT outputs
if [ -f "$FASTTEXT_IT_SKIP_RESULTS" -a -f "$BERT_IT_RESULTS" ]; then
    echo "evaluate Italian fastText and BERT outputs"
    python eval_results.py -f "$FASTTEXT_IT_SKIP_RESULTS" -t fasttext -o results/results_fasttext_skip_it.txt
    python eval_results.py -f "$BERT_IT_RESULTS" -t transformers -o results/results_bert_it.txt
else
    echo "either or both the Italian fastText and BERT outputs are missing."
fi
