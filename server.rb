#!/usr/bin/env ruby
require 'webrick'
require 'cgi'

class Netstat

  def self.open
    netstat_3489 = IO.popen("netstat -an | grep 3489")    
    netstat_3589 = IO.popen("netstat -an | grep 3589")
    netstat_3689 = IO.popen("netstat -an | grep 3689")
    netstat_3789 = IO.popen("netstat -an | grep 3789")
    if result_1 = netstat_3489.gets && result_2 = netstat_3589.gets && result_3 = netstat_3689.gets && result_4 = netstat_3789.gets
      return result_1, result_2, result_3, result_4
    elsif result_1 = netstat_3489.gets
      return result_1, "PORTS 3589, 3689 and 3789 are FREE"
    elsif result_2 = netstat_3589.gets
      return result_2, "PORTS 3489, 3689, 3789 are FREE"
    elsif result_3 = netstat_3689.gets
      return result_3, "PORTS 3489, 3589, 3789 are FREE"
    elsif result_4 = netstat_3789.gets
      return result_4, "PORTS 3489, 3589, 3689 are FREE"
    elsif result_1 = netstat_3489.gets && result_2 = netstat_3589.gets
      return result_1, result_2, "PORTS 3689, 3789 are FREE"
    elsif result_1 = netstat_3489.gets && result_3 = netstat_3689.gets
      return result_1, result_3, "PORTS 3589, 3789 are FREE"
    elsif result_1 = netstat_3489.gets && result_4 = netstat_3789.gets
      return result_1, result_4, "PORTS 3589, 3689 are FREE"
    elsif result_2 = netstat_3589.gets && result_3 = netstat_3689.gets
      return result_2, result_3, "PORTS 3489, 3789 are FREE"
    elsif result_2 = netstat_3589.gets && result_4 = netstat_3789.gets
      return result_2, result_4, "PORTS 3489, 3689 are FREE"
    elsif result_3 = netstat_3689.gets && result_4 = netstat_3789.gets
      return result_3, result_4, "PORTS 3489, 3589 are FREE"
    elsif result_1 = netstat_3489.gets && result_2 = netstat_3589.gets && result_3 = netstat_3689.gets
      return result_1, result_2, result_3, "PORT 3789 is FREE"
    elsif result_1 = netstat_3489.gets && result_2 = netstat_3589.gets && result_4 = netstat_3789.gets
      return result_1, result_2, result_4, "PORT 3689 is FREE"
    elsif result_2 = netstat_3589.gets && result_3 = netstat_3689.gets && result_4 = netstat_3789.gets
      return result_2, result_3, result_4, "PORT 3489 is FREE"
    elsif result_1 = netstat_3489.gets && result_3 = netstat_3689.gets && result_4 = netstat_3789.gets
      return result_1, result_3, result_4, "PORT 3589 is FREE"
    else
      return "PORTS 3489, 3589, 3689, 3789 are FREE"
    end
  end

  def self.print_results
    result = Netstat.open
    return result
  end

end

class RunScript < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req, res)
      res['Content-Type'] = 'text/html' 
      res.body = "<html>#{Netstat.print_results}</html>"
  end
end

server = WEBrick::HTTPServer.new(:Port => 4000)
server.mount("/run",  RunScript)

trap("INT"){ server.shutdown }
server.start
