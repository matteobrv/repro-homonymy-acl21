# [Re] Word Meanings Representation in Context

This repository hosts the code, data and results of our reproducibility experiment for the ACL 2021 paper [*Exploring the Representation of Word Meanings in Context: A Case Study on Homonymy and Synonymy*](https://arxiv.org/abs/2106.13553) by Marcos Garcia. The paper looks at both static and contextualized word embeddings with the goal to assess their ability to adequately represent different lexical‐semantic relations, such as homonymy and synonymy. Our goal is to reproduce the results summarised in Table 4 of the orginal paper and to test the hypothesis formulated by the author on a newly-compiled Italian dataset. The original repository can be reached at [https://github.com/marcospln/homonymy_acl21](https://github.com/marcospln/homonymy_acl21).

## Datasets

For our experiment we work with `.tsv` data-sets of _triples_ in five languages: English, Spanish, Portuguese, Galician and Italian. A _triple_ is a set of three sentences, each containing a target word marked by `<b></b>` tags. Two target words have the same meaning while the third is an outlier.

```tsv
Target	POS	Context	Overlap	Sent1	Sent2	Sent3
coach	same|same|same	same|same|same	false|false|false	We're going to the airport by <b>coach</b>.	We're going to the airport by <b>bus</b>.	We're going to the airport by <b>bicycle</b>.
```

For each `.tsv` data-set we also need its corresponding `.conllu` version. These resources are provided in the `datasets` folder.

## Run the Experiment

1. execute `get_fasttext_models.sh` to get the fastText models required to succesfully run the experiment;
2. execute `generate_comparisons.sh` to generate an embedding for each sentence in each triple and compare them: _(emb_sent_1 vs emb_sent_2)_, _(emb_sent_1 vs emb_sent_3)_ and _(emb_sent_2 vs emb_sent_3)_;
3. execute `evaluate_comparisons.sh` to compute the accuracy scores for each language variety.

## Results

The outputs of the two scripts, `generate_comparisons.sh` and `evaluate_comparisons.sh`, are stored in `triples_comparisons` and `results`, respectively. We provide our results in the `repro_results` folder.
