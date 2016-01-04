module GemFresh
  class ConfigFile

    def self.require_gemfresh
      begin
        @@file = File.open(ENV['gemfresh_path'])
      rescue TypeError # ENV['gemfresh_path'] is nil
        @@file = nil
      end

      require @@file.to_path unless @@file.nil?
    end

    def self.file
      @@file
    end
  end
end
