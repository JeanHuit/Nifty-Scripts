require 'sequel' # gem to access various DB's
require 'axlsx' # gem to write spreadsheets

DB = Sequel.connect(adapter: 'mysql', user: 'root', password: '@Busty750',
                    host: 'localhost', database: 'revenue')

ds = DB.fetch('SELECT biz_entry.valuation_no,biz_entry.biz_name,
biz_entry.biz_type,biz_entry.biz_category,biz_entry.fixed_chargeable_amt,
biz_entry.surburb, payment.amount,payment.ballance FROM biz_entry
 INNER JOIN payment ON biz_entry.valuation_no = payment.valuation_no').all
#
puts ds.inspect
# package = Axlsx::Package.new
# wb = package.workbook
# myworkbook.add_worksheet(name: 'Business Operating Permit') do |sheet|
#   sheet.add_row ['Valuation Number', 'Business Name', 'Business Type',
#                  'Business Category', 'Fixed Chargable Amount', 'Surburb',
#                  'Amount', 'Balance']
#   ds.each do |cell|
#     sheet.add_row[cell[:valuation_no], cell[:biz_name], cell[:biz_type],
#                   cell[:biz_category], cell[:fixed_chargeable_amt],
#                   cell[:surburb], cell[:amount], cell[:ballance]]
#   end
# end
#
# package.serialize
# send_file('bop.xlsx', filename: 'bop.xlsx', type: 'application/vnd.ms-excel')

  # wb.add_worksheet(name: "Basic Worksheet") do |sheet|
  #   sheet.add_row ['Valuation Number', 'Business Name', 'Business Type',
  #   #                  'Business Category', 'Fixed Chargable Amount', 'Surburb',
  #   #                  'Amount', 'Balance']
  #   sheet.add_row [1, 2, 3]
  #   sheet.add_row ['     preserving whitespace']
  # end
  #  package.serialize 'bop.xlsx'
  #  send_file('bop.xlsx', filename: 'bop.xlsx', type: 'application/vnd.ms-excel')
c
