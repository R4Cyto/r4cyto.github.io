---
layout: reference
title: "Cytomulate: accurate and efficient simulation of CyTOF data"
author: "Yang Y, Wang K, Lu Z, Wang T, Wang X"
author_key: "yang-y"
year: 2023
source: "Genome Biol"
url: "https://doi.org/10.1186/s13059-023-03099-1"
editor_comment: "**Cytomulate** is a novel simulation algorithm for **Cytometry by Time-of-Flight (CyTOF)** data. This article presents its development and validation. Cytomulate is positioned as a critical tool to advance CyTOF methodology by providing a reliable platform for benchmarking and validation."
---

## Additional Notes

### Key Findings

1.  **Addresses Evaluation Gap:** Existing CyTOF analysis tools lack objective evaluation due to the absence of ground truth in real data.
2.  **Introduces Cytomulate:** The paper presents Cytomulate as a reproducible and accurate algorithm to **simulate CyTOF data**, serving as a reliable foundation for future method development and unbiased evaluation.
3.  **Captures Data Characteristics:** Cytomulate is demonstrated to effectively **capture the various high-dimensional and heterogeneous characteristics** inherent to actual CyTOF data.
4.  **Superior Performance:** The simulation shows **superiority in learning overall data distributions** compared to single-cell RNA-sequencing-oriented methods (like scDesign2, Splatter) and other generative models (like LAMBDA).
5.  **Utilizes GMMs:** The simulation model is based on **Gaussian Mixture Models (GMMs)**, which are suitable for the near-normality of arcsinh-transformed protein expressions observed in CyTOF data.

### Methodology

Description of the methods used...
