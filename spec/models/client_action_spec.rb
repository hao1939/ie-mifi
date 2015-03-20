describe ClientAction do
  it 'mark as delivered' do
    client_action = ClientAction.create

    assert !client_action.delivered?
    client_action.mark_delivered!
    assert client_action.delivered?
  end
end
