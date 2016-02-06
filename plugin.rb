# name: no_session
# about: it's a hack, really
# version: 0.0.1
# authors: Markus Kahl

after_initialize do
  module NOSession
    def set_current_user_for_logs
      super
      cookies[:no_session] = {
        value: "#{current_user.id}:#{current_user.no_session_salt}",
        domain: String(ENV['DISCOURSE_HOSTNAME']).scan(/^.+?\.(.+)/).flatten.last,
        secure: true
      }
    end
  end

  ApplicationController.prepend NOSession
end
