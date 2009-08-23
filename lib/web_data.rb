require 'hpricot'
require 'open-uri'

class WebData

  private
  def get_response
    @response = Hpricot(open(url))
  end

end
