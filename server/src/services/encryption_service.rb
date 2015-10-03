class EncryptionService
  def initialize
    @client_des_map = {}
  end

  def new_client_des(client)
    password = gen_random_password
    des = Des.new password
    @client_des_map[client] = des
    des
  end

  def get_des(client)
    @client_des_map[client]
  end

  def delete_client_des(client)
    @client_des_map.delete client
  end

  def puts_data(client, data)
    des = get_des client
    client.puts(des.encrypt(data) + "\n") unless des.nil?
  end

  private

  def gen_random_password
    [*('a'..'z'),*('A'..'Z'),*(0..9)].shuffle[0..9].join
  end
end