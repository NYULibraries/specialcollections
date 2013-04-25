$ ->
  # Hide search fields if url specifies repository
  if $("#repository_header").html() != ""
    $("#search_field").hide()