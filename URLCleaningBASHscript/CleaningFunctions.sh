#!/bin/bash

backup_original_file() {
  cp "$1" "$2"
}

count_lines() {
  wc -l < "$1"
}

remove_lines_without_protocol() {
  grep '://' "$1" > "$2.tmp"
  mv "$2.tmp" "$2"
}

remove_duplicates() {
  sort "$1" | uniq > "$1.tmp"
  mv "$1.tmp" "$1"
}

remove_lines_with_colons() {
  grep -vE '::+' "$1" > "$1.tmp"
  mv "$1.tmp" "$1"
}

remove_lines_start_end_colon() {
  sed '/^:.*:$/d' "$1" > "$1.tmp"
  mv "$1.tmp" "$1"
}

remove_empty_lines() {
  grep -vE '^$' "$1" > "$1.tmp"
  mv "$1.tmp" "$1"
}

normalize_urls() {
  awk '{print tolower($0)}' "$1" | sed 's:/*$::' > "$1.tmp"
  mv "$1.tmp" "$1"
}

validate_urls() {
  grep -E '^https?://[a-zA-Z0-9.-]+(/[a-zA-Z0-9./?%&=-]*)?$' "$1" > "$1.tmp"
  mv "$1.tmp" "$1"
}

remove_specific_extensions() {
  grep -vE '\.(jpg|jpeg|png|gif|pdf|docx|xlsx)$' "$1" > "$1.tmp"
  mv "$1.tmp" "$1"
}

sort_lines_by_url_part() {
  awk -F'://' '{print $2, $0}' "$1" | sort | cut -d' ' -f2- > "$1.tmp"
  mv "$1.tmp" "$1"
}
