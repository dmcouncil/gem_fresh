module GemFresh
  class GemVersion
    attr_reader :major, :minor, :patch

    # version_string is usually formatted like 7.6.2, but could be
    # 7.6.2.11, 7.6, or even 7.6.2.beta. We just care about the first
    # three numbers
    def initialize(version_string)
      begin
        @major, @minor, @patch = version_string.split('.').map(&:to_i)
        @patch ||= 0
      rescue NoMethodError
        @major, @minor, @patch = [0,0,0]
      end
    end
  end
end
