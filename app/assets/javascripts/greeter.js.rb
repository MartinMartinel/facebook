Document.ready? do
  Timeout.new(1000) { Element.find('.alert').slideDown(500) }
  Timeout.new(4000) { Element.find('.alert').slideUp(500) }

  # alternative using native JS: `window.setTimeout(function(){$('.alert').slideDown(500);}, 1000); window.setTimeout(function(){$('.alert').slideUp(500);}, 5000);`
end

