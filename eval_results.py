#!/usr/bin/python3

"""
This script computes the accuracy scores for each of the four experiments described in
the original paper, both for BERT and fastText models.

Author: Matteo Brivio
"""

import argparse
import pandas as pd
from pathlib import Path
from tabulate import tabulate
from typing import Tuple


# ResultsSentAvg[-4], ResultsConcat[-4] and ResultsSum[-4] correspond to Sent, Cat and Add
# as reported in Table 4 in the original paper for BERT models. Similarly, for fastText models
# Bas1, Bas2 and Meth1c correspond to WV, Sent and Syn(3), respectively.
COLUMNS_TRANSFORMERS = ["ResultsSentAvg[-4]", "ResultsConcat[-4]", "ResultsSum[-4]"]
COLUMNS_FASTEXT = ["Bas1", "Bas2", "Meth1c"]


def get_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Computes accuracy scores given a .tsv file storing embeddings comparison results."
    )
    parser.add_argument(
        "-f",
        "--file",
        type=Path,
        default=None,
        required=True,
        help="name of the .tsv file storing the results of the embeddings comparison.",
    )
    parser.add_argument(
        "-t",
        "--type",
        type=str,
        default=None,
        required=True,
        choices=["transformers", "fasttext"],
        help="type of comparison results being evaluated; either transformers or fasttext.",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        default=None,
        required=True,
        help="path to the .txt file where the output evaluation should be stored.",
    )

    return parser.parse_args()


def get_data(df: pd.DataFrame, column: str) -> pd.DataFrame:
    """Collects data to compute accuracy scores for the four experiments.

    Args:
        df(pd.DataFrame): a dataframe storing the results of the target-words
        embeddings comparisons for either a BERT or fastText model, together
        with the original triples and their respective `Target`, `POS`, `Context`
        and `Overlap` information.
        column(str): column identifying either of the three embedding creation
        strategies `Sent`, `Sum` and `Cat` for BERT models and `WV`, `Sent`, `Syn3`
        for fastText models.

    Returns:
        A dataframe storing the total number of wrong and correct items for each
        experiment and for the whole dataset, where a correct item is defined as
        a triple in which sim1 > sim2 and sim1 > sim3. sim1 is the cosine similarity
        between sent. 1 and sent. 2; sim2 is the cosine similarity between sent. 1
        and sent. 3; sim3 is the cosine similarity between sent. 2 and sent. 3.
    """
    df = df.loc[:, ["Target", "POS", "Context", "Overlap", "Sent1", column]]
    # add new column storing the target word from Sent1
    df["Word1"] = df["Sent1"].str.extract(r"<b>(.*)</b>")

    # total number of correct and wrong instances in the given column
    total = dict(df[column].value_counts())

    # Experiment 1 only considers triplets of sentences having the same target word
    # (overlap "true|true|true"), different contexts (context "diff|diff|diff") and
    # the same target word POS (POS "same|same|same").
    experiment_1 = dict(
        df[
            (df["Context"] == "diff|diff|diff")
            & (df["Overlap"] == "true|true|true")
            & (df["POS"] == "same|same|same")
        ][column].value_counts()
    )

    # Experiment 2 only considers triplets of sentences having different target words
    # (overlap "false|false|false"), different contexts (context "diff|diff|diff") and
    # the same target word POS (POS "same|same|same"). Moreover, Target should be
    # contained in Word1 or vice versa e.g. Target: "bat", Word1: "bats".
    experiment_2 = dict(
        df[
            (
                df.apply(
                    lambda x: (x["Target"] in x["Word1"])
                    or (x["Word1"] in x["Target"]),
                    axis=1,
                )
            )
            & (df["Context"] == "diff|diff|diff")
            & (df["Overlap"] == "false|false|false")
            & (df["POS"] == "same|same|same")
        ][column].value_counts()
    )

    # Experiment 3 only considers triplets of sentences exhibiting all but the following
    # overlap patterns "false|false|false", "true|false|false" and "true|true|true",
    # different contexts (context "diff|diff|diff") and the same target word POS
    # (POS "same|same|same").
    experiment_3 = dict(
        df[
            (df["Context"] == "diff|diff|diff")
            & (
                (df["Overlap"] != "false|false|false")
                & (df["Overlap"] != "true|false|false")
                & (df["Overlap"] != "true|true|true")
            )
            & (df["POS"] == "same|same|same")
        ][column].value_counts()
    )

    # Experiment 4 only considers triplets of sentences having different target words
    # (overlap "false|false|false"), either one of the following context patterns
    # "same|same|same", "diff|same|diff" and the same target word POS (POS "same|same|same").
    experiment_4 = dict(
        df[
            ((df["Context"] == "same|same|same") | (df["Context"] == "diff|same|diff"))
            & (df["Overlap"] == "false|false|false")
            & (df["POS"] == "same|same|same")
        ][column].value_counts()
    )

    results = pd.DataFrame(
        [total, experiment_1, experiment_2, experiment_3, experiment_4]
    ).fillna(0)
    results.rename(
        index={0: "Full", 1: "exp_1", 2: "exp_2", 3: "exp_3", 4: "exp_4"},
        inplace=True
    )

    return results


