module LogsTF

  class Log

    attr_accessor :file, :map_name, :title, :api_key

    def initialize(file, map_name = "", title = "", api_key = LogsTF::API_KEY)
      @file     = file
      @map_name = map_name
      @title    = title
      @api_key  = api_key
    end

    def filename
      File.basename(file)
    end

  end

end
