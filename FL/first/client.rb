
#   # client.rb
#   class Client
#     attr_accessor :local_data, :local_model
  
#     def initialize(local_data)
#       @local_data = local_data
#       @local_model = { slope: 1.0, intercept: 0.0 }
#     end
  
#     def train
#       @local_data.each do |x, y|
#         predicted = @local_model[:slope] * x + @local_model[:intercept]
#         error = predicted - y
  
#         # Gradient descent update
#         @local_model[:slope] -= 0.01 * error * x
#         @local_model[:intercept] -= 0.01 * error
#       end
#     end
  
#     def update_server
#       { slope: @local_model[:slope], intercept: @local_model[:intercept] }
#     end
#   end

# class Client
#     attr_accessor :local_data, :local_model
  
#     def initialize(local_data)
#       @local_data = local_data
#       @local_model = { slope: 1.0, intercept: 0.0 }
#     end
  
#     def train
#       @local_data.each do |x, y|
#         predicted = @local_model[:slope] * x + @local_model[:intercept]
#         error = predicted - y
  
#         # Gradient descent update
#         @local_model[:slope] -= 0.01 * error * x
#         @local_model[:intercept] -= 0.01 * error
#       end
#     end
  
#     def update_server
#       { slope: @local_model[:slope], intercept: @local_model[:intercept] }
#     end
#   end
  
require 'socket'

class Client
  attr_accessor :local_data, :local_model

  def initialize(local_data)
    @local_data = local_data
    @local_model = { slope: 1.0, intercept: 0.0 }
  end

  def train
    @local_data.each do |x, y|
      predicted = @local_model[:slope] * x + @local_model[:intercept]
      error = predicted - y

      # Gradient descent update
      @local_model[:slope] -= 0.01 * error * x
      @local_model[:intercept] -= 0.01 * error
    end
  end

  def update_server
    { slope: @local_model[:slope], intercept: @local_model[:intercept] }
  end

  def send_update
    client = TCPSocket.new('localhost', 8082)
    client.puts(Marshal.dump(update_server))
    ack = client.gets.chomp
    client.close if ack == "ACK"
  end
end
