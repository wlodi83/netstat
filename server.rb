#!/usr/bin/env ruby
require 'webrick'

class Netstat

  def self.print_results
    #check port 3489
    netstat_4 = IO.popen("netstat -an | grep :3489")
    #check port 3589
    netstat_5 = IO.popen("netstat -an | grep :3589")
    #check port 3689
    netstat_6 = IO.popen("netstat -an | grep :3689")
    #check port 3789
    netstat_7 = IO.popen("netstat -an | grep :3789")

    #create arrays with results
    a = Netstat.create_array(netstat_4)
    b = Netstat.create_array(netstat_5)
    c = Netstat.create_array(netstat_6)
    d = Netstat.create_array(netstat_7)

    return a, b, c, d
  end

  def self.create_array(shell_output)
    array = Array.new
    results = shell_output.readlines
    if results.empty?
      array.push("THIS PORT IS FREE")
      return array
    else
      results.each do |line|
        array.push("#{line}")
      end
      return array
    end
  end

end

class RunScript < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req, res)
    res['Content-Type'] = 'text/html'
    result = Netstat.print_results
    array_1 = print_to_html(result[0])
    array_2 = print_to_html(result[1])
    array_3 = print_to_html(result[2])
    array_4 = print_to_html(result[3])

    res.body = "<h1>PORT 3489:</h1><br/>#{array_1}" + "<h1>PORT 3589:</h1><br/>#{array_2}" + "<h1>PORT 3689:</h1><br/>#{array_3}" + "<h1>PORT 3789:</h1><br/>#{array_4}"
  end

  def print_to_html(result)
    array = Array.new
    result.each do |res|
      res.each_line do |row|
        (array).push("<h3>#{row}</h3>")
      end
    end

    return array
  end
end

server = WEBrick::HTTPServer.new(:Port => 4000)
server.mount("/netstat",  RunScript)

trap("INT"){ server.shutdown }
server.start
