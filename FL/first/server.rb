# class Server
#     attr_accessor :global_model
  
#     def initialize
#       @global_model = { slope: 0.5, intercept: 2.0 }
#     end
  
#     def aggregate(client_updates)
#       new_slope = 0.0
#       new_intercept = 0.0
  
#       client_updates.each do |update|
#         new_slope += update[:slope]
#         new_intercept += update[:intercept]
#       end
  
#       @global_model[:slope] = new_slope / client_updates.length
#       @global_model[:intercept] = new_intercept / client_updates.length
#     end
#   end


# class Server
#     attr_accessor :global_model
  
#     def initialize
#       @global_model = { slope: 0.5, intercept: 2.0 }
#     end
  
#     def aggregate(client_updates)
#       new_slope = 0.0
#       new_intercept = 0.0
  
#       client_updates.each do |update|
#         new_slope += update[:slope]
#         new_intercept += update[:intercept]
#       end
  
#       @global_model[:slope] = new_slope / client_updates.length
#       @global_model[:intercept] = new_intercept / client_updates.length
#     end
#   end
  

require 'socket'

class Server
  attr_accessor :global_model

  def initialize
    @global_model = { slope: 0.5, intercept: 2.0 }
  end

  def start
    server = TCPServer.new('localhost', 8082)

    loop do
      client = server.accept
      Thread.new(client) do |client_socket|
        handle_client(client_socket)
      end
    end
  end

  def handle_client(client_socket)
    client_data = Marshal.load(client_socket.gets)
    client_socket.puts("ACK")

    aggregate([client_data])
    client_socket.close
  end

  def aggregate(client_updates)
    new_slope = 0.0
    new_intercept = 0.0

    client_updates.each do |update|
      new_slope += update[:slope]
      new_intercept += update[:intercept]
    end

    @global_model[:slope] = new_slope / client_updates.length
    @global_model[:intercept] = new_intercept / client_updates.length
  end
end
