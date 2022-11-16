require 'pdfcrowd'
require 'dotenv'

Dotenv.load

username = ENV['www2pdfusername']
key = ENV['www2pdf']

begin
    # create the API client instance
    client = Pdfcrowd::HtmlToPdfClient.new("#{username}", "#{key}")

    # create an output stream for the conversion result
    output_stream = open("technical.pdf", "wb")

    # run the conversion and write the result into the output stream
    client.convertUrlToStream("http://sshfc.github.io/technical/", output_stream)

    # close the output stream
    output_stream.close()
rescue Pdfcrowd::Error => why
    # report the error
    STDERR.puts "Pdfcrowd Error: #{why}"

    # rethrow or handle the exception
    raise
end
