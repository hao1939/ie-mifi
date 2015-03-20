require File.expand_path('../../client_log.rb', __FILE__)

class LogRequest < MifiRequest
  def save_card_log
    ClientLog.create(:user => user,
      :card_binding => user.card_bindings.first,
      :client_time => client_time,
      :text => text)
  end

  def client_time
    @data[2].unpack('H*')[0]
  end

  def text
    @data[4]
  end
end
