require 'faraday'
require 'json'

module LogsTF

  class Upload

    attr_accessor :log, :logs_tf_url, :api_key, :response, :response_body

    def initialize(log, logs_tf_url = 'http://logs.tf')
      @log          = log
      @logs_tf_url  = logs_tf_url
    end

    def send
      @response = connection.post('/upload', post_options)
      if request_success?
        if !upload_success?
          raise_logs_tf_error
        end
      else
        raise RequestError, response.body
      end
    end

    def url
      logs_tf_url + response_body["url"]
    end

    def raise_logs_tf_error
      error_class = case error
      when "Invalid log file"
        InvalidLogError
      when "No file"
        MissingLogError
      when "Not authenticated"
        NotAuthenticatedError
      when "Invalid API key"
        InvalidAPIKeyError
      when "Log has no valid rounds (at least one needed)"
        NoValidRoundsError
      when "Not enough players (2 needed)"
        NotEnoughPlayersError
      when "Log is empty"
        LogIsEmptyError
      when /^Parsing failed in line \d+$/
        ParsingFailedError
      when "Missing API key or login"
        MissingAPIKeyOrLoginError
      when "Guru Meditation"
        GuruMeditationError
      else
        UnknownLogsTfError
      end

      raise error_class, response_body["error"]
    end

    def error
      response_body["error"]
    end

    private

    def response_body
      @response_body ||= JSON.parse(response.body)
    end

    def upload_success?
      response_body["success"] == true
    end

    def request_success?
      response.status == 200
    end

    def post_options
      { :key      => api_key,
        :title    => title,
        :map      => map_name,
        :logfile  => logfile }
    end

    def logfile
      Faraday::UploadIO.new(log.file, "text/plain", log.filename)
    end

    def title
      log.title
    end

    def map_name
      log.map_name
    end

    def api_key
      log.api_key
    end

    def connection
      Faraday.new(:url => logs_tf_url + '/upload') do |conn|
        conn.request :multipart
        conn.request :url_encoded
        conn.adapter :net_http
      end
    end

    class Error < StandardError; end
    class RequestError < Error; end
    class InvalidLogError < Error; end
    class MissingLogError < Error; end
    class NotAuthenticatedError < Error; end
    class InvalidAPIKeyError < Error; end
    class NoValidRoundsError < Error; end
    class NotEnoughPlayersError < Error; end
    class LogIsEmptyError < Error; end
    class ParsingFailedError < Error; end
    class MissingAPIKeyOrLoginError < Error; end
    class GuruMeditationError < Error; end
    class UnknownLogsTfError < Error; end

  end


end
