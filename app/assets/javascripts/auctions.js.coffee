jQuery ->
  $('#auction_product_id').change ->   
    url = "/admin/image-selector/#{$('#auction_product_id')[0].value}"
    $.get url, null, (res, status)->
      $('#image-selector').html(res)