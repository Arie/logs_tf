require 'spec_helper'
require 'pry-nav'

module LogsTF

  describe Upload do

    let(:file)        { File.open(File.expand_path('../../fixtures/logs/broder_vs_epsilon.log', __FILE__)) }
    let(:log)         { Log.new(file, "cp_granlands", "qux") }
    let(:logs_tf_url) { 'http://213.216.248.72:3000' }
    let(:upload)      { Upload.new(log, logs_tf_url ) }


    vcr_options = { :cassette_name => "upload", :record => :none, :match_requests_on => [:method, :uri] }
    context "uploading logfiles", :vcr => vcr_options do

      describe "#send" do

        it "knows the status of the request" do
          upload.send
          expect(upload).to be_request_success
        end

        it "knows if tf.logs was able to parse the log" do
          upload.send
          expect(upload).to be_upload_success
        end

        it "knows the log's location after sending" do
          upload.send
          expect(upload.url).to eql "#{logs_tf_url}/91"
        end

        it "raises the appropriate error when upload was unsuccessful" do
          expect(upload).to receive(:connection).and_return(double(:connection).as_null_object)
          expect(upload).to receive(:request_success?).and_return(true)
          expect(upload).to receive(:upload_success?).and_return(false)
          expect(upload).to receive(:raise_logs_tf_error)
          upload.send
        end

        it "raises an error when the response status is not 200" do
          expect(upload).to receive(:connection).and_return(double(:connection).as_null_object)
          expect(upload).to receive(:request_success?).and_return(false)
          expect{upload.send}.to raise_error Upload::RequestError
        end

      end

      describe '#error' do
        before { expect(upload).to receive(:response).and_return(double(body: '{ "error": "foobar" }')) }

        it "parses the JSON respone from logs.tf for the error message" do
          expect(upload.error).to eql 'foobar'
        end

      end

      describe '#raise_logs_tf_error' do

        before { expect(upload).to receive(:response).and_return(double(body: '{ "error": "foobar" }')) }

        it "raises InvalidLogError" do
          expect(upload).to receive(:error).and_return("Invalid log file")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::InvalidLogError
        end

        it "raises MissingLogError" do
          expect(upload).to receive(:error).and_return("No file")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::MissingLogError
        end

        it "raises NotAuthenticatedError" do
          expect(upload).to receive(:error).and_return("Not authenticated")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::NotAuthenticatedError
        end

        it "raises InvalidAPIKeyError" do
          expect(upload).to receive(:error).and_return("Invalid API key")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::InvalidAPIKeyError
        end

        it "raises NoValidRoundsError" do
          expect(upload).to receive(:error).and_return("Log has no valid rounds (at least one needed)")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::NoValidRoundsError
        end

        it "raises NotEnoughPlayersError" do
          expect(upload).to receive(:error).and_return("Not enough players (2 needed)")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::NotEnoughPlayersError
        end

        it "raises LogIsEmptyError" do
          expect(upload).to receive(:error).and_return("Log is empty")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::LogIsEmptyError
        end

        it "raises ParsingFailedError" do
          expect(upload).to receive(:error).and_return("Parsing failed in line 123")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::ParsingFailedError

          expect(upload).to receive(:error).and_return("Parsing failed in line 456")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::ParsingFailedError
        end

        it "raises MissingAPIKeyOrLoginError" do
          expect(upload).to receive(:error).and_return("Missing API key or login")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::MissingAPIKeyOrLoginError
        end

        it "raises GuruMeditationError" do
          expect(upload).to receive(:error).and_return("Guru Meditation")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::GuruMeditationError
        end

        it "raises UnknownLogsTFError" do
          expect(upload).to receive(:error).and_return("Foobar")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::UnknownLogsTfError
        end

      end

    end

  end

end
