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
    # '1' + [1] + [2] + [3], notice [1/2/3] have one byte for length
    i = 4 + @data[1].length + @data[2].length + @data[3].length
    @text ||= @raw[i..-1]
  end
end
