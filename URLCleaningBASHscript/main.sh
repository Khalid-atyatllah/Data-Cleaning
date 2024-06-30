#!/bin/bash

# Define the input and output files
input_file="part_as"
output_file="cleaned_sorted.txt"
backup_file="${input_file}.bak"

# Source the function scripts
source ./functions.sh

# Main script execution
main() {
  backup_original_file "$input_file" "$backup_file"

  initial_lines=$(count_lines "$input_file")
  echo "Lines before cleaning: $initial_lines"

  remove_lines_without_protocol "$input_file" "$output_file"
  lines_with_protocol=$(count_lines "$output_file")
  echo "Lines after removing lines without '://': $lines_with_protocol"

  remove_duplicates "$output_file"
  duplicates_lines=$(count_lines "$output_file")
  echo "Lines after removing duplicates: $duplicates_lines"

  remove_lines_with_colons "$output_file"
  lines_with_colons_removed=$(count_lines "$output_file")
  removed_lines=$(($duplicates_lines - $lines_with_colons_removed))
  echo "Lines removed containing '::' or more: $removed_lines"

  remove_lines_start_end_colon "$output_file"
  lines_start_end_colon_removed=$(count_lines "$output_file")
  echo "Lines removed that start and end with a colon: $(($lines_with_colons_removed - $lines_start_end_colon_removed))"

  remove_empty_lines "$output_file"
  normalize_urls "$output_file"
  validate_urls "$output_file"
  remove_specific_extensions "$output_file"

  final_lines=$(count_lines "$output_file")
  echo "Lines after removing empty lines: $final_lines"

  sort_lines_by_url_part "$output_file"

  echo "Sorting complete. Cleaned and sorted data saved to $output_file"
}

# Execute the main function
main
