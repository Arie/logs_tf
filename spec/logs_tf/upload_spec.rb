require 'spec_helper'

module LogsTF

  describe Upload do

    let(:file)        { File.open(File.expand_path('../../fixtures/logs/broder_vs_epsilon.log', __FILE__)) }
    let(:log)         { Log.new(file, "cp_granlands", "qux") }
    let(:logs_tf_url) { 'http://213.216.248.72:3000' }
    let(:upload)      { Upload.new(log, logs_tf_url ) }


    vcr_options = { :cassette_name => "upload", :record => :new_episodes, :match_requests_on => [:method, :uri, :body] }
    context "uploading logfiles", :vcr => vcr_options do

      describe "#send" do

        it "knows the status of the request" do
          upload.send
          upload.should be_request_success
        end

        it "knows if tf.logs was able to parse the log" do
          upload.send
          upload.should be_upload_success
        end

        it "knows the log's location after sending" do
          upload.send
          upload.url.should == "#{logs_tf_url}/91"
        end

        it "raises the appropriate error when upload was unsuccessful" do
          upload.stub(:connection => double(:connection).as_null_object)
          upload.stub(:request_success? => true)
          upload.stub(:upload_success? => false)
          upload.should_receive(:raise_logs_tf_error)
          upload.send
        end

        it "raises an error when the response status is not 200" do
          upload.stub(:connection => double(:connection).as_null_object)
          upload.stub(:request_success? => false)
          expect{upload.send}.to raise_error Upload::RequestError
        end

      end

      describe '#error' do
        before { upload.stub(:response => double(:body => '{ "error": "foobar" }')) }

        it "parses the JSON respone from logs.tf for the error message" do
          upload.error.should == 'foobar'
        end

      end

      describe '#raise_logs_tf_error' do

        before { upload.stub(:response => double(:body => '{ "error": "foobar" }')) }

        it "raises InvalidLogError" do
          upload.stub(:error => "Invalid log file")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::InvalidLogError
        end

        it "raises MissingLogError" do
          upload.stub(:error => "No file")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::MissingLogError
        end

        it "raises NotAuthenticatedError" do
          upload.stub(:error => "Not authenticated")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::NotAuthenticatedError
        end

        it "raises InvalidAPIKeyError" do
          upload.stub(:error => "Invalid API key")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::InvalidAPIKeyError
        end

        it "raises NoValidRoundsError" do
          upload.stub(:error => "Log has no valid rounds (at least one needed)")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::NoValidRoundsError
        end

        it "raises NotEnoughPlayersError" do
          upload.stub(:error => "Not enough players (2 needed)")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::NotEnoughPlayersError
        end

        it "raises LogIsEmptyError" do
          upload.stub(:error => "Log is empty")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::LogIsEmptyError
        end

        it "raises ParsingFailedError" do
          upload.stub(:error => "Parsing failed in line 123")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::ParsingFailedError

          upload.stub(:error => "Parsing failed in line 456")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::ParsingFailedError
        end

        it "raises MissingAPIKeyOrLoginError" do
          upload.stub(:error => "Missing API key or login")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::MissingAPIKeyOrLoginError
        end

        it "raises GuruMeditationError" do
          upload.stub(:error => "Guru Meditation")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::GuruMeditationError
        end

        it "raises UnknownLogsTFError" do
          upload.stub(:error => "Foobar")
          expect{upload.raise_logs_tf_error}.to raise_error Upload::UnknownLogsTfError
        end

      end

    end

  end

end
