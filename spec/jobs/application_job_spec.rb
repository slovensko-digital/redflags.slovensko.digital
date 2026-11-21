require 'rails_helper'

RSpec.describe ApplicationJob do
  let(:job_class) do
    Class.new(ApplicationJob) do
      def perform(body)
        raise Google::Apis::ClientError.new('Invalid request', status_code: 400, body: body)
      end
    end
  end

  it 'adds the reason from Google to the error of the job' do
    body = '{"error":{"code":400,"message":"Unable to parse range: Hárok1!A5:BX5","status":"INVALID_ARGUMENT"}}'

    expect { job_class.perform_now(body) }.to raise_error(Google::Apis::ClientError, /Invalid request: .*Unable to parse range: Hárok1!A5:BX5/) do |error|
      expect(error.status_code).to eq(400)
      expect(error.backtrace.first).to include('application_job_spec.rb')
    end
  end

  it 'keeps the error without a body as it is' do
    expect { job_class.perform_now(nil) }.to raise_error(Google::Apis::ClientError, 'Invalid request')
  end
end
