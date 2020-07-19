require 'socket'

server = TCPServer.new 3000
while session = server.accept

  request = session.gets
  # puts request

  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: application/json\r\n"
  session.print "\r\n"
  session.print 'a: 1'

  session.close
end
