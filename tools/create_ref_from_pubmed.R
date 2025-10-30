# R Script to Generate Jekyll Reference Markdown File from PubMed ID
#
# This script uses the rentrez package to query the NCBI PubMed database,
# extract key bibliographic data, and format it into a new Markdown file
# compliant with the Decap CMS 'references' collection configuration.
#
# NOTE: The target directory MUST exist before running the function.
#       (i.e., you must first create a folder named '_references' in your Jekyll root.)

library(rentrez)
library(stringr)
library(yaml)
library(tools) # Used for standardizing case

create_ref_from_pubmed_id <- function(pubmed_id, output_dir = "_references") {

  # 0. Check parameters
  if (!dir.exists(output_dir)) {
    stop("Output directory '", output_dir, "' does not exist. ",
         "Please create it first or check the working directory is correct.")
  }

  # 1. Fetch data from NCBI PubMed E-utilities
  cat(paste("Fetching data for PubMed ID:", pubmed_id, "... \n"))

  tryCatch({
    # Use esummary for simple, structured data retrieval
    summ <- rentrez::entrez_summary(db="pubmed", id=pubmed_id)

    # Check if summary is valid
    if (length(summ) == 0 || is.null(summ[[1]])) {
      stop("Could not retrieve summary data for the given PubMed ID.")
    }

    # 2. Extract and format fields

    # a. Title
    article_title <- summ$title

    # b. Authors
    # Format: "Last Initials." e.g., "Smith J, Doe A"
    authors_df <- summ$authors
    author_string <- paste(authors_df$name, collapse= ", ")

    # c. Year
    pub_year <- str_extract(summ$pubdate, "\\d{4}")

    # d. Source/Journal
    journal_name <- summ$source

    # e. External URL (PubMed link)
    external_url <- paste0("https://pubmed.ncbi.nlm.nih.gov/", pubmed_id, "/")

    # f. DOI (if available in identifiers)
    doi <- summ$uid # Sometimes the UID is the DOI if retrieved via DOI, but better to check
    doi_link <- ""

    if (!is.null(summ$elocationid)) {
      doi_match <- str_extract(summ$elocationid, "10\\.\\d{4,9}/[[:graph:]]+")
      if (!is.null(doi_match) && length(doi_match) > 0) {
        doi_link <- paste0("https://doi.org/", doi_match)
      }
    }

    # 3. Determine the Filename Slug (year-author_key)

    # Get the last name of the first author for the author_key
    first_author_name <- summ$authors[1, "name"]
    first_author_key <- tolower(gsub("[^a-zA-Z]", "-", first_author_name))

    # 4. Check the uniqueness of the base slug

    # Check for potential conflict: is the file already there?
    first_author_key_temp <- first_author_key
    # Use a simple counter to avoid overwriting immediately
    # The 'a' suffix corresponds to the first occurrence but is not set
    i <- 1
    while (i < 26) {
      # Create the base slug: e.g., '2024-smith-j'
      base_slug <- paste(pub_year, first_author_key_temp, sep="-")
      # Create file path
      filename <- paste0(base_slug, ".md")
      filepath <- file.path(output_dir, filename)
      # Check file conflict
      if (!file.exists(filepath)) {
        first_author_key <- first_author_key_temp
        break
      }
      # Conflict detected
      if (i == 1) {
        warning("WARNING: Potential filename conflict detected. The 'author_key' must be changed.\n")
      }
      # New proposal to avoid conflict
      i <- i + 1
      first_author_key_temp <- paste(first_author_key, letters[i], sep="-")
      base_slug <- paste(pub_year, first_author_key_temp)
    }

    # 5. Assemble YAML Front Matter (matching decap_cms_config_update.yaml)

    front_matter_reference <- list(
      layout = "reference",
      title = article_title,
      author = author_string,
      year = as.integer(pub_year),
      author_key = first_author_key, # Editor must check and modify this if needed
      source = journal_name,
      doi = ifelse(doi_link != "", doi_link, external_url), # Prefer DOI link if found
      last_modified = format(Sys.Date(), "%Y-%m-%d"),
      editor_comment = ""
    )

    yaml_string <- as.yaml(front_matter_reference, column.major = FALSE)

    # 6. Create Markdown Content

    # Final output content: YAML front matter + content body (which we leave empty)
    md_content <- paste0(
      "---\n",
      yaml_string,
      "---\n",
      "\n## Additional Notes\n",
      "\n### Key Findings\n\n",
      "1.  **point 1:** Detail point 1.\n",
      "\n### Methodology\n\n",
      "Description of the methods used...\n"
    )

    # 7. Save the file

    writeLines(md_content, filepath)

    cat("\nSUCCESS: Markdown reference file created.\n")
    cat(paste("Path: ", filepath, "\n"))

  }, error = function(e) {
    cat(paste("ERROR processing PMID", pubmed_id, ":", conditionMessage(e), "\n"))
  })
}

# --- EXAMPLE USAGE ---
# 1. MAKE SURE YOU HAVE CREATED THE FOLDER: _references/
# 2. Then, run the function with a known PubMed ID:

# create_ref_from_pubmed_id("37974276")
