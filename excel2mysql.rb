require 'sequel'  #gem to access various DB's
require 'roo' #gem to read spreadsheets

DB = Sequel.connect(adapter: '', user: '', password: '',
                    host: 'localhost', database: '') #Connection string, adapter <mysql,postgres,ado, etc etc>

my_list = Roo::Spreadsheet.open('EXCEL SPREADSHEET') #Open spreadsheet

my_list.each(name: 'Full Name', residence: 'Residential Address',
             phone: 'Phone Number', email: 'Email Address') do |hash|
               DB[:Dues_tbl].insert(Name: hash[:name].to_s, Dues: 'MMYY',
                                    Address: hash[:residence].to_s,
                                    PhoneNumber: hash[:phone].to_s,
                                    Email: hash[:email].to_s)
             end
# Call each and via hash insert into the DB.
#README
# This script is useful when uyou want to convert data from excel into mysql
