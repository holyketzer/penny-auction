jQuery ->
  $('#auction_product_id').change ->   
    url = "/admin/image-selector/#{$('#auction_product_id')[0].value}"
    $.get url, null, (res, status)->
      $('#image-selector').html(res)

$ ->
  PrivatePub.subscribe '/auctions/update', (data, channel) ->
    console.log(data)
    $('#auction-' + data.auction_id + ' .time-left').html(data.time_left)
    if data.notice
      $('#alets').prepend("<div class='alert'>#{data.notice}</div")