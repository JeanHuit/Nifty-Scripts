
def wp_generate_password(len = 13)
  chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()'
  chars = chars.split('')
  a = 0
  password = ''
  while a < len
    xfactor = Random.new
    index = xfactor.rand(chars.length)
    password << chars[index]
    a += 1
  end
  File.open('wp-pass.txt', 'a') { |to_append| to_append.write("#{password},\n") }
end

Array.new(100000) { wp_generate_password }
