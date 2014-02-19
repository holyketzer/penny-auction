jQuery ->
  $('#auction_product_id').change ->   
    url = "/admin/image-selector/#{$('#auction_product_id')[0].value}"
    $.get url, null, (res, status)->
      $('#image-selector').html(res)

$ ->
  PrivatePub.subscribe '/auctions/update', (data, channel) ->    
    $('#auction-' + data.auction_id + ' .time-left').html(data.time_left).effect("highlight", {}, 2000);
    $('#auction-' + data.auction_id + ' .price').html(data.price).effect("highlight", {}, 2000);

  $(".button_to").bind "ajax:success", (evt, data, status, xhr) ->
    data = JSON.parse(xhr.responseText)
    if data.notice
      old_alerts = $('#alets').children().remove()
      $('#alets').prepend(data.notice)
      $('#alets').children().effect("highlight", {}, 2000);

  $(".button_to").bind "ajax:error", (event, jqXHR, ajaxSettings, thrownError) ->
    if jqXHR.status == 401 # thrownError is 'Unauthorized'
      window.location.replace('/users/sign_in')