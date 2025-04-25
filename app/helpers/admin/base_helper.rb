module Admin
  module BaseHelper
    def admin_timestamp(time)
      return if time.blank?

      time.strftime('%y-%m-%d %H:%M:%S')
    end
  end
end
