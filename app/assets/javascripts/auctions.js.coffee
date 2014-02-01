jQuery ->
  $('#auction_product_id').change ->   
    url = "/admin/products/#{$('#auction_product_id')[0].value}/images-selector"    
    $.get url, null, (res, status)->
      $('#auction_image_id').html(res)
    