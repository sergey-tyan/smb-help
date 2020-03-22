require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

class WelcomeController < ApplicationController
  def index
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize
    spreadsheet_id = ENV['SPREADSHEET_ID']
    range = "Sheet1!A2:G"
    response = service.get_spreadsheet_values spreadsheet_id, range
    
    puts "No data found." if response.values.empty?
    response.values.each do |row|
      @asdasd = row[0]
    end
  end

  private
  def authorize
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    credentials
  end

end
