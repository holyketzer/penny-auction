class AuctionsController < InheritedResources::Base
  respond_to :html, :only => [:index, :show]
end