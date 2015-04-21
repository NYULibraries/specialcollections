$ ->
  # Show library facet by default
  unless $("#facets").find("#facet-repository_sim").is(":visible")
    $("#facets").find("#facet-repository_sim").addClass("in")
    $("#facets").find(".blacklight-repository_sim").find(".panel-heading.collapse-toggle.collapsed").removeClass("collapsed")

  $('a[data-remote=true]').click ->
    $('#ajax-modal .modal-content').html($('<div />').addClass('modal-header').append($('<h3 />').addClass('modal-title').html($(this).html())))
    $('#ajax-modal .modal-header').prepend($('<button />').attr({type: 'button', class: 'close', 'data-dismiss': 'modal'}).html('&times;'))
    $('#ajax-modal .modal-content').append($('<div />').addClass('modal-body').load($(this).attr('href')))
    $('#ajax-modal').modal()

  # Hack the Format to be the top facet in advance search and automatically uncollapsed
  # Doing this here because I don't wanna override the view
  $("#advanced_search_facets").find(".advanced-facet-limits.panel-group").prepend($(".blacklight-format_sim"))

  # Open certain facets by default
  unless $("#advanced_search_facets").find("#facet-format_sim").is(":visible")
    $("#advanced_search_facets").find("div[data-target='#facet-format_sim']").trigger("click")
