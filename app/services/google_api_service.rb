class GoogleApiService
  def self.authorize
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(ENV['GOOGLE_APPLICATION_CREDENTIALS']),
      scope: ['https://www.googleapis.com/auth/spreadsheets',
              'https://www.googleapis.com/auth/documents',
              'https://www.googleapis.com/auth/drive']
    )
  end

  def self.get_drive_service
    drive_service = Google::Apis::DriveV3::DriveService.new
    drive_service.authorization = self.authorize
    drive_service
  end

  def self.get_sheets_service
    sheets_service = Google::Apis::SheetsV4::SheetsService.new
    sheets_service.authorization = self.authorize
    sheets_service
  end

  def self.get_document(document_id)
    docs_service = Google::Apis::DocsV1::DocsService.new
    docs_service.authorization = self.authorize
    docs_service.get_document(document_id)
  end
end