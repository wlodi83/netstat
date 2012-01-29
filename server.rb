#!/usr/bin/env ruby
require 'webrick'

class Netstat
 def self.open
    #check port 3489
    netstat_4 = IO.popen("netstat -an | grep :3489")
    #check port 3589
    netstat_5 = IO.popen("netstat -an | grep :3589")
    #check port 3689
    netstat_6 = IO.popen("netstat -an | grep :3689")
    #check port 3789
    netstat_7 = IO.popen("netstat -an | grep :3789")
    a = Array.new
    b = Array.new
    c = Array.new
    d = Array.new
    netstat_4 = netstat_4.readlines
    i = 0
    netstat_4.each do |line|
      a[i] = line
      i = i + 1
    end
    netstat_5 = netstat_5.readlines
    j = 0
    netstat_5.each do |line|
      b[j] = line
      j = j + 1
    end
    netstat_6 = netstat_6.readlines
    f = 0
    netstat_6.each do |line|
      c[f] = line
      f = f + 1
    end
    netstat_7 = netstat_7.readlines
    g = 0
    netstat_7.each do |line|
      d[g] = line
      g = g + 1
    end
    return a, b, c, d
  end

  def self.print_results
    result_1, result_2, result_3, result_4 = Array.new
    result_1, result_2, result_3, result_4 = Netstat.open
  end

end

class RunScript < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req, res)
      res['Content-Type'] = 'text/html'
      ree = Netstat.open
      puts "--------------------------"
      puts ree[0]
      puts "--------------------------"
      puts ree[1]
      puts "--------------------------"
      puts ree[2]
      puts "-------------------------"
      puts ree[3]
      i = 0
      array = Array.new
      ree[0].each do |result|
        result.each_line do |row|
          array[i] = "<h2>#{row}</h2>"
          i = i + 1
        end
      end
      i = 0 
      array1 = Array.new
      ree[1].each do |result|
        result.each_line do |row|
          array1[i] = "<h2>#{row}</h2>"
          i = i + 1
        end
      end
      i = 0 
      array2 = Array.new
      ree[2].each do |result|
        result.each_line do |row|
          array2[i] = "<h2>#{row}</h2>"
          i = i + 1
        end
      end
      i = 0
      array3 = Array.new
      ree[3].each do |result|
        result.each_line do |row|
          array3[i] = "<h2>#{row}</h2>"
          i = i + 1
        end
      end

      res.body = "#{array}" + "#{array1}" + "#{array2}" + "#{array3}"
  end
end

server = WEBrick::HTTPServer.new(:Port => 4000)
server.mount("/netstat",  RunScript)

trap("INT"){ server.shutdown }
server.start
