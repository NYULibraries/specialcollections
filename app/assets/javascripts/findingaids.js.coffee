$ ->
  # Hide search fields if url specifies repository
  if $("#repository_header").html() != ""
    $("#search_field").hide()

  $('a[data-remote=true]').click ->
    $('#ajax-modal .modal-content').html($('<div />').addClass('modal-header').append($('<h3 />').addClass('modal-title').html($(this).html())))
    $('#ajax-modal .modal-header').prepend($('<button />').attr({type: 'button', class: 'close', 'data-dismiss': 'modal'}).html('&times;'))
    $('#ajax-modal .modal-content').append($('<div />').addClass('modal-body').load($(this).attr('href')))
    $('#ajax-modal').modal()
