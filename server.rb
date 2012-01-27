#!/usr/bin/env ruby
require 'webrick'

class Netstat

  def self.open
    #check port 3489
    netstat_3489 = IO.popen("netstat -an | grep ::3489")
    #check port 3589
    netstat_3589 = IO.popen("netstat -an | grep ::3589")
    #check port 3689
    netstat_3689 = IO.popen("netstat -an | grep ::3689")
    #check port 3789
    netstat_3789 = IO.popen("netstat -an | grep ::3789")
   
    return netstat_3489, netstat_3589, netstat_3689, netstat_3789
  end

  def self.print_results
    result_1, result_2, result_3, result_4 = Netstat.open
    return result_1.gets, result_2.gets, result_3.gets, result_4.gets
  end

end

class RunScript < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req, res)
      res['Content-Type'] = 'text/html'
      result_1, result_2, result_3, result_4 = Netstat.print_results
      result_1 = "PORT 3489 is FREE" if result_1.nil?
      result_2 = "PORT 3589 is FREE" if result_2.nil?
      result_3 = "PORT 3689 is FREE" if result_3.nil?
      result_4 = "PORT 3789 is FREE" if result_4.nil?
      res.body = "<html><title>Scanning Ports</title>
                 <h1>Results:</h1>
                 <body>
                 <h2>#{result_1}</h2>
                 <h2>#{result_2}</h2>
                 <h2>#{result_3}</h2>
                 <h2>#{result_4}</h2>
                 </body>
                 </html>"
  end
end

server = WEBrick::HTTPServer.new(:Port => 4000)
server.mount("/netstat",  RunScript)

trap("INT"){ server.shutdown }
server.start
