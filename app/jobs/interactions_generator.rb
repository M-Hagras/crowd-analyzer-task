class InteractionsGenerator < ApplicationJob
  require 'aws-sdk-sqs'
  @@credentials = Aws::Credentials.new(ENV.fetch('SQQ_ACCESS_KEY'), ENV.fetch('SQQ_SECRET'))
  @@sqs = Aws::SQS::Client.new(region: 'us-east-1', credentials: @@credentials)

  def self.generate
    data = {
      "id": rand(9999999999),
      "organization_id": "601a6fc90638651eff8350a8",
      "type": "post",
      "source": "facebook",
      "link": "https://facebook.com/fake-post",
      "username": "faker fake",
      "engagements": {
        "likes": rand(500),
        "love": rand(500),
        "haha": rand(500),
        "angry": rand(500)
      }
    }
    @@sqs.send_message(queue_url: ENV.fetch('SQS_URL'), message_body: data.to_json)
  end
end