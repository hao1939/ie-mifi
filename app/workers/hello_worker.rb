class HelloWorker
  include ::Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => false, :backtrace => true

  def perform
    puts 'hello'
  end
end
