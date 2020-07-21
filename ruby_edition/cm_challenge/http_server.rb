require 'socket'
require_relative 'absences'
require_relative 'api'

server = TCPServer.new 3000
while session = server.accept
  request = session.gets

  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: application/json\r\n"
  session.print "\r\n"

  # TODO: Parse request and fill params
  params = {}

  # TODO: send file, not just print
  session.print CmChallenge::Absences.to_ical(params)

  session.close
end
