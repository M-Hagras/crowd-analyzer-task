class InteractionsConsumer < ApplicationJob
  require 'aws-sdk-sqs'
  @@credentials = Aws::Credentials.new(ENV.fetch('SQQ_ACCESS_KEY'), ENV.fetch('SQQ_SECRET'))
  @@sqs = Aws::SQS::Client.new(region: 'us-east-1', credentials: @@credentials)

  def self.consume
    receive_message_result = @@sqs.receive_message({
                                                     queue_url: ENV.fetch('SQS_URL'),
                                                     message_attribute_names: ["All"], # Receive all custom attributes.
                                                     max_number_of_messages: 10, # Receive at most one message.
                                                     wait_time_seconds: 0 # Do not wait to check for the message.
                                                   })
    receive_message_result.messages.each do |message|
      total_engagements = self.calc_engagements(JSON.parse(message[:body])) if self.authorized_organization? message['organization_id']
      $total = $total.nil? ? total_engagements : $total + total_engagements
      $count = $count.nil? ? 1 : $count + 1
      logger.info("#{$total/$count}")
      @@sqs.delete_message({
                             queue_url: ENV.fetch('SQS_URL'),
                             receipt_handle: message.receipt_handle
                           })
    end
  end

  def self.authorized_organization?(org_id)
    # call third party here
    # Suggestions
    #   1- api call: this gives us on time data, no extra data on our app, but adds time latency, dependent on this api change, how to handle failure
    #   2- migrate view of organization ids and its enable status: in app data, no time latency, but dependent on other service schema
    #   3- having table of organization data and its enable status (update by listen to queue): require the other system to send data through queue, no dependency
    true
  end

  def self.calc_engagements(message)
    total_engagements = 0
    unless message['engagements'].blank?
      logger.info "This is from info"
      total_engagements += (message['engagements']['likes'].is_a? Numeric) && message['engagements']['likes'] > 0 ?
                             message['engagements']['likes'] : 0
      total_engagements += (message['engagements']['love'].is_a? Numeric) && message['engagements']['love'] > 0 ?
                             message['engagements']['love'] : 0
      total_engagements += (message['engagements']['haha'].is_a? Numeric) && message['engagements']['haha'] > 0 ?
                             message['engagements']['haha'] : 0
      total_engagements += (message['engagements']['angry'].is_a? Numeric) && message['engagements']['angry'] > 0 ?
                             message['engagements']['angry'] : 0
    end
    total_engagements
  end
end