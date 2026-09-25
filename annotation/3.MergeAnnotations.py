#!/usr/bin/env python3

import pandas as pd

# ---------- inputs ----------
swiss = "swissprot.diamond.tsv"
eggnog = "eggnog_out/eggnog.emapper.annotations"
ipr = "interproscan_out/interproscan.tsv"

# ---------- SwissProt ----------
sw = pd.read_csv(swiss, sep="\t", header=None)
sw.columns = [
    "protein_id","swissprot_id","pident","aln_len","mismatch","gapopen",
    "qstart","qend","sstart","send","evalue","bitscore","swissprot_title"
]
sw = sw[["protein_id","swissprot_id","evalue","bitscore","swissprot_title"]]

# ---------- eggNOG ----------
eg = pd.read_csv("eggnog_out/eggnog.emapper.annotations.fixed",
                 sep="\t",
                 dtype=str,
                 engine="python")
eg = eg.rename(columns={"#query": "protein_id"})
eg["protein_id"] = eg["protein_id"].str.strip()
colmap = {}
for c in eg.columns:
    lc = c.strip().lower()
    if lc in ("#query","query"):
        colmap[c] = "protein_id"
    elif lc == "description":
        colmap[c] = "eggnog_description"
    elif lc == "preferred_name":
        colmap[c] = "eggnog_preferred_name"
    elif lc in ("gos","go"):
        colmap[c] = "eggnog_go"
    elif lc == "kegg_ko":
        colmap[c] = "kegg_ko"
    elif lc == "kegg_pathway":
        colmap[c] = "kegg_pathway"
    elif lc == "kegg_module":
        colmap[c] = "kegg_module"
    elif lc == "cog_category":
        colmap[c] = "cog_category"
eg = eg.rename(columns=colmap)
keep_eg = [c for c in ["protein_id","eggnog_preferred_name","eggnog_description","eggnog_go",
                       "kegg_ko","kegg_pathway","kegg_module","cog_category"] if c in eg.columns]
eg = eg[keep_eg]

# ---------- InterProScan TSV ----------
ipr_df = pd.read_csv(ipr, sep="\t", header=None, low_memory=False)
maxcols = ipr_df.shape[1]
# InterProScan TSV format (most common) has 15 columns; GO at col 13, pathways at col 14
ipr_df = ipr_df.rename(columns={
    0:"protein_id",
    3:"analysis",
    4:"signature_acc",
    5:"signature_desc",
    11:"interpro_acc",
    12:"interpro_desc",
    13:"ipr_go",
    14:"ipr_pathways"
})

# aggregate multiple rows per protein into semicolon-joined unique sets
def uniq_join(s):
    s = s.dropna().astype(str)
    s = [x for x in s if x not in ("-", "NA", "nan")]
    return ";".join(sorted(set(s))) if s else ""

ipr_agg = ipr_df.groupby("protein_id", as_index=False).agg({
    "analysis": uniq_join,
    "signature_acc": uniq_join,
    "signature_desc": uniq_join,
    "interpro_acc": uniq_join,
    "interpro_desc": uniq_join,
    "ipr_go": uniq_join,
    "ipr_pathways": uniq_join
})

# ---------- merge ----------
m = sw.merge(eg, on="protein_id", how="outer").merge(ipr_agg, on="protein_id", how="outer")

# nice combined GO column
def merge_go(row):
    parts = []
    for k in ("eggnog_go","ipr_go"):
        if k in row and pd.notna(row[k]) and str(row[k]).strip():
            parts.append(str(row[k]))
    if not parts:
        return ""
    # split and unique
    gos = set()
    for p in parts:
        for token in p.replace(",", ";").split(";"):
            token = token.strip()
            if token.startswith("GO:"):
                gos.add(token)
    return ";".join(sorted(gos))

m["GO_terms_merged"] = m.apply(merge_go, axis=1)
m.to_csv("functional_annotation_merged.tsv", sep="\t", index=False)
 
