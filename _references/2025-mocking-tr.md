---
layout: reference
title: 'CytoScan: Automated detection of technical anomalies for cytometry quality
  control'
author: Mocking TR, Zwolle F, Park Y, Kelder A, Saeys Y, Cloos J, van Gassen S, Bachas
  C
pub_date: '2025-09-26'
year: 2025
author_key: mocking-tr
source: bioRxiv
doi: https://doi.org/10.1101/2025.09.24.678276
last_modified: '2025-10-30'
editor_comment: 'This bioRxiv preprint introduces a new computational tool to standardize and improve quality control in flow and mass cytometry experiments.'
keywords:
  - FCS cleaning
  - quality control
---

## Additional Notes

### 📰 Article Summary

1.  The paper presents **CytoScan**, a novel R package designed to automate the detection of technical anomalies and ensure quality control in large, multi-parameter cytometry datasets.
2.  It addresses the challenge of spurious technical effects, which arise from standardization issues and complicate downstream analysis of cellular phenotypes.
3.  CytoScan evaluates inter-measurement variation and identifies two distinct types of anomalies: **outliers** (files dissimilar to the current batch) and **novelties** (files dissimilar to a previously defined high-quality reference set).
4.  The tool was validated using both controlled simulations of marker distribution skewing and observations of real-life technical effects, demonstrating high accuracy in detection.
5.  By providing informative visualizations and operating efficiently on consumer-grade hardware, CytoScan offers a highly accessible and reliable solution for quality-control in cytometry pipelines.

###  🎯 Key Findings

1.  **Need for Automation:** Complex, multi-parameter cytometry studies urgently require **user-friendly, automated tools** to detect technical variations that skew marker distributions.
2.  **CytoScan Development:** The researchers developed and present the **CytoScan R package** to fill the gap in exploratory data analysis tools for post-acquisition quality control.
3.  **Dual Detection Mechanism:** CytoScan's core innovation is its ability to specifically identify both **outliers** (anomalies within the current batch) and **novelties** (anomalies relative to external, high-quality reference data).
4.  **Proof of Efficacy:** The tool's ability to **accurately detect anomalies** was confirmed using evidence from controlled simulations and complex, real-world technical effects present in clinical datasets.
5.  **Accessibility for Large Data:** CytoScan is designed for **scalability**, ensuring it can be effectively applied to very large cytometry datasets using standard hardware, providing informative and accessible visualizations.

### ⚙️ Algorithm Methodology
CytoScan works by evaluating **inter-measurement variation** across files within a cytometry dataset. The core of the algorithm is a **comparison mechanism** that detects two distinct types of data quality anomalies:

1.  **Outlier Detection:** Identifies files that show **limited similarity** when compared to **other measurements** within the same batch or experiment.
2.  **Novelty Detection:** Identifies files that show **limited similarity** when compared to a set of **previously acquired high-quality reference data**. This allows for flagging files that deviate from an ideal baseline standard.

### 🧪 Validation Methodology
The tool's accuracy and robustness were validated through two primary approaches, confirming its ability to detect technical errors:

1.  **Simulations:** The authors used **simulations of skewed marker distributions** to create artificial, known technical effects. This allowed them to quantitatively demonstrate CytoScan's capability to detect errors under controlled conditions.
2.  **Real-Life Effects:** The tool was tested on datasets containing **real-life technical effects**, proving its practical utility in identifying the spurious, non-biological variations commonly encountered in clinical and experimental cytometry data acquisition.
