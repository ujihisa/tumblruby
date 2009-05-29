$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require 'tumblruby'
require 'rubygems'
require 'pit'

describe Tumblruby do
  before(:all) do
    conf = Pit.get "tumblr"
    @email = conf["email"]
    @pass = conf["pass"]
    @tum = Tumblruby.new @email,@pass
  end

  describe '.new' do
    it 'get user attributes' do
      @tum.auth.user.can_upload_audio.should be_instance_of Fixnum
      @tum.auth.user.can_upload_aiff.should be_instance_of Fixnum
      @tum.auth.user.can_upload_video.should be_instance_of Fixnum
      @tum.auth.user.default_post_format.should be_instance_of String
      @tum.auth.user.vimeo_login_url.should be_instance_of URI::HTTP
    end

    it 'get tumblelog attributes' do
      @tum.auth.tumblelog.title.should be_instance_of String
      @tum.auth.tumblelog.type.should be_instance_of Symbol
      @tum.auth.tumblelog.name.should be_instance_of String
      if @tum.auth.tumblelog.type == :public
        @tum.auth.tumblelog.url.should be_instance_of URI::HTTP
        @tum.auth.tumblelog.avatar_url.should be_instance_of URI::HTTP
        @tum.auth.tumblelog.primary?.should_not == nil
      end
    end
  end
end
