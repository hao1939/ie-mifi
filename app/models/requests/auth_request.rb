require_relative './mifi_request.rb'
class AuthRequest < MifiRequest
  def auth_req
    @data[2]
  end
end
