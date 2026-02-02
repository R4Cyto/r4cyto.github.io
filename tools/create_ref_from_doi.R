# R Script to Generate Jekyll Reference Markdown File from DOI (via Crossref)
#
# This script uses the jsonlite package to query the Crossref API,
# extract key bibliographic data using a DOI, and format it into a new
# Markdown file compliant with the Decap CMS 'references' collection.
#
# NOTE: The target directory MUST exist before running the function.

library(jsonlite) # Used for fetching data from Crossref API
library(stringr)
library(yaml)
library(tools) # Used for standardizing case

create_ref_from_doi <- function(doi, output_dir = "_references") {

  # 0. Check parameters
  if (!dir.exists(output_dir)) {
    stop("Output directory '", output_dir, "' does not exist. ",
         "Please create it first or check the working directory is correct.")
  }

  # 1. Fetch data from Crossref API
  cat(paste("Fetching data for DOI:", doi, "... \n"))

  # Construct the Crossref API URL
  crossref_url <- paste0("https://api.crossref.org/works/", URLencode(doi))

  tryCatch({
    # Use jsonlite to get and parse the JSON response
    response <- jsonlite::fromJSON(crossref_url)

    # Check for valid response status and data
    if (response$status != "ok" || is.null(response$message)) {
      stop("Could not retrieve data from Crossref for the given DOI.")
    }

    # Extract the main message object
    data <- response$message

    # 2. Extract and format fields

    # a. Title (handle cases where title is a list or vector)
    article_title <- data$title
    if (is.list(article_title) || length(article_title) > 1) {
      article_title <- article_title[[1]]
    }

    # b. Authors
    # Format: "Last, Initials." e.g., "Smith, J. and Doe, A."
    authors <- data$author
    author_initials <- sapply(authors$given, function(a) {
      paste(substr(unlist(strsplit(a, " ")), 1, 1), collapse = "")
    })
    author_names <- paste(authors$family, author_initials)
    author_string <- paste(author_names, collapse= ", ")

    # c. Year (Use 'issued' date)
    date_parts <- data$issued$`date-parts`[1,]
    pub_date <- sprintf(
      "%04d-%02d-%02d", date_parts[1], date_parts[2], date_parts[3])

    # If you only need the year for the YAML front matter and file name, use pub_year:
    # pub_year is already set above as date_parts[1]
    pub_year <- date_parts[1]

    # d. Source/Journal (The container-title is usually the journal/preprint server)
    # bioRxiv preprints use "bioRxiv" as the container-title
    journal_name <- data$`container-title`
    if (is.list(journal_name) && length(journal_name) > 0) {
      journal_name <- journal_name[[1]]
    } else if (length(journal_name) == 0) {
      journal_name <- data$institution
      if (is.list(journal_name) && length(journal_name) > 0) {
        journal_name <- journal_name[[1]]
      } else if (length(journal_name) == 0) {
        journal_name <- "Preprint Server" # Fallback
      }
    }

    # e. External URL (The official DOI link)
    doi_link <- paste0("https://doi.org/", doi)
    external_url <- doi_link # For the field 'doi' in the YAML

    # f. DOI (Original DOI for convenience)
    doi_full <- data$DOI # Stored for reference, though used in doi_link

    # 3. Determine the Filename Slug (year-author_key)

    # Get the last name of the first author for the author_key
    first_author_family <- author_names[1]
    # Convert to lowercase and replace non-alphabetic chars with '-'
    first_author_key <- tolower(gsub("[^a-zA-Z]", "-", first_author_family))

    # 4. Check the uniqueness of the base slug (Logic remains the same)
    first_author_key_temp <- first_author_key
    i <- 1
    while (i < 26) {
      base_slug <- paste(pub_year, first_author_key_temp, sep="-")
      filename <- paste0(base_slug, ".md")
      filepath <- file.path(output_dir, filename)

      if (!file.exists(filepath)) {
        first_author_key <- first_author_key_temp
        break
      }
      if (i == 1) {
        warning("WARNING: Potential filename conflict detected. The 'author_key' must be changed.\n")
      }
      i <- i + 1
      first_author_key_temp <- paste(first_author_key, letters[i], sep="-")
      base_slug <- paste(pub_year, first_author_key_temp)
    }

    # 5. Assemble YAML Front Matter

    front_matter_reference <- list(
      layout = "reference",
      title = article_title,
      author = author_string,
      pub_date = pub_date,
      year = as.integer(pub_year),
      author_key = first_author_key,
      source = journal_name,
      doi = doi_link, # This now correctly holds the DOI link
      last_modified = format(Sys.Date(), "%Y-%m-%d"),
      editor_comment = ""
    )

    yaml_string <- as.yaml(front_matter_reference, column.major = FALSE)

    # 6. Create Markdown Content (remains the same)
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
    cat(paste("ERROR processing DOI", doi, ":", conditionMessage(e), "\n"))
  })
}

# --- EXAMPLE USAGE ---
# 1. MAKE SURE YOU HAVE CREATED THE FOLDER: _references/
# 2. Then, run the function with a known bioRxiv DOI:

# Example bioRxiv DOI (change as needed):
# create_ref_from_doi("10.1101/2025.09.24.678276")

doi = "10.1101/2025.09.24.678276"
