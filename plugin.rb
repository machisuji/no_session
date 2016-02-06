# name: no_session
# about: it's a hack, really
# version: 0.0.1
# authors: Markus Kahl

after_initialize do
  module NOSession
    def self.domain
      @domain ||= String(ENV['DISCOURSE_HOSTNAME']).scan(/^.+?\.(.+)/).flatten.last
    end

    def set_current_user_for_logs
      super

      if current_user
        cookies[:no_session] = {
          value: "#{current_user.id}:#{current_user.no_session_salt}",
          domain: NOSession.domain
        }
      elsif cookies.include? :no_session
        cookies.delete :no_session, domain: NOSession.domain
      end
    end
  end

  ApplicationController.send :prepend, NOSession
end
