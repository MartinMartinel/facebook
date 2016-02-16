require 'opal'
require 'opal_ujs'
require 'greeter'
require 'jquery'
require 'jquery_ujs'
require 'bootstrap-sprockets'
require 'turbolinks'
require_tree '.'

class Timeout
  def initialize(time=0, &block)
    `setTimeout(function(){#{block.call}}, time)`
  end
end

Element.expose :slideDown
Element.expose :slideUp




