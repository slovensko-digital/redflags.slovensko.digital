class ApplicationJob < ActiveJob::Base
  # Google APIs give the reason of a failed request only in the body of the response,
  # the error says just "Invalid request". Keep the reason in the error of the job.
  rescue_from Google::Apis::ClientError do |error|
    raise error if error.body.blank?

    detailed_error = error.class.new("#{error.message}: #{error.body}", status_code: error.status_code, header: error.header, body: error.body)
    detailed_error.set_backtrace(error.backtrace)
    raise detailed_error
  end

  # Que retried failed jobs, GoodJob does not by itself. Retry the errors of Google APIs that it marks as
  # temporary (rate limits, errors of its servers, timeouts), a few times within minutes. Declared after the
  # handler above, so it handles the timeout, which is a ClientError, first.
  retry_on(*Google::Apis::Core::HttpCommand::RETRIABLE_ERRORS, wait: :polynomially_longer, attempts: 5)
end
