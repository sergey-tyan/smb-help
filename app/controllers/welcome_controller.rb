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
    range = "Sheet1!A:H"
    response = service.get_spreadsheet_values spreadsheet_id, range
    
    puts "No data found." if response.values.empty?
    @smbs = [];
    headers = []
    @categories = []
    response.values.each_with_index do |row, index|
      if index == 0
        headers = row
        puts "headers #{headers}"
      else
        smb = {}
        approved = false
        headers.each_with_index do |header, index|
          if header == 'approved'
            approved = (row[index] == 'y')
            puts "approved #{approved}"
          end
          if header == 'Категории'
            cats = row[index].split(',')
            cats.each do |cat|
              if !@categories.include? cat.strip
                @categories << cat.strip
              end
            end
          end
          smb[header] = row[index]
        end
        @smbs.push(smb) if approved
      end
    end
    puts @categories
    puts @smbs
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
