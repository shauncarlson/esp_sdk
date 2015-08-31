module ESP
  class Dashboard < ESP::Resource
    def self.recent
      # call find_every directly since find is overriden/not implemented
      find_every from: "#{prefix}dashboard/recent.#{format.extension}"
    end

    def self.timewarp(start_of_window)
      raise ArgumentError, "expected a start time" unless start_of_window.present? && start_of_window.is_a?(Time)
      # call find_every directly since find is overriden/not implemented
      find_every(from: "#{prefix}dashboard/timewarp.#{format.extension}", params: { filter: { time: start_of_window.to_i } })
    end

    def self.find(*)
      fail ESP::NotImplemented, 'Regular ARELlike methods are disabled.  Use either the .recent or .timewarp method.'
    end

    def save
      fail ESP::NotImplemented
    end

    def destroy
      fail ESP::NotImplemented
    end
  end
end
