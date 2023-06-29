# def create_file_list(folder_path, output_file)
#   File.open(output_file, 'w') do |file|
#     Dir.foreach(folder_path) do |item|
#       next if item == '.' || item == '..'

#       full_path = File.join(folder_path, item)
#       if File.directory?(full_path)
#         file.puts("[#{item}]")
#         create_file_list(full_path, output_file)
#       else
#         file.puts(item)
#       end
#     end
#   end
# end

# # Usage example
# folder_path = 'qrcodes/test/good'
# output_file = 'test.txt'
# create_file_list(folder_path, output_file)


def create_file_list(folder_path, output_file, prefix = '')
  File.open(output_file, 'a') do |file| # Open the file in append mode ('a')
    Dir.foreach(folder_path) do |item|
      next if item == '.' || item == '..'

      full_path = File.join(folder_path, item)
      if File.directory?(full_path)
        new_prefix = File.join(prefix, item)
        file.puts("[#{new_prefix}]")
        create_file_list(full_path, output_file, new_prefix)
      else
        file.puts("#{folder_path}/#{item}") # Include the location of the image in the file name
      end
    end
  end
end

# Usage example
folder_path = 'qrcodes/test/good'
output_file = 'test.txt'
create_file_list(folder_path, output_file)