def compute_accuracy(df: pd.DataFrame) -> pd.DataFrame:
    """Given a dataset obtained from a specific embedding creation strategy
    (i.e. `Sent`, `Sum`, `Cat`...) computes the accuracy scores for each of
    the four experiments.

    Args:
        df(pd.DataFrame): a dataframe storing the total number of wrong
        and correct items for each experiment and for the whole dataset
        being considered.

    Returns:
        A dataframe storing the number of correct, wrong and total triples
        for each experiment and for the whole dataset, together with their
        respective accuracy scores.
    """

    df["tot_instances"] = df["correct"] + df["wrong"]
    df["accuracy"] = df["correct"] / df["tot_instances"]
    df["macro_avg_exp"] = df["accuracy"][1:].mean()
    df["micro_avg_exp"] = df["correct"][1:].sum() / df["tot_instances"][1:].sum()

    return df


def format_output(df: pd.DataFrame) -> Tuple[str, str]:
    """Formats the accuracy scores dataframe into a table.

    Args:
        df(pd.DataFrame): a dataframe storing the number of correct, wrong
        and total triples for each experiment and for the whole dataset,
        together with their respective accuracy and macro and micro averages.

    Returns:
        A formatted table summarizing the accuracy scores.
    """
    exps = tabulate(
        [
            ["exp_1", df.loc["exp_1", "accuracy"]],
            ["exp_2", df.loc["exp_2", "accuracy"]],
            ["exp_3", df.loc["exp_3", "accuracy"]],
            ["exp_4", df.loc["exp_4", "accuracy"]],
        ],
        headers=["Experiments", "Accuracy"],
    )

    avgs = tabulate(
        [
            [
                "avg. accuracy scores",
                df.loc["Full", "accuracy"],
                df.loc["Full", "micro_avg_exp"],
                df.loc["Full", "macro_avg_exp"],
            ]
        ],
        headers=["Full micro avg.", "Exp. micro avg.", "Exp. macro avg."],
    )

    return exps, avgs


def main() -> None:
    args = get_args()

    columns = COLUMNS_TRANSFORMERS if args.type == "transformers" else COLUMNS_FASTEXT

    comparison_output = args.file
    df = pd.read_csv(comparison_output, sep="\t")
    # drop last (unnamed) column storing only NaNs
    df = df.dropna(how="all", axis="columns")

    with open(args.output, "w") as output_file:
        for column in columns:
            data = get_data(df, column)
            scores = compute_accuracy(data)
            exps, avgs = format_output(scores)

            out = f"{column}\n{exps}\n{avgs}\n\n"
            output_file.write(out)


if __name__ == "__main__":
    main()
