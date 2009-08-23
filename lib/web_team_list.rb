require 'web_data'
class WebTeamList < WebData
  attr_accessor :response, :site

  def initialize(site="jhowell")
    @site=site
    get_response
  end

  def url
    case site
      when "jhowell"
      return "http://www.jhowell.net/cf/scores/byName.htm"
      else
        raise InvalidArgumentError
    end
  end

  def html_list
    (@response/"p[4]")
  end

end
