jQuery ->
  $('#auction_product_id').change ->   
    url = "/admin/image-selector/#{$('#auction_product_id')[0].value}"
    $.get url, null, (res, status)->
      $('#image-selector').html(res)

$ ->
  PrivatePub.subscribe '/auctions/update', (data, channel) ->    
    $('#auction-' + data.auction_id + ' .time-left').html(data.time_left)    

  $(".button_to").bind "ajax:success", (evt, data, status, xhr) ->
    data = JSON.parse(xhr.responseText)
    if data.notice
      #old_alerts = $('#alets').children()
      #old_alerts.slideUp 600, -> old_alerts.remove()
      $('#alets').prepend("<div style=\"display: none;\">#{data.notice}</div")
      $('#alets').children().slideDown(1000)