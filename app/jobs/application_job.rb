class ApplicationJob < ActiveJob::Base
  # Google APIs give the reason of a failed request only in the body of the response,
  # the error says just "Invalid request". Keep the reason in the error of the job.
  rescue_from Google::Apis::ClientError do |error|
    raise error if error.body.blank?

    detailed_error = error.class.new("#{error.message}: #{error.body}", status_code: error.status_code, header: error.header, body: error.body)
    detailed_error.set_backtrace(error.backtrace)
    raise detailed_error
  end
end
