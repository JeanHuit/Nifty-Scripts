

  
  
#   # main.rb
#   require_relative 'server'
#   require_relative 'client'
  
#   # Simulated data points (x, y)
#   data = [
#     [1, 2],
#     [2, 4],
#     [3, 6],
#     [4, 8],
#     [5, 10]
#   ]
  
#   server = Server.new
#   clients = []
  
#   # Create and initialize client instances
#   data.each do |x, y|
#     client = Client.new([[x, y]])
#     clients << client
#   end
  
#   # Federated Learning loop
#   10.times do |round|
#     clients.each do |client|
#       client.train
#     end
  
#     client_updates = clients.map(&:update_server)
#     server.aggregate(client_updates)
  
#     puts "Round #{round + 1} - Global Model: Slope: #{server.global_model[:slope]}, Intercept: #{server.global_model[:intercept]}"
#   end
  

# require_relative 'server'
# require_relative 'client'

# # Simulated data points (x, y)
# data = [
#   [1, 2],
#   [2, 4],
#   [3, 6],
#   [4, 8],
#   [5, 10]
# ]

# NUM_CLIENTS = 5
# NUM_ROUNDS = 10

# server = Server.new
# clients = []

# # Create and initialize client instances
# data_per_client = data.each_slice(data.length / NUM_CLIENTS).to_a
# data_per_client.each do |client_data|
#   client = Client.new(client_data)
#   clients << client
# end

# # Federated Learning loop
# NUM_ROUNDS.times do |round|
#   clients.each do |client|
#     client.train
#   end

#   client_updates = clients.map(&:update_server)
#   server.aggregate(client_updates)

#   puts "Round #{round + 1} - Global Model: Slope: #{server.global_model[:slope]}, Intercept: #{server.global_model[:intercept]}"
# end


require_relative 'server'
require_relative 'client'

# Simulated data points (x, y)
data = [
  [1, 2],
  [2, 4],
  [3, 6],
  [4, 8],
  [5, 10]
]

NUM_CLIENTS = 5
NUM_ROUNDS = 10

server = Server.new
server_thread = Thread.new { server.start }

clients = []
data_per_client = data.each_slice(data.length / NUM_CLIENTS).to_a

# Create and initialize client instances
data_per_client.each do |client_data|
  client = Client.new(client_data)
  clients << client
end

# Federated Learning loop
NUM_ROUNDS.times do |round|
  clients.each do |client|
    client.train
    client.send_update
  end

  puts "Round #{round + 1} - Global Model: Slope: #{server.global_model[:slope]}, Intercept: #{server.global_model[:intercept]}"
end

server_thread.join
