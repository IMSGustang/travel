module PusherHelper
  def self.push(channel, event, content)
    pusher_client = Pusher::Client.new(
        app_id: ENV['PUSH_APP_ID'],
        key: ENV['PUSH_APP_KEY'],
        secret: ENV['PUSH_APP_SECRET'],
        cluster: ENV['PUSH_APP_CLUSTER']
    )
    # pusher_client.trigger('dashboard-abutours', 'my-event', {:title => 'Tes', :message => 'Transaksi Pulsa'})
    pusher_client.trigger(channel, event, content)
  end
end
