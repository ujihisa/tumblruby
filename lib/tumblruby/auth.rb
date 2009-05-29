class Tumblruby
  class Auth
    def initialize email,pass
      auth = Tumblruby::Request.login email,pass
      @user = User.new auth["tumblr"]["user"]
      @tumblelog = Tumblelog.new auth["tumblr"]["tumblelog"]
    end
    attr_reader :user,:tumblelog

    class Template

      def initialize hash
        @hash = hash
        @convert_targets = set_convert_targets
        set_attributes
        convert_attributes
      end

      private

      def set_convert_targets
        {}
      end

      def set_attributes
        @hash.each do |k,v|
          self.send "#{k}=",v
        end
      end

      def convert_attributes
        unless @convert_targets.empty?
          @convert_targets.each do |key,action|
            attribute = self.send key
            unless key.nil?
              if action["class"]
                new_attribute = action["class"].send action["method"],attribute
              else
                new_attribute = attribute.send action["method"]
              end
              self.send "#{key}=",new_attribute
            end
          end
        end
      end
    end

    class Tumblelog < Template
      attr_accessor :title,:type,:private_id,:name,:url,:avatar_url,:is_primary

      def primary?
        if @is_primary == "yes"
          true
        else
          false
        end
      end
      
      private

      def set_convert_targets
        {
          "type" => {"method" => "to_sym"},
          "private_id" => {"method" => "to_i"},
          "url" => {"class" => URI,"method" => "parse"},
          "avatar_url" => {"class" => URI,"method" => "parse"}
        }
      end
    end

    class User < Template
      attr_accessor :default_post_format,:can_upload_audio,:can_upload_aiff,:can_upload_video,:vimeo_login_url,:max_video_bytes_uploaded

      private

      def set_convert_targets
        {
          "can_upload_audio" => {"method" => "to_i"},
          "can_upload_aiff" => {"method" => "to_i"},
          "can_upload_video" => {"method" => "to_i"},
          "vimeo_login_url" => {"class" => URI,"method" => "parse"},
          "max_video_bytes_uploaded" => {"method" => "to_i"}
        }
      end
    end

  end
end
