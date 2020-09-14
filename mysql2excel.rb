# require 'sequel' # gem to access various DB's
# require 'roo' # gem to read spreadsheets

# DB = Sequel.connect(adapter: '', user: '', password: '',
#                     host: 'localhost', database: '') # Connection string, adapter <mysql,postgres,ado, etc etc>

# my_list = Roo::Spreadsheet.open('EXCEL SPREADSHEET') # Open spreadsheet

# my_list.each(name: 'Full Name', residence: 'Residential Address',
#              phone: 'Phone Number', email: 'Email Address') do |hash|
#                DB[:Dues_tbl].insert(Name: hash[:name].to_s, Dues: 'MMYY',
#                                     Address: hash[:residence].to_s,
#                                     PhoneNumber: hash[:phone].to_s,
#                                     Email: hash[:email].to_s)
#              end
# Call each and via hash insert into the DB.
# README
# This script is useful when uyou want to convert data from excel into mysql



# require 'sequel' # gem to access various DB's
# require 'roo' # gem to read spreadsheets

# DB = Sequel.connect(adapter: :mysql2, user: 'root', password: 'root',
#                     host: '127.0.0.1', database: 'ipdb') # Connection string, adapter <mysql,postgres,ado, etc etc>
# # DB = Sequel.connect(type: :sql, uri: 'mysql2://root:root@127.0.0.1:3306/ipdb')
# my_list = Roo::Spreadsheet.open('ipdb.xlsx') # Open spreadsheet

# my_list.each(division: 'DIVISION', section: 'SECTION', startdate: 'START DATE', pinvestigator: 'PRINCIPAL INVESTIGATOR', pscientist: 'PARTICIPATING SCIENTISTS', rtitle: 'RESEARCH TITLE', aorf: 'AREA/FIELD',collabo: 'COLLABORATORS', status: 'STATUS',
#              sponsor: 'SPONSOR', duration: 'DURATION') do |hash|
#                DB[:InstiProjects].insert(
#                  Divisions: hash[:division].to_s, 
#                  StartDate: hash[:startdate].to_s, 
#                  PrincipalInvestigator: hash[:pinvestigator].to_s,
#                  ParticipatingScientist: hash[:pscientist].to_s,
#                  ResearchTitle: hash[:rtitle].to_s,
#                  AreaFields: hash[:aorf].to_s,
#                  Sections: hash[:section].to_s,
#                  Statuss: hash[:status].to_s,
#                  Sponsors: hash[:sponsor].to_s,
#                  Collaborators: hash[:collabo].to_s,
#                  Duration: hash[:duration].to_s)
#              end


require 'sequel' # gem to access various DB's
require 'roo' # gem to read spreadsheets

DB = Sequel.connect(adapter: :mysql2, user: 'root', password: 'root',
                    host: '127.0.0.1', database: 'KuafoDB') # Connection string, adapter <mysql,postgres,ado, etc etc>
# DB = Sequel.connect(type: :sql, uri: 'mysql2://root:root@127.0.0.1:3306/ipdb')
my_list = Roo::Spreadsheet.open('*.xlsx') # Open spreadsheet

my_list.each(division: 'DIVISION', section: 'SECTION', startdate: 'START DATE', pinvestigator: 'PRINCIPAL INVESTIGATOR', pscientist: 'PARTICIPATING SCIENTISTS', rtitle: 'RESEARCH TITLE', aorf: 'AREA/FIELD',collabo: 'COLLABORATORS', status: 'STATUS',
             sponsor: 'SPONSOR', duration: 'DURATION') do |hash|
               DB[:InstiProjects].insert(
                 Divisions: hash[:division].to_s, 
                 StartDate: hash[:startdate].to_s, 
                 PrincipalInvestigator: hash[:pinvestigator].to_s,
                 ParticipatingScientist: hash[:pscientist].to_s,
                 ResearchTitle: hash[:rtitle].to_s,
                 AreaFields: hash[:aorf].to_s,
                 Sections: hash[:section].to_s,
                 Statuss: hash[:status].to_s,
                 Sponsors: hash[:sponsor].to_s,
                 Collaborators: hash[:collabo].to_s,
                 Duration: hash[:duration].to_s)
             end