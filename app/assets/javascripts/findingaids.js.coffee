$ ->
  # Hide search fields if url specifies repository
  if $("#repository_header").html() != ""
    $("#search_field").hide()

  $('a[data-remote=true]').click ->
    $('#ajax-modal .modal-content').html($('<div />').addClass('modal-header').append($('<h3 />').addClass('modal-title').html($(this).html())))
    $('#ajax-modal .modal-header').prepend($('<button />').attr({type: 'button', class: 'close', 'data-dismiss': 'modal'}).html('&times;'))
    $('#ajax-modal .modal-content').append($('<div />').addClass('modal-body').load($(this).attr('href')))
    $('#ajax-modal').modal()

  # Change default label of "All Libraries" to "All Fields" for advanced search
  $(".advanced-search-field label[for='all_fields']").html("All Fields")
  # Hack the Format to be the top facet in advance search and automatically uncollapsed
  # Doing this here because I don't wanna override the view
  $("#advanced_search_facets").find(".advanced-facet-limits.panel-group").prepend($(".blacklight-format_sim"))
  $("#advanced_search_facets").find("#facet-format_sim").collapse()
