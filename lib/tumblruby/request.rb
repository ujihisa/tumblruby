class Tumblruby
  class Request
    API_URI = "http://www.tumblr.com/api"

    def self.login email,pass
      HTTParty.post "#{API_URI}/authenticate", :query => {:email => email,:password => pass}
    end
  end
end
